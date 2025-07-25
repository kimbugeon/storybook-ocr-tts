package com.mc.controller;

import com.mc.app.dto.Tale;
import com.mc.app.dto.User;
import com.mc.app.service.TaleService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/tale")
public class TaleController {

    String dir = "tale/";

    final TaleService taleService;

    @RequestMapping("/read")
    public String taleRead(@RequestParam String taleId,
                           Model model,
                           HttpSession httpSession) throws Exception {
        User user = (User)httpSession.getAttribute("loginUser");

        if (user == null) {
            return "redirect:/login"; // 세션 만료나 비로그인 처리
        }

        List<Tale> tale = taleService.getByTaleId(taleId);

        model.addAttribute("tale", tale);
        model.addAttribute("center", dir + "center");
        return "index";
    }
}
