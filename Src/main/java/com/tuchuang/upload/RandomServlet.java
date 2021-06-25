package com.tuchuang.upload;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Pattern;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/random")
public class RandomServlet extends HttpServlet {
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

	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
		String sql = "SELECT Path FROM IMAGE WHERE ID >= ((SELECT MAX(ID) FROM IMAGE)-(SELECT MIN(ID) FROM IMAGE)) * RAND() + (SELECT MIN(ID) FROM IMAGE)  LIMIT 1;";
		Connection c = null;
		Statement stmt = null;
		
		try {
			c = getConnection();
			stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			String path = null;
			while(rs.next()) {
				path = rs.getString("Path");
            }
            rs.close();

            if(path != null) {
        		URL baseUrl = new URL(request.getRequestURL().toString());
        		request.setAttribute("url", concatenate(baseUrl, "./" + path));
			}
    		getServletContext().getRequestDispatcher("/preview.jsp").forward(request, response);
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
