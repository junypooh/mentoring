/* license */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.*;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    StatisticsSerrvice.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 21. 오후 5:42:52
 * @author  technear
 * @see
 */
public interface StatisticsService {
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

    List<LectureSummaryDTO> listLectStatistics(LectureSearch lectureSearch);

    List<ClassStatisticsExcelDto> excelClassList(LectureSearch lectureSearch);

    List<ClassStatisticsExcelDto> excelSchoolList(LectureSearch lectureSearch);

    List<ClassStatisticsExcelDto> excelClassLectureList(LectureSearch lectureSearch);

    StatusSummaryDto statusSummary(BizGrpInfo bizGrpInfo);

    List<LectureSummaryByJobDto> lectureSummaryByJob(BizGrpInfo bizGrpInfo);

    List<MentorSummaryByJobClsfDto> mentorSummaryByJobCslf(BizGrpInfo bizGrpInfo);
    List<StatusAreaDto> statusArea(BizGrpInfo bizGrpInfo);



}
