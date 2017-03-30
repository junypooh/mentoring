/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    MyLectureController
 *
 * 나의수업 관련 Controller
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-10-01 오후 1:58
 */
@Controller
@RequestMapping("myPage/myLecture")
@Slf4j
public class MyLectureController {

    @Autowired
    LectureManagementService lectureManagementService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    /**
     *
     * <pre>
     * 마이페이지에서 나의수업 리스트
     * </pre>
     * @param lectApplInfo
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.myLectureList.do")
    @ResponseBody
    public Map myLectureList(@Pageable LectApplInfo lectApplInfo, Authentication authentication) throws Exception {
        Map model = new HashMap();
        User user = (User) authentication.getPrincipal();

        lectApplInfo.setApplMbrNo(user.getMbrNo());
        lectApplInfo.setMbrClassCd(user.getMbrClassCd());

        model = lectureManagementService.myLectureList(lectApplInfo);

        return model;
    }

    /**
     *
     * <pre>
     * 수업취소
     * </pre>
     * @param lectureInfomationDTO
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("cancelReqLecture.do")
    @ResponseBody
    public JSONResponse cancelMyLecture( LectureInfomationDTO lectureInfomationDTO, Authentication authentication) throws Exception {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();

            LectureSearch lectureSearch = new LectureSearch();

            lectureSearch.setLectSer(lectureInfomationDTO.getLectSer());
            lectureSearch.setLectTims(lectureInfomationDTO.getLectTims());

            LectTimsInfo lectTimsInfo = lectureManagementService.lectureTimsSchdInfo(lectureSearch);

            lectureInfomationDTO.setLectrMbrNo(user.getMbrNo());
            lectureInfomationDTO.setLectureCnt((int)lectTimsInfo.getLectureCnt());

            int cnclLectSchdInfo = lectureManagementService.cnclLectClass(lectureInfomationDTO);

            if(cnclLectSchdInfo > 0){

                /**
                 * 메일발송에서 실패가 있더라도 무시한다.
                 *
                 */
                try {
                    MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
                    reciever.setMailAddress(user.getEmailAddr());

                    Message message = new Message();
                    message.setSendType(MessageSendType.EMS.getValue());
                    message.setContentType(MessageType.LECTURE_CANCEL_SELF);
                    message.addReciever(reciever);

                    LecturePayLoad cancelPayload = LecturePayLoad.of(message, lectureInfomationDTO.getLectSer(), lectureInfomationDTO.getLectTims(), false);
                    cancelPayload.setCause(lectureInfomationDTO.getCnclRsnSust());
                    message.setPayload(cancelPayload);

                    messageTransferManager.invokeTransfer(message);

                } catch (Exception e) {
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }

                return JSONResponse.success(CodeMessage.MSG_100009_X0_님_수업취소_되었습니다_.toMessage(user.getUsername()));
            }else{
                return JSONResponse.failure(CodeMessage.MSG_900005_취소_실패_하였습니다_);
            }
        }
        catch (Exception e) {
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
     * 수업요청 취소
     * </pre>
     * @param lectReqInfo
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("cancelReqLectInfo.do")
    @ResponseBody
    public JSONResponse cancelReqLectInfo( LectReqInfo lectReqInfo, Authentication authentication) throws Exception {

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();

            lectReqInfo.setReqStatCd(CodeConstants.CD101655_101657_요청취소); //요청취소 코드

            int cnclLectSchdInfo = lectureManagementService.cancelReqLectInfo(lectReqInfo);

            if(cnclLectSchdInfo > 0){
                return JSONResponse.success(CodeMessage.MSG_100011_X0_님_요청수업_취소되었습니다_.toMessage(user.getUsername()));
            }else{
                return JSONResponse.failure(CodeMessage.ERROR_000001_시스템_오류_입니다_);
            }
        }
        catch (Exception e) {
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
     * 나의수업에서 수업신청
     * </pre>
     * @param lectApplInfo
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("applLectApplInfo.do")
    @ResponseBody
    public JSONResponse applLectApplInfo( LectApplInfo lectApplInfo, Authentication authentication) throws Exception {

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();

            lectApplInfo.setChgMbrNo(user.getMbrNo());
            lectApplInfo.setRegMbrNo(user.getMbrNo());
            lectApplInfo.setApplMbrNo(user.getMbrNo());

            int insetResult = lectureManagementService.applLectApplInfo(lectApplInfo);

            if(insetResult == 1){
                return JSONResponse.success(CodeMessage.MSG_100015_X0_님_수업신청_등록되었습니다_.toMessage(user.getUsername()));
            }else if(insetResult == 2){
                return JSONResponse.success(CodeMessage.MSG_100016_X0_님_수업대기신청_등록되었습니다_.toMessage(user.getUsername()));
            }else{
                return JSONResponse.failure(CodeMessage.ERROR_000001_시스템_오류_입니다_);
            }
        }
        catch (Exception e) {
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
     * 수업참관시 참관이력 저장
     * </pre>
     * @param lectApplInfo
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.regObsvHist.do")
    @ResponseBody
    public JSONResponse regObsvHist(LectApplInfo lectApplInfo, Authentication authentication) throws Exception {

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();

            lectApplInfo.setApplMbrNo(EgovProperties.getProperty("TOMMS_PREFIX") + user.getMbrNo() + lectApplInfo.getClasRoomSer());


            int insetResult = lectureManagementService.regObsvHist(lectApplInfo);


            if(insetResult > 0){
                return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage());
            }else{
                log.debug("참관이력 저장 실패하였습니다.");
                return JSONResponse.failure(CodeMessage.ERROR_000001_시스템_오류_입니다_);
            }
        }
        catch (Exception e) {

            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            log.debug("참관이력 저장 시스템 실패하였습니다.");
            log.debug(codeMessage.toMessage());

            return JSONResponse.failure(codeMessage, e);
        }
    }


    /**
     * <pre> 수업신청(수업신청대기) 모바일 신청화면 </pre>
     *
     * @param model
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("mWebLectureApply.do")
    public void onLoadLayerPopupLectureApply(Model model, HttpServletRequest request, LectureSearch lectureSearch) throws Exception {


        //수업정보 조회
        LectInfo lectureInfo = lectureManagementService.lectureInfo(lectureSearch);
        //수업 차수 및 회차 정보 조회
        LectTimsInfo lectTimsInfo = lectureManagementService.lectureTimsSchdInfo(lectureSearch);

        model.addAttribute("lectTimsInfo", lectTimsInfo);    //수업 차수&회차 정보
        model.addAttribute("lectInfo", lectureInfo);         //수업정보
        model.addAttribute("applClassCd", lectureSearch.getApplClassCd());         //수업정보
    }

}
