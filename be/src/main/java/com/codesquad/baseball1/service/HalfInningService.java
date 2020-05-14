package com.codesquad.baseball1.service;

import com.codesquad.baseball1.dao.InningDao;
import com.codesquad.baseball1.domain.HalfInning;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;

@Service
public class HalfInningService {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    private InningDao inningDao;


    public HalfInningService(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public void updateIfItsOverWhenGameIsOver(int inningId) {
        HalfInning thisInning = inningDao.findInningById(inningId);
        if (thisInning.getOutSum() == 3 && thisInning.getRound().equals("9회 말")) {
            String sql = "UPDATE halfInning SET game_over = 1 WHERE inning_id =" + inningId;
            jdbcTemplate.update(sql);

        }
    }
}