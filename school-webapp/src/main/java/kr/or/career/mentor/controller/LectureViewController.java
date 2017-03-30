/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.LectureDataService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureViewController
 *
 * 수업상세 화면의 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-30 오후 3:10
 */
@Controller
@RequestMapping("lecture/lectureTotal")
public class LectureViewController {

    @Autowired
    LectureManagementService lectureManagementService;

    @Autowired
    private LectureDataService lectureDataService;

    /**
     * <pre>
     *     수업상세화면 조회
     * </pre>
     * @param model
     * @param lectSer
     * @param lectTims
     * @param schdSeq
     * @throws Exception
     */
    @RequestMapping(value = "lectureView.do", method = RequestMethod.GET)
    public void onLoadlectureView(Model model, @RequestParam int lectSer, @RequestParam int lectTims, @RequestParam int schdSeq,  Authentication authentication) throws Exception{

        LectureSearch lectureSearch = new LectureSearch();
        User user = null;
        String rpsStdtYn = "N";


        if (authentication != null && authentication.getPrincipal() != null) {
            user = (User) authentication.getPrincipal();
            lectureSearch.setMbrNo(user.getMbrNo());

            if(lectureManagementService.getRpsClasStdt(lectureSearch) > 0){
                rpsStdtYn = "Y";
            }
        }


        lectureSearch.setLectSer(lectSer);
        lectureSearch.setLectTims(lectTims);
        lectureSearch.setSchdSeq(schdSeq);


        //수업정보 조회
        LectInfo lectureInfo = lectureManagementService.lectureInfo(lectureSearch);

        //수업 차수 및 회차 정보 조회
        LectTimsInfo lectTimsInfo = lectureManagementService.lectureTimsSchdInfo(lectureSearch);

        //수업평점 조회
        ArclInfo arclInfo = new ArclInfo();
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_APPR); //게시판ID
        arclInfo.setCntntsTargtCd(CodeConstants.CD100979_101511_강의후기); //게시판 대상 코드
        arclInfo.setCntntsTargtNo(lectureSearch.getLectSer()); //게시판 대상 번호 : 수업일련번호
        LectureInfomationDTO lectureRatingInfo = lectureManagementService.retireveLectureRating(arclInfo);

        model.addAttribute("lectInfo", lectureInfo);    //수업정보
        model.addAttribute("lectureSearch", lectureSearch);    //수업정보

        model.addAttribute("lectTimsInfo", lectTimsInfo);    //수업 차수&회차 정보
        model.addAttribute("lectureRatingInfo", lectureRatingInfo);                     //수업평점*/

        model.addAttribute("rpsStdtYn", rpsStdtYn);                     //대표학생여부*/

        /*
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
        */

    }

    /**
     * <pre>
     *     수업 자료 리스트
     * </pre>
     * @param model
     * @param lectDataInfo
     * @throws Exception
     */
    @RequestMapping("ajax.lectDataList.do")
    @ResponseBody
    public List<LectDataInfo> lectDataList(@Pageable LectDataInfo lectDataInfo, Model model) throws Exception{

        return lectureDataService.selectLectDataList(lectDataInfo);

    }

}

