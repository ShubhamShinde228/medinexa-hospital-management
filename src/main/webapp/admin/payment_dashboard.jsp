<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="com.db.DBConnect"%>
<%@ page import="com.dao.PaymentDao"%>
<%@ page import="com.entity.Payment"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
    Object adminObj = session.getAttribute("adminObj");
    if (adminObj == null) {
        session.setAttribute("errorMsg", "Please login as admin to access the payment dashboard.");
        response.sendRedirect("../admin_login.jsp");
        return;
    }

    Connection conn = DBConnect.getConn();
    PaymentDao paymentDao = new PaymentDao(conn);
    List<Payment> allPayments = paymentDao.getAllPayments();

    // Get current date strings for metrics
    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
    String todayStr = sdfDate.format(new Date());
    String monthStr = todayStr.substring(0, 7); // yyyy-MM

    double totalRevenue = 0;
    double todaysRevenue = 0;
    double monthlyRevenue = 0;
    int pendingCount = 0;
    int failedCount = 0;
    int successCount = 0;

    for (Payment p : allPayments) {
        String status = p.getStatus();
        double amt = p.getAmount();
        String created = p.getCreatedAt();
        
        if ("SUCCESS".equalsIgnoreCase(status)) {
            successCount++;
            totalRevenue += amt;
            if (created != null) {
                if (created.startsWith(todayStr)) {
                    todaysRevenue += amt;
                }
                if (created.startsWith(monthStr)) {
                    monthlyRevenue += amt;
                }
            }
        } else if ("FAILED".equalsIgnoreCase(status)) {
            failedCount++;
        } else if ("PENDING".equalsIgnoreCase(status) || "CREATED".equalsIgnoreCase(status)) {
            pendingCount++;
        }
    }

    // Interactive Filters
    String filterPatient = request.getParameter("filterPatient");
    String filterStatus = request.getParameter("filterStatus");
    String filterStartDate = request.getParameter("filterStartDate");
    String filterEndDate = request.getParameter("filterEndDate");

    List<Payment> filteredPayments = new ArrayList<>();
    for (Payment p : allPayments) {
        // Patient Name Filter
        if (filterPatient != null && !filterPatient.trim().isEmpty()) {
            if (p.getPatientName() == null || !p.getPatientName().toLowerCase().contains(filterPatient.toLowerCase().trim())) {
                continue;
            }
        }
        // Status Filter
        if (filterStatus != null && !filterStatus.trim().isEmpty() && !"ALL".equalsIgnoreCase(filterStatus)) {
            if (!filterStatus.equalsIgnoreCase(p.getStatus())) {
                continue;
            }
        }
        // Date Filters
        if (p.getCreatedAt() != null) {
            String pDate = p.getCreatedAt().split(" ")[0]; // Extract yyyy-MM-dd
            if (filterStartDate != null && !filterStartDate.trim().isEmpty()) {
                if (pDate.compareTo(filterStartDate) < 0) {
                    continue;
                }
            }
            if (filterEndDate != null && !filterEndDate.trim().isEmpty()) {
                if (pDate.compareTo(filterEndDate) > 0) {
                    continue;
                }
            }
        }
        filteredPayments.add(p);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Financial Dashboard - MEDI HOME</title>
    <%@ include file="../component/allcss.jsp"%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .metric-card {
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .metric-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }
        .filter-card {
            border-radius: 12px;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp"%>

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-success fw-bold mb-0">
                <i class="fa-solid fa-chart-line me-2"></i> Financial & Payment Dashboard
            </h2>
            <button class="btn btn-outline-success btn-sm" onclick="window.location.reload();">
                <i class="fa-solid fa-arrows-rotate me-1"></i> Refresh Data
            </button>
        </div>

        <!-- METRICS CARDS -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card border-0 bg-success text-white p-3 metric-card shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-white-50 uppercase fw-semibold">Total Revenue</h6>
                            <h3 class="fw-bold mb-0">INR <%= String.format("%.2f", totalRevenue) %></h3>
                        </div>
                        <i class="fa-solid fa-indian-rupee-sign fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-info text-white p-3 metric-card shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-white-50 uppercase fw-semibold">Today's Collection</h6>
                            <h3 class="fw-bold mb-0">INR <%= String.format("%.2f", todaysRevenue) %></h3>
                        </div>
                        <i class="fa-solid fa-calendar-day fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-primary text-white p-3 metric-card shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-white-50 uppercase fw-semibold">Monthly Collection</h6>
                            <h3 class="fw-bold mb-0">INR <%= String.format("%.2f", monthlyRevenue) %></h3>
                        </div>
                        <i class="fa-solid fa-calendar-days fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 bg-warning text-dark p-3 metric-card shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-dark-50 uppercase fw-semibold">Pending Payments</h6>
                            <h3 class="fw-bold mb-0"><%= pendingCount %></h3>
                        </div>
                        <i class="fa-solid fa-clock-rotate-left fs-1 text-dark-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-danger text-white p-3 metric-card shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-white-50 uppercase fw-semibold">Failed Payments</h6>
                            <h3 class="fw-bold mb-0"><%= failedCount %></h3>
                        </div>
                        <i class="fa-solid fa-circle-xmark fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-success-subtle border border-success text-success p-3 metric-card shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-success uppercase fw-semibold">Successful Orders</h6>
                            <h3 class="fw-bold mb-0 text-success-emphasis"><%= successCount %></h3>
                        </div>
                        <i class="fa-solid fa-circle-check fs-1 text-success"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- INTERACTIVE FILTERS -->
        <div class="card border-0 shadow-sm p-4 mb-4 filter-card bg-light">
            <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-filter me-2"></i>Filter Transactions</h5>
            <form action="payment_dashboard.jsp" method="GET" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label small text-muted">Patient Name</label>
                    <input type="text" name="filterPatient" class="form-control form-control-sm" placeholder="Search name..." value="<%= filterPatient != null ? filterPatient : "" %>">
                </div>
                <div class="col-md-3">
                    <label class="form-label small text-muted">Status</label>
                    <select name="filterStatus" class="form-select form-select-sm">
                        <option value="ALL" <%= "ALL".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>All Statuses</option>
                        <option value="SUCCESS" <%= "SUCCESS".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>SUCCESS</option>
                        <option value="FAILED" <%= "FAILED".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>FAILED</option>
                        <option value="PENDING" <%= "PENDING".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>PENDING</option>
                        <option value="CREATED" <%= "CREATED".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>CREATED</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label small text-muted">Start Date</label>
                    <input type="date" name="filterStartDate" class="form-control form-control-sm" value="<%= filterStartDate != null ? filterStartDate : "" %>">
                </div>
                <div class="col-md-2">
                    <label class="form-label small text-muted">End Date</label>
                    <input type="date" name="filterEndDate" class="form-control form-control-sm" value="<%= filterEndDate != null ? filterEndDate : "" %>">
                </div>
                <div class="col-md-2 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-success btn-sm w-100 py-2 fw-semibold">
                        Filter
                    </button>
                    <a href="payment_dashboard.jsp" class="btn btn-secondary btn-sm w-100 py-2 fw-semibold">
                        Reset
                    </a>
                </div>
            </form>
        </div>

        <!-- PAYMENTS LOG TABLE -->
        <div class="card border-0 shadow-sm p-4 filter-card">
            <h5 class="fw-bold mb-4">Transaction Records</h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr class="table-light">
                            <th>ID</th>
                            <th>Patient Name</th>
                            <th>Purpose</th>
                            <th>Amount</th>
                            <th>Method</th>
                            <th>Transaction ID</th>
                            <th>Order ID</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th class="text-center">Invoice</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (filteredPayments.isEmpty()) { %>
                            <tr>
                                <td colspan="11" class="text-center py-4 text-muted">No transaction records found matching the filters.</td>
                            </tr>
                        <% } else {
                            for (Payment p : filteredPayments) { %>
                                <tr>
                                    <td><%= p.getId() %></td>
                                    <td><strong><%= p.getPatientName() %></strong></td>
                                    <td><span class="badge bg-secondary"><%= p.getPaymentType().replace("_", " ") %></span></td>
                                    <td class="fw-semibold">INR <%= String.format("%.2f", p.getAmount()) %></td>
                                    <td><%= p.getPaymentMethod() %></td>
                                    <td class="text-muted small"><%= p.getRazorpayPaymentId() != null ? p.getRazorpayPaymentId() : "-" %></td>
                                    <td class="text-muted small"><%= p.getRazorpayOrderId() != null ? p.getRazorpayOrderId() : "-" %></td>
                                    <td>
                                        <% if ("SUCCESS".equalsIgnoreCase(p.getStatus())) { %>
                                            <span class="badge bg-success">SUCCESS</span>
                                        <% } else if ("FAILED".equalsIgnoreCase(p.getStatus())) { %>
                                            <span class="badge bg-danger">FAILED</span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark"><%= p.getStatus() %></span>
                                        <% } %>
                                    </td>
                                    <td class="small"><%= p.getCreatedAt() %></td>
                                    <td class="text-center">
                                        <% if ("SUCCESS".equalsIgnoreCase(p.getStatus()) && p.getBillId() != null && p.getBillId() > 0) { %>
                                            <a href="../generateInvoice?billId=<%= p.getBillId() %>" class="btn btn-outline-success btn-sm px-2 py-1">
                                                <i class="fa-solid fa-file-pdf"></i> PDF
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted small">-</span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <% if ("SUCCESS".equalsIgnoreCase(p.getStatus())) { %>
                                            <button class="btn btn-outline-danger btn-sm py-1 px-2" onclick="swal('Refund Process', 'Refund feature initiated for Trans ID: <%= p.getRazorpayPaymentId() %> (Stub action)', 'info')">
                                                Refund
                                            </button>
                                        <% } else { %>
                                            <button class="btn btn-outline-secondary btn-sm py-1 px-2" disabled>
                                                Refund
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- SweetAlert and Bootstrap -->
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
