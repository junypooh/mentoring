package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.StatisticsMentorMapper;
import kr.or.career.mentor.domain.MentorReportDTO;
import kr.or.career.mentor.domain.StatisticsMentor;
import kr.or.career.mentor.service.StatisticsMentorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      StatisticsMentorServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-29 오전 11:28
 */
@Service
public class StatisticsMentorServiceImpl implements StatisticsMentorService {

    @Autowired
    private StatisticsMentorMapper statisticsMentorMapper;


    @Override
    public List<StatisticsMentor> selectStatisticsJob(StatisticsMentor statisticsMentor) {
        return statisticsMentorMapper.selectStatisticsJob(statisticsMentor);
    }

    @Override
    public StatisticsMentor selectDepthCnt() {
        return statisticsMentorMapper.selectDepthCnt();
    }

    @Override
    public List<StatisticsMentor> selectStatisticsChrstc(StatisticsMentor statisticsMentor) {
        return statisticsMentorMapper.selectStatisticsChrstc(statisticsMentor);
    }

    @Override
    public List<MentorReportDTO> selectMentorList(StatisticsMentor statisticsMentor) {
        return statisticsMentorMapper.selectMentorList(statisticsMentor);
    }

    @Override
    public List<StatisticsMentor> selectStatisticsMentorLect(StatisticsMentor statisticsMentor) {
        return statisticsMentorMapper.selectStatisticsMentorLect(statisticsMentor);
    }
}
