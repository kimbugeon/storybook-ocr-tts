package com.mc.controller;

import com.mc.app.dto.User;
import com.mc.app.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RequiredArgsConstructor
@Slf4j
@Controller
@RequestMapping("/login")
public class LoginController {

    final UserService userService;

    // 로그인 페이지로 이동
    @GetMapping({"", "/"})
    public String loginPage() {
        return "login/login";
    }

    // 로그인 처리
    @PostMapping("/get")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession httpsession,
                        Model model) throws Exception {
        User user = userService.get(email);
        if (user != null && user.getPassword().equals(password)) {
            httpsession.setAttribute("loginUser", user);
            return "redirect:/";
        } else {
            model.addAttribute("error", "이메일 또는 비밀번호가 틀렸습니다.");
            return "login/login";
        }
    }

    // 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpSession httpsession) {
        httpsession.invalidate();
        return "redirect:/";
    }

    // 회원가입 페이지로 이동
    @GetMapping("/registerGo")
    public String registerPage() {
        return "login/register";
    }

    // 회원가입 처리
    @PostMapping("/register")
    public String registerUser(@RequestParam String email,
                               @RequestParam String name,
                               @RequestParam String password,
                               Model model) {
        try {
            String profilePath = null;

            // 사용자 저장 로직
            User user = new User();
            user.setEmail(email);
            user.setName(name);
            user.setPassword(password);
            user.setProfile(profilePath);

            userService.add(user);
            return "redirect:/login";

        } catch (Exception e) {
            log.error("회원가입 중 예외 발생", e); // 예외 로그 찍기
            model.addAttribute("error", "회원가입 중 오류 발생");
            return "redirect:login/registerGo";
        }
    }

}
