package com.tuchuang.user;

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
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
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

    public static String filter(String str) {
    	String regEx = "[^A-Za-z0-9]";
    	str = Pattern.compile(regEx).matcher(str).replaceAll("").trim();
    	return str;
    }
	
	public void init() throws ServletException{
		Connection c = null;
		Statement stmt = null;
		String sql = null;
		ResultSet rs;
		try {
			c = getConnection();
			System.out.println("Opened database successfully");

			stmt = c.createStatement();
			sql = "CREATE TABLE IF NOT EXISTS USER (\n"
					+ "    ID         INTEGER   PRIMARY KEY AUTO_INCREMENT\n" 
					+ "                         NOT NULL,\n"
					+ "    Name       CHAR(64)  NOT NULL,\n"
					+ "    Password   CHAR(64)  NOT NULL,\n" 
					+ "    Authority  INTEGER   NOT NULL\n"
					+ ");";
			stmt.executeUpdate(sql);
			
			sql = "SELECT ID FROM USER WHERE Name='admin';";
			rs  = stmt.executeQuery(sql);
			sql = "INSERT INTO USER VALUES(NULL, 'admin', 'admin', 0);";
			if(!rs.next()) stmt.executeUpdate(sql);

			sql = "SELECT ID FROM USER WHERE Name='user1';";
			rs  = stmt.executeQuery(sql);
			sql = "INSERT INTO USER VALUES(NULL, 'user1', 'user1', 1);";
			if(!rs.next()) stmt.executeUpdate(sql);

			sql = "SELECT ID FROM USER WHERE Name='user2';";
			rs  = stmt.executeQuery(sql);
			sql = "INSERT INTO USER VALUES(NULL, 'user2', 'user2', 1);";
			if(!rs.next()) stmt.executeUpdate(sql);
			
			stmt.close();
			c.close();
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Object userIdString = session.getAttribute("userId");
		if (userIdString != null)
			return;

		String username = request.getParameter("user");
		String password = request.getParameter("password");
		
		if(username == null || password == null) return;
		
		username = filter(username);
		password = filter(password);

		boolean loginSuccess = false;
		
		Connection c = null;
		Statement stmt = null;
		String sql = null;
		ResultSet rs;
		
		try {
			c = getConnection();
			stmt = c.createStatement();
			sql = "SELECT ID, Authority FROM USER WHERE Name='" + username + "' and Password='" + password + "';";
			rs  = stmt.executeQuery(sql);
			if(rs.next()) {
				System.out.println(rs.getInt("ID"));
				session.setAttribute("userId", rs.getInt("ID"));
				session.setAttribute("authority", rs.getInt("Authority"));
				loginSuccess = true;
			}
		}
		catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
		}
		
		if(loginSuccess) {
			session.setAttribute("username", username);
			response.sendRedirect("./index.jsp");
		}
	}
}
