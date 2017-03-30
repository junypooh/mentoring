package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.domain.UserSearch;
import kr.or.career.mentor.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.List;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      MemberWithdrawalController
 *
 * 탈퇴회원 관리 Controller
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-13 오후 3:52
 */

@Controller
@RequestMapping("/member/withdrawal")
@Slf4j
public class MemberWithdrawalController {

    @Autowired
    private UserService userService;

    @RequestMapping("/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000016")
    public List<User> listMemberPublicAjax(@Pageable UserSearch search) {

        if (CollectionUtils.isNotEmpty(search.getMbrCualfCds())) {
            if(search.getMbrCualfCds().contains(CodeConstants.CD100204_100214_교사)) {
                search.setMbrCualfCds(TEACHER_CUALF_CDS);
            }
            if(search.getMbrCualfCds().contains(CodeConstants.CD100204_101502_소속멘토)) {
                search.setMbrCualfCds(MENTOR_CUALF_CDS);
            }
        }
        search.setMbrStatCds(Arrays.asList(CodeConstants.CD100861_100864_탈퇴));

        log.debug("[REQ] search: {}", search);

        return userService.listUserBy(search);
    }

    //@formatter:off
    private static final List<String> MENTOR_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_101502_소속멘토,
            CodeConstants.CD100204_101503_개인멘토);
    private static final List<String> TEACHER_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_100214_교사,
            CodeConstants.CD100204_100215_교사_진로상담_);
    //@formatter:on
}
