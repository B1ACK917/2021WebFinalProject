<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");
	String name= (String)session.getAttribute("name");
    String password= (String)session.getAttribute("password");
%>

<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>图床</title>
</head>
<body>
    <%=name%><br><%=password%>
</body>
</html>
