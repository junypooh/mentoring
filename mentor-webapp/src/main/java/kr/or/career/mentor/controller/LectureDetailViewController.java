/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.LectInfo;
import kr.or.career.mentor.domain.LectTimsInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.view.JSONResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureDetailViewController
 *
 * 수업상세화면 controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-27 오후 3:00
 */
@Controller
@RequestMapping("lecture/lectureState")
public class LectureDetailViewController {

    @Autowired
    private LectureManagementService lectureManagementService;


    /**
     * <pre>
     *     멘토수업상세화면 조회
     * </pre>
     * @param model
     * @param lectureSearch
     * @throws Exception
     */
    @RequestMapping("lectureDetailView.do")
    public void onLoadlectureDetailView(Model model, LectureSearch lectureSearch) throws Exception{
        LectTimsInfo lectTimsInfo = null;
        //수업정보 조회
        LectInfo lectInfo = lectureManagementService.lectureInfo(lectureSearch);

        model.addAttribute("lectInfo", lectInfo);                 //수업정보
        model.addAttribute("assignDay", Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY")));
        //수업 차수 및 회차 정보 조회
        if(lectureSearch.getLectTims() != null && !lectureSearch.getLectTims().equals("")  ){
            lectTimsInfo = lectureManagementService.lectureTimsSchdInfo(lectureSearch);
            model.addAttribute("lectTimsInfo", lectTimsInfo);                 //차수정보
            model.addAttribute("lectSchdInfo", lectTimsInfo.getLectSchdInfo()); //회차정보
            model.addAttribute("schdSeq", lectureSearch.getSchdSeq()); //회차정보
        }
    }


    /**
     * <pre>
     *     수업 차수 노출/비노출 수정
     * </pre>
     * @param lectTimsInfo
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("setExpsLectureInfo.do")
    @ResponseBody
    public JSONResponse setExpsLectureInfo(LectTimsInfo lectTimsInfo, Authentication authentication) throws Exception {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            lectureManagementService.updateExpsLectureInfo(lectTimsInfo);
            return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage(user.getUsername()));
        }
        catch (Exception e) {
            e.printStackTrace();
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }



/*
    @RequestMapping("lectureDetailView.do")
    public void onLoadlectureDetailView(Model model, LectSchdInfo lectSchdInfo) throws Exception{
        Integer lectSer = lectSchdInfo.getLectSer();

        //수업정보 조회
        Map lectInfo = lectureManagementService.retireveLectSchdInfo(lectSchdInfo);

        //수업평점 조회
        ArclInfo arclInfo = new ArclInfo();
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_APPR); //게시판ID
        arclInfo.setCntntsTargtCd(CodeConstants.CD100979_101511_강의후기); //게시판 대상 코드
        arclInfo.setCntntsTargtNo(lectSer); //게시판 대상 번호 : 수업일련번호
        LectureInfomationDTO lectureRatingInfo = lectureManagementService.retireveLectureRating(arclInfo);

        model.addAttribute("lectInfo", lectInfo.get("resultLectInfo"));                 //수업정보
        model.addAttribute("mentorInfo", lectInfo.get("mentorInfo"));                   //멘토정보
        model.addAttribute("lectPicInfoList", lectInfo.get("lectPicInfoList"));         //수업이미지정보
        model.addAttribute("mentorRelMapp", lectInfo.get("mentorRelMapp"));             //소속멘토일 경우 업체명과 교육청 정보
        model.addAttribute("lectSchdInfo", lectInfo.get("resultLectSchdInfo"));         //수업일시정보 단건
        model.addAttribute("lectSchdInfoList", lectInfo.get("resultLectSchdInfoList")); //수업일시정보 리스트
        model.addAttribute("lectureApplCnt", lectInfo.get("lectureApplCnt"));           //수업신청상태별 건수
        model.addAttribute("isLectureDday", lectInfo.get("isLectureDday"));             //수업 D-7일 여부
        model.addAttribute("obsvCnt", lectInfo.get("obsvCnt"));                         //현재참관수
        model.addAttribute("lectureRatingInfo", lectureRatingInfo);                     //수업평점
    }*/

}

