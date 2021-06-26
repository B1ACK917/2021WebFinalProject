<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.net.URL" %>
<%
    Object userIdObj = session.getAttribute("userId");
    if (userIdObj == null) response.sendRedirect("./index.jsp");
    int userId = (int) userIdObj;
    Object authorityObj = session.getAttribute("authority");
    int authority = (int) authorityObj;

    Object obj = session.getAttribute("username");
    String exploreOnClick = "showLoginBox()";
    String randomOnClick = "showLoginBox()";
    String uploadOnClick = "showLoginBox()";
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
        uploadOnClick = "selectFile()";
        logStatus = "登出";
        logOnClick = "postLogout()";
        exploreUrl = "./explorer.jsp";
        randomUrl = "./random";
        uzoneUrl = "./uzone.jsp";
    }

%>

<%

    int pageSize = 8;
    int curPage;
    Object pageObj = request.getParameter("page");
    if (pageObj == null) {
        curPage = 0;
    } else {
        System.out.println(pageObj);
        curPage = Integer.parseInt(pageObj.toString());
    }

    int orderBy;
    Object orderObj = request.getParameter("orderBy");
    if (orderObj == null) {
        orderBy = 0;
    } else {
        System.out.println(orderObj);
        orderBy = Integer.parseInt(orderObj.toString());
    }

    int skip = curPage * pageSize;
    int userImageNum = 0;

    Connection c = null;
    Statement stmt = null;

    String connectString = "jdbc:mysql://web.malloc.fun:3306/web_malloc_fun" + "?autoReconnect=true&useUnicode=true"
            + "&characterEncoding=UTF-8";
    String user = "web_malloc_fun";
    String pwd = "y7tM7hftsFSyMC2y";
    Class.forName("com.mysql.jdbc.Driver");
    c = DriverManager.getConnection(connectString, user, pwd);
    stmt = c.createStatement();
    String sql = "SELECT COUNT(*) FROM IMAGE WHERE userId=" + userId + ";";
    ResultSet rs = stmt.executeQuery(sql);

    if (rs.next())
        userImageNum = rs.getInt(1);

    if(orderBy == 0) {
	    sql = "SELECT ID, Path FROM IMAGE WHERE userId=" + userId + " ORDER BY CreateTime DESC" + " limit " + skip + " , " + pageSize + ";";
    }
    else if(orderBy == 1){
	    sql = "SELECT ID, Path FROM IMAGE WHERE userId=" + userId + " ORDER BY CreateTime ASC" + " limit " + skip + " , " + pageSize + ";";
    }
    else {
    	sql = "SELECT ID, Path FROM IMAGE WHERE userId=" + userId + " ORDER BY Path ASC" + " limit " + skip + " , " + pageSize + ";";
    }
	
    rs = stmt.executeQuery(sql);
    String[] tableImgs = new String[8];
    String[] previewUrls = new String[8];
    int cnt = 0;
    URL baseUrl = new URL(request.getRequestURL().toString());
    for (int i = 0; i < 8; i++) {
        if (rs.next()) {
            String path = rs.getString("Path");
            tableImgs[i] = new URL(baseUrl, path).toString();
            previewUrls[i] = "./preview?id=" + rs.getInt("ID");
        }
    }
    rs.close();
%>

<%
    String userName = curUser;
    String userZoneUrl = "./uzone.jsp";
    Number userAlbumNum = 0;
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
            removeAnchorDecoration(".tableImg")
            relocateCurOrder()
        }
        window.onresize = () => {
            moveElementToCenter("contentWrapper")
        }

        function prevPage() {
            let curPage = parseInt("<%=curPage%>")
            if (curPage > 0) {
                window.location.href = "uzone.jsp?page=" + (curPage - 1) + "&orderBy=" + orderType
            } else {
                window.location.href = "uzone.jsp?page=0" + "&orderBy=" + orderType
            }
        }

        function nextPage() {
            let curPage = parseInt("<%=curPage%>")
            let maxPage = Math.floor(parseInt("<%=userImageNum%>") / 8)
            if (curPage >= maxPage) {
                window.location.href = "uzone.jsp?page=" + maxPage + "&orderBy=" + orderType
            } else {
                window.location.href = "uzone.jsp?page=" + (curPage + 1) + "&orderBy=" + orderType
            }
        }

        function changeOrderBy(orderType) {
            let orderBy = parseInt(orderType)
            let curPage = parseInt("<%=curPage%>")
            if (orderType > 2 || orderType < 0) return 0
            else {
                window.location.href = "uzone.jsp?page=" + curPage + "&orderBy=" + orderType
            }
        }

        function relocateCurOrder() {
            let lis = document.querySelectorAll('.contentTabs>li')
            lis.forEach(element => {
                element.className = ""
            })
            let orderBy = parseInt("<%=orderBy%>")
            lis[orderBy].className = "current"
        }
    </script>
</head>

<body>
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
                </div>
            </div>

            <div></div>
        </div>

        <div id="topTabs" class="header">
            <h1><%=userName%> 的图片</h1>
            <ul class="contentTabs">
                <li class="current" onclick="changeOrderBy(0)"><a>最新的</a>
                </li>
                <li class=" " onclick="changeOrderBy(1)"><a>最旧的</a>
                </li>
                <li class=" " onclick="changeOrderBy(2)"><a>AZ</a>
                </li>
            </ul>
        </div>

        <div id="imgsFatherDiv">
            <div id="contentImgs">
                <table id="imgTable" class="imgTable">
                    <tr>
                        <td><a href="<%=previewUrls[0]%>"><img src="<%=tableImgs[0]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                        <td><a href="<%=previewUrls[1]%>"><img src="<%=tableImgs[1]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                        <td><a href="<%=previewUrls[2]%>"><img src="<%=tableImgs[2]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                        <td><a href="<%=previewUrls[3]%>"><img src="<%=tableImgs[3]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                    </tr>
                    <tr>
                        <td><a href="<%=previewUrls[4]%>"><img src="<%=tableImgs[4]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                        <td><a href="<%=previewUrls[5]%>"><img src="<%=tableImgs[5]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                        <td><a href="<%=previewUrls[6]%>"><img src="<%=tableImgs[6]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                        <td><a href="<%=previewUrls[7]%>"><img src="<%=tableImgs[7]%>" class="tableImg"
                                                               onerror="this.src='icons/alp0.png'"></a></td>
                    </tr>
                </table>
            </div>
        </div>

        <div id="pageBtnDiv">
            <div id="btnLine" class="btnLine">
                <div id="leftBtn" onclick="prevPage()">
                    <div class="btn">
                        上一页
                    </div>
                </div>
                <div id="rightBtn" onclick="nextPage()">
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
