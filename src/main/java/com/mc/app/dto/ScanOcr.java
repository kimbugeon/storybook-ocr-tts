package com.mc.app.dto;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Data
public class ScanOcr {
    private Integer pageNum;
    private String pageImg;      // 저장된 파일명(UUID 붙은 이름)
    private String ocrText;
    private String ttsUrl;
    private Long taleId;

    // 아래 필드들은 저장용이 아닌 업로드/조회 시 사용
    private List<MultipartFile> images;   // 업로드 받을 때만 사용(임시)
    private List<String> imageUrls;       // 조회 결과로 보여줄 때 사용
}
