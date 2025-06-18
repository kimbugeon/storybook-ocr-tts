from flask import Flask, request, jsonify, send_from_directory
from PIL import Image
import numpy as np
import io
import base64
import easyocr
import re
from gtts import gTTS
import os
import uuid

app = Flask(__name__) # Flask 애플리케이션 생성
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024
reader = easyocr.Reader(['ko', 'en'])  # 한글 + 영어 지원

UPLOAD_FOLDER = "tts_output" # TTS 파일 저장 폴더
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
# 폴더가 없으면 생성
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

def split_into_sentences(texts):
    all_text = ' '.join(texts) #OCR로 받은 텍스트를 하나의 문자열로 합침
    # 문장 끝을 구분하기 위한 정규 표현식
    sentence_end = re.compile(r'([.!?]|[.?!]\”|[.?!]\')(?=\s|$)')
    parts = sentence_end.split(all_text)
    # 문장 본문, 구분자, 문장 본문, 구분자 순으로 나뉘므로 짝수 인덱스의 부분과 홀수 인덱스의 부분을 합쳐서 문장을 만듭니다.
    sentences = []
    for i in range(0, len(parts)-1, 2):
        sentence = (parts[i] + parts[i+1]).strip()
        if sentence:
            sentences.append(sentence)
    # 문장 구분이 어려운 경우를 위해 마지막 부분까지도 추가
    if len(parts) % 2 != 0 and parts[-1].strip():
        sentences.append(parts[-1].strip())
    return sentences

# /ocr-tts 엔드포인트를 통해 OCR과 TTS를 수행하는 API
# POST 요청으로 이미지 데이터를 받아 OCR을 수행하고, 각 문장에 대해 TTS를 생성합니다.
# 요청 본문은 JSON 형식으로, 'image_base64' 키에 base64로 인코딩된 이미지 데이터를 포함해야 합니다.
# 응답은 인식된 문장과 각 문장에 대한 TTS 파일 경로를 포함하는 JSON 객체입니다.
@app.route('/ocr-tts', methods=['POST'])
def ocr_and_tts_multiple():
    try:
        data = request.json
        image_list = data.get('images', [])
        
        result_list = []
        
        for img_obj in image_list:
            print("이미지 처리 시작:", img_obj.get("filename"))
            
            filename = img_obj.get('filename', 'unknown')
            base64_data = img_obj.get('image_base64')

            image_data = base64.b64decode(base64_data)
            image = Image.open(io.BytesIO(image_data)).convert("RGB")
            gray = image.convert("L")
            enhanced = gray.point(lambda x: 0 if x < 140 else 255)

            results = reader.readtext(np.array(enhanced), detail=1)
            texts = [text for (_, text, conf) in results if conf > 0.5]
            sentences = split_into_sentences(texts)

            tts_paths = []
            for sentence in sentences:
                print("TTS 생성:", sentence)
                
                if sentence.strip() == "": continue
                fname = f"{uuid.uuid4()}.mp3"
                gTTS(sentence, lang='ko').save(os.path.join(UPLOAD_FOLDER, fname))
                tts_paths.append(fname)
            # 각 문장을 gTTS를 통해 mp3로 변환 후 저장
            # 파일명은 UUID로 중복 방지
            # 저장된 파일의 경로(/tts/파일명)를 리스트에 저장   

            result_list.append({
                "filename": filename,
                "sentences": sentences,
                "tts_paths": tts_paths
            })

        return jsonify({'results': result_list})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
# 로컬에 저장된 오디오(mp3) 파일을 HTTP 경로를 통해 외부에 열어주는 역할
@app.route('/tts/<filename>')
def serve_tts(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

# 서버를 실행하는 메인 함수
# 0.0.0.0 은 모든 IP 주소에서 접근 가능하도록 설정
# 포트는 5001로 설정
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)

# pip install easyocr flask pillow gTTS numpy 필요 모듈 설치
# python flask_easyocr_tts_server.py 해당 파일 경로로 이동한 뒤 서버 실행