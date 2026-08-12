<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User" %>
<%
    /* ------------------------------------------------------------------
     * Secure Checkout Page
     * Accepts: type, amount, appointmentId (opt), billId (opt), admissionId (opt)
     * Sessions: userObj (patient) OR staffObj (staff)
     * ------------------------------------------------------------------ */
    Object userObj = session.getAttribute("userObj");
    Object staffObj = session.getAttribute("staffObj");
    if (userObj == null && staffObj == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    String displayName = "Patient";
    String displayEmail = "";

    if (userObj instanceof com.entity.User) {
        com.entity.User u = (com.entity.User) userObj;
        displayName = u.getFullName() != null ? u.getFullName() : "Patient";
        displayEmail = u.getEmail() != null ? u.getEmail() : "";
    } else if (staffObj instanceof com.entity.Staff) {
        com.entity.Staff s = (com.entity.Staff) staffObj;
        displayName = s.getFullName() != null ? s.getFullName() : "Staff";
        displayEmail = s.getEmail() != null ? s.getEmail() : "";
    }

    String type          = request.getParameter("type");
    String amountStr     = request.getParameter("amount");
    String appointmentId = request.getParameter("appointmentId");
    String billId        = request.getParameter("billId");
    String admissionId   = request.getParameter("admissionId");

    if (type == null || type.isBlank() || amountStr == null || amountStr.isBlank()) {
        response.sendRedirect("index.jsp");
        return;
    }

    double amount = 500.0;
    try { amount = Double.parseDouble(amountStr); } catch (Exception ignored) {}

    String purposeLabel = "APPOINTMENT_FEE".equals(type) ? "Appointment Booking Fee"
                        : "DISCHARGE_BILL".equals(type)  ? "Hospital Discharge Bill"
                        : "Admission Deposit";

    String ctxPath = request.getContextPath();  // e.g. /Hospital_System

    // Safe JS string escaping
    String jsName  = displayName.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
    String jsEmail = displayEmail.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");

    String safeApptId    = (appointmentId != null ? appointmentId.trim() : "");
    String safeBillId    = (billId        != null ? billId.trim()        : "");
    String safeAdmId     = (admissionId   != null ? admissionId.trim()   : "");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Payment — Medi Home Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: linear-gradient(135deg, #0d6efd 0%, #198754 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
            padding: 20px;
        }
        .pay-card {
            background: #fff;
            border-radius: 24px;
            padding: 40px 36px;
            max-width: 480px;
            width: 100%;
            box-shadow: 0 24px 64px rgba(0,0,0,0.28);
            animation: slideUp 0.4s ease;
        }
        @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .hospital-logo { font-size: 2.4rem; color: #0d6efd; }
        .hospital-name { font-size: 1.1rem; font-weight: 700; color: #1a1a2e; letter-spacing: .5px; }
        .hospital-sub  { font-size: 0.78rem; color: #6c757d; }
        .divider { border: none; border-top: 2px dashed #e9ecef; margin: 20px 0; }
        .detail-row { display: flex; justify-content: space-between; align-items: center; padding: 9px 0; border-bottom: 1px solid #f1f3f5; font-size: 0.92rem; }
        .detail-row:last-child { border-bottom: none; }
        .detail-label { color: #6c757d; }
        .detail-value { font-weight: 600; color: #1a1a2e; }
        .amount-badge {
            background: linear-gradient(135deg, #0d6efd, #198754);
            border-radius: 16px;
            padding: 18px;
            text-align: center;
            margin: 22px 0;
            color: white;
        }
        .amount-badge .amount-val { font-size: 2.6rem; font-weight: 800; line-height: 1; }
        .amount-badge .amount-label { font-size: 0.82rem; opacity: .85; margin-top: 4px; }
        .secure-strip {
            background: #f0fff4;
            border: 1px solid #b2dfdb;
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 0.8rem;
            color: #155724;
            text-align: center;
            margin-bottom: 20px;
        }
        .btn-pay {
            background: linear-gradient(135deg, #0d6efd, #198754);
            color: #fff !important;
            border: none;
            border-radius: 50px;
            padding: 14px;
            font-size: 1.05rem;
            font-weight: 700;
            width: 100%;
            cursor: pointer;
            transition: all 0.25s;
            letter-spacing: .5px;
        }
        .btn-pay:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 12px 28px rgba(13,110,253,.35); }
        .btn-pay:disabled { opacity: .65; cursor: not-allowed; transform: none; }
        .back-link { display: block; text-align: center; margin-top: 16px; color: #6c757d; text-decoration: none; font-size: 0.88rem; }
        .back-link:hover { color: #0d6efd; }
        .status-msg { text-align: center; font-size: 0.82rem; color: #6c757d; margin-top: 12px; min-height: 18px; }
        .spinner-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.55);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: white;
            gap: 14px;
        }
        .spinner-overlay .label { font-size: 1.05rem; font-weight: 500; }
    </style>
</head>
<body>

<!-- Full-screen loading overlay -->
<div class="spinner-overlay" id="spinnerOverlay">
    <div class="spinner-border" style="width:3.2rem;height:3.2rem;color:#7bc8a4;" role="status"></div>
    <div class="label" id="spinnerLabel">Processing Payment…</div>
</div>

<div class="pay-card">
    <!-- Header -->
    <div class="text-center mb-3">
        <div class="hospital-logo mb-1"><i class="fas fa-hospital-alt"></i></div>
        <div class="hospital-name">Medi Home Hospital</div>
        <div class="hospital-sub">Secure Online Payment</div>
    </div>

    <hr class="divider">

    <!-- Payment details -->
    <div class="mb-1">
        <div class="detail-row">
            <span class="detail-label"><i class="fas fa-tag me-1"></i>Purpose</span>
            <span class="detail-value"><%= purposeLabel %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label"><i class="fas fa-user me-1"></i>Patient</span>
            <span class="detail-value"><%= displayName %></span>
        </div>
        <% if (!safeApptId.isEmpty()) { %>
        <div class="detail-row">
            <span class="detail-label"><i class="fas fa-calendar-check me-1"></i>Appointment ID</span>
            <span class="detail-value">#<%= safeApptId %></span>
        </div>
        <% } %>
        <% if (!safeBillId.isEmpty()) { %>
        <div class="detail-row">
            <span class="detail-label"><i class="fas fa-file-invoice me-1"></i>Bill ID</span>
            <span class="detail-value">#<%= safeBillId %></span>
        </div>
        <% } %>
        <% if (!safeAdmId.isEmpty()) { %>
        <div class="detail-row">
            <span class="detail-label"><i class="fas fa-bed me-1"></i>Admission ID</span>
            <span class="detail-value">#<%= safeAdmId %></span>
        </div>
        <% } %>
    </div>

    <!-- Amount -->
    <div class="amount-badge">
        <div class="amount-val">&#8377;<%= String.format("%.2f", amount) %></div>
        <div class="amount-label">Total Amount (INR)</div>
    </div>

    <!-- Secure strip -->
    <div class="secure-strip">
        <i class="fas fa-lock me-1"></i>256-bit SSL Encrypted &nbsp;&bull;&nbsp;
        <i class="fas fa-shield-alt me-1"></i>Razorpay Secured &nbsp;&bull;&nbsp;
        <i class="fas fa-check-circle me-1"></i>PCI DSS Compliant
    </div>

    <!-- Error alert (hidden by default) -->
    <div id="errorAlert" class="alert alert-danger d-none py-2" style="font-size:.88rem;"></div>

    <!-- Pay button -->
    <button id="payBtn" class="btn-pay" onclick="initiatePayment()">
        <i class="fas fa-credit-card me-2"></i>Pay &#8377;<%= String.format("%.2f", amount) %> Securely
    </button>

    <a class="back-link" href="javascript:history.back()"><i class="fas fa-arrow-left me-1"></i>Cancel &amp; Go Back</a>
    <div class="status-msg" id="statusMsg"></div>
</div>

<!-- Hidden form submitted to VerifyPaymentServlet after successful payment -->
<form id="verifyForm" action="<%= ctxPath %>/verifyPayment" method="POST" style="display:none;">
    <input type="hidden" name="razorpay_order_id"  id="f_orderId">
    <input type="hidden" name="razorpay_payment_id" id="f_paymentId">
    <input type="hidden" name="razorpay_signature"  id="f_signature">
    <input type="hidden" name="type"          value="<%= type %>">
    <input type="hidden" name="amount"        value="<%= amountStr %>">
    <input type="hidden" name="appointmentId" value="<%= safeApptId %>">
    <input type="hidden" name="billId"        value="<%= safeBillId %>">
    <input type="hidden" name="admissionId"   value="<%= safeAdmId %>">
</form>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    /* JavaScript variables injected from JSP */
    var CTX       = '<%= ctxPath %>';
    var PAY_TYPE  = '<%= type %>';
    var PAY_AMT   = '<%= amountStr %>';
    var APPT_ID   = '<%= safeApptId %>';
    var BILL_ID   = '<%= safeBillId %>';
    var ADM_ID    = '<%= safeAdmId %>';
    var USER_NAME  = '<%= jsName %>';
    var USER_EMAIL = '<%= jsEmail %>';

    function setStatus(msg) {
        document.getElementById('statusMsg').textContent = msg;
    }

    function showError(msg) {
        var el = document.getElementById('errorAlert');
        el.textContent = msg;
        el.classList.remove('d-none');
        document.getElementById('payBtn').disabled = false;
        document.getElementById('spinnerOverlay').style.display = 'none';
        setStatus('');
    }

    function showSpinner(label) {
        document.getElementById('spinnerLabel').textContent = label || 'Processing…';
        document.getElementById('spinnerOverlay').style.display = 'flex';
    }

    function initiatePayment() {
        document.getElementById('payBtn').disabled = true;
        document.getElementById('errorAlert').classList.add('d-none');
        showSpinner('Creating secure payment order…');
        setStatus('Connecting to payment gateway…');

        /* Build URL-encoded payload — URLSearchParams sends as application/x-www-form-urlencoded
           which any servlet can read with req.getParameter() without needing @MultipartConfig */
        var params = new URLSearchParams();
        params.append('type',   PAY_TYPE);
        params.append('amount', PAY_AMT);
        if (APPT_ID) params.append('appointmentId', APPT_ID);
        if (BILL_ID) params.append('billId',        BILL_ID);
        if (ADM_ID)  params.append('admissionId',   ADM_ID);

        fetch(CTX + '/createOrder', {
            method:      'POST',
            body:        params,
            credentials: 'same-origin'
        })
        .then(function(res) {
            // Always try to parse JSON — server returns JSON even for errors
            return res.json().catch(function() {
                throw new Error('Server returned HTTP ' + res.status + ' (non-JSON response)');
            }).then(function(data) {
                return { ok: res.ok, status: res.status, data: data };
            });
        })
        .then(function(result) {
            document.getElementById('spinnerOverlay').style.display = 'none';
            if (!result.data.success) {
                showError((result.data.message || 'Unknown error. Please try again.'));
                return;
            }
            setStatus('Order created. Opening Razorpay…');
            openRazorpayCheckout(result.data.orderId, result.data.amount, result.data.key);
        })
        .catch(function(err) {
            showError('Network error: ' + err.message + '. Please check your connection.');
            console.error('createOrder error:', err);
        });
    }

    function openRazorpayCheckout(orderId, amountPaise, key) {
        var options = {
            key:         key,
            amount:      amountPaise,
            currency:    'INR',
            name:        'Medi Home Hospital',
            description: '<%= purposeLabel %>',
            order_id:    orderId,
            prefill: {
                name:  USER_NAME,
                email: USER_EMAIL
            },
            theme:  { color: '#0d6efd' },
            handler: function(response) {
                /* Payment succeeded — POST to server for HMAC verification */
                showSpinner('Verifying payment with server…');
                document.getElementById('f_orderId').value   = response.razorpay_order_id;
                document.getElementById('f_paymentId').value = response.razorpay_payment_id;
                document.getElementById('f_signature').value = response.razorpay_signature;
                document.getElementById('verifyForm').submit();
            },
            modal: {
                ondismiss: function() {
                    document.getElementById('payBtn').disabled = false;
                    document.getElementById('spinnerOverlay').style.display = 'none';
                    setStatus('Payment window closed. Click "Pay" to try again.');
                }
            }
        };

        var rzp = new Razorpay(options);
        rzp.on('payment.failed', function(response) {
            document.getElementById('spinnerOverlay').style.display = 'none';
            window.location.href = 'payment_failed.jsp?error=' + encodeURIComponent(response.error.description);
        });
        rzp.open();
    }
</script>
</body>
</html>
