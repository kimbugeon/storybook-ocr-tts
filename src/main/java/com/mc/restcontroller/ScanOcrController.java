package com.mc.restcontroller;

import com.mc.app.service.ScanOcrService;
import com.mc.util.OcrTtsUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/scanOcr")
public class ScanOcrController {

    final ScanOcrService scanOcrService;

    @ResponseBody
    @RequestMapping("/ocr")
    public Map<String, Object> handleOcrUpload(@RequestParam("file") List<MultipartFile> files, Model model) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<Map<String, String>> base64Images = new ArrayList<>();
            for (MultipartFile file : files) {
                byte[] bytes = file.getBytes();
                String base64 = Base64.getEncoder().encodeToString(bytes);
                Map<String, String> imageMap = new HashMap<>();
                imageMap.put("filename", file.getOriginalFilename());
                imageMap.put("image_base64", base64);
                base64Images.add(imageMap);
            }

            JSONObject requestJson = new JSONObject();
            requestJson.put("images", base64Images);

            // Flask에 전송하고 결과 받기
            JSONObject resultJson = OcrTtsUtil.sendToFlask(requestJson);

            // 결과 + 업로드 파일을 넘겨서 저장
            scanOcrService.saveScanResult(resultJson, files);

            // JSON 응답 반환
            response.put("success", true);
            response.put("message", "스캔이 완료되었습니다.");
            return response;

        } catch (Exception e) {
            log.error("OCR 처리 실패", e);
            response.put("success", false);
            response.put("error", "스캔 중 오류가 발생했습니다.");
            return response;
        }
    }
}
