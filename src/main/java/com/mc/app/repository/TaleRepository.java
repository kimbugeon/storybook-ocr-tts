package com.mc.app.repository;

import com.mc.app.dto.Tale;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface TaleRepository extends MCRepository<Tale, String> {
    List<Tale> getByTaleId(String string) throws Exception;

}
