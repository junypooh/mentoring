/* ntels */
package kr.go.career.mentor.controller;

import com.google.common.collect.Lists;
import kr.or.career.mentor.annotation.ExcelFieldName;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.AssignGroupService;
import kr.or.career.mentor.service.StatisticsService;
import lombok.Data;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    StatusStatisticsController
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 16. 5. 25. 오후 3:28
 */
@Controller
@RequestMapping("statistics/status")
public class StatusStatisticsController {

    @Autowired
    private StatisticsService statisticsService;

    @Autowired
    private AssignGroupService assignGroupService;

    /**
     * <pre>
     *     직업분류별 통계 조회
     * </pre>
     * @param bizGrpInfo
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.mentorSummaryByJobCslf.do")
    @ResponseBody
    public List<MentorSummaryByJobClsfDto> mentorSummaryByJobCslf(BizGrpInfo bizGrpInfo) {
        return statisticsService.mentorSummaryByJobCslf(bizGrpInfo);
    }

    @RequestMapping(value ={"/total/list.do","/school/list.do","/job/list.do","/clsf/list.do"})
    public void totalList(Model model){
        List<BizGrpInfo> bizGrpInfos = assignGroupService.listAssignGroupByDistinct();
        model.addAttribute("bizGrps",bizGrpInfos);
    }

    @RequestMapping("ajax.totalListByBizGroup.do")
    @ResponseBody
    public StatusSummaryDto totalListByBizGroup(BizGrpInfo bizGrpInfo) {
        return statisticsService.statusSummary(bizGrpInfo);
    }


    @RequestMapping("ajax.areaSummaryList.do")
    @ResponseBody
    public List<StatusAreaDto> statusArea(BizGrpInfo bizGrpInfo) {
        return statisticsService.statusArea(bizGrpInfo);
    }

    @RequestMapping("ajax.lectureSummaryByJob.do")
    @ResponseBody
    public List<LectureSummaryByJobDto> lectureSummaryByJob(BizGrpInfo bizGrpInfo) {
        return statisticsService.lectureSummaryByJob(bizGrpInfo);
    }


    @RequestMapping(value="excel.mentorSummaryByJobCslf.do",method= RequestMethod.POST)
    public ModelAndView excelMentorSummaryByJobCslf(BizGrpInfo bizGrpInfo) {

        Map<String, Object> model = new HashMap<>();

        List<MentorSummaryByJobClsfDto> domains = statisticsService.mentorSummaryByJobCslf(bizGrpInfo);


        model.put("fileName", String.format("%s_%s_고용직업분류별멘토수.xls", DateFormatUtils.format(new Date(), "yyyyMMddhhmmss"), bizGrpInfo.getGrpNm()));
        model.put("domains", domains);

        return new ModelAndView("excelView", model);
    }

    @RequestMapping(value="excel.areaSummaryList.do",method= RequestMethod.POST)
    public ModelAndView excelAreaSummary(BizGrpInfo bizGrpInfo) {

        Map<String, Object> model = new HashMap<>();

        List<StatusAreaDto> listLectStatistics = statisticsService.statusArea(bizGrpInfo);
        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.put("fileName", String.format("%s_%s_학교참여현황.xls", DateFormatUtils.format(new Date(), "yyyyMMddhhmmss"), bizGrpInfo.getGrpNm()));
        model.put("domains", listLectStatistics);

        return new ModelAndView("excelView",model);
    }

    @RequestMapping(value="excel.lectureSummaryByJob.do",method= RequestMethod.POST)
    public ModelAndView excelLectureSummaryByJob(BizGrpInfo bizGrpInfo) {

        Map<String, Object> model = new HashMap<>();

        List<LectureSummaryByJobDto> domains = statisticsService.lectureSummaryByJob(bizGrpInfo);


        model.put("fileName", String.format("%s_%s_직업별수업수.xls", DateFormatUtils.format(new Date(), "yyyyMMddhhmmss"),bizGrpInfo.getGrpNm()));
        model.put("domains", domains);

        return new ModelAndView("excelView", model);
    }

    @RequestMapping(value="excel.summary.do",method= RequestMethod.POST)
    public ModelAndView excelSummary(BizGrpInfo bizGrpInfo) {

        Map<String, Object> model = new HashMap<>();

        StatusSummaryDto statusSummaryDto = statisticsService.statusSummary(bizGrpInfo);

        List<SummaryDto> domains = Lists.newArrayList();

        domains.add(new SummaryDto("대상 학교수",statusSummaryDto.getBizSetSchoolCnt().toString()));
        domains.add(new SummaryDto("수업참여 학교수",statusSummaryDto.getAppliedSchoolCnt().toString()));
        domains.add(new SummaryDto("학교 수업참여수 누적",statusSummaryDto.getAppliedClassCnt().toString()));
        domains.add(new SummaryDto("학교당 참여수업수 평균(대상교 전체 기준)",statusSummaryDto.getAvgOfAppliedClassBySchool()));
        domains.add(new SummaryDto("학교당 참여수업수 평균(불참교 제외)",statusSummaryDto.getAvgOfAppliedClassExpect()));
        domains.add(new SummaryDto("개설 수업수",statusSummaryDto.getOpenClassCnt().toString()));
        domains.add(new SummaryDto("수업당 참여학교수 평균",statusSummaryDto.getAvgOfSchoolCntPerClass()));
        domains.add(new SummaryDto("전체 멘토수",statusSummaryDto.getTotalMentorCnt().toString()));
        domains.add(new SummaryDto("멘토 직업수",statusSummaryDto.getJobCntOfMentor().toString()));
        domains.add(new SummaryDto("수업 멘토수",statusSummaryDto.getMentorCntOfLecture().toString()));
        domains.add(new SummaryDto("수업 직업수", statusSummaryDto.getJobCntOfLecture().toString()));

        model.put("fileName", String.format("%s_%s_종합현황.xls", DateFormatUtils.format(new Date(), "yyyyMMddhhmmss"), bizGrpInfo.getGrpNm()));
        model.put("domains", domains);

        return new ModelAndView("excelView", model);
    }

    @Data
    private class SummaryDto {

        @ExcelFieldName(name="구분",order = 1)
        private String rowHeader;
        @ExcelFieldName(name="실적",order = 2)
        private String rowData;

        public SummaryDto(String rowHeader, String rowData) {
            this.rowHeader = rowHeader;
            this.rowData = rowData;
        }
    }

}
