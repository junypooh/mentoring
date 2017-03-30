/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ClassroomService;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupLectureReqController
 *
 * 수업요청 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-21 오후 1:07
 */
@Controller
@RequestMapping("layer")
public class LayerPopupLectureReqController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    ClassroomService classroomService;

    @RequestMapping("layerPopupLectureReq.do")
    public void popupLectureReq(Model model, Authentication authentication) throws Exception {
        Code codeParam = new Code();
        SchInfo schInfo = new SchInfo();
        User user = (User) authentication.getPrincipal();

        schInfo.setMbrNo(user.getMbrNo());

        codeParam.setUseYn("Y");
        codeParam.setSupCd(CodeConstants.CD100211_100494_학교);

        List<Code> schoolGrd = codeManagementService.listCode(codeParam); //강의대상

        codeParam.setSupCd(CodeConstants.CD101512_101663_솔루션종류코드);
        List<Code> solutionKinds = codeManagementService.listCode(codeParam); //솔루션종류코드

        List<SchInfo> schInfoList = classroomService.listMySchool(schInfo); //교사가속한 학교목록

        model.addAttribute("schoolGrd",schoolGrd);
        model.addAttribute("user", authentication.getPrincipal());
        model.addAttribute("schInfoList", schInfoList);
        model.addAttribute("solutionKinds", solutionKinds);
    }

    @RequestMapping("lectureReqInsert.do")
    @ResponseBody
    public JSONResponse lectureReqInsert(LectReqInfo lectReqInfo, Authentication authentication) throws Exception {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        List<LectReqTimeInfo> lectReqTimeInfoList = new ArrayList<LectReqTimeInfo>();

        try {
            User user = (User) authentication.getPrincipal();

            for(int i=0; i<lectReqInfo.getLectReqTimeInfo().size(); i++){
                LectReqTimeInfo lectReqTimeInfo = new LectReqTimeInfo();
                lectReqTimeInfo.setLectPrefTime(lectReqInfo.getLectReqTimeInfo().get(i));
                lectReqTimeInfo.setLectPrefDay(lectReqInfo.getLectReqDayInfo().get(i));

                lectReqTimeInfoList.add(lectReqTimeInfo);
            }
            lectReqInfo.setLectReqTimeInfoDomain(lectReqTimeInfoList);
            lectReqInfo.setReqMbrNo(user.getMbrNo()); //요청_회원_번호 : 수업을 요청한 교사의 회원번호
            lectReqInfo.setReqStatCd(CodeConstants.CD101655_101656_수업요청);

            boolean cnclLectSchdInfo = lectureManagementService.insertLectureRequest(lectReqInfo);

            return JSONResponse.success(CodeMessage.MSG_100008_X0_님_수업요청_등록되었습니다_.toMessage(user.getUsername()));
        }
        catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

}

