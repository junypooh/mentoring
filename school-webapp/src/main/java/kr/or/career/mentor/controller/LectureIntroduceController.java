/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.LectureInfomationMapper;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureSearch;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureIntroduceController
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-10-16 오후 1:37
 */
@Controller
@RequestMapping("/mentor/lectureIntroduce")
@Slf4j
public class LectureIntroduceController {

    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;

    /**
     * 수업 소개 목록
     *
     * @param lectureSearch
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.listLectureInfo.do")
    public List<LectSchdInfo> listMentorIntroduceAjax(@Pageable(size = 9) LectureSearch lectureSearch) {
        log.debug("[request] search: {}", lectureSearch);
        lectureSearch.setSearchType("all");

        List<String> exceptLectStatCdList = new ArrayList<String>();
        exceptLectStatCdList.add(CodeConstants.CD101541_101542_수업요청); //수업요청상태인 것들은 목록에서 제외(개인멘토가 만들어서 관리자의 승인이 아직 안된 수업)
        lectureSearch.setExceptLectStatCdList(exceptLectStatCdList);

        List<LectSchdInfo> resultLecutreLuist = lectureInfomationMapper.listLect(lectureSearch);
        return resultLecutreLuist;
    }
}
