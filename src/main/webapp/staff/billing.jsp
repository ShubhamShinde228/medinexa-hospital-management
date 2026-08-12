<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect"%>
<%@ page import="com.dao.AdmitPatientDAO"%>
<%@ page import="com.dao.BillingDao"%>
<%@ page import="com.dao.DoctorDao"%>
<%@ page import="com.entity.AdmitPatient"%>
<%@ page import="com.entity.Billing"%>
<%@ page import="com.entity.BillingItem"%>
<%@ page import="com.entity.Doctor"%>
<%@ page import="com.entity.Staff"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%
    Staff staffObj = (Staff) session.getAttribute("staffObj");
    if (staffObj == null) {
        session.setAttribute("errorMsg", "Please login as staff to access billing.");
        response.sendRedirect("../staff_login.jsp");
        return;
    }

    Connection conn = DBConnect.getConn();
    BillingDao billingDao = new BillingDao(conn);
    AdmitPatientDAO patientDao = new AdmitPatientDAO(conn);
    DoctorDao doctorDao = new DoctorDao(conn);

    String admissionIdStr = request.getParameter("admissionId");
    String billIdStr = request.getParameter("billId");

    Billing bill = null;
    AdmitPatient patient = null;
    List<BillingItem> billingItems = null;

    if (billIdStr != null && !billIdStr.trim().isEmpty()) {
        try {
            int billId = Integer.parseInt(billIdStr);
            bill = billingDao.getBillingById(billId);
            if (bill != null) {
                billingItems = billingDao.getBillingItemsByBillId(bill.getId());
                patient = patientDao.getPatientById(bill.getAdmissionId());
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    } else if (admissionIdStr != null && !admissionIdStr.trim().isEmpty()) {
        try {
            int admissionId = Integer.parseInt(admissionIdStr);
            bill = billingDao.getBillingByAdmissionId(admissionId);
            if (bill != null) {
                response.sendRedirect("billing.jsp?billId=" + bill.getId());
                return;
            }
            patient = patientDao.getPatientById(admissionId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    if (patient == null && bill == null) {
        session.setAttribute("errorMsg", "Specified Patient Admission or Bill ID was not found.");
        response.sendRedirect("ViewAdmittedPatients.jsp");
        return;
    }

    String doctorName = "N/A";
    if (patient != null) {
        Doctor d = doctorDao.getDoctorById(patient.getDoctorId());
        if (d != null) {
            doctorName = d.getFullName();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= bill == null ? "Generate Bill" : "Invoice Detail" %> - MEDI HOME</title>
    <%@ include file="navbarcss.jsp"%>
    <style>
        .billing-card {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp"%>

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-success fw-bold mb-0">
                <i class="fa-solid fa-file-invoice-dollar me-2"></i>
                <%= bill == null ? "Generate Patient Discharge Bill" : "Invoice #" + bill.getInvoiceNumber() %>
            </h2>
            <a href="ViewAdmittedPatients.jsp" class="btn btn-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Patient Directory
            </a>
        </div>

        <!-- Patient Context Alert -->
        <div class="card border-0 bg-light p-3 mb-4 billing-card">
            <div class="row">
                <div class="col-md-3">
                    <small class="text-muted d-block">Patient Name</small>
                    <strong class="text-dark"><%= patient != null ? patient.getName() : bill.getPatientName() %></strong>
                </div>
                <div class="col-md-3">
                    <small class="text-muted d-block">Admitted For / Disease</small>
                    <strong class="text-dark"><%= patient != null ? patient.getDisease() : "N/A" %></strong>
                </div>
                <div class="col-md-3">
                    <small class="text-muted d-block">Attending Doctor</small>
                    <strong class="text-dark"><%= patient != null ? doctorName : bill.getDoctorName() %></strong>
                </div>
                <div class="col-md-3">
                    <small class="text-muted d-block">Admission Date</small>
                    <strong class="text-dark"><%= patient != null ? patient.getAdmittedDate() : bill.getAdmissionDate() %></strong>
                </div>
            </div>
        </div>

        <% if (bill == null) { %>
            <!-- BILL CREATION MODE -->
            <form action="../billing?action=create" method="POST" id="billingForm">
                <input type="hidden" name="admissionId" value="<%= patient.getId() %>">
                <input type="hidden" name="patientName" value="<%= patient.getName() %>">
                <input type="hidden" name="doctorName" value="<%= doctorName %>">
                <input type="hidden" name="admissionDate" value="<%= patient.getAdmittedDate() %>">
                
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card border-0 p-4 billing-card mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold mb-0">Line Items</h5>
                                <button type="button" class="btn btn-success btn-sm" onclick="addRow()">
                                    <i class="fa-solid fa-plus me-1"></i> Add Row
                                </button>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 25%;">Item Type</th>
                                            <th style="width: 35%;">Description</th>
                                            <th style="width: 12%;">Qty</th>
                                            <th style="width: 15%;">Unit Price (INR)</th>
                                            <th style="width: 15%;">Total (INR)</th>
                                            <th style="width: 5%;"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="billingItemsBody">
                                        <!-- Rows added dynamically via JS -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card border-0 p-4 billing-card bg-light mb-4">
                            <h5 class="fw-bold mb-4">Summary & Discharge Details</h5>
                            <div class="mb-3">
                                <label class="form-label small text-muted">Discharge Date</label>
                                <input type="date" name="dischargeDate" class="form-control" required id="dischargeDateInput">
                            </div>
                            <div class="mb-3">
                                <label class="form-label small text-muted">Notes / Comments</label>
                                <textarea name="notes" class="form-control" rows="3" placeholder="Additional remarks..."></textarea>
                            </div>
                            <hr class="my-4">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Subtotal:</span>
                                <span class="fw-semibold">INR <span id="subtotalText">0.00</span></span>
                                <input type="hidden" name="subtotal" id="subtotalInput" value="0.00">
                            </div>
                            <div class="mb-2">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="text-muted">Discount (INR):</span>
                                    <input type="number" name="discount" id="discountInput" class="form-control form-control-sm text-end" style="width: 100px;" value="0.00" min="0" step="0.01" onchange="calculateTotals()">
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="text-muted">Tax (%):</span>
                                    <input type="number" name="tax" id="taxInput" class="form-control form-control-sm text-end" style="width: 100px;" value="0.00" min="0" max="100" step="0.1" onchange="calculateTotals()">
                                </div>
                                <div class="text-end text-muted small">Tax Amount: INR <span id="taxAmountText">0.00</span></div>
                            </div>
                            <hr class="my-3">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <span class="fw-bold text-dark fs-5">Grand Total:</span>
                                <span class="fw-bold text-success fs-4">INR <span id="grandTotalText">0.00</span></span>
                                <input type="hidden" name="grandTotal" id="grandTotalInput" value="0.00">
                            </div>
                            <button type="submit" class="btn btn-success w-100 py-2 fw-semibold">
                                <i class="fa-solid fa-save me-1"></i> Save & Generate Bill
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        <% } else { %>
            <!-- BILL INVOICE DETAIL VIEW MODE -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card border-0 p-4 billing-card mb-4 bg-white">
                        <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                            <div>
                                <small class="text-muted d-block">Invoice Date</small>
                                <span class="fw-semibold"><%= bill.getCreatedAt() %></span>
                            </div>
                            <div>
                                <small class="text-muted d-block">Discharge Date</small>
                                <span class="fw-semibold"><%= bill.getDischargeDate() != null ? bill.getDischargeDate() : "N/A" %></span>
                            </div>
                            <div>
                                <small class="text-muted d-block">Status</small>
                                <% if ("PAID".equals(bill.getPaymentStatus())) { %>
                                    <span class="badge bg-success">PAID</span>
                                <% } else { %>
                                    <span class="badge bg-warning text-dark">UNPAID</span>
                                <% } %>
                            </div>
                        </div>

                        <h5 class="fw-bold mb-3">Itemized Details</h5>
                        <div class="table-responsive mb-4">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="table-light">
                                        <th>Item Type</th>
                                        <th>Description</th>
                                        <th class="text-center">Qty</th>
                                        <th class="text-end">Unit Price</th>
                                        <th class="text-end">Total Price</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (billingItems != null) { 
                                        for (BillingItem item : billingItems) { %>
                                            <tr>
                                                <td><span class="badge bg-secondary"><%= item.getItemType() %></span></td>
                                                <td><%= item.getDescription() %></td>
                                                <td class="text-center"><%= item.getQuantity() %></td>
                                                <td class="text-end">INR <%= String.format("%.2f", item.getUnitPrice()) %></td>
                                                <td class="text-end fw-semibold">INR <%= String.format("%.2f", item.getTotalPrice()) %></td>
                                            </tr>
                                    <% } } %>
                                </tbody>
                            </table>
                        </div>
                        
                        <% if (bill.getNotes() != null && !bill.getNotes().trim().isEmpty()) { %>
                            <div class="mt-4 p-3 bg-light rounded">
                                <h6 class="fw-bold text-muted mb-1">Invoice Notes:</h6>
                                <p class="mb-0 text-secondary"><%= bill.getNotes() %></p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 p-4 billing-card bg-light mb-4">
                        <h5 class="fw-bold mb-4">Payment Summary</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Subtotal:</span>
                            <span>INR <%= String.format("%.2f", bill.getSubtotal()) %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Discount:</span>
                            <span class="text-danger">- INR <%= String.format("%.2f", bill.getDiscount()) %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">Tax:</span>
                            <span>INR <%= String.format("%.2f", bill.getTax()) %></span>
                        </div>
                        <hr class="my-3">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fw-bold text-dark fs-5">Grand Total:</span>
                            <span class="fw-bold text-success fs-4">INR <%= String.format("%.2f", bill.getGrandTotal()) %></span>
                        </div>

                        <% if (!"PAID".equals(bill.getPaymentStatus())) { %>
                            <div class="d-grid gap-3">
                                <!-- Option 1: Razorpay Payment Link -->
                                <a href="../payment_checkout.jsp?type=DISCHARGE_BILL&billId=<%= bill.getId() %>&admissionId=<%= bill.getAdmissionId() %>&amount=<%= bill.getGrandTotal() %>" class="btn btn-success py-2 fw-semibold">
                                    <i class="fa-solid fa-credit-card me-1"></i> Razorpay Payment
                                </a>
                                
                                <hr class="my-2">
                                
                                <!-- Option 2: Record Manual Cash/Card/UPI Payment -->
                                <form action="../billing?action=cashPayment" method="POST" class="p-3 bg-white rounded border">
                                    <input type="hidden" name="billId" value="<%= bill.getId() %>">
                                    <input type="hidden" name="admissionId" value="<%= bill.getAdmissionId() %>">
                                    <input type="hidden" name="amount" value="<%= bill.getGrandTotal() %>">
                                    
                                    <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-wallet me-1"></i> Record Manual Payment</h6>
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">Payment Method</label>
                                        <select name="paymentMethod" class="form-select form-select-sm" required>
                                            <option value="CASH">CASH</option>
                                            <option value="UPI">UPI</option>
                                            <option value="CARD">CARD</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-outline-success btn-sm w-100 py-2">
                                        Submit Payment Status
                                    </button>
                                </form>
                            </div>
                        <% } else { %>
                            <div class="alert alert-success text-center mb-4 py-3">
                                <i class="fa-solid fa-circle-check fs-3 d-block mb-2"></i>
                                <span class="fw-bold">Invoice Paid in Full</span>
                            </div>
                            <a href="../generateInvoice?billId=<%= bill.getId() %>" class="btn btn-outline-success w-100 py-2 fw-semibold">
                                <i class="fa-solid fa-file-pdf me-1"></i> Download Invoice PDF
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Include SweetAlert -->
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script>
        // Set today's date as default for discharge date input
        const dateInput = document.getElementById('dischargeDateInput');
        if (dateInput) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.value = today;
        }

        let rowCount = 0;

        function addRow() {
            const tbody = document.getElementById('billingItemsBody');
            const tr = document.createElement('tr');
            tr.id = 'row_' + rowCount;
            tr.innerHTML = `
                <td>
                    <select name="itemType" class="form-select form-select-sm" required>
                        <option value="ROOM_CHARGE">Room Charge</option>
                        <option value="DOCTOR_FEE">Doctor Fee</option>
                        <option value="MEDICINE">Medicine</option>
                        <option value="LAB_TEST">Lab Test</option>
                        <option value="ADMISSION_CHARGE">Admission Charge</option>
                        <option value="OTHER">Other</option>
                    </select>
                </td>
                <td>
                    <input type="text" name="description" class="form-control form-control-sm" placeholder="e.g. Ward Room Rent" required>
                </td>
                <td>
                    <input type="number" name="quantity" class="form-control form-control-sm text-center item-qty" value="1" min="1" oninput="calculateRow(${rowCount})" required>
                </td>
                <td>
                    <input type="number" name="unitPrice" class="form-control form-control-sm text-end item-price" value="0.00" min="0" step="0.01" oninput="calculateRow(${rowCount})" required>
                </td>
                <td>
                    <input type="number" name="totalPrice" class="form-control form-control-sm text-end item-total" value="0.00" step="0.01" readonly>
                </td>
                <td class="text-center">
                    <button type="button" class="btn btn-link text-danger p-0" onclick="removeRow(${rowCount})">
                        <i class="fa-solid fa-trash"></i>
                    </button>
                </td>
            `;
            tbody.appendChild(tr);
            calculateRow(rowCount);
            rowCount++;
        }

        function removeRow(id) {
            const row = document.getElementById('row_' + id);
            if (row) {
                row.remove();
                calculateTotals();
            }
        }

        function calculateRow(id) {
            const row = document.getElementById('row_' + id);
            if (row) {
                const qtyInput = row.querySelector('.item-qty');
                const priceInput = row.querySelector('.item-price');
                const totalInput = row.querySelector('.item-total');

                const qty = parseInt(qtyInput.value) || 0;
                const price = parseFloat(priceInput.value) || 0;
                const total = qty * price;
                totalInput.value = total.toFixed(2);
                calculateTotals();
            }
        }

        function calculateTotals() {
            let subtotal = 0;
            document.querySelectorAll('.item-total').forEach(el => {
                subtotal += parseFloat(el.value) || 0;
            });

            document.getElementById('subtotalInput').value = subtotal.toFixed(2);
            document.getElementById('subtotalText').innerText = subtotal.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

            const discount = parseFloat(document.getElementById('discountInput').value) || 0;
            const taxPercent = parseFloat(document.getElementById('taxInput').value) || 0;

            const taxableAmount = Math.max(0, subtotal - discount);
            const taxAmount = taxableAmount * (taxPercent / 100);
            const grandTotal = taxableAmount + taxAmount;

            document.getElementById('taxAmountText').innerText = taxAmount.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('grandTotalInput').value = grandTotal.toFixed(2);
            document.getElementById('grandTotalText').innerText = grandTotal.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        // Initialize with one empty row in create mode
        <% if (bill == null) { %>
            document.addEventListener("DOMContentLoaded", function() {
                addRow();
            });
        <% } %>
    </script>
    
    <%
        String successMessage = (String) session.getAttribute("sucMsg");
        String errorMessage = (String) session.getAttribute("errorMsg");

        if (successMessage != null) {
    %>
    <script type="text/javascript">
        swal("Success", "<%= successMessage %>", "success");
    </script>
    <%
            session.removeAttribute("sucMsg");
        }

        if (errorMessage != null) {
    %>
    <script type="text/javascript">
        swal("Error", "<%= errorMessage %>", "error");
    </script>
    <%
            session.removeAttribute("errorMsg");
        }
    %>
</body>
</html>
