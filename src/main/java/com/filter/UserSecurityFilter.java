package com.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
    "/view_appointment.jsp",
    "/user_appointment.jsp",
    "/pay_bill.jsp",
    "/payment_history.jsp",
    "/addAppointment",
    "/UserLogout",
    "/PaymentServlet",
    "/slot_booking.jsp",
    "/my_prescriptions.jsp",
    "/my_timeline.jsp",
    "/bookSlot",
    "/prescriptionPdf",
    "/payment_checkout.jsp",
    "/createOrder",
    "/verifyPayment"
})
public class UserSecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        if (path.endsWith(".css") || path.endsWith(".js") || path.contains("/img/") || path.contains("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("userObj") != null);

        if (loggedIn) {
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);
            chain.doFilter(request, response);
        } else {
            if ("/PaymentServlet".equals(path) && "POST".equalsIgnoreCase(httpRequest.getMethod())) {
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                httpResponse.setContentType("application/json");
                httpResponse.getWriter().write("{\"success\":false,\"message\":\"Please login before payment.\"}");
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/user_login.jsp");
            }
        }
    }

    @Override
    public void destroy() {
    }
}
