package com.feature.servlet;

import com.db.DBConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/claimVerifier")
public class ClaimVerifierServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String provider = request.getParameter("provider");
            String policyNo = request.getParameter("policyNo");
            double estimatedCost = Double.parseDouble(request.getParameter("estimatedCost"));

            double coveragePct = 0.85; // Default 85% coverage
            if (provider != null && provider.toLowerCase().contains("ayushman")) {
                coveragePct = 1.0; // 100% Cashless Government Scheme
            }

            double insuranceShare = estimatedCost * coveragePct;
            double patientShare = estimatedCost - insuranceShare;

            request.getSession().setAttribute("sucMsg", "✅ INSURANCE PRE-AUTHORIZATION APPROVED! Covered Amount: ₹" + String.format("%.2f", insuranceShare) + " (" + (int)(coveragePct * 100) + "%) | Out-of-Pocket: ₹" + String.format("%.2f", patientShare));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Verification Error: " + e.getMessage());
        }
        response.sendRedirect("claim_verifier.jsp");
    }
}
