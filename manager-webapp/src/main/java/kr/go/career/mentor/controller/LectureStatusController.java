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
import kr.or.career.mentor.view.GenericExcelView;
import kr.or.career.mentor.view.GenericListExcelView;
import kr.or.career.mentor.view.MultiSheetExcelView;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
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
import java.lang.reflect.Field;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;


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
@RequestMapping("lecture/mentor/status")
public class LectureStatusController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @RequestMapping("list.do")
    public void lectureStatusList(Model model){

        Code codeParam = new Code();
        codeParam.setUseYn("Y");
        codeParam.setSupCd(CodeConstants.CD101512_101533_강의대상코드);
        List<Code> schoolGrd = codeManagementService.listCode(codeParam); //학교급

        codeParam.setSupCd(CodeConstants.CD101512_101528_강의유형코드);
        List<Code> lectType = codeManagementService.listCode(codeParam);  //강의유형

        model.addAttribute("schoolGrd",schoolGrd);
        model.addAttribute("lectType",lectType);
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

        List<LectureInfomationDTO> listLecture = lectureManagementService.lectureTimsList(lectureSearch);

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
    public ModelAndView excelLectApplList(LectureSearch lectureSearch, Model model, Authentication authentication) throws Exception {

        User user = (User) authentication.getPrincipal();
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());
        lectureSearch.setApplStatCd("101576");

        List<ExcelInfoDTO> excelSheetList = new ArrayList<>();

        lectureSearch.setSchdSeq(0);
        List<LectureInfomationDTO> listLecture = lectureManagementService.lectureTimsList(lectureSearch);

        ExcelInfoDTO excelA1SheetInfo = lectureManagementService.lectInfoExcelList(listLecture);
        excelSheetList.add(excelA1SheetInfo);


        List<LectureInfomationDTO> listApplClas = lectureManagementService.lectApplClasList(lectureSearch);
        ExcelInfoDTO excelA2SheetInfo = lectureManagementService.lectApplClasExcelList(listApplClas, "status");
        excelSheetList.add(excelA2SheetInfo);



        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);


        model.addAttribute("fileName", str + "수업현황.xls");
        model.addAttribute("excelSheetList",excelSheetList);

        return new ModelAndView("multiSheetExcelView", "data", model);
    }


    @RequestMapping("view.do")
    @Historic(workId = "1000000101")
    public void lectureStatusView(LectureSearch lectureSearch, Model model) throws Exception{

        //수업정보 조회
        LectInfo lectInfo = lectureManagementService.lectureInfo(lectureSearch);

        model.addAttribute("lectInfo", lectInfo);
        model.addAttribute("lectSer", lectureSearch.getLectSer());
        model.addAttribute("lectTims", lectureSearch.getLectTims());
    }


    @RequestMapping("ajax.view.do")
    @ResponseBody
    public LectTimsInfo  lectureTimsSchdList(LectureSearch lectureSearch, Authentication authentication) throws Exception{

        //수업 차수 및 회차 정보 조회
        LectTimsInfo lectTimsInfo = lectureManagementService.lectureTimsSchdInfo(lectureSearch);

        return lectTimsInfo;
    }

    @RequestMapping("ajax.appList.do")
    @ResponseBody
    public List<LectureInfomationDTO>  lectureApplList(LectureSearch lectureSearch, Authentication authentication) throws Exception{
        //수업 승인/참관 이력 리시트
        List<LectureInfomationDTO> lectApplList = lectureManagementService.lectureApplList(lectureSearch);

        return lectApplList;
    }




    @RequestMapping("ajax.otherTimsList.do")
    @ResponseBody
    public List<LectTimsInfo>  lectureOtherTimsList(@Pageable LectureSearch lectureSearch, Authentication authentication) throws Exception{
        //수업 다른 차수 리스트
        List<LectTimsInfo> lectTimsList = lectureManagementService.lectureOtherTimsList(lectureSearch);

        return lectTimsList;
    }


    /**
     *
     * <pre>
     * 수업상태현황 수치
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.lectureStatusCnt.do")
    @ResponseBody
    public List<LectureInfomationDTO> lectureStatusCnt(LectureSearch lectureSearch, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());


        return lectureManagementService.lectureTimsStatusCnt(lectureSearch);
    }

    /**
     *
     * <pre>
     * 수업 수동 취소
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.cnclLect.do")
    @ResponseBody
    public JSONResponse cnclLect(LectTimsInfo lectTimsInfo, Authentication authentication) {
        CodeMessage codeMessage = null;

        User user = (User) authentication.getPrincipal();
        lectTimsInfo.setCnclMbrNo(user.getMbrNo());
        lectTimsInfo.setLectStatCd("101547");
        lectTimsInfo.setApplStatCd("101578");

        try{
            lectureManagementService.cnclLect(lectTimsInfo);
            codeMessage = CodeMessage.MSG_100020_수업취소_되었습니다_;


        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }

    /**
     *
     * <pre>
     * 수업 노출여부 수정
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.expsLect.do")
    @ResponseBody
    public JSONResponse expsLect(LectTimsInfo lectTimsInfo, Authentication authentication) {
        CodeMessage codeMessage = null;

        User user = (User) authentication.getPrincipal();
        lectTimsInfo.setCnclMbrNo(user.getMbrNo());


        try{
            lectureManagementService.updateExpsLectureInfo(lectTimsInfo);
            codeMessage = CodeMessage.MSG_900003_수정_되었습니다_;

        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }



    /**
     *
     * <pre>
     * 수업 취소 사유 수정
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.cnclRsnUpdate.do")
    @ResponseBody
    public JSONResponse cnclRsnUpdate(LectTimsInfo lectTimsInfo, Authentication authentication) {
        CodeMessage codeMessage = null;

        User user = (User) authentication.getPrincipal();
        lectTimsInfo.setCnclMbrNo(user.getMbrNo());


        try{
            lectureManagementService.cnclRsnUpdate(lectTimsInfo);
            codeMessage = CodeMessage.MSG_900003_수정_되었습니다_;

        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }

    /**
     *
     * <pre>
     * 수업 참여 가능 MC 리스트
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.listMcInfo.do")
    @ResponseBody
    public List<McInfo> listMcInfo(LectureSearch lectureSearch, Authentication authentication) throws Exception {

        List<McInfo> listMc = lectureManagementService.listMcInfo(lectureSearch);


        return listMc;
    }

    /**
     *
     * <pre>
     * 수업 스튜디오 리스트
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.listStdoInfo.do")
    @ResponseBody
    public List<StdoInfo> listStdoInfo(LectureSearch lectureSearch, Authentication authentication) throws Exception {

        List<StdoInfo> listStdo = lectureManagementService.listStdoInfo(lectureSearch);


        return listStdo;
    }


    /**
     *
     * <pre>
     * 수업 회의 재개설
     * </pre>
     *
     * @return
     * @throws UnsupportedEncodingException
     * @throws BadPaddingException
     * @throws IllegalBlockSizeException
     * @throws InvalidAlgorithmParameterException
     * @throws NoSuchPaddingException
     * @throws NoSuchAlgorithmException
     * @throws InvalidKeyException
     */
    @RequestMapping("ajax.createSession.do")
    @ResponseBody
    public ApprovalDTO createSession(ApprovalDTO approvalDTO) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
        return lectureManagementService.createSession(approvalDTO);
    }




    @RequestMapping("ajax.lectUpdateMcStdo.do")
    @ResponseBody
    public JSONResponse lectUpdateMcStdo(LectTimsInfo lectTimsInfo, Authentication authentication) throws Exception {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        int insetResult = 0;


        try {
            User user = (User) authentication.getPrincipal();

            insetResult = lectureManagementService.lectUpdateMcStdo(lectTimsInfo, user.getMbrNo());


            if(insetResult >0){
                return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage(user.getUsername()));
            }else{
                return JSONResponse.success(CodeMessage.MSG_900002_등록_실패_하였습니다_.toMessage(user.getUsername()));
            }
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

    /**
     *
     * <pre>
     * 수업 수동 신청 Class 리스트
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.listLectClass.do")
    @ResponseBody
    public List<ClasRoomInfo> listLectClass(LectureSearch lectureSearch, Authentication authentication) throws Exception {

        List<ClasRoomInfo> listClass = lectureManagementService.listLectClass(lectureSearch);

        return listClass;
    }



    @RequestMapping("ajax.lectInsertClass.do")
    @ResponseBody
    public JSONResponse lectInsertClass(LectureInfomationDTO lectureInfomationDTO, Authentication authentication) throws Exception {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        int insetResult = 0;


        try {
            User user = (User) authentication.getPrincipal();

            //수동 수강신청 등록 관리자 정보
            lectureInfomationDTO.setLectrMbrNo(user.getMbrNo());

            insetResult = lectureManagementService.lectInsertClass(lectureInfomationDTO, "mng");


            if(insetResult >0){
                if(lectureInfomationDTO.getApplClassCd().equals("101716")){
                    LectApplInfo lectApplInfo = new LectApplInfo();
                    double obsvCnt = 0.5;

                    if(lectureInfomationDTO.getLectTypeCd().equals("101532")){
                        obsvCnt = 1;
                    }

                    lectApplInfo.setApplMbrNo(EgovProperties.getProperty("TOMMS_PREFIX") + user.getMbrNo() + lectureInfomationDTO.getClasRoomSer());
                    lectApplInfo.setClasRoomSer(lectureInfomationDTO.getClasRoomSer());
                    lectApplInfo.setSchNo(lectureInfomationDTO.getSchNo());
                    lectApplInfo.setWithdrawCnt(obsvCnt);
                    lectApplInfo.setSetSer(lectureInfomationDTO.getSetSer());

                    for(LectSchdInfo lectSchdInfo : lectureInfomationDTO.getLectSchdInfoList()){
                        lectApplInfo.setLectSessId(lectSchdInfo.getLectSessId());

                        lectureManagementService.regObsvHist(lectApplInfo);
                    }

                }

                return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage(user.getUsername()));
            }else{
                return JSONResponse.success(CodeMessage.MSG_900002_등록_실패_하였습니다_.toMessage(user.getUsername()));
            }
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }


    /**
     *
     * <pre>
     * 수업 Class 신청 취소
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.cnclLectClass.do")
    @ResponseBody
    public JSONResponse cnclLectClass(LectureInfomationDTO lectureInfomationDTO, Authentication authentication) {
        CodeMessage codeMessage = null;

        User user = (User) authentication.getPrincipal();
        lectureInfomationDTO.setLectrMbrNo(user.getMbrNo());


        try{
            lectureManagementService.cnclLectClass(lectureInfomationDTO);
            codeMessage = CodeMessage.MSG_100020_수업취소_되었습니다_;


        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }

}
