package com.mc.app.dto;

import lombok.Data;

@Data
public class Tale {
    private Integer pageNum;
    private String pageImg;      // 저장된 파일명(UUID 붙은 이름)
    private String ocrText;
    private String ttsUrl;
    private Long taleId;
}
