/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureScheduleController
 *
 * 수업스케줄 controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-26 오후 2:35
 */
@Controller
@RequestMapping("mentor/lectureSchedule")
public class LectureScheduleController {

    @Autowired
    protected CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    /**
     * <pre>
     *     수업스케줄 onload
     * </pre>
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("lectureSchedule.do")
    public void onLoadLectureSchedule(Model model) throws Exception {
        Code code = new Code();
        code.setSupCd(CodeConstants.CD101512_101541_강의상태코드);
        model.addAttribute("code101541", codeManagementService.listCode(code)); //수업상태코드

        code.setSupCd(CodeConstants.CD101512_101649_요청수업_선택_팝업화면_검색조건2);
        model.addAttribute("code101512", codeManagementService.listCode(code));
    }

    /**
     * <pre>
     *     수업스케줄 목록조회
     * </pre>
     * @param lectureSearch
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listLectureSchedule.do")
    @ResponseBody
    public List<LectureInfomationDTO> listLectureSchedule(LectureSearch lectureSearch, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        lectureSearch.setSearchType(user.getMbrCualfCd());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());
        lectureSearch.setCoNo(user.getPosCoNo());
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setPageable(true);

        List<LectureInfomationDTO> lectureInfomationDTOList = lectureManagementService.listLectureSchedule(lectureSearch);

        return lectureInfomationDTOList;
    }

    /**
     * <pre>
     *     정산(소속멘토) 엑셀다운로드
     * </pre>
     * @param lectureSearch
     * @param authentication
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.excelDownListLectureSchedule.do")
    public ModelAndView excelDownListLectureSchedule(LectureSearch lectureSearch, Authentication authentication, Model model) throws Exception{
        User user = (User) authentication.getPrincipal();
        lectureSearch.setSearchType(user.getMbrCualfCd());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());
        lectureSearch.setCoNo(user.getPosCoNo());
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setPageable(false);

        List<LectureInfomationDTO> originList = lectureManagementService.listLectureSchedule(lectureSearch);

        List<LectureScheduleExcelDTO> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(LectureInfomationDTO originSource: originList){
            LectureScheduleExcelDTO targetSource = new LectureScheduleExcelDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            //수업일 세팅
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            targetSource.setDateLectDay(sdf.parse(targetSource.getLectDay()));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd"); //강의 시작날짜

            Date today = new Date();   //오늘날짜
            LectTimsInfo lectTimsInfo = new LectTimsInfo();
            LectApplCnt  lectApplCnt = new LectApplCnt();
            LectApplInfo  lectApplInfo = new LectApplInfo();



            //수업시간 세팅
            StringBuffer sbStartTime = new StringBuffer(targetSource.getLectStartTime());
            sbStartTime.insert(2, ":");
            StringBuffer sbEndTime = new StringBuffer(targetSource.getLectEndTime());
            sbEndTime.insert(2, ":");
            SimpleDateFormat sf = new SimpleDateFormat("hh:mm");
            Date startDay = sf.parse(sbStartTime.toString());
            Date endDay = sf.parse(sbEndTime.toString());

            long startTime = startDay.getTime();
            long endTime = endDay.getTime();

            long mill = Math.abs(endTime-startTime);


            targetSource.setLectTime(sbStartTime.toString() + "~" + sbEndTime.toString()+"("+(mill/60000)+"분)");

            targetList.add(targetSource);
        }

        model.addAttribute("fileName", "ListLectureSchedule.xls");
        model.addAttribute("domains", targetList);

        return new ModelAndView("excelView","data",model);
    }

}

