package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.LectReqInfo;
import kr.or.career.mentor.domain.StdoInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.StudioService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      LectureStudioController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-22 오전 11:40
 */
@Controller
@RequestMapping("lecture/lectureOpenReq")
public class LectureOpenReqController {

    @Autowired
    private LectureManagementService lectureManagementService;

    /**
     * <pre>
     *     수업관리 > 수업개설신청 목록
     * </pre>
     * @param lectReqInfo
     * @return
     */
    @RequestMapping("ajax.list.do")
    @ResponseBody
    public List<LectReqInfo> selectLectOpenReqList(@Pageable LectReqInfo lectReqInfo, Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        lectReqInfo.setReqMbrNo(user.getMbrNo());
        lectReqInfo.setReqTypeCd("101727");   //수업개설신청 조회
        List<LectReqInfo> listOpenLecture = lectureManagementService.selectLectReqInfoList(lectReqInfo);

        return listOpenLecture;
    }

    /**
     * <pre>
     *     수업개설신청 상세
     * </pre>
     * @param lectReqInfo
     * @return
     */
    @RequestMapping("lectureOpenReqView.do")
    public void selectLectOpenReqInfo(LectReqInfo lectReqInfo, Model model) {

        LectReqInfo lectOpenReqInfo = lectureManagementService.selectLectReqInfo(lectReqInfo);
        model.addAttribute("lectOpenReqInfo", lectOpenReqInfo);
    }

    /**
     * <pre>
     *     수업개설신청 수정 화면
     * </pre>
     * @param model
     * @return
     */
    @RequestMapping("lectureOpenReqEdit.do")
    public void studioEdit(LectReqInfo lectReqInfo, Model model) {

        LectReqInfo lectOpenReqInfo = lectureManagementService.selectLectReqInfo(lectReqInfo);
        model.addAttribute("lectOpenReqInfo", lectOpenReqInfo);

    }

    /**
     * <pre>
     *     멘토 수업개설신청 등록
     * </pre>
     * @param lectReqInfo
     * @return
     */
    @RequestMapping("/ajax.save.do")
    @ResponseBody
    public JSONResponse insertLectOpenReqInfo(LectReqInfo lectReqInfo, Authentication authentication){
        CodeMessage codeMessage = null;
        int chkCnt= 0;

        User user = (User) authentication.getPrincipal();
        lectReqInfo.setMbrNo(user.getMbrNo());
        lectReqInfo.setReqTypeCd("101727");   //수업 개설신청 타입
        lectReqInfo.setAuthStatCd("101026");  //신청상태로 등록

        try{

            chkCnt = lectureManagementService.insertLectOpenReqInfo(lectReqInfo);

            if(chkCnt > 0){
                return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage(user.getUsername()));
            }else{

                return JSONResponse.success(CodeMessage.MSG_900002_등록_실패_하였습니다_.toMessage(user.getUsername()));
            }

        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

    /**
     * <pre>
     *     멘토 수업개설신청 수정
     * </pre>
     * @param lectReqInfo
     * @return
     */
    @RequestMapping("/ajax.edit.do")
    @ResponseBody
    public JSONResponse updateLectOpenReqInfo(LectReqInfo lectReqInfo, Authentication authentication){
        CodeMessage codeMessage = null;
        int chkCnt= 0;
        User user = (User) authentication.getPrincipal();

        try{

            chkCnt = lectureManagementService.updateLectOpenReqInfo(lectReqInfo);

            if(chkCnt > 0){
                return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage(user.getUsername()));
            }else{

                return JSONResponse.success(CodeMessage.MSG_900008_수정_실패_하였습니다_.toMessage(user.getUsername()));
            }

        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

}
