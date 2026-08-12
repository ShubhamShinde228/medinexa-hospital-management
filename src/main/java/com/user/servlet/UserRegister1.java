package com.user.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.regex.Pattern;

import com.dao.UserDao;
import com.db.DBConnect;
import com.entity.User;

@WebServlet("/UserRegister1")
public class UserRegister1 extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            // Get form parameters
            String fullName = request.getParameter("fullname");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            
            if (fullName == null || email == null || password == null ||
                    fullName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                session.setAttribute("errorMsg", "All fields are required.");
                response.sendRedirect("sign_up.jsp");
                return;
            }

          
            String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
            if (!Pattern.matches(emailRegex, email)) {
                session.setAttribute("errorMsg", "Invalid email format.");
                response.sendRedirect("sign_up.jsp");
                return;
            }

           
            String passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{6,}$";
            if (!Pattern.matches(passwordRegex, password)) {
                session.setAttribute("errorMsg", "Password must be at least 6 characters, include a number and a special character.");
                response.sendRedirect("sign_up.jsp");
                return;
            }

         
            User u = new User(fullName, email, password);

           
            UserDao dao = new UserDao(DBConnect.getConn());

            if (dao.register(u)) {
                session.setAttribute("sucMsg", "Account created successfully!");
                response.sendRedirect("user_login.jsp");
            } else {
                session.setAttribute("errorMsg", "Registration failed. Email might already be in use.");
                response.sendRedirect("sign_up.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Something went wrong. Please try again.");
            response.sendRedirect("sign_up.jsp");
        }
    }
}
