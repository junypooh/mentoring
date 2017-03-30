/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.service.MessageSenderService;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    CalculateManagementController
 *
 * 정산관리(개인멘토) 화면의 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-19 오전 10:47
 */
@Controller
@RequestMapping("mentor/calculateManagement")
public class CalculateManagementController {

    public static final Logger log = LoggerFactory.getLogger(CalculateManagementController.class);

    @Autowired
    protected CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private MessageSenderService messageSenderService;

    /**
     * <pre>
     *     정산관리(개인멘토) onload
     * </pre>
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("calculateManagement.do")
    public void onLoadCalculateManagement(Model model) throws Exception {
        Code code = new Code();
        code.setSupCd(CodeConstants.CD101512_101528_강의유형코드);
        model.addAttribute("code101528", codeManagementService.listCode(code)); //수업유형코드

        code.setSupCd(CodeConstants.CD101512_101649_요청수업_선택_팝업화면_검색조건2);
        model.addAttribute("code101512", codeManagementService.listCode(code));
    }

    /**
     * <pre>
     *     정산관리(개인멘토) 조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listCalculateLectureByMentor.do")
    @ResponseBody
    public LectureInfomationDTO listCalculateLectureByMentor(LectureSearch lectureSearch, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        lectureSearch.setSearchType(user.getMbrCualfCd());
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setCoNo(user.getPosCoNo());
        lectureSearch.setPageable(true);

        LectureInfomationDTO lectureInfomationDTO = lectureManagementService.listCalculateLectureByMentor(lectureSearch);

        lectureInfomationDTO.setCurrentPageNo(lectureSearch.getCurrentPageNo());

        return lectureInfomationDTO;
    }

    /**
     * <pre>
     *     정산관리 엑셀다운로드
     * </pre>
     * @param lectureSearch
     * @param authentication
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.excelDownListCalculate.do")
    public ModelAndView excelDownListCalculate(LectureSearch lectureSearch, Authentication authentication, Model model) throws Exception{
        User user = (User) authentication.getPrincipal();
        lectureSearch.setSearchType(user.getMbrCualfCd());
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setCoNo(user.getPosCoNo());
        lectureSearch.setPageable(false);

        LectureInfomationDTO lectureInfomationDTO = lectureManagementService.listCalculateLectureByMentor(lectureSearch);

        List<LectureInfomationDTO> originList = lectureInfomationDTO.getLectureInfomationDTOList();
        List<CalculateManagementExcelDTO> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(LectureInfomationDTO originSource: originList){
            CalculateManagementExcelDTO targetSource = new CalculateManagementExcelDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            //수업일 세팅
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            targetSource.setDateLectDay(sdf.parse(targetSource.getLectDay()));

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

        log.info("==========targetList.size()::" + targetList.size());

        model.addAttribute("fileName", "listCalculateLecture.xls");
        model.addAttribute("domains", targetList);

        return new ModelAndView("excelView","data",model);
    }

    @RequestMapping("ajax.listCalculateSmsSendResult.do")
    @ResponseBody
    public List<SendResultDTO> listCalculateSmsSendResult(@Pageable SendResultDTO sendResultDTO, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        sendResultDTO.setMbrNo(user.getMbrNo());
        sendResultDTO.setPageable(true);

        List<SendResultDTO> sendResultDTOs = messageSenderService.listSmsSendResultTest(sendResultDTO);

        return sendResultDTOs;
    }

}

