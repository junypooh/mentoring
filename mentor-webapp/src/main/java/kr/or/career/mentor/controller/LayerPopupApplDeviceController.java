/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureInfomationDTO;
import kr.or.career.mentor.service.LectureManagementService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupApplDevice
 *
 * 신청 디바이스 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-07 오후 6:07
 */
@Controller
@RequestMapping("layer")
public class LayerPopupApplDeviceController {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    LectureManagementService lectureManagementService;

    /**
     * <pre>
     *     수업신청(수업신청대기) 팝업화면 onload
     * </pre>
     * @param model
     * @param lectSer
     * @param lectTims
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "layerPopupApplDevice.do", method = RequestMethod.GET)
    public void onLoadLayerPopupLectureApply(Model model, @RequestParam int lectSer, @RequestParam int lectTims, @RequestParam int schdSeq) throws Exception{

        LectSchdInfo lectSchdInfo = new LectSchdInfo();

        lectSchdInfo.setLectSer(lectSer);
        lectSchdInfo.setLectTims(lectTims);
        lectSchdInfo.setSchdSeq(schdSeq);

        //수업정보 조회
        LectSchdInfo resultLectSchdInfo = lectureManagementService.listLectApplDvc(lectSchdInfo);
        model.addAttribute("lectSchdInfo", resultLectSchdInfo);

        //해당수업 기기(교실정보)조회
        List<LectureInfomationDTO> lectApplInfoList = lectureManagementService.listLectApplClas(lectSchdInfo);
        model.addAttribute("lectApplInfoList", lectApplInfoList);
    }


    /**
     * <pre>
     *     수업참관(수업신청대기) 팝업화면 onload
     * </pre>
     * @param model
     * @param lectSer
     * @param lectTims
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "layerPopupObsvDevice.do", method = RequestMethod.GET)
    public void onLoadLayerPopupLectureObsv(Model model, @RequestParam int lectSer, @RequestParam int lectTims, @RequestParam int schdSeq) throws Exception{

        LectSchdInfo lectSchdInfo = new LectSchdInfo();

        lectSchdInfo.setLectSer(lectSer);
        lectSchdInfo.setLectTims(lectTims);
        lectSchdInfo.setSchdSeq(schdSeq);

        //수업정보 조회
        LectSchdInfo resultLectSchdInfo = lectureManagementService.listLectApplDvc(lectSchdInfo);
        model.addAttribute("lectSchdInfo", resultLectSchdInfo);

        //해당수업 기기(교실정보)조회
        List<LectureInfomationDTO> lectApplInfoList = lectureManagementService.listLectObsvClas(lectSchdInfo);
        model.addAttribute("lectApplInfoList", lectApplInfoList);
    }
}

