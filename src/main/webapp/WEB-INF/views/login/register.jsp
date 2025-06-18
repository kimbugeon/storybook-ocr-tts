<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            padding: 20px;
            background-color: #fffaf3;
        }

        .register-container {
            max-width: 400px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        input[type="text"], input[type="password"], input[type="email"], input[type="file"] {
            width: 100%;
            padding: 10px;
            margin: 8px 0 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #ffa07a;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #ff8c5a;
        }

        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="register-container">
    <h2>회원가입</h2>

    <form method="post" action="<c:url value='/login/register'/>" enctype="multipart/form-data">
        <label>이메일</label>
        <input type="email" name="email" placeholder="이메일을 입력해 주세요" required />

        <label>이름</label>
        <input type="text" name="name" placeholder="이름을 입력해 주세요" required />

        <label>비밀번호</label>
        <input type="password" name="password" placeholder="비밀번호를 입력해 주세요" required />

        <button type="submit">가입하기</button>
    </form>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
</div>

</body>
</html>