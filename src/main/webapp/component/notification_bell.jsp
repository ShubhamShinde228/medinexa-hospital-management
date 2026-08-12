
<%@ page import="com.dao.NotificationDao, com.db.DBConnect" %>
<%
    String notifRole = (String) request.getAttribute("notifRole");
    Integer notifIdObj = (Integer) request.getAttribute("notifId");
    String notifPage   = (String) request.getAttribute("notifPage");
    if (notifRole == null) notifRole = "ADMIN";
    int notifId = (notifIdObj != null) ? notifIdObj : 0;
    if (notifPage == null) notifPage = "#";

    int unreadCount = 0;
    try {
        NotificationDao _nDao = new NotificationDao(DBConnect.getConn());
        unreadCount = _nDao.countUnread(notifRole, notifId);
    } catch (Exception _e) { _e.printStackTrace(); }
%>
<li class="nav-item" id="notifBellItem" data-role="<%=notifRole%>" data-id="<%=notifId%>">
    <a class="nav-link text-white position-relative" href="<%=notifPage%>" id="notifBellLink">
        <i class="fas fa-bell fa-lg"></i>
        <span id="notifBadge"
              class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
              style="font-size:10px; <%=unreadCount == 0 ? "display:none;" : ""%>">
            <%=unreadCount > 9 ? "9+" : String.valueOf(unreadCount)%>
        </span>
    </a>
</li>
<script>
(function() {
    var role = '<%=notifRole%>';
    var id   = '<%=notifId%>';
    function refreshCount() {
        fetch(contextPath + '/notificationApi?action=count&role=' + role + '&id=' + id)
            .then(r => r.json()).then(data => {
                var badge = document.getElementById('notifBadge');
                if (!badge) return;
                if (data.count > 0) {
                    badge.textContent = data.count > 9 ? '9+' : data.count;
                    badge.style.display = '';
                } else {
                    badge.style.display = 'none';
                }
            }).catch(() => {});
    }
    var contextPath = '<%=request.getContextPath()%>';
    setInterval(refreshCount, 30000); // poll every 30 seconds
})();
</script>
