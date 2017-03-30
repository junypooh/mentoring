/* license */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    StatisticsMapper.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 21. 오후 5:46:35
 * @author  technear
 * @see
 */
public interface StatisticsMapper {
    public List<CoInfoDTO> allocateGroupCnt();
    public Map<String,Integer> lectureStatusCnt(User user);
    public Map<String,Integer> approvalRequestCnt();
    public Map<String,Integer> articleCnt();
    public Map<String,Integer> memberCnt();
    public Map<String,Integer> schoolCnt();

    List<MentorStatisticsDTO> listMentorStatistics(LectureSearch lectureSearch);

    List<MentorStatisticsDTO> excelDownListMentorStatistics(LectureSearch lectureSearch);

    List<MentorStatisticsDTO> listMentorStatisticsByEdu(LectureSearch lectureSearch);

    List<LoginSummaryDTO> listLoginStatistics(LectureSearch lectureSearch);

    List<LoginSummaryDTO> listLoginStatisticsExcel(LectureSearch lectureSearch);

    List<JoinSummaryDTO> listJoinStatistics(LectureSearch lectureSearch);

    List<JoinSummaryDTO> listJoinStatisticsExcel(LectureSearch lectureSearch);

    List<LectureSummaryDTO> listLectureStatistics(LectureSearch lectureSearch);

    List<ClassStatisticsExcelDto> excelClassList(LectureSearch lectureSearch);

    List<ClassStatisticsExcelDto> excelSchoolList(LectureSearch lectureSearch);

    List<ClassStatisticsExcelDto> excelClassLectureList(LectureSearch lectureSearch);

    Integer selectBizSetSchoolCnt(String setSer);

    Map<String,BigDecimal> selectAppliedSchool(String setSer);

    Map<String,BigDecimal> selectAppliedLecture(String setSer);

    Map<String,BigDecimal> selectMentorSummary();

    List<LectureSummaryByJobDto> selectLectureSummaryByJob(String setSer);

    List<MentorSummaryByJobClsfDto> selectMentorSummaryByJobCslf(String setSer);

    List<StatusAreaDto> listAreaStatistics(String setSer);
}
