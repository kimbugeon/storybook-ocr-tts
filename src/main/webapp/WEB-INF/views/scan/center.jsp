<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 스캔</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #fffaf3;
            margin: 0;
            padding: 20px;
        }

        .scan-container {
            max-width: 800px;
            margin: 50px auto;
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            text-align: center;
        }

        .btn {
            background-color: #ffa07a;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
        }

        .btn:hover {
            background-color: #ff8c5a;
        }

        #imageInput {
            display: none;
        }

        .file-label {
            display: inline-block;
            background-color: #ddd;
            padding: 10px 16px;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 20px;
        }

        .file-label:hover {
            background-color: #ccc;
        }

        .file-count {
            font-size: 16px;
            font-weight: bold;
            margin-top: 10px;
            margin-bottom: 10px;
            color: #555;
        }

        .preview-container {
            margin-top: 20px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .preview-block {
            background: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            padding: 12px;
            text-align: center;
        }

        .preview-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 6px;
            background-color: #f0f0f0;
            display: block;
        }

        .file-info {
            font-size: 13px;
            color: #444;
            word-break: break-word;
            margin-top: 6px;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100vw; height: 100vh;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            font-size: 20px;
            font-weight: bold;
            color: #333;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
            text-align: center;
        }

        #uploadForm {
            border: 2px dashed #ccc;
            padding: 20px;
        }
    </style>
</head>
<body>

<div class="scan-container">
    <h2>📚 도서 스캔</h2>

    <form id="uploadForm" method="post" enctype="multipart/form-data">

        <div class="file-count" id="fileCount">선택된 파일이 없습니다.</div>

        <div class="preview-container" id="previewContainer"></div>

        <label for="imageInput" class="file-label">파일 선택</label>
        <input type="file" id="imageInput" accept="image/*" multiple required>

        <br>
        <button type="button" id="ocrButton" class="btn">스캔하기</button>
    </form>
</div>

<!-- 모달 -->
<div class="modal-overlay" id="modal">
    <div class="modal-content" id="modalMessage">스캔 중입니다... 자리만 기다려주세요 🙏</div>
</div>

<script>
    let filesArray = [];

    const ocrScan = {
        init: function () {
            $('#imageInput').on('change', function () {
                filesArray = Array.from(this.files);
                updatePreview();
            });

            $('#ocrButton').on('click', function () {
                ocrScan.sendToOcr();
            });
        },

        sendToOcr: function () {
            if (!filesArray || filesArray.length === 0) {
                alert("이미지를 선택해주세요.");
                return;
            }

            const formData = new FormData();
            for (let i = 0; i < filesArray.length; i++) {
                formData.append("file", filesArray[i]);
            }

            $('#modalMessage').text("스캔 중입니다... 자리만 기다려주세요 🙏");
            $('#modal').css("display", "flex");

            fetch("/scanOcr/ocr", {
                method: "POST",
                body: formData
            })
                .then(res => res.json())
                .then(data => {
                    if (data.error) {
                        alert(data.error);
                        $('#modal').hide();
                    } else {
                        $('#modalMessage').text("동화책 스캔이 완료되었습니다!");
                        setTimeout(() => {
                            $('#modal').hide();
                            window.location.href = "/";
                        }, 1500);
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert("서버 오류가 발생했습니다.");
                    $('#modal').hide();
                });
        }
    };

    function updatePreview() {
        $('#fileCount').text(filesArray.length > 0
            ? filesArray.length + "개 파일이 선택되었습니다."
            : "선택된 파일이 없습니다.");

        $('#previewContainer').empty();

        for (let i = 0; i < filesArray.length; i++) {
            const file = filesArray[i];
            if (!file.type.startsWith("image/")) continue;

            const reader = new FileReader();

            reader.onload = (function(file, index) {
                return function(e) {
                    const block = $('<div class="preview-block"></div>');
                    const img = $('<img>', {
                        class: 'preview-img',
                        src: e.target.result,
                        alt: '미리보기'
                    });
                    const info = $(`<div class="file-info">${file.name}</div>`);
                    const deleteBtn = $('<div style="color:red; cursor:pointer; font-weight:bold;">❌</div>');

                    // 삭제 버튼 이벤트 핸들링
                    deleteBtn.on('click', function () {
                        filesArray.splice(index, 1); // filesArray에서 제거
                        updatePreview(); // 다시 렌더링
                    });

                    block.append(img).append(info).append(deleteBtn);
                    $('#previewContainer').append(block);
                };
            })(file, i);

            reader.readAsDataURL(file);
        }
    }

    $(document).ready(function () {
        ocrScan.init();
    });
</script>

</body>
</html>
