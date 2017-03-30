/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.dao.LectureInfomationMapper;
import kr.or.career.mentor.domain.LectReqInfo;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureApplInfoDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupLectCancelController
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-10-30 오후 1:06
 */
@Controller
@RequestMapping("layer")
public class LayerPopupLectCancelController {


    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;


    /**
     * <pre>
     *     요청수업 정보조회
     * </pre>
     * @param reqSer
     * @throws Exception
     */
    @RequestMapping(value = "layerReqLectCancel.do")
    public void layerReqLectCancel(Model model, @RequestParam int reqSer) throws Exception{
        LectReqInfo lectReqInfo = new LectReqInfo();
        lectReqInfo.setReqSer(reqSer);

        //요청수업정보 조회
        LectReqInfo resultLectReqInfo = lectureInfomationMapper.retrieveLectReqInfo(lectReqInfo);

        model.addAttribute("resultLectReqInfo", resultLectReqInfo);
    }

    /**
     * <pre>
     *     신청수업 정보조회
     * </pre>
     * @param lectureApplInfoDTO
     * @throws Exception
     */
    @RequestMapping(value = "layerLectureCancel.do")
    public void layerLectureCancel(Model model, LectureApplInfoDTO lectureApplInfoDTO) throws Exception{
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(lectureApplInfoDTO.getLectSer());
        lectSchdInfo.setLectTims(lectureApplInfoDTO.getLectTims());
        lectSchdInfo.setSchdSeq(lectureApplInfoDTO.getSchdSeq());

        //신청수업정보 조회
        LectSchdInfo resultLectReqInfo = lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);

        model.addAttribute("resultLectReqInfo", resultLectReqInfo);
        model.addAttribute("lectureApplInfoDTO", lectureApplInfoDTO);
    }

}
