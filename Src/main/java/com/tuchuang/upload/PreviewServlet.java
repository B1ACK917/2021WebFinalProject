package com.tuchuang.upload;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/preview")
public class PreviewServlet extends HttpServlet {
	private Connection getConnection() throws ClassNotFoundException, SQLException {
		Connection c = null;
		String connectString = "jdbc:mysql://web.malloc.fun:3306/web_malloc_fun" + "?autoReconnect=true&useUnicode=true"
				+ "&characterEncoding=UTF-8";
		String user = "web_malloc_fun";
		String pwd = "y7tM7hftsFSyMC2y";
		Class.forName("com.mysql.jdbc.Driver");
		c = DriverManager.getConnection(connectString, user, pwd);
		return c;
	}

	public static String concatenate(URL baseUrl, String relativePath) throws URISyntaxException, MalformedURLException {
		URL url = new URL(baseUrl, relativePath);
		return url.toString();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String imageIdStr = request.getParameter("id");
		if(imageIdStr == null || "" == imageIdStr.trim()) response.sendRedirect("./index.jsp");
		int imageId = Integer.parseInt(imageIdStr);

		Connection c = null;
		Statement stmt = null;

		HttpSession session = request.getSession();
		
		int userId = -1;
		int authority = -1;
		Object userIdObj = session.getAttribute("userId");
		if(userIdObj != null) userId = (int) userIdObj;
		Object authorityObj = session.getAttribute("authority");
		if(authorityObj != null) authority = (int) authorityObj;
		
		try {
			c = getConnection();
			stmt = c.createStatement();
			String sql = "SELECT Path, Token, UserId FROM IMAGE WHERE ID = " + imageId + ";";
			URL baseUrl = new URL(request.getRequestURL().toString());
			ResultSet rs = stmt.executeQuery(sql);
			if(rs.next()) {
				int imgUserId = rs.getInt("UserId");
				if(imgUserId == userId || authority == 0) {
					request.setAttribute("deleteUrl", concatenate(baseUrl, "./delete?token=" + rs.getString("Token")));;
				}
				request.setAttribute("url", concatenate(baseUrl, "./" + rs.getString("Path")));
	    		getServletContext().getRequestDispatcher("/display.jsp").forward(request, response);
            }
			else {
				response.sendRedirect("./index.jsp");
			}
            rs.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			// 关闭资源
			try {
				if (stmt != null)
					stmt.close();
			} catch (SQLException se2) {
			} // 什么都不做
			try {
				if (c != null)
					c.close();
			} catch (SQLException se) {
				se.printStackTrace();
			}
		}
	}
}
