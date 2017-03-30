package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.MentorReportDTO;
import kr.or.career.mentor.domain.StatisticsMentor;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *      StatisticsMentorMapper
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-29 오전 10:49
 */
public interface StatisticsMentorMapper {

    /** 멘토리포트 > 직업별 */
    List<StatisticsMentor> selectStatisticsJob(StatisticsMentor statisticsMentor);

    /** 멘토리포트 > 직업분류별 카운트 */
    StatisticsMentor selectDepthCnt();

    /** 멘토리포트 > 특징분류별 */
    List<StatisticsMentor> selectStatisticsChrstc(StatisticsMentor statisticsMentor);

    /** 멘토리포트 > 멘토목록 리스트 */
    List<MentorReportDTO> selectMentorList(StatisticsMentor statisticsMentor);

    /** 멘토리포트 > 멘토별수업 */
    List<StatisticsMentor> selectStatisticsMentorLect(StatisticsMentor statisticsMentor);


}
