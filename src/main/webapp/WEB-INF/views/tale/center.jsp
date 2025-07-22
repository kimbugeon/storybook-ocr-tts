<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .container {
    text-align: center;
    margin-top: 50px;
  }

  .book-img {
    max-width: 53%;
    height: auto;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }

  .progress-container {
    width: 60%;
    max-width: 600px;
    height: 10px;
    background-color: #eee;
    border-radius: 5px;
    overflow: hidden;
    margin: 20px auto 0;
  }

  .progress-bar {
    height: 100%;
    width: 0%;
    background-color: #ffa07a;
    transition: width 0.1s linear;
  }

  .controls {
    margin-top: 20px;
  }

  .container button {
    padding: 10px 20px;
    font-size: 16px;
    border-radius: 8px;
    background-color: #ffa07a;
    border: none;
    color: white;
    cursor: pointer;
  }

  .container button:hover {
    background-color: #ff8c5a;
  }

  .page-text {
    display: none;
    font-size: 22px;
    color: #222;
    background-color: #fffbe6;
    border: 1px solid #ffe58f;
    padding: 16px;
    border-radius: 12px;
    width: 80%;
    max-width: 700px;
    margin: 30px auto 0;
    font-family: 'Gowun Batang', serif;
    line-height: 1.7;
    white-space: pre-wrap;
  }

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
    padding: 30px 40px;
    border-radius: 16px;
    text-align: center;
    font-size: 24px;
    font-weight: bold;
    color: #333;
    box-shadow: 0 10px 20px rgba(0,0,0,0.2);
  }

  .close-btn {
    margin-top: 20px;
    font-size: 16px;
    background-color: #ff9999;
  }
</style>


<div class="container">
  <img id="pageImg" class="book-img" src="" alt="동화 이미지" />
  <div class="progress-container">
    <div id="progressBar" class="progress-bar"></div>
  </div>
  <div id="pageText" class="page-text"></div>
  <audio id="ttsAudio"></audio>

  <div class="controls">
    <button id="startBtn" onclick="showStartModal()">동화책 읽기</button>
    <button id="pauseBtn" style="display:none;">⏸️ 일시정지</button>
  </div>
</div>

<!-- 시작 모달 -->
<div class="modal-overlay" id="startModal">
  <div class="modal-content">
    동화책을 읽어드릴게요! 📖
  </div>
</div>

<!-- 종료 모달 -->
<div class="modal-overlay" id="endModal">
  <div class="modal-content">
    동화가 끝났어요! 👏<br><br>
    재미있게 읽으셨나요?
    <br><button class="close-btn" onclick="readerApp.closeEndModal()">닫기</button>
    <button class="close-btn" id="restartBtn" onclick="readerApp.restart()">🔁 다시 듣기</button>
  </div>
</div>

<script>
  const readerApp = {
    pages: [
      <c:forEach var="page" items="${tale}" varStatus="pageStatus">
      {
        img: '/imgs/${page.pageImg}',
        audio: '${page.ttsUrl}',
        text: `${page.ocrText}`
      }<c:if test="${!pageStatus.last}">,</c:if>
      </c:forEach>
    ],
    current: 0,
    isPaused: false,

    init: function () {
      this.img = document.getElementById('pageImg');
      this.audio = document.getElementById('ttsAudio');
      this.text = document.getElementById('pageText');
      this.progressBar = document.getElementById('progressBar');
      this.startBtn = document.getElementById('startBtn');
      this.startModal = document.getElementById('startModal');
      this.endModal = document.getElementById('endModal');
      this.pauseBtn = document.getElementById('pauseBtn');
      this.restartBtn = document.getElementById('restartBtn');

      window.onload = () => {
        this.img.src = this.pages[0].img;
        this.text.style.display = "none";
        this.progressBar.style.width = '0%';
      };

      this.audio.addEventListener('timeupdate', () => this.updateProgress());
      this.audio.addEventListener('ended', () => this.handleAudioEnd());

      this.startBtn.addEventListener('click', () => this.showStartModal());
      this.pauseBtn.addEventListener('click', () => this.togglePause());
    },

    showStartModal: function () {
      this.startModal.style.display = 'flex';
      setTimeout(() => {
        this.startModal.style.display = 'none';
        this.startReading();
      }, 2000);
    },

    startReading: function () {
      this.current = 0;
      this.startBtn.style.display = 'none';
      this.pauseBtn.style.display = 'inline-block';
      this.restartBtn.style.display = 'none';
      this.playCurrent();
    },

    togglePause: function () {
      if (this.audio.paused) {
        this.audio.play();
        this.pauseBtn.textContent = "⏸️ 일시정지";
      } else {
        this.audio.pause();
        this.pauseBtn.textContent = "▶️ 계속 듣기";
      }
    },

    playCurrent: function () {
      const page = this.pages[this.current];
      this.img.src = page.img;

      const currentText = page.text.trim();
      if (currentText) {
        this.text.innerText = currentText;
        this.text.style.display = "block";
      } else {
        this.text.innerText = "";
        this.text.style.display = "none";
      }

      this.audio.src = page.audio;
      this.audio.play();
    },

    updateProgress: function () {
      if (this.audio.duration > 0) {
        const percent = (this.audio.currentTime / this.audio.duration) * 100;
        this.progressBar.style.width = percent + '%';
      }
    },

    handleAudioEnd: function () {
      this.progressBar.style.width = '0%';
      this.current++;
      if (this.current < this.pages.length) {
        setTimeout(() => this.playCurrent(), 1000);
      } else {
        this.pauseBtn.style.display = 'none';
        this.restartBtn.style.display = 'inline-block';
        this.endModal.style.display = 'flex';
      }
    },

    restart: function () {
      this.endModal.style.display = 'none';
      this.startReading();
    },

    closeEndModal: function () {
      this.endModal.style.display = 'none';
    }
  };

  document.addEventListener("DOMContentLoaded", function () {
    readerApp.init();
  });
</script>