package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.McInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.McService;
import kr.or.career.mentor.util.SessionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      LectureMcController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-25 오전 10:38
 */
@Controller
@RequestMapping("lecture/mc")
public class LectureMcController {

    @Autowired
    private McService mcService;

    @RequestMapping("ajax.list.do")
    @ResponseBody
    public List<McInfo> ajaxList(@Pageable LectureSearch lectureSearch) {

        User user = SessionUtils.getUser();
        lectureSearch.setPosCoNo(user.getPosCoNo());
        return mcService.listMcPaging(lectureSearch);
    }

    @RequestMapping({"view.do", "edit.do"})
    public void viewEdit(McInfo mcInfo, Model model) {

        User user = SessionUtils.getUser();
        mcInfo.setPosCoNo(user.getPosCoNo());

        if(StringUtils.isEmpty(mcInfo.getMcNo())){
            mcInfo.setUseYn("Y");
            mcInfo.setGenCd("100323");
            model.addAttribute("mcInfo", mcInfo);
        }else{
            model.addAttribute("mcInfo", mcService.retrieveMcInfo(mcInfo));
        }
    }

    @RequestMapping(value={"saveMcInfo.do"})
    public String saveMcInfo(@ModelAttribute McInfo mcInfo, BindingResult result, Model model, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        mcInfo.setRegMbrNo(user.getMbrNo());

        if(StringUtils.isEmpty(mcInfo.getMcNm())){
            result.rejectValue("stdoNm", "", "MC 이름을 입력해주세요");
        }

        // Validation 오류 발생시 게시글 정보 등록화면으로 이동
        if (result.hasErrors()) {
            // 에러 출력
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError e : list) {
                //log.error(" ObjectError : " + e);
            }

            return "lecture/status/mc/edit";
        }

        mcService.saveMcInfo(mcInfo);
        return "redirect:list.do";
    }
}
