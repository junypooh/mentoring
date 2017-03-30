/* license */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.StatisticsMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.StatisticsService;
import kr.or.career.mentor.util.EgovProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    StatisticsServiceImpl.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 21. 오후 5:43:38
 * @author  technear
 * @see
 */
@Service
public class StatisticsServiceImpl implements StatisticsService {

    @Autowired
    private StatisticsMapper statisticsMapper;

    @Override
    public List<CoInfoDTO> allocateGroupCnt() {
        return statisticsMapper.allocateGroupCnt();
    }

    public Map<String,Integer> lectureStatusCnt(User user){
        return statisticsMapper.lectureStatusCnt(user);
    }
    public Map<String,Integer> approvalRequestCnt(){
        return statisticsMapper.approvalRequestCnt();
    }
    public Map<String,Integer> articleCnt(){
        return statisticsMapper.articleCnt();
    }

    public Map<String,Integer> memberCnt(){
        return statisticsMapper.memberCnt();
    }

    public Map<String,Integer> schoolCnt(){
        return statisticsMapper.schoolCnt();
    }

    @Override
    public List<MentorStatisticsDTO> listMentorStatistics(LectureSearch lectureSearch) {
        return statisticsMapper.listMentorStatistics(lectureSearch);
    }

    @Override
    public List<MentorStatisticsDTO> excelDownListMentorStatistics(LectureSearch lectureSearch) {
        return statisticsMapper.excelDownListMentorStatistics(lectureSearch);
    }

    @Override
    public List<MentorStatisticsDTO> listMentorStatisticsByEdu(LectureSearch lectureSearch) {
        return statisticsMapper.listMentorStatisticsByEdu(lectureSearch);
    }

    @Override
    public List<LoginSummaryDTO> listLoginStatistics(LectureSearch lectureSearch) {
        return statisticsMapper.listLoginStatistics(lectureSearch);
    }

    @Override
    public List<LoginSummaryDTO> listLoginStatisticsExcel(LectureSearch lectureSearch) {
        return statisticsMapper.listLoginStatisticsExcel(lectureSearch);
    }

    @Override
    public List<JoinSummaryDTO> listJoinStatistics(LectureSearch lectureSearch) {
        return statisticsMapper.listJoinStatistics(lectureSearch);
    }

    @Override
    public List<JoinSummaryDTO> listJoinStatisticsExcel(LectureSearch lectureSearch) {
        return statisticsMapper.listJoinStatisticsExcel(lectureSearch);
    }

    @Override
    public List<LectureSummaryDTO> listLectStatistics(LectureSearch lectureSearch) {
        return statisticsMapper.listLectureStatistics(lectureSearch);
    }

    @Override
    public List<ClassStatisticsExcelDto> excelClassList(LectureSearch lectureSearch) {
        return statisticsMapper.excelClassList(lectureSearch);
    }

    @Override
    public List<ClassStatisticsExcelDto> excelSchoolList(LectureSearch lectureSearch) {
        return statisticsMapper.excelSchoolList(lectureSearch);
    }

    @Override
    public List<ClassStatisticsExcelDto> excelClassLectureList(LectureSearch lectureSearch) {
        return statisticsMapper.excelClassLectureList(lectureSearch);
    }

    @Override
    public StatusSummaryDto statusSummary(BizGrpInfo bizGrpInfo) {
        StatusSummaryDto dto = new StatusSummaryDto();

        String setSer = bizGrpInfo.getSetSer().toString();

        Integer bizSetSchoolCnt = statisticsMapper.selectBizSetSchoolCnt(setSer);

        Map<String,BigDecimal> appliedSchool = statisticsMapper.selectAppliedSchool(setSer);

        Map<String,BigDecimal> appliedLecture = statisticsMapper.selectAppliedLecture(setSer);

        Map<String,BigDecimal> mentorSummary = statisticsMapper.selectMentorSummary();

        DecimalFormat decimalFormat = new DecimalFormat("#####.##");

        dto.setBizSetSchoolCnt(bizSetSchoolCnt);
        dto.setAppliedSchoolCnt(appliedSchool.get("SCH_APP_CNT").intValue());
        dto.setAppliedClassCnt(appliedSchool.get("SCH_APP_TOT").doubleValue());
        dto.setOpenClassCnt(appliedLecture.get("LECT_APPL_CNT").intValue());
        dto.setAvgOfSchoolCntPerClass(decimalFormat.format(appliedLecture.get("AVG_SCH_APP").doubleValue()));
        dto.setTotalMentorCnt(mentorSummary.get("JOB_TOT_CNT").intValue());
        dto.setJobCntOfMentor(mentorSummary.get("MENTOR_TOT_CNT").intValue());
        dto.setMentorCntOfLecture(mentorSummary.get("APPL_MBR_CNT").intValue());
        dto.setJobCntOfLecture(mentorSummary.get("APPL_JOB_CNT").intValue());

        return dto;
    }

    @Override
    public List<LectureSummaryByJobDto> lectureSummaryByJob(BizGrpInfo bizGrpInfo) {

        return statisticsMapper.selectLectureSummaryByJob(bizGrpInfo.getSetSer().toString());
    }

    @Override
    public List<MentorSummaryByJobClsfDto> mentorSummaryByJobCslf(BizGrpInfo bizGrpInfo) {
        return statisticsMapper.selectMentorSummaryByJobCslf(bizGrpInfo.getSetSer().toString());
    }



    @Override
    public List<StatusAreaDto> statusArea(BizGrpInfo bizGrpInfo) {
        return statisticsMapper.listAreaStatistics(bizGrpInfo.getSetSer().toString());
    }





}
