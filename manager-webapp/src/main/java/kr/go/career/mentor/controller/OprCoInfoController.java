package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.CoInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      OprCoInfoController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-28 오후 3:21
 */
@Controller
@RequestMapping("/opr/corp")
@Slf4j
public class OprCoInfoController {

    @Autowired
    private CodeManagementService codeManagementService;

    /**
     * <pre>
     *     운영관리 기관관리 리스트 조회
     * </pre>
     * @param coInfo
     * @return
     */
    @RequestMapping("/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000303")
    public List<CoInfo> listCoInfo(@Pageable CoInfo coInfo) throws Exception {
        return codeManagementService.listCoInfo(coInfo);
    }

    /**
     * <pre>
     *     운영관리 기관관리 리스트 조회 (페이징 없음)
     * </pre>
     * @param coInfo
     * @return
     */
    @RequestMapping("/ajax.list.nopaging.do")
    @ResponseBody
    public List<CoInfo> listCoInfoNoPaging(CoInfo coInfo) throws Exception {
        return codeManagementService.listCoInfo(coInfo);
    }

    @RequestMapping("/view.do")
    @Historic(workId = "1000000304")
    public void viewCoInfo(CoInfo coInfo, Model model) {

        log.debug("[REQ] viewCoInfo: {}", coInfo);

        if(StringUtils.isNotEmpty(coInfo.getCoNo())) {
            List<CoInfo> coInfos = codeManagementService.listCoInfo(coInfo);
            model.addAttribute("coInfo", coInfos.get(0));
        }
    }
    @RequestMapping("/editSubmit.do")
    @Historic(workId = "1000000305")
    public String updateCoInfo(CoInfo coInfo, RedirectAttributes redirectAttributes) {

        User sessionUser = SessionUtils.getUser();
        coInfo.setChgMbrNo(sessionUser.getMbrNo());
        coInfo.setRegMbrNo(sessionUser.getMbrNo());

        if(StringUtils.isNotEmpty(coInfo.getCoNo())) {
            codeManagementService.updateCoInfo(coInfo);
        } else {
            codeManagementService.insertCoInfo(coInfo);
        }

        return "redirect:/opr/corp/list.do";
    }
}
