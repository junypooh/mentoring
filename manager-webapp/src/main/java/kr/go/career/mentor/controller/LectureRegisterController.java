/* ntels */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.joda.time.DateTime;
import org.joda.time.Minutes;
import org.joda.time.format.DateTimeFormat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
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
@RequestMapping("lecture/mentor/register")
public class LectureRegisterController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @RequestMapping("list.do")
    public void lectureStatusList(Model model){

        Code codeParam = new Code();
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
     * 수업 등록 관리 리스트
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000102")
    public List<LectInfo> lectureTotalList(@Pageable LectureSearch lectureSearch, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());

        //수업정보 조회
        List<LectInfo> lectInfoList = lectureManagementService.lectureInfoList(lectureSearch);

        return lectInfoList;
    }


    @RequestMapping("view.do")
    @Historic(workId = "1000000103")
    public void lectureStatusView(LectureSearch lectureSearch, Model model) throws Exception{

        //수업정보 조회
        LectInfo lectInfo = lectureManagementService.lectureInfo(lectureSearch);

        model.addAttribute("lectInfo", lectInfo);
        model.addAttribute("lectSer", lectureSearch.getLectSer());
        model.addAttribute("lectTims", lectureSearch.getLectTims());
        model.addAttribute("assignDay", Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY")));
    }


    @RequestMapping("ajax.view.do")
    @ResponseBody
    public LectTimsInfo  lectureTimsSchdList(LectureSearch lectureSearch, Authentication authentication) throws Exception{

        //수업 차수 및 회차 정보 조회
        LectTimsInfo lectTimsInfo = lectureManagementService.lectureTimsSchdInfo(lectureSearch);

        return lectTimsInfo;
    }

    @RequestMapping("edit.do")
    public void lectureStatusUpdate(LectureSearch lectureSearch, Model model) throws Exception{

        //수업정보 조회
        LectInfo lectInfo = lectureManagementService.lectureInfo(lectureSearch);

        model.addAttribute("lectInfo", lectInfo);
        model.addAttribute("lectSer", lectureSearch.getLectSer());
        model.addAttribute("lectTims", lectureSearch.getLectTims());
    }

    @RequestMapping("lectInfoUpdate.do")
    @Historic(workId = "1000000104")
    public String lectInfoUpdate(LectInfo lectInfo, Authentication authentication) throws Exception {
        int insetResult = 0;

        try {
            User user = (User) authentication.getPrincipal();

            lectInfo.setChgMbrNo(user.getMbrNo());

            insetResult = lectureManagementService.updateLectInfo(lectInfo, "mng");
        }
        catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
        }

        return "redirect:view.do?lectSer="+lectInfo.getLectSer();
    }


    @RequestMapping("ajax.lectTimsList.do")
    @ResponseBody
    public List<LectTimsInfo>  lectTimsList(@Pageable LectureSearch lectureSearch, Authentication authentication) throws Exception{
        //수업 다른 차수 리스트
        List<LectTimsInfo> lectTimsList = lectureManagementService.lectureOtherTimsList(lectureSearch);

        return lectTimsList;
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
     * 수업 일시추가 차수/회차 등록
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.IectureSchdInfoInsert.do")
    @ResponseBody
    public JSONResponse IectureSchdInfoInsert(LectTimsInfo lectTimsInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        int insetResult = 0;

        try {
            User user = (User) authentication.getPrincipal();

            lectTimsInfo.setRegMbrNo(user.getMbrNo());

            insetResult = lectureManagementService.IectureSchdInfoInsert(lectTimsInfo);


            if( insetResult == (Constants.LECTURE_CREATE_SUCCESS|Constants.TOMMS_CREATE_SUCCESS) && (insetResult&Constants.LECTURE_CREATE_SUCCESS) == Constants.LECTURE_CREATE_SUCCESS) {
                return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage(user.getUsername()));
            }else if((insetResult&Constants.TOMMS_CREATE_SUCCESS) == 0){
                return JSONResponse.success(CodeMessage.MSG_900006_화상회의_개설에_실패_하였습니다_.toMessage(user.getUsername()));
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


}
