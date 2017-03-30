/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LayerPopupLectureScheduleAddController
 *
 * 수업일시추가 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-21 오후 7:23
 */
@Controller
@RequestMapping("layer")
public class LayerPopupLectureScheduleAddController {

    @Autowired
    LectureManagementService lectureManagementService;
}

