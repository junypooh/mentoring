/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.AssignGroupMapper;
import kr.or.career.mentor.dao.LectureInfomationMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.FileManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureManagementController
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-10-15 오후 4:51
 */
@Controller
@RequestMapping("lecture/lectureState")
@Slf4j
public class LectureManagementController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;

    @Autowired
    private AssignGroupMapper assignGroupMapper;

    @Autowired
    protected FileManagementService fileManagementService;

    @Autowired
    protected ComunityService comunityService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @RequestMapping("mentorLectList.do")
    public void onLoadMentorlectureList(Model model){
        Code codeParam = new Code();
        codeParam.setSupCd("101533");
        List<Code> schoolGrd = codeManagementService.listCode(codeParam); //강의대상

        codeParam.setSupCd("101528");
        List<Code> lectType = codeManagementService.listCode(codeParam);  //강의유형

        model.addAttribute("schoolGrd",schoolGrd);
        model.addAttribute("lectType",lectType);
    }


    @RequestMapping("lectureInfoInsert.do")
    public void onLoadlectureInfoInsert(LectInfo lectureInfo, Model model){

        model.addAttribute("lectureInfo", lectureInfo);
        model.addAttribute("lectSchdInfoListCnt", 0);
        model.addAttribute("bizGrpInfo", assignGroupMapper.listBizGrpInfo());

    }

    @RequestMapping("retrieveIectureInfo.do")
    public void retrieveIectureInfo(@Pageable @RequestParam("lectSer") Integer lectSer, HttpServletRequest request, Model model) throws Exception {
        String sPath = request.getServletPath();

        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setLectSer(lectSer);

        LectInfo lectureInfo = lectureManagementService.retrieveLectInfo(lectureSearch);

        LectInfo lectInfo = new LectInfo();
        lectInfo.setLectSer(lectSer);

        List<LectSchdInfo> lectSchdInfoList = lectureManagementService.listLectureScheduleInfomation(lectInfo);

        model.addAttribute("lectureInfo",lectureInfo);
        model.addAttribute("lectSchdInfoListCnt",lectSchdInfoList.size());

        //수업자료 조회
        List<ArclInfo<T>> listArclInfo = new ArrayList<>();
        List<ArclFileInfo>  listArclFileInfo = new ArrayList<>();
        ArclInfo<T> arclInfo = new ArclInfo();
        arclInfo.setCntntsTargtNo(lectSer);
        arclInfo.setLectSer(String.valueOf(lectSer));
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_FILE);

        listArclInfo = comunityService.lectureFiledResult(arclInfo);

        model.addAttribute("listArclInfo", listArclInfo);
    }


    @RequestMapping("listLectSchdInfo.do")
    @ResponseBody
    public List<LectTimsInfo> listLectSchdInfo(@Pageable LectureSearch lectureSearch) throws Exception {
        List<LectTimsInfo> lectTimsInfoList = new ArrayList<>();
        lectureSearch.setPageable(true);

        if(lectureSearch.getLectSer() != null && !lectureSearch.getLectSer().equals("")){
            lectTimsInfoList = lectureInfomationMapper.listLectTimsInfo(lectureSearch);
        }
        return lectTimsInfoList;
    }

    @RequestMapping(value={"retrieveIectureInfoInsert.do", "retrieveIectureInfoModify.do"})
    public String retrieveIectureInfoInsert(LectInfo lectInfo, HttpServletRequest request, Authentication authentication,final RedirectAttributes redirectAttrs) throws Exception {
        String sPath = request.getServletPath();
        int insetResult = 0;

        try {
            User user = (User) authentication.getPrincipal();
            lectInfo.setRegMbrNo(user.getMbrNo());
            lectInfo.setLectCoNo(user.getPosCoNo());

            lectInfo.setLectStatCd(CodeConstants.CD101541_101543_수강모집);

            if(lectInfo.getCopyLectSer() == null || lectInfo.getCopyLectSer().equals("")){
                insetResult = lectureManagementService.saveOpenLect(lectInfo);

                if(lectInfo.getLectReqSer() != null && !lectInfo.getLectReqSer().equals("")){  //수업요청테이블 업데이트
                    LectReqInfo lectReqInfo = new LectReqInfo();
                    lectReqInfo.setReqSer(lectInfo.getLectReqSer());
                    lectReqInfo.setReqStatCd(CodeConstants.CD101655_101658_개설완료);
                    lectureInfomationMapper.cancelReqLectInfo(lectReqInfo);
                }
            }else{  //복사수업저장
                insetResult = lectureManagementService.copySaveOpenLect(lectInfo);
            }

        }
        catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            redirectAttrs.addFlashAttribute("codeMsg",codeMessage.getHint());

            return "redirect:/lecture/lectureState/lectureInfoInsert.do";
        }

        redirectAttrs.addFlashAttribute("result",insetResult);

        return "redirect:/lecture/lectureState/lectureDetailView.do?lectSer="+lectInfo.getLectSer();
    }


    @RequestMapping("retrieveIectureSchdInfoInsert.do")
    @ResponseBody
    public JSONResponse retrieveIectureSchdInfoInsert(LectInfo lectInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        int insetResult = 0;

        try {
            User user = (User) authentication.getPrincipal();
            lectInfo.getLectTimsInfo().setRegMbrNo(user.getMbrNo());

            insetResult = lectureManagementService.IectureSchdInfoInsert(lectInfo.getLectTimsInfo());

            //기업멘토는 화상회의 개설이 같이 되어야 한다.
            if( insetResult == (Constants.LECTURE_CREATE_SUCCESS|Constants.TOMMS_CREATE_SUCCESS) && (insetResult&Constants.LECTURE_CREATE_SUCCESS) == Constants.LECTURE_CREATE_SUCCESS) {
/*

                */
/**
 * 메일 발송을 위한 정보 세팅 (수업신청 or 수업신청대기)
 *//*

                try {
*/
/*                    MessageReciever reciever = MessageReciever.of(true);
                    reciever.setMemberNo(mentorInfo.getMbrNo());
                    reciever.setMailAddress(mentorInfo.getEmailAddr());*//*


                    Message message = new Message();
                    message.setSendType(MessageSendType.EMS.getValue());
//                    message.addReciever(reciever);

                    message.setPayload(LecturePayLoad.of(message, lectInfo.getLectTimsInfo().getLectSer(), lectInfo.getLectTimsInfo().getLectTims(), false));
                    message.setContentType(MessageType.LECTURE_OPEN);

                    messageTransferManager.invokeTransfer(message);

                    if(lectInfo.getLectTestYn() == 'Y') {

                        final HttpClient client = new HttpClient();

                        PostMethod method = new PostMethod(EgovProperties.getLocalProperty("Manager.url"));

                        method.setRequestHeader("Accept-Encoding", "UTF-8");
                        method.setRequestHeader("Content-Type", "application/json; charset=UTF-8");

                        int statusCode = 0;
                        String resultString = "";

                        statusCode = client.executeMethod(method);

                        log.debug("called......{}", statusCode);

                        resultString = method.getResponseBodyAsString();
                        log.debug("result......[code:message] {}:{}", statusCode, resultString);
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }
*/

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

    @RequestMapping("cnclLectSchdInfo.do")
    @ResponseBody
    public JSONResponse cnclLectSchdInfo(LectureSearch lectureSearch, Authentication authentication) throws Exception {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();

            LectTimsInfo lectTimsInfo = lectureInfomationMapper.lectureTimsSchdInfo(lectureSearch);

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd"); //강의 시작날짜
            Date today = new Date();   //오늘날짜

            Date lectDate = formatter.parse(lectTimsInfo.getLectSchdInfo().get(0).getLectDay());
            formatter.format(today);

            Calendar startCal = Calendar.getInstance();
            Calendar endCal = Calendar.getInstance();

            startCal.setTime(today);
            endCal.setTime(lectDate);

            long diffMillis = endCal.getTimeInMillis() - startCal.getTimeInMillis();
            int diff = (int) (diffMillis/(24 *60 * 60 *1000));

            if(diff < Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY"))){
                throw CodeMessage.MSG_100010_수업시작_4일이전에만_취소가능합니다_.toException();
            }else{

                lectTimsInfo.setCnclMbrNo(user.getMbrNo());
                lectTimsInfo.setLectStatCd("101547");
                lectTimsInfo.setApplStatCd("101578");

                lectureManagementService.cnclLect(lectTimsInfo);
            }

            return JSONResponse.success(CodeMessage.MSG_100020_수업취소_되었습니다_.toMessage(user.getUsername()));
        }
        catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }


    @RequestMapping("mentorLectureList.do")
    @ResponseBody
    public List<LectureApplInfoDTO> mentorLectureList(@Pageable LectureSearch lectureSearch, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());
        lectureSearch.setCoNo(user.getPosCoNo());

        List<LectureApplInfoDTO> listLecture = lectureManagementService.mentorLectureSchdList(lectureSearch);

        return listLecture;
    }

    /**
     * <pre>
     *     멘토수업 수정
     * </pre>
     * @param model
     * @param
     * @throws Exception
     */
    @RequestMapping("lectureModify.do")
    public void lectureModify(LectureSearch lectureSearch, HttpServletRequest request, Model model) throws Exception {

        LectInfo lectureInfo = lectureManagementService.lectureInfo(lectureSearch);

        lectureInfo.setSchdSeq(lectureSearch.getSchdSeq());
        lectureInfo.setLectTims(lectureSearch.getLectTims());
        model.addAttribute("lectureInfo",lectureInfo);

    }
    /**
     * <pre>
     *     멘토수업 수정
     * </pre>
     * @param
     * @param
     * @throws Exception
     */
    @RequestMapping("ajax.edit.do")
    public String lectureUpdate(LectInfo lectInfo, HttpServletRequest request, Authentication authentication,final RedirectAttributes redirectAttrs) throws Exception {
        int insetResult = 0;

        try {
            User user = (User) authentication.getPrincipal();
            lectInfo.setRegMbrNo(lectInfo.getLectrMbrNo());
            lectInfo.setChgMbrNo(lectInfo.getLectrMbrNo());

            lectInfo.setLectStatCd(CodeConstants.CD101541_101543_수강모집);

            insetResult = lectureManagementService.updateLectInfo(lectInfo, "men");

        }
        catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            System.out.println(codeMessage);
        }

        redirectAttrs.addFlashAttribute("result",insetResult);
        String redirectUrl = "redirect:/lecture/lectureState/lectureDetailView.do?lectSer="+lectInfo.getLectSer();

        if(lectInfo.getLectTims() != null){
            redirectUrl += "&lectTims="+lectInfo.getLectTims()+"&schdSeq="+lectInfo.getSchdSeq();
        }

        return redirectUrl;
    }

}
