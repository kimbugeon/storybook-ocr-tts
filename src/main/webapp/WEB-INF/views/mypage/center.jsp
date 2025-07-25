<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 내 정보 박스 */
    .info-box {
        max-width: 600px;
        margin: 50px auto;
        background: #fff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        font-size: 16px;
    }

    .info-box h2 {
        text-align: center;
        margin-bottom: 30px;
    }

    .info-row {
        margin-bottom: 16px;
    }

    .info-label {
        font-weight: bold;
        color: #555;
    }

    .info-value {
        color: #333;
        margin-left: 10px;
    }

    /* 수정 / 삭제 버튼 */
    .btn-group {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }

    .btn-half {
        flex: 1;
        padding: 12px;
        font-size: 16px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
    }

    .btn-edit {
        background-color: #ffa07a;
        color: white;
    }

    .btn-edit:hover {
        background-color: #ff8c5a;
    }

    .btn-delete {
        background-color: #ff4d4d;
        color: white;
    }

    .btn-delete:hover {
        background-color: #e63e3e;
    }

    /* 모달 전체 레이어 */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0;
        width: 100vw; height: 100vh;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .modal-content {
        background: white;
        padding: 30px 40px 20px;
        border-radius: 16px;
        text-align: left;
        width: 400px;
        box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .modal-content h3 {
        margin-bottom: 10px;
    }

    .modal-content input {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        border-radius: 8px;
        border: 1px solid #ccc;
        box-sizing: border-box;
    }

    .modal-footer {
        display: flex;
        justify-content: space-between;
        gap: 12px;
        margin-top: 30px;
    }

    .modal-btn {
        flex: 1;
        padding: 12px 0;
        font-size: 16px;
        font-weight: 600;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.25s ease-in-out;
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
    }

    /* 저장 버튼 */
    .modal-btn.save-btn {
        background: linear-gradient(to right, #ffa07a, #ff7f50);
        color: white;
    }

    .modal-btn.save-btn:hover {
        background: linear-gradient(to right, #ff8c5a, #ff6347);
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(255, 140, 90, 0.3);
    }

    /* 취소 버튼 */
    .modal-btn.cancel-btn {
        background-color: #f0f0f0;
        color: #333;
    }

    .modal-btn.cancel-btn:hover {
        background-color: #e0e0e0;
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(150, 150, 150, 0.2);
    }
</style>

<!-- 내 정보 출력 영역 -->
<div class="info-box">
    <h2>내 계정 정보</h2>

    <div class="info-row">
        <span class="info-label">이메일:</span>
        <span class="info-value">${userOne.email}</span>
    </div>
    <div class="info-row">
        <span class="info-label">이름:</span>
        <span class="info-value">${userOne.name}</span>
    </div>
    <div class="info-row">
        <span class="info-label">비밀번호:</span>
        <span class="info-value">${userOne.password}</span>
    </div>
    <div class="info-row">
        <span class="info-label">가입일:</span>
        <span class="info-value">${userOne.createdAt}</span>
    </div>

    <!-- 수정/삭제 버튼-->
    <div class="btn-group">
        <!-- 정보 수정 버튼 -->
        <button class="btn-half btn-edit" onclick="openEditModal()">정보 수정</button>

        <!-- 회원 탈퇴 버튼 (form 안에 버튼 포함) -->
        <form method="post" action="<c:url value='/mypage/delete'/>"
              onsubmit="return confirm('정말로 계정을 삭제하시겠습니까?');"
              style="flex: 1; margin: 0; padding: 0;">
            <input type="hidden" name="userId" value="${userOne.userId}" />
            <button type="submit" class="btn-half btn-delete" style="width: 100%;">회원 탈퇴</button>
        </form>
    </div>
</div>

<!-- 정보 수정 모달 -->
<div class="modal-overlay" id="editModal">
    <div class="modal-content">
        <form id="editForm">
            <h3>정보 수정</h3>
            <input type="hidden" name="userId" value="${userOne.userId}"/>
            <label>이메일</label>
            <input type="email" name="email" value="${userOne.email}" readonly/>
            <label>이름</label>
            <input type="text" name="name" id="reset-name" value="${userOne.name}" placeholder="새 이름 입력" required/>
            <label>비밀번호</label>
            <input type="password" name="password" id="reset-password" placeholder="새 비밀번호 입력"/>
        </form>
        <div class="modal-footer">
            <button id="myPage-save" class="modal-btn save-btn">저장</button>
            <button id="myPage-non" class="modal-btn cancel-btn" onclick="closeEditModal()">취소</button>
        </div>
    </div>
</div>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    const myPageApp = {
        init: function () {
            // 저장 버튼 클릭 시 업데이트
            $(document).on('click', '#myPage-save', function () {
                const password = $('#reset-password').val();
                const name = $('#reset-name').val();

                if (!password || password.trim() === "") {
                    alert("비밀번호를 입력해주세요.");
                    return;
                }

                if (!name || name.trim() === "") {
                    alert("이름을 입력해주세요.");
                    return;
                }

                myPageApp.update();
            });
        },

        update: function () {
            if (confirm("입력한 정보를 수정하시겠습니까?")) {
                $('#editForm').attr({
                    'method': 'post',
                    'action': '<c:url value="/mypage/update"/>'
                });
                $('#editForm').submit();
            }
        }
    };

    // 모달 열기/닫기 함수 전역에 노출
    window.openEditModal = function () {
        document.getElementById("editModal").style.display = "flex";
    };
    window.closeEditModal = function () {
        document.getElementById("editModal").style.display = "none";
    };

    $(document).ready(function () {
        myPageApp.init();
    });
</script>