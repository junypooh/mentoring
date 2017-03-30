/* ntels */
package kr.or.career.mentor.controller;

import java.util.List;

import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureInfomationDTO;
import kr.or.career.mentor.service.LectureManagementService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupApplDvcListController
 *
 * 수업신청기기 팝업화면 controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-23 오후 5:48
 */
@Controller
@RequestMapping("layer")
public class LayerPopupApplDvcListController {

    @Autowired
    private LectureManagementService lectureManagementService;

    @RequestMapping("layerPopupApplDvcList.do")
    public void layerPopupApplDvcList(Model model, LectSchdInfo lectSchdInfo) throws Exception{
        List<LectureInfomationDTO> applDvcList = lectureManagementService.listLectApplClas(lectSchdInfo);
        model.addAttribute("applDvcList", applDvcList);
        model.addAttribute("applCnt",lectSchdInfo.getApplCnt());
        model.addAttribute("maxApplCnt",lectSchdInfo.getMaxApplCnt());
        model.addAttribute("applClassCd", lectSchdInfo.getApplClassCd());
    }
}

