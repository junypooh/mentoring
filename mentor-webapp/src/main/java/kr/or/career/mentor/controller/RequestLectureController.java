/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.LectReqInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    RequestLectureController
 *
 * 수업요청화면의 controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-27 오후 7:18
 */
@Controller
@RequestMapping("lecture/requestLecture")
public class RequestLectureController {

    @Autowired
    private LectureManagementService lectureManagementService;

    @RequestMapping("ajax.listRequestLecture.do")
    @ResponseBody
    public List<LectReqInfo> listRequestLecture(LectureSearch lectureSearch, Authentication authentication) throws Exception{

        User sessionUser = (User) authentication.getPrincipal();
        lectureSearch.setPageable(true);
        lectureSearch.setReqStatCd(CodeConstants.CD101655_101656_수업요청);
        lectureSearch.setMbrNo(sessionUser.getMbrNo());
        lectureSearch.setMbrCualfCd(sessionUser.getMbrCualfCd());

        List<LectReqInfo> lectReqInfoList = lectureManagementService.listRequestLecture(lectureSearch);

        return lectReqInfoList;
    }
}

