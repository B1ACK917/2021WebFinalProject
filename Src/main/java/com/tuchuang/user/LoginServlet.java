package com.tuchuang.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Object userIdString = session.getAttribute("userId");
		if (userIdString != null)
			return;

		String username = request.getParameter("user");
		System.out.println(username);
		String password = request.getParameter("password");
		System.out.println(password);

		boolean loginSuccess = false;
		
		if ("admin".equals(username) && "admin".equals(password)) {
			session.setAttribute("userId", 1);
			loginSuccess = true;
		}
		
		if ("user1".equals(username) && "user1".equals(password)) {
			session.setAttribute("userId", 2);
			loginSuccess = true;
		}
		
		if ("user2".equals(username) && "user2".equals(password)) {
			session.setAttribute("userId", 3);
			loginSuccess = true;
		}
		
		if(loginSuccess) {
			session.setAttribute("username", username);
			response.sendRedirect("./index.jsp");
		}
	}
}
