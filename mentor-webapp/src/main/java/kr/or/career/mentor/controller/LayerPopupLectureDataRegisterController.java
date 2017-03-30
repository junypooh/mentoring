/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupLectureDataRegisterController
 *
 * 수업자료등록 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-21 오후 7:22
 */
@Controller
@RequestMapping("layer")
@Slf4j
public class LayerPopupLectureDataRegisterController {

    @Autowired
    LectureManagementService lectureManagementService;

    @Autowired
    ComunityService comunityService;

    /**
     * <pre>
     *    수업자료 등록 팝업
     * </pre>
     * @param model
     * @param Model
     * @throws Exception
     */
    @RequestMapping("layerPopupLectureDataRegister.do")
    public void onLoadlectureDetailView(Model model) throws Exception{
        ArclInfo arclInfo = new ArclInfo();

        model.addAttribute("arclInfo", arclInfo);
    }

    /**
     * <pre>
     *    수업자료 입력
     * </pre>
     * @param arclInfo
     * @throws Exception
     */
    @RequestMapping("registLecutureData.do")
    @ResponseBody
    public JSONResponse registLecutreData(ArclInfo<T> arclInfo, Authentication authentication) throws Exception{
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
//        arclInfo.setRegMbrNo(user.getMbrNo());
        arclInfo.setChgMbrNo(arclInfo.getRegMbrNo());
        int resultCnt = 0;

            try {
                resultCnt = comunityService.registLectureDataArcl(arclInfo);

                if(resultCnt >0){
                    return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage());
                }else{
                    return JSONResponse.success(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toMessage());
                }

            } catch(Exception e) {
                CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
                if (e instanceof CnetException) {
                    codeMessage = ((CnetException) e).getCode();
                }
                return JSONResponse.failure(codeMessage, e);
            }
    }
}

