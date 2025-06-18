package com.mc.app.repository;

import com.mc.app.dto.ScanOcr;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ScanOcrRepository extends MCRepository<ScanOcr, String> {
    void save(ScanOcr scanOcr) throws Exception;
}
