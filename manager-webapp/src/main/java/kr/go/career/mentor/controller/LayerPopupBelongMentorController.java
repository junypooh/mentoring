/* ntels */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.MentorDTO;
import kr.or.career.mentor.domain.MentorSearch;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.MentorManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;


/**
 * <pre>
 * kr.go.career.mentor.controller
 *    LayerPopupBelongMentorController
 *
 * 소속멘토찾기 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-21 오후 7:22
 */
@Controller
@RequestMapping("layer")
public class LayerPopupBelongMentorController {

    @Autowired
    MentorManagementService mentorManagementService;

    @RequestMapping("ajax.listBelongMentor.do")
    @ResponseBody
    public List<MentorDTO> listBelongMentor(MentorSearch search, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        search.setRegMbrNo(user.getMbrNo());
        search.setAuthStatCd(CodeConstants.CD101025_101027_수락_승인_); //승인상태코드
        search.setMbrStatCd(CodeConstants.CD100861_100862_정상이용); //회원상태코드
        search.setPageable(false);

        List<MentorDTO> mentorDTOList = mentorManagementService.listBelongMentor(search);

        return mentorDTOList;
    }
}

