/* ntels */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.view.JSONResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;


/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureStatusController
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-11-06 오전 10:04
 */
@Controller
@RequestMapping("lecture/mentor/lectAppl")
public class LectureClassApplController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;


    @RequestMapping("list.do")
    public void lectureStatusList(Model model){

        Code codeParam = new Code();
        codeParam.setUseYn("Y");

        codeParam.setSupCd(CodeConstants.CD100211_100494_학교);
        List<Code> schoolGrd = codeManagementService.listCode(codeParam); //학교급

        model.addAttribute("schoolGrd",schoolGrd);
    }

    /**
     *
     * <pre>
     * 수업 현황 리스트
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000100")
    public List<LectureInfomationDTO> lectureTotalList(@Pageable LectureSearch lectureSearch, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());

        List<LectureInfomationDTO> listLecture = lectureManagementService.lectApplClasList(lectureSearch);

        return listLecture;
    }


    /**
     * <pre>
     *     수업개설관리 > 수업현황 목록 엑셀다운로드
     * </pre>
     * @param lectureSearch
     * @return
     */
    @RequestMapping(value = "excel.list.do", method = RequestMethod.POST)
    public ModelAndView excelLectApplList(LectureSearch lectureSearch, Model model) throws Exception {

        List<ExcelInfoDTO> excelSheetList = new ArrayList<>();

        List<LectureInfomationDTO> listApplClas = lectureManagementService.lectApplClasList(lectureSearch);
        ExcelInfoDTO excelA2SheetInfo = lectureManagementService.lectApplClasExcelList(listApplClas, "lectAppl");
        excelSheetList.add(excelA2SheetInfo);

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);


        model.addAttribute("fileName", str + "수업신청취소현황.xls");
        model.addAttribute("excelSheetList",excelSheetList);

        return new ModelAndView("multiSheetExcelView", "data", model);
    }

}
