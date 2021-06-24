package com.tuchuang.upload;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/delete")
public class DeleteServlet extends HttpServlet {
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

	private String getRealPath(String path) {
		return getServletContext().getRealPath("/") + File.separator + path;
	}

    public static String filter(String str) {
    	String regEx = "[^A-Za-z0-9]";
    	str = Pattern.compile(regEx).matcher(str).replaceAll("").trim();
    	return str;
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String token = request.getParameter("token");
		if(token == null) return;
		token = filter(token);
		System.out.println(token);

		Connection c = null;
		Statement stmt = null;

		try {
			c = getConnection();
			stmt = c.createStatement();
			String querySql = "SELECT Path FROM IMAGE where Token = '" + token + "';";
			ResultSet rs = stmt.executeQuery(querySql);
			String path = null;
			while(rs.next()) {
				path = rs.getString("Path");
            }
            rs.close();
			
            if(path != null) {
				String deleteSql = "Delete FROM IMAGE where Token = '" + token + "';";
				stmt.executeUpdate(deleteSql);

				File file = new File(getRealPath(path));
				if (file.exists()) {
					file.delete();
				}
			}
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
