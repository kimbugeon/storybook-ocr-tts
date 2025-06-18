<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="ko">
<head>
    <title>Title</title>

    <style>
        .banner {
            background-color: #ffe1c5;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            margin: 20px;
        }

        .book-section {
            margin: 20px;
        }

        .section-title {
            font-size: 22px;
            font-weight: bold;
            color: #444;
            margin-bottom: 16px;
            padding-left: 4px;
            border-left: 6px solid #ffa94d;
        }

        .book-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);  /* 3열 유지 */
            gap: 24px;
            justify-items: center;  /* 카드 중앙 정렬 */
        }

        .book-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            text-align: center;
            padding: 12px;
            width: 300px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .book-card:hover {
            transform: translateY(-5px);  /* 살짝 위로 이동 */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);  /* 그림자 진하게 */
            cursor: pointer;
        }

        .book-card img {
            width: 100%;
            height: 300px;   /* 기존 220 → 260으로 확대 */
            object-fit: cover;
            border-radius: 10px;
        }

        .book-title {
            margin-top: 10px;
            font-size: 15px;
            color: #333;
            word-break: break-word;
        }


        .horizontal-scroll {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 10px;
        }

        .horizontal-scroll .book-card {
            min-width: 120px;
            flex-shrink: 0;
        }

    </style>
</head>
<body>
<div class="banner">
    <h3>스캔한 동화책을 읽어줘요! 서재에서 원하는 책을 골라볼까요?</h3>
</div>

<div class="book-section">
    <div class="section-title">서재</div>
    <div class="book-grid">
        <c:forEach var="book" items="${mainPages}">
            <a href="<c:url value='/tale/read?taleId=${book.taleId}'/>"
               style="text-decoration: none; color: inherit;">
                <div class="book-card">
                    <img src="/imgs/${book.pageImg}" alt="대표 이미지">
                    <div class="book-title">
                        동화책 #${book.taleId}<br>
                        <span style="font-size: 12px; color: #777;">파일명: ${book.pageImg}</span>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>
</div>

<div class="book-section">
    <div class="section-title">좋아하는 독서</div>
    <div class="horizontal-scroll">
        <c:forEach var="book" items="${likedBooks}">
            <div class="book-card">
                <img src="${book.cover}" alt="${book.title}">
                <div class="book-title">${book.title}</div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
