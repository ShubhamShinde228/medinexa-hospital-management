package com.user.servlet;

import com.dao.UserDao;
import com.db.DBConnect;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
     
        UserDao userDAO = new UserDao(DBConnect.getConn());  
        
        User user = userDAO.getUserByEmail(email); 
        
        if (user != null) {
            String newPassword = userDAO.resetPassword(email);
            response.getWriter().println("Your new password is: " + newPassword);
        } else {
            response.getWriter().println("Email not found!");
        }
    }
}
