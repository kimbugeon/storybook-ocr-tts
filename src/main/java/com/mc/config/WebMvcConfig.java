package com.mc.config;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Slf4j
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${app.dir.imgdir}")
    private String imgdir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/imgs/**")
                .addResourceLocations(imgdir)
                .setCachePeriod(3600);  // 1시간 캐시

        log.info(" [WebMvcConfig] 정적 리소스 매핑됨: /imgs/** → {}", imgdir);
    }

    @PostConstruct
    public void init() {
        log.info(" WebMvcConfig 초기화: imgdir = {}", imgdir);
    }
}
