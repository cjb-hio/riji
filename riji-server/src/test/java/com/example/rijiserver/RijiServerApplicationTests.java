package com.example.rijiserver;

import cn.dev33.satoken.dao.SaTokenDao;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class RijiServerApplicationTests {

    @Autowired
    private SaTokenDao saTokenDao;

    @Test
    void contextLoads() {
        assertThat(saTokenDao.getClass().getSimpleName()).contains("RedisTemplate");
    }

}
