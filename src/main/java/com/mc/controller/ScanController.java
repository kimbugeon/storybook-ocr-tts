package com.mc.controller;

import com.mc.app.dto.User;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/scan")
public class ScanController {

    String dir = "scan/";

    @RequestMapping("")
    public String scan(Model model, HttpSession httpSession) throws Exception {

        User user = (User)httpSession.getAttribute("loginUser");

        if (user == null) {
            return "redirect:/login"; // 세션 만료나 비로그인 처리
        }

        model.addAttribute("center", dir + "center");
        return "index";
    }
}
