package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.LectDataInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.LectureDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      MyCommunityController
 *
 * 마이페이지 > 나의 커뮤니티
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-08 오후 3:32
 */
@Controller
@RequestMapping("myPage/myCommunity")
public class MyCommunityController {

    @Autowired
    private LectureDataService lectureDataService;

    /**
     * <pre>
     *     수업자료 리스트 조회
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.lectDataList.do")
    @ResponseBody
    public List<LectDataInfo> lectDataList(@Pageable LectDataInfo lectDataInfo, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        lectDataInfo.setMbrNo(user.getMbrNo());
        return lectureDataService.selectCommunityLectData(lectDataInfo);
    }


}
