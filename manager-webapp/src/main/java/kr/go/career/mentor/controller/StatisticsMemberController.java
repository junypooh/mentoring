package kr.go.career.mentor.controller;

import kr.or.career.mentor.domain.JoinSummaryDTO;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.LoginSummaryDTO;
import kr.or.career.mentor.service.StatisticsService;
import lombok.extern.slf4j.Slf4j;
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
 *      StatisticsMemberController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-08-29 오전 10:42
 */
@Controller
@RequestMapping("statistics/member")
@Slf4j
public class StatisticsMemberController {

    @Autowired
    private StatisticsService statisticsService;

    /**
     * <pre>
     *     회원통계 화면의 로그인통계 조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("conn/ajax.list.do")
    @ResponseBody
    public Map listLoginStatistics(LectureSearch lectureSearch) throws Exception{
        Map model = new HashMap();
        List<LoginSummaryDTO> listLoginStatistics = statisticsService.listLoginStatistics(lectureSearch);
        model.put("list", listLoginStatistics);

        Calendar calendar = Calendar.getInstance();
        Integer iMonth = calendar.get(Calendar.MONTH);
        Integer iDate = calendar.get(Calendar.DATE);
        Integer iHour = calendar.get(Calendar.HOUR_OF_DAY);

        model.put("iMonth", iMonth + 1);
        model.put("iDate", iDate);
        model.put("iHour", iHour);
        return model;
    }

    /**
     * <pre>
     *     회원통계 화면의 로그인통계 엑셀다운로드
     * </pre>
     * @param lectureSearch
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="conn/excel.do",method= RequestMethod.POST)
    public ModelAndView excelDownListLoginStatistics(LectureSearch lectureSearch, Model model) throws Exception{
        List<LoginSummaryDTO> originList = statisticsService.listLoginStatisticsExcel(lectureSearch);

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_회원통계_접속현황.xls");
        model.addAttribute("domains", originList);

        return new ModelAndView("excelView", "data", model);
    }

    /**
     * <pre>
     *     회원통계 화면의 회원가입 통계 조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("join/ajax.list.do")
    @ResponseBody
    public Map listJoinStatistics(LectureSearch lectureSearch) throws Exception{
        Map model = new HashMap();
        List<JoinSummaryDTO> listLoginStatistics = statisticsService.listJoinStatistics(lectureSearch);
        model.put("list", listLoginStatistics);

        Calendar calendar = Calendar.getInstance();
        Integer iMonth = calendar.get(Calendar.MONTH);
        Integer iDate = calendar.get(Calendar.DATE);
        Integer iHour = calendar.get(Calendar.HOUR_OF_DAY);

        model.put("iMonth", iMonth + 1);
        model.put("iDate", iDate);
        model.put("iHour", iHour);
        return model;
    }

    /**
     * <pre>
     *     회원통계 화면의 회원가입 통계 엑셀다운로드
     * </pre>
     * @param lectureSearch
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="join/excel.do",method= RequestMethod.POST)
    public ModelAndView excelDownlistJoinStatistics(LectureSearch lectureSearch, Model model) throws Exception{
        List<JoinSummaryDTO> originList = statisticsService.listJoinStatisticsExcel(lectureSearch);

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_회원통계_가입현황.xls");
        model.addAttribute("domains", originList);

        return new ModelAndView("excelView", "data", model);
    }

}
