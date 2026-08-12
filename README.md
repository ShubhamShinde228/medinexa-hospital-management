# medinexa-hospital-management
Date: 2026-06-27

## Summary

This project is a Maven-based Java Hospital Management System using JSP, Servlets, JDBC, MySQL, Bootstrap, and Tomcat. It already has patient, doctor, admin, staff, ward, report, and appointment modules. The project follows the expected JSP -> Servlet -> DAO -> MySQL flow, but it needs cleanup and feature hardening before it is placement-ready.

## Main Findings

- `component/allcss.jsp` has duplicate Font Awesome versions and a malformed Bootstrap script tag. This is a likely root cause for pages aligning only after scrolling or after delayed rendering.
- Several pages load different Bootstrap versions, which can break navbar collapse, spacing, and modal behavior.
- Some pages duplicate public JSPs and `WEB-INF` JSPs, increasing maintenance effort.
- `view_appointment.jsp` redirects unauthenticated users back to itself, causing a redirect loop instead of sending users to login.
- Tables are not consistently wrapped in `.table-responsive`, so mobile/tablet layout can overflow.
- `DBConnect.java` contains hardcoded database credentials and uses one static connection.
- DAOs mostly use prepared statements, but several statements/result sets should still be closed with try-with-resources.
- JSP output uses direct `<%= ... %>` rendering for user-controlled values, which should later be escaped to reduce XSS risk.
- Role-based access is handled page-by-page instead of through a centralized filter.
- Razorpay payment support was missing in this workspace and has now been added as a focused first pass.

## Priority Fixes Applied

1. Cleaned shared Bootstrap and Font Awesome include.
2. Added Razorpay appointment payment lifecycle.
3. Added payment entity, DAO, servlet, schema, payment pages, and history pages.
4. Fixed appointment page login redirect.
5. Made appointment table responsive and added secure payment action.

## Recommended Next Work

1. Move database credentials to environment variables or `application.properties`.
2. Add centralized authentication and role authorization filters.
3. Add CSRF tokens for state-changing forms.
4. Escape JSP output or migrate views to JSTL/EL with safe helpers.
5. Add billing tables and PDF invoice generation.
6. Add admin dashboard revenue cards and payment reports.
7. Normalize duplicate JSP locations and remove unused assets carefully.

