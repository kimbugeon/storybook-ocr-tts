package com.mc.controller;

import com.mc.app.dto.ScanOcr;
import com.mc.app.service.ScanOcrService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MainController {

    final ScanOcrService scanOcrService;

    String dir = "home/";

    @RequestMapping("/")
    public String main(Model model) throws Exception {

        List<ScanOcr> mainPages = scanOcrService.get();

        model.addAttribute("mainPages", mainPages);
        model.addAttribute("center", dir + "center");
        return "index";
    }

}
