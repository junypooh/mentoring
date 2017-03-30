/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureInfomationDTO;
import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    TabRelationLecture
 *
 * 수업상세 화면의 관련수업 탭페이지 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-05 오후 4:15
 */
@Controller
@RequestMapping("lecture/lectureTotal")
public class TabRelationLectureController {

    @Autowired
    LectureManagementService lectureManagementService;

    @RequestMapping("ajax.listTabRelationLecture.do")
    @ResponseBody
    public List<LectureInfomationDTO> listTabRelationLecture(@Pageable LectSchdInfo lectSchdInfo) throws Exception{
        List<LectureInfomationDTO> lectSchdInfoList = lectureManagementService.listRelationLecture(lectSchdInfo);
        return lectSchdInfoList;
    }
}

