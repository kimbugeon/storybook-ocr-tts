package com.mc.app.service;

import com.mc.app.dto.Tale;
import com.mc.app.frame.MCService;
import com.mc.app.repository.TaleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class TaleService implements MCService<Tale, String> {

    final TaleRepository taleRepository;

    @Override
    public void add(Tale tale) throws Exception {

    }

    @Override
    public void mod(Tale tale) throws Exception {

    }

    @Override
    public void del(String string) throws Exception {

    }

    @Override
    public Tale get(String string) throws Exception {
        return null;
    }

    @Override
    public List<Tale> get() throws Exception {
        return taleRepository.select();
    }

    public List<Tale> getByTaleId(String string) throws Exception {
        return taleRepository.getByTaleId(string);
    }
}
