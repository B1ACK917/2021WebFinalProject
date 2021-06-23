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
		String loginUser = (String) session.getAttribute("userId");
		if(loginUser != null) return;
		
		String username = request.getParameter("user");
		System.out.println(username);
		String password = request.getParameter("password");
		System.out.println(password);

		// 如果用户和密码都等于admin,则登录成功
		if ("admin".equals(username) && "admin".equals(password)) {
			session.setAttribute("userId", "1");
			request.setAttribute("message", "登录成功!");
			getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
		}

		if ("user1".equals(username) && "user1".equals(password)) {
			session.setAttribute("userId", "2");
			request.setAttribute("message", "登录成功!");
			getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
		}

		if ("user2".equals(username) && "user2".equals(password)) {
			session.setAttribute("userId", "3");
			request.setAttribute("message", "登录成功!");
			getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
		}
	}
}
