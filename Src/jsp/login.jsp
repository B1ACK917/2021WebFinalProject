<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");
	String msg = "";
	String connectString = "jdbc:mysql://localhost:3306/webproject"
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	String user="user"; String pwd="123";
	String name = request.getParameter("user_name");
	String password = request.getParameter("user_password");
	if(request.getMethod().equalsIgnoreCase("post")){
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(connectString,user, pwd);
		Statement stmt = con.createStatement();
		try{ 
			String sql = "select * from users where name=" + name + " and password=" + queryVal;
			int cnt = stmt.executeUpdate(sql);
			if(cnt>0)
            {
                msg = "登录成功!";
                session.setAttribute("name", name);
                session.setAttribute("password", password);
            }
            else{
                meg = "用户名或密码错误！";
            } 
			stmt.close(); 
            con.close();
		}catch (Exception e){
			msg = e.getMessage();
		}
	}
%>

<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>图床</title>
</head>
<body>
    <div><%=msg%></div>
</body>
</html>
