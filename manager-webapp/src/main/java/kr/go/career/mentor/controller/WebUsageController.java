package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.Code;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.ComunityService;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      WebUsageController
 *
 * WEB > 이용안내관리 controller
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-01 오전 11:03
 */
@Controller
@RequestMapping("/web/usage")
public class WebUsageController {


    @Autowired
    private ComunityService comunityService;

    @Autowired
    private CodeManagementService codeManagementService;

    /**
     * <pre>
     *     공지사항 상세 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping("/notice/view.do")
    @Historic(workId = "1000000220")
    public void noticeView(ArclInfo<T> arclInfo, Model model) {

        Code code = new Code();
        code.setSupCd(CodeConstants.CD101512_101633_배너구역코드);
        model.addAttribute("code101633",codeManagementService.listCode(code));

        if(arclInfo.getArclSer() != null) {
            model.addAttribute("arclInfo", comunityService.getSimpleArclInfo(arclInfo));
            model.addAttribute("fileList", comunityService.getFileInfoList(arclInfo));
        }
    }

    /**
     * <pre>
     *     공지사항 등록 및 수정
     * </pre>
     * @param arclInfo
     * @return
     */

    @RequestMapping("/registArcl.do")
    public String registArcl(ArclInfo<T> arclInfo,  @RequestParam(value="redirectUrl", required = false) String redirectUrl, Authentication authentication) throws CnetException {
        User user = (User) authentication.getPrincipal();
        arclInfo.setRegMbrNo(user.getMbrNo());
        arclInfo.setChgMbrNo(user.getMbrNo());

        if (arclInfo.getArclSer() == null || arclInfo.getArclSer() == 0) {
            comunityService.registArcl(arclInfo, arclInfo.getFileSers());
        } else {
            comunityService.updateArcl(arclInfo, arclInfo.getFileSers());
        }
        return "redirect:"+redirectUrl;
    }

    /**
     * <pre>
     *     공지사항 리스트 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping("/notice/ajax.noticeList.do")
    @ResponseBody
    @Historic(workId = "1000000219")
    public Map<String, Object> getNoticeList(@Pageable ArclInfo<T> arclInfo) {
        return comunityService.getNoticeList(arclInfo);
    }

    /**
     * <pre>
     *     자주찾는질문 상세 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping("/faq/view.do")
    @Historic(workId = "1000000222")
    public void faqView(ArclInfo<T> arclInfo, Model model) {

        Code code = new Code();
        code.setSupCd(CodeConstants.CD101512_101633_배너구역코드);
        model.addAttribute("code101633",codeManagementService.listCode(code));
        model.addAttribute("prefInfo", comunityService.getBoardPrefInfo(Constants.BOARD_ID_FAQ));

        if(arclInfo.getArclSer() != null) {
            model.addAttribute("arclInfo", comunityService.getSimpleArclInfo(arclInfo));
            model.addAttribute("fileList", comunityService.getFileInfoList(arclInfo));
        }
    }
}
