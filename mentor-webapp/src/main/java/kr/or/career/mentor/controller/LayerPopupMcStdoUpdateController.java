/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.dao.LectureInfomationMapper;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupBelongMentorController
 *
 * MC및 스튜디오 수정 Controller
 *
 * </pre>
 *
 * @see
 */
@Controller
@RequestMapping("layer")
public class LayerPopupMcStdoUpdateController {


    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;


    /**
     * <pre>
     *     Mc및 스듀디오 수정 onLoad
     * </pre>
     * @param model
     * @param lectSer
     * @param lectTims
     * @param schdSeq
     * @throws Exception
     */
    @RequestMapping(value = "layerMcStdoUpdate.do")
    public void onLoadlectureDetailView(Model model, @RequestParam int lectSer, @RequestParam int lectTims, @RequestParam int schdSeq) throws Exception{
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(lectSer);
        lectSchdInfo.setLectTims(lectTims);
        lectSchdInfo.setSchdSeq(schdSeq);

        //수업정보 조회
        LectSchdInfo resultLectInfo = lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);

        model.addAttribute("resultLectInfo", resultLectInfo);
    }

    @RequestMapping("updateMcStdo.do")
    @ResponseBody
    public JSONResponse updateMcStdo(LectSchdInfo lectSchdInfo, Authentication authentication) throws Exception {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        int insetResult = 0;

        try {
            User user = (User) authentication.getPrincipal();
            lectSchdInfo.setChgMbrNo(user.getMbrNo());
            insetResult = lectureInfomationMapper.updateLectureScheduleInfomation(lectSchdInfo);

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
}

