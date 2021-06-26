<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object obj = session.getAttribute("username");
    String exploreOnClick = "showLoginBox()";
    String randomOnClick = "showLoginBox()";
    String logOnClick = "showLoginBox()";
    String curUser = "none", userDisplay = "none", logStatus = "登入";
    String exploreUrl = "###";
    String randomUrl = "###";
    String uzoneUrl = "###";
    if (obj == null) {
        System.out.println("未登录");
    } else {
        System.out.println("已登录");
        curUser = obj.toString();
        userDisplay = "block";
        exploreOnClick = "";
        randomOnClick = "";
        logStatus = "登出";
        logOnClick = "postLogout()";
        exploreUrl = "./explorer.jsp";
        randomUrl = "./random";
        uzoneUrl = "./uzone.jsp";
    }
%>

<%
    String removeSuccess = null;
    Object removeSuccessObj = request.getParameter("removeSucess");
    if (removeSuccessObj == null) {
        response.sendRedirect("./index.jsp");
    } else {
        removeSuccess = "true";
    }
%>
<html>
<head>
    <meta charset="utf-8">
    <title>图床</title>
    <link rel="stylesheet" type="text/css" href="css/font-awesome.css"/>
    <link rel="stylesheet" type="text/css" href="css/index.css"/>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/animate.css/4.1.1/animate.css"/>
    <script src="js/utils.js"></script>
    <script src="js/index.js"></script>
    <script src="js/click.js"></script>
</head>

<body id="removedPageBody">
<div id="header">
    <div class="headPart explore" onclick="<%=exploreOnClick%>">
        <a href="<%=exploreUrl%>">
            <i class="fa fa-bars"
               aria-hidden="true"></i>
            探索</a>
    </div>
    <div class="headPart random" onclick="<%=randomOnClick%>">
        <a href="<%=randomUrl%>">
            <i class="fa fa-random"
               aria-hidden="true"></i>
            随机</a>
    </div>
    <div class="headPart search">
        <form style="margin-top: -4px;">
            <input type="text" name="search" placeholder="搜索..">
        </form>
    </div>

    <div class="headPart home" onclick="<%=randomOnClick%>">
        <a href="index.jsp">
            <img src="icons/Home-w.png">
        </a>
    </div>

    <div class="headPart welcome" style="display: <%=userDisplay%>">
        <a href="<%=uzoneUrl%>">欢迎您，<%=curUser%>
        </a>
    </div>
    <form action="./logout" method="post" style="display: none;" id="logoutForm"></form>
    <div class="headPart login" onclick="<%=logOnClick%>"><a><i class="fa fa-sign-in"
                                                                aria-hidden="true"></i> <%=logStatus%>
    </a>
    </div>
</div>

</body>
</html>
