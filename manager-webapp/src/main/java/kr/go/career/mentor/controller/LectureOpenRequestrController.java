/* ntels */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
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
@RequestMapping("lecture/mentor/openreq")
public class LectureOpenRequestrController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @RequestMapping("list.do")
    public void lectureOpenReqList(Model model){

        Code codeParam = new Code();
        codeParam.setSupCd("101025"); //승인상태 코드 리스트
        List<Code> authType = codeManagementService.listCode(codeParam);

        model.addAttribute("authType",authType);

    }


    /**
     *
     * <pre>
     * 수업 개설 신청 리스트
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000105")
    public List<LectReqInfo> selectLectOpenReqList(@Pageable LectReqInfo lectReqInfo, Authentication authentication) throws Exception {

        lectReqInfo.setReqTypeCd("101727");   //수업개설신청 조회
        List<LectReqInfo> lectReqList = lectureManagementService.selectLectReqInfoList(lectReqInfo);

        return lectReqList;
    }


    /**
     * <pre>
     *     수업개설신청 > 수업개설신청 상세
     * </pre>
     * @param lectReqInfo
     * @return
     */
    @RequestMapping("view.do")
    @Historic(workId = "1000000106")
    public void selectLectOpenReqInfo(LectReqInfo lectReqInfo, Model model) {

        LectReqInfo lectOpenReqInfo = lectureManagementService.selectLectReqInfo(lectReqInfo);
        model.addAttribute("lectOpenReqInfo", lectOpenReqInfo);
    }

    /**
     *
     * <pre>
     *  관리자 수업 개설신청 승인/반려/오픈/미오픈 처리
     * </pre>
     *
     * @return
     */
    @RequestMapping("ajax.edit.do")
    @ResponseBody
    @Historic(workId = "1000000107")
    public JSONResponse updateOpenReqLecture(LectReqInfo lectReqInfo, Authentication authentication) {
        CodeMessage codeMessage = null;

        User user = (User) authentication.getPrincipal();

        lectReqInfo.setProcMbrNo(user.getMbrNo());

        try{
            lectureManagementService.updateLectOpenReqInfo(lectReqInfo);
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


}
