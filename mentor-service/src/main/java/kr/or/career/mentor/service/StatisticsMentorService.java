package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.MentorReportDTO;
import kr.or.career.mentor.domain.StatisticsMentor;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      StatisticsMentorService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-29 오전 11:28
 */
public interface StatisticsMentorService {

    /** 멘토리포트 > 직업별 리스트 */
    List<StatisticsMentor> selectStatisticsJob(StatisticsMentor statisticsMentor);

    /** 멘토리포트 > 직업분류별 카운트 조회 */
    StatisticsMentor selectDepthCnt();

    /** 멘토리포트 > 특징분류별 리스트 */
    List<StatisticsMentor> selectStatisticsChrstc(StatisticsMentor statisticsMentor);

    /** 멘토리포트 > 멘토목록 리스트 */
    List<MentorReportDTO> selectMentorList(StatisticsMentor statisticsMentor);

    /** 멘토리포트 > 멘토별수업 리스트 */
    List<StatisticsMentor> selectStatisticsMentorLect(StatisticsMentor statisticsMentor);
}
