<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="ko">
<head>
    <title>title</title>

    <style>
        .nav-wrapper {
            background-color: #ffe9c9;
            border-bottom: 1px solid #eee;
            padding: 0 20px;
            position: relative;
        }

        .nav-header {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 60px;
        }

        .nav-header a {
            text-decoration: none;
            color: #555;
            font-size: 14px;
            font-weight: bold;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0 80px;
        }

        .nav-header a.active {
            color: #ff914d;
        }

        .nav-header i {
            font-size: 20px;
            margin-bottom: 4px;
        }

        .nav-right {
            position: absolute;
            top: 10px;
            right: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-info {
            color: #333;
        }

        .nav-right a {
            text-decoration: none;
            color: #555;
        }

        .nav-right a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
<div class="nav-wrapper">
    <!-- 가운데 메뉴 -->
    <div class="nav-header">
        <a href="<c:url value='/'/>"><i class="fas fa-home"></i>홈</a>
        <a href="<c:url value='/scan'/>"><i class="fas fa-qrcode"></i>도서 스캔</a>
        <a href="<c:url value='/recode'/>"><i class="fas fa-book"></i>도서 기록</a>
        <a href="<c:url value='/mypage'/>"><i class="fas fa-user"></i>마이페이지</a>
    </div>

    <!-- 우측 로그인/로그아웃 영역 -->
    <div class="nav-right">
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <span class="user-info">👤 ${sessionScope.loginUser.name}님</span>
                <a href="<c:url value='/login/logout'/>">로그아웃</a>
            </c:when>
            <c:otherwise>
                <a href="<c:url value='/login'/>">로그인</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
