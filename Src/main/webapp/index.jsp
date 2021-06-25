<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object obj = session.getAttribute("username");
    String exploreOnClick = "showLoginBox()";
    String randomOnClick = "showLoginBox()";
    String uploadOnClick = "showLoginBox()";
    String logOnClick = "showLoginBox()";
    String curUser = "none", userDisplay = "none", logStatus = "登入";
    if (obj == null) {
        System.out.println("未登录");
    } else {
        System.out.println("已登录");
        curUser = obj.toString();
        userDisplay = "block";
        exploreOnClick = "";
        randomOnClick = "";
        uploadOnClick = "selectFile()";
        logStatus = "登出";
        logOnClick = "postLogout()";
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
    <script>
        window.onload = () => {
            moveElementToCenter("main");
            moveElementToCenter("loginFrame")
            removeLoginFrame()
        }
        window.onresize = () => {
            moveElementToCenter("main");
            moveElementToCenter("loginFrame")
        }
    </script>
</head>

<body>

<div id="header">
    <div class="headPart explore" onclick="<%=exploreOnClick%>">
        <a>
            <i class="fa fa-bars"
               aria-hidden="true"></i>
            探索</a>
    </div>
    <div class="headPart random" onclick="<%=randomOnClick%>">
        <a>
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
            <img src="icons/Home.png">
        </a>
    </div>

    <div class="headPart welcome" style="display: <%=userDisplay%>">
        <a href="uzone.jsp">欢迎您，<%=curUser%>
        </a>
    </div>
    <form action="./logout" method="post" style="display: none;" id="logoutForm"></form>
    <div class="headPart login" onclick="<%=logOnClick%>"><a><i class="fa fa-sign-in"
                                                                aria-hidden="true"></i> <%=logStatus%>
    </a>
    </div>
</div>

<div id="main">
    <h1 style="text-align: center; color: white; height: 80px; ">上传与分享您的图片</h1>
    <h3 style="text-align: center; color: white; height: 80px;">
        任意拖放图片到这里, 即开始上传你的图片。 <br>
        或者点击下面的图标以开始批量上传你的图片。
    </h3>
    <form action="./upload" method="post" style="display: none;" id="fileUploadForm" enctype="multipart/form-data">
        <input type="file" name="images" id="fileInput" onchange="postFile()" accept="image/*">
    </form>
    <div class="upload" id="uploadBtn" onclick="<%=uploadOnClick%>">
        <a>
            <i class="fa fa-cloud-upload" aria-hidden="true"></i>
            开始上传
        </a>
    </div>
</div>

<div id="loginFrame">
    <form id="loginArgs" method="POST" action="./login">
        <div class="login-header">
            <img src="icons/tabler-icon-activity.png">
            <p>Login</p>
        </div>
        <div class="login-input-box">
            <i class="fa fa-user" aria-hidden="true" style="width: 20px;"></i>
            <input type="text" placeholder="账户" name="user" id="userInput">
        </div>
        <div class="login-input-box">
            <i class="fa fa-lock" aria-hidden="true" style="width: 20px;"></i>
            <input type="password" placeholder="密码" name="password" id="pwdInput">
        </div>
    </form>
    <div class="login-button-box">
        <button onclick="postAccount()">登录</button>
    </div>
    <div class="back-arrow">
        <i class="fa fa-arrow-left" aria-hidden="true" onclick="hideLoginBox()"></i>
    </div>
</div>
</body>

<script>document.onclick = clickwave;</script>
<script type="text/javascript" color="255,255,255" opacity='0.7' zIndex="-2" count="200" src="js/net.js"></script>

</html>
