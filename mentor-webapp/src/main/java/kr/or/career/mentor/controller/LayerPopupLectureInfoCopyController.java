/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.Code;
import kr.or.career.mentor.domain.LectInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
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
 *    LayerPopupLectureInfoCopyController
 *
 * 수업정보복사 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-21 오후 7:22
 */
@Controller
@RequestMapping("layer")
public class LayerPopupLectureInfoCopyController {

    @Autowired
    protected CodeManagementService codeManagementService;

    @Autowired
    LectureManagementService lectureManagementService;

    /**
     * <pre>
     *     수업정보복사 팝업화면 onload
     * </pre>
     * @param model
     * @throws Exception
     */
    @RequestMapping("layerPopupLectureInfoCopy.do")
    public void layerPopupLectureInfoCopy(Model model) throws Exception{
        Code code = new Code();
        code.setSupCd("101649");
        model.addAttribute("code101649", codeManagementService.listCode(code)); //요청수업 선택 팝업화면 검색조건2
    }

    /**
     * <pre>
     *     수업정보 조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listLectInfo.do")
    @ResponseBody
    public List<LectInfo> listLectInfo(LectureSearch lectureSearch, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        lectureSearch.setPageable(false);
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());
        List<LectInfo> lectInfoList = lectureManagementService.lectureInfoList(lectureSearch);

        return lectInfoList;
    }

}

