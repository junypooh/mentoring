/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.Code;
import kr.or.career.mentor.domain.LectReqInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupRequestLectureController
 *
 * 요청수업선택 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-21 오후 7:23
 */
@Controller
@RequestMapping("layer")
public class LayerPopupRequestLectureController {

    @Autowired
    protected CodeManagementService codeManagementService;

    @Autowired
    LectureManagementService lectureManagementService;

    /**
     * <pre>
     *     요청수업선택 팝업화면 onload
     * </pre>
     * @param model
     * @throws Exception
     */
    @RequestMapping("layerPopupRequestLecture.do")
    public void layerPopupRequestLecture(Model model) throws Exception{
        Code code = new Code();

        code.setSupCd("101645");
        model.addAttribute("code101645", codeManagementService.listCode(code)); //요청수업 선택 팝업화면 검색조건1

        code.setSupCd("101649");
        model.addAttribute("code101649", codeManagementService.listCode(code)); //요청수업 선택 팝업화면 검색조건2
    }

    /**
     * <pre>
     *     요청수업선택 팝업화면 조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listRequestLecture.do")
    @ResponseBody
    public List<LectReqInfo> listRequestLecture(LectureSearch lectureSearch) throws Exception{

        User user = SessionUtils.getUser();
        lectureSearch.setCoNo(user.getPosCoNo());
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());

        List<LectReqInfo> lectReqInfoList = lectureManagementService.listLectureRequest(lectureSearch);

        return lectReqInfoList;
    }
}

