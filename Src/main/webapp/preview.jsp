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
    String picName = "";
    String picUrl = "";
    String picPosition = "";
    String picDeleteUrl = "";

    // Test Usage
    picName = "1.jpg";
    picUrl = "../testResource/1.jpg";
    picPosition = picUrl;
    picDeleteUrl = picUrl;

    // True Usage
    picUrl = request.getAttribute("url").toString();
    Object deleteUrl = request.getAttribute("deleteUrl");
    String[] temp = picUrl.replaceAll("\\\\", "/").split("/");
    if (temp.length > 1) {
        picName = temp[temp.length - 1];
    } else {
        picName = "error.jpg";
    }
    picPosition = picUrl;
    if(deleteUrl != null)
    	picDeleteUrl = deleteUrl.toString();
%>

<%--TODO:
        (1) 美化
        (2)
--%>


<html>
<head>
    <meta charset="utf-8">
    <title>图床</title>
    <link rel="stylesheet" type="text/css" href="css/font-awesome.css"/>
    <link rel="stylesheet" type="text/css" href="css/index.css"/>
    <link rel="stylesheet" type="text/css" href="css/preview.css"/>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/animate.css/4.1.1/animate.css"/>
    <script src="js/utils.js"></script>
    <script src="js/index.js"></script>
    <script src="js/click.js"></script>
    <script>
        window.onload = () => {
            moveElementToCenter("imgPreview")
        }
        window.onresize = () => {
            moveElementToCenter("imgPreview")
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

<fieldset style="margin-top: 10px; position: fixed" id="imgPreview">
    <legend><img src="icons/tabler-icon-brand-unsplash.png" alt=""
                 style="vertical-align:middle; line-height:16px; height:16px; padding-right:5px;"><%=picName%>
    </legend>
    <table style="width:100%;">
        <tbody>
        <tr>
            <td style="width:260px; text-align: center;">
                <a href="<%=picUrl%>" target="_blank">
                    <img class="lazy" width="260" height="244"
                         src="<%=picPosition%>"
                         style="max-width: 300px;max-height: 300px;">
                </a>
            </td>
            <td class="padding10" style="text-align:left;">
                <div class="dlinput_header">HTML</div>
                <div class="dlinput_container">
                    <div class="row">
                        <div class="col-md-8">
                            <input class="form-control" type="text" onclick="this.select();"
                                   value="<a href=&quot;<%=picUrl%>&quot; target=&quot;_blank&quot;><img src=&quot;<%=picPosition%>&quot; ></a>">
                        </div>
                    </div>
                </div>
                <div class="dlinput_header mt3">BBCode</div>
                <div class="dlinput_container">
                    <div class="row">
                        <div class="col-md-8">
                            <input class="form-control" type="text" onclick="this.select();"
                                   value="[url=<%=picUrl%>][img]<%=picPosition%>[/img][/url]">
                        </div>
                    </div>
                </div>
                <div class="dlinput_header mt3">Markdown</div>
                <div class="dlinput_container">
                    <div class="row">
                        <div class="col-md-8">
                            <input class="form-control" type="text" onclick="this.select();"
                                   value="![86377681_p0.jpg](<%=picPosition%>)">
                        </div>
                    </div>
                </div>
                <div class="dlinput_header mt3">Link only</div>
                <div class="dlinput_container">
                    <div class="row">
                        <div class="col-md-8">
                            <input class="form-control" type="text" onclick="this.select();"
                                   value="<%=picUrl%>">
                        </div>
                    </div>
                </div>
                <div class="dlinput_header mt3">Removal Link (to delete the image)</div>
                <div class="dlinput_container">
                    <div class="row">
                        <div class="col-md-8">
                            <input class="form-control" type="text" onclick="this.select();"
                                   value="<%=picDeleteUrl%>">
                        </div>
                    </div>
                </div>
            </td>


        </tr>
        </tbody>
    </table>
</fieldset>

<script>document.onclick = clickwave;</script>

</body>
</html>
