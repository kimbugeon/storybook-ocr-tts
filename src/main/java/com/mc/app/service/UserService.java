package com.mc.app.service;

import com.mc.app.dto.User;
import com.mc.app.frame.MCService;
import com.mc.app.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService implements MCService<User, String> {

    final UserRepository userRepository;

    @Override
    public void add(User user) throws Exception {
        userRepository.insert(user);
    }

    @Override
    public void mod(User user) throws Exception {
        userRepository.update(user);
    }

    @Override
    public void del(String string) throws Exception {
        userRepository.delete(string);
    }

    @Override
    public User get(String string) throws Exception {
        return userRepository.selectOne(string);
    }

    @Override
    public List<User> get() throws Exception {
        return userRepository.select();
    }
}
