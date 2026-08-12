package com.user.servlet;

import java.io.IOException;

import com.dao.UserDao;
import com.db.DBConnect;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserLogin")
public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
           
            String email = request.getParameter("email");
            String password = request.getParameter("password");

           
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Email and password are required.");
                response.sendRedirect("user_login.jsp");
                return;
            }

            UserDao dao = new UserDao(DBConnect.getConn());
            User user = dao.login(email, password);

            if (user != null) {
            
                session.setAttribute("userObj", user);
                response.sendRedirect("index.jsp");
              
            } else {
                session.setAttribute("errorMsg", "Invalid email or password.");
                response.sendRedirect("user_login.jsp"); 
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An error occurred. Please try again.");
            response.sendRedirect("user_login.jsp");
        }
    }
}
