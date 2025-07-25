package com.mc.controller;

import com.mc.app.dto.User;
import com.mc.app.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MyPageController {

    String dir = "mypage/";

    final UserService userService;

    @RequestMapping("")
    public String mypageSel(Model model, HttpSession httpSession) throws Exception {

        User user = (User)httpSession.getAttribute("loginUser");

        if (user == null) {
            return "redirect:/login"; // 세션 만료나 비로그인 처리
        }

        String email = user.getEmail();
        User userOne = userService.get(email);

        model.addAttribute("userOne", userOne);
        model.addAttribute("center", dir + "center");
        return "index";
    }

    @RequestMapping("/update")
    public String update(@Valid User user) throws Exception {
        userService.mod(user);
        return "redirect:/mypage";
    }
}
