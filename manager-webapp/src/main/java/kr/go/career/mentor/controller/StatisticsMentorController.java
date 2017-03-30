package kr.go.career.mentor.controller;

import kr.or.career.mentor.domain.JoinSummaryDTO;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.MentorReportDTO;
import kr.or.career.mentor.domain.StatisticsMentor;
import kr.or.career.mentor.service.StatisticsMentorService;
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
 * kr.go.career.mentor.controller
 *      StatisticsMentorController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-29 오후 1:06
 */
@Controller
@RequestMapping("statistics/mentor")
public class StatisticsMentorController {

    @Autowired
    private StatisticsMentorService statisticsMentorService;


    /**
     * <pre>
     *     멘토리포트 > 직업별 리스트
     * </pre>
     * @param statisticsMentor
     * @return
     */
    @RequestMapping("/job/ajax.list.do")
    @ResponseBody
    public Map jobList(StatisticsMentor statisticsMentor) {
        Map model = new HashMap();
        List<StatisticsMentor> jobList = statisticsMentorService.selectStatisticsJob(statisticsMentor);
        model.put("list", jobList);

        StatisticsMentor jobCnt = statisticsMentorService.selectDepthCnt();
        model.put("jobCnt", jobCnt);
        return model;
    }


    /**
     * <pre>
     *     멘토리포트 > 직업별 리스트
     * </pre>
     * @param statisticsMentor
     * @return
     */
    @RequestMapping("/clsf/ajax.list.do")
    @ResponseBody
    public Map chrstcList(StatisticsMentor statisticsMentor) {
        Map model = new HashMap();
        List<StatisticsMentor> ChrstcList = statisticsMentorService.selectStatisticsChrstc(statisticsMentor);
        model.put("list", ChrstcList);
        return model;
    }


    /**
     * <pre>
     *     멘토리포트 > 멘토목록 리스트
     * </pre>
     * @param statisticsMentor
     * @return
     */
    @RequestMapping("/mentor/ajax.list.do")
    @ResponseBody
    public List<MentorReportDTO> mentorList(StatisticsMentor statisticsMentor) {

        return statisticsMentorService.selectMentorList(statisticsMentor);
    }

    /**
     * <pre>
     *     멘토리포트 > 멘토목록 엑셀 다운로드
     * </pre>
     * @param statisticsMentor
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="mentor/excel.do",method= RequestMethod.POST)
    public ModelAndView excelDownlistJoinStatistics(StatisticsMentor statisticsMentor, Model model) throws Exception{
        List<MentorReportDTO> originList = statisticsMentorService.selectMentorList(statisticsMentor);

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_멘토통계_멘토목록.xls");
        model.addAttribute("domains", originList);

        return new ModelAndView("excelView", "data", model);
    }


    /**
     * <pre>
     *     멘토리포트 > 멘토별수업
     * </pre>
     * @param statisticsMentor
     * @return
     */
    @RequestMapping("/lecture/ajax.list.do")
    @ResponseBody
    public Map mentorLectureList(StatisticsMentor statisticsMentor) {
        Map model = new HashMap();
        List<StatisticsMentor> mentorLectureList = statisticsMentorService.selectStatisticsMentorLect(statisticsMentor);
        model.put("list", mentorLectureList);
        return model;
    }

    /**
     * <pre>
     *     멘토리포트 > 멘토별수업 엑셀 다운로드
     * </pre>
     * @param statisticsMentor
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/lecture/excel.do",method= RequestMethod.POST)
    public ModelAndView excelDownLectureStatistics(StatisticsMentor statisticsMentor, Model model) throws Exception{
        List<StatisticsMentor> originList = statisticsMentorService.selectStatisticsMentorLect(statisticsMentor);

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_멘토통계_멘토별수업.xls");
        model.addAttribute("domains", originList);

        return new ModelAndView("excelView", "data", model);
    }


}
