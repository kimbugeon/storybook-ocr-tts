package com.mc.app.service;

import com.mc.app.dto.ScanOcr;
import com.mc.app.frame.MCService;
import com.mc.app.repository.ScanOcrRepository;
import com.mc.util.FileUploadUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ScanOcrService implements MCService<ScanOcr, String> {

    final ScanOcrRepository scanOcrRepository;

    @Value("${app.dir.uploadimgdir}")
    String uploadDir;

    @Override
    public void add(ScanOcr scanOcr) throws Exception {

    }

    @Override
    public void mod(ScanOcr scanOcr) throws Exception {

    }

    @Override
    public void del(String string) throws Exception {

    }

    @Override
    public ScanOcr get(String string) throws Exception {
        return null;
    }

    @Override
    public List<ScanOcr> get() throws Exception {
        return scanOcrRepository.select();
    }

    public void saveScanResult(JSONObject resultJson, List<MultipartFile> files) {
        try {
            JSONArray results = resultJson.getJSONArray("results");

            for (int i = 0; i < results.length(); i++) {
                JSONObject r = results.getJSONObject(i);
                String originalPageImg = r.getString("filename");

                MultipartFile matchedFile = findImageFileByName(files, originalPageImg);
                if (matchedFile == null) {
                    log.warn("파일 매칭 실패: {}", originalPageImg);
                    continue;
                }

                // UUID 이름으로 저장
                String uuid = UUID.randomUUID().toString().substring(0, 8);
                String savedFilename = uuid + "_" + originalPageImg;

                // 경로는 @Value 주입받은 변수 사용
                FileUploadUtil.saveFile(matchedFile, uploadDir, savedFilename);

                JSONArray ocrTexts = r.getJSONArray("sentences");
                JSONArray ttsUrls = r.getJSONArray("tts_paths");

                for (int j = 0; j < ocrTexts.length(); j++) {
                    String ocrText = ocrTexts.getString(j);
                    String ttsUrl = "http://localhost:5001/tts/" + ttsUrls.getString(j);

                    ScanOcr page = new ScanOcr();
                    page.setPageNum(i);
                    page.setPageImg(savedFilename);
                    page.setOcrText(ocrText);
                    page.setTtsUrl(ttsUrl);
                    page.setTaleId(6L);

                    scanOcrRepository.save(page);
                }
            }

        } catch (Exception e) {
            log.error("스캔 결과 DB 저장 실패", e);
            throw new RuntimeException("DB 저장 중 오류 발생");
        }
    }

    private MultipartFile findImageFileByName(List<MultipartFile> files, String filename) {
        return files.stream()
                .filter(f -> f.getOriginalFilename().equals(filename))
                .findFirst()
                .orElse(null);
    }
}
