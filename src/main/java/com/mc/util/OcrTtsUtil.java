package com.mc.util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import org.json.JSONObject;

public class OcrTtsUtil {

    public static JSONObject sendToFlask(JSONObject requestJson) {
        try {
            URL url = new URL("http://127.0.0.1:5001/ocr-tts");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(60000);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(requestJson.toString().getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                throw new IOException("Flask 서버 응답 오류: HTTP " + responseCode);
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder responseBuffer = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                responseBuffer.append(line);
            }
            conn.disconnect();

            return new JSONObject(responseBuffer.toString());

        } catch (Exception e) {
            System.err.println("Flask 호출 실패:................" + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}