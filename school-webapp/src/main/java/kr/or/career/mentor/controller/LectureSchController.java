package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.LectCalendarInfo;
import kr.or.career.mentor.domain.LectInfo;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.service.LectureManagementService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureSchController
 *
 * 수업일정 화면의 Controller
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2015-09-30 오후 3:10
 *
 */
@Slf4j
@Controller
@RequestMapping("lecture/lectureSchedule")
public class LectureSchController {

    @Autowired
    private LectureManagementService lectureManagementService;

    /**
     * <pre>
     *     수업일정화면 조회
     * </pre>
     * @param model
     * @param lectureSearch
     * @throws Exception
     */
    @RequestMapping(value = "lectureSch.do")
    public void lectureSch(Model model, LectureSearch lectureSearch) throws Exception {

        // 캘린더 데이터
        List<String> exceptLectStatCdList = new ArrayList<String>();
        exceptLectStatCdList.add(CodeConstants.CD101541_101542_수업요청); //수업요청상태인 것들은 목록에서 제외(개인멘토가 만들어서 관리자의 승인이 아직 안된 수업)
        exceptLectStatCdList.add(CodeConstants.CD101541_101547_모집취소); //모집취소상태인 것들은 목록에서 제외
        lectureSearch.setExceptLectStatCdList(exceptLectStatCdList);
        lectureSearch.setExpsYn("Y");
//        lectureSearch.setSchdSeq(1);
        List<LectCalendarInfo> schCalendarInfo = lectureManagementService.selectLectureSchCalendarInfo(lectureSearch);
        model.addAttribute("calendarInfo", schCalendarInfo);

        // 달력 표시 월
        LectCalendarInfo calInfo = schCalendarInfo.get(8);
        model.addAttribute("thisMonth", Integer.valueOf(calInfo.getDtm().substring(4, 6)));
        model.addAttribute("thisMonthStr", calInfo.getDtm().substring(0, 6));

    }

    /**
     * <pre>
     *     수업일정화면(캘린더) 조회
     * </pre>
     * @param lectureSearch
     * @throws Exception
     */
    @RequestMapping(value = "ajax.lectureSchCalendar.do")
    @ResponseBody
    public List<?> lectureSchCalendar(LectureSearch lectureSearch) throws Exception {

        // 캘린더 데이터 조회
        List<String> exceptLectStatCdList = new ArrayList<String>();
        exceptLectStatCdList.add(CodeConstants.CD101541_101542_수업요청); //수업요청상태인 것들은 목록에서 제외(개인멘토가 만들어서 관리자의 승인이 아직 안된 수업)
        exceptLectStatCdList.add(CodeConstants.CD101541_101547_모집취소); //모집취소상태인 것들은 목록에서 제외
        lectureSearch.setExceptLectStatCdList(exceptLectStatCdList);
        lectureSearch.setExpsYn("Y");
//        lectureSearch.setSchdSeq(1);
        List<LectCalendarInfo> schCalendarInfo = lectureManagementService.selectLectureSchCalendarInfo(lectureSearch);

        return schCalendarInfo;
    }

    /**
     * <pre>
     *     해당 날짜 수업 리스트 조회
     * </pre>
     * @param lectureSearch
     * @throws Exception
     */
    @RequestMapping(value = "ajax.lectureSchLectureList.do")
    @ResponseBody
    public List<LectSchdInfo> lectureSchLectureList(LectureSearch lectureSearch) throws Exception {

        // 날짜 리스트 조회
        List<String> exceptLectStatCdList = new ArrayList<String>();
        exceptLectStatCdList.add(CodeConstants.CD101541_101542_수업요청); //수업요청상태인 것들은 목록에서 제외(개인멘토가 만들어서 관리자의 승인이 아직 안된 수업)
        exceptLectStatCdList.add(CodeConstants.CD101541_101547_모집취소); //모집취소상태인 것들은 목록에서 제외
        lectureSearch.setExceptLectStatCdList(exceptLectStatCdList);
        lectureSearch.setExpsYn("Y");
//        lectureSearch.setSchdSeq(1);
        List<LectSchdInfo> listLecture = lectureManagementService.listLect(lectureSearch);

        return listLecture;
    }
}
