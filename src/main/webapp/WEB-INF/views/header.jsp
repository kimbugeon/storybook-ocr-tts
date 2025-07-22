<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="nav-wrapper">
    <div class="nav-header">
        <a href="<c:url value='/'/>"><i class="fas fa-home"></i>홈</a>
        <a href="<c:url value='/scan'/>"><i class="fas fa-qrcode"></i>도서 스캔</a>
        <a href="<c:url value='/recode'/>"><i class="fas fa-book"></i>도서 기록</a>
        <a href="<c:url value='/mypage'/>"><i class="fas fa-user"></i>마이페이지</a>
    </div>

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
