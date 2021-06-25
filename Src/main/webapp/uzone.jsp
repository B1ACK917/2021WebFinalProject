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
<%
    // Test Usage
    String userName = "Test";
    String userZoneUrl = "http://localhost:8080/imgDepot/uzone.jsp";
    String userImageNum = "11";
    String userAlbumNum = "2";
    String[] tableImgs = {"testResource/1.jpg", "testResource/1.jpg", "testResource/1.jpg", "testResource/1.jpg",
            "testResource/1.jpg", "testResource/1.jpg", "testResource/1.jpg", "testResource/1.jpg"};

    // True Usage
//    userName = request.getAttribute("username").toString();
//    userZoneUrl = "http://localhost:8080/imgDepot/uzone.jsp";
//    userImageNum = request.getAttribute("totalImgs").toString();
//    userAlbumNum = request.getAttribute("totalAlbums").toString();
%>


<html>
<head>
    <meta charset="utf-8">
    <title>图床</title>
    <link rel="stylesheet" type="text/css" href="css/font-awesome.css"/>
    <link rel="stylesheet" type="text/css" href="css/index.css"/>
    <link rel="stylesheet" type="text/css" href="css/uzone.css"/>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/animate.css/4.1.1/animate.css"/>
    <script src="js/utils.js"></script>
    <script src="js/index.js"></script>
    <script>
        window.onload = () => {
            moveElementToCenter("contentWrapper")
        }
        window.onresize = () => {
            moveElementToCenter("contentWrapper")
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

    <div class="headPart welcome" style="display: <%=userDisplay%>">
        <a>欢迎您，<%=curUser%>
        </a>
    </div>
    <form action="./logout" method="post" style="display: none;" id="logoutForm"></form>
    <div class="headPart login" onclick="<%=logOnClick%>"><a><i class="fa fa-sign-in"
                                                                aria-hidden="true"></i> <%=logStatus%>
    </a>
    </div>
</div>

<div id="contentWrapper">
    <div id="contentWidth">
        <div id="topUser" class="topUser">
            <div class="userContent">
                <a href="<%=userZoneUrl%>">
                    <img src="testResource/1.jpg" alt="Head" class="userImage">
                </a>
                <h1>
                    <a>
                        <%=userName%>
                    </a>
                </h1>
                <div id="userMeta" class="userMeta">
                    <a class="userMetaLink" href="<%=userZoneUrl%>">
                        <i class="fa fa-pencil" aria-hidden="true"></i>
                        <span>编辑</span>
                    </a>
                </div>
            </div>

            <div class="topUserRight">
                <div class="textAlignRight">
                    <a class="numberFigures" href="<%=userZoneUrl%>">
                        <b>
                            <%=userImageNum%>
                        </b>
                        <span>图片</span>
                    </a>
                    <a class="numberFigures" href="<%=userZoneUrl%>">
                        <b>
                            <%=userAlbumNum%>
                        </b>
                        <span>相册</span>
                    </a>
                </div>
            </div>

            <div></div>
        </div>

        <div id="topTabs" class="header">
            <h1><%=userName%> 的图片</h1>
            <ul class="contentTabs">
                <li class="current"><a>最新的</a>
                </li>
                <li class=" "><a>最旧的</a>
                </li>
                <li class=" "><a>AZ</a>
                </li>
            </ul>
        </div>

        <div id="imgsFatherDiv">
            <div id="contentImgs">
                <table id="imgTable" class="imgTable">
                    <tr>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                    </tr>
                    <tr>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                        <td><img src="<%=tableImgs[0]%>" class="tableImg"></td>
                    </tr>
                </table>
            </div>
        </div>

        <div id="pageBtnDiv">
            <div id="btnLine" class="btnLine">
                <div class="leftBtn">
                    <div class="btn" onclick="<%=page%>">
                        上一页
                    </div>
                </div>
                <div class="rightBtn">
                    <div class="btn">
                        下一页
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
</body>
</html>