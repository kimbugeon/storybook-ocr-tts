<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>동화책 플랫폼</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" type="text/css" href="<c:url value="/styles/headerSt.css"/>">
</head>
<body>
    <!-- 고정된 header 영역 -->
    <jsp:include page="header.jsp"/>

    <!-- 페이지별 콘텐츠 영역 -->
    <div class="main-container">
        <jsp:include page="${center}.jsp"/>
    </div>
</body>
</html>
