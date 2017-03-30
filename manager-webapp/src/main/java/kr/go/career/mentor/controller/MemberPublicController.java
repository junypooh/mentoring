package kr.go.career.mentor.controller;

import com.google.common.collect.Maps;
import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.AssignGroupService;
import kr.or.career.mentor.service.ClassroomService;
import kr.or.career.mentor.service.SchInfoService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      MemberPublicController
 *
 * 일반회원 관리 Controller
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-13 오후 3:51
 */

@Controller
@RequestMapping("/member/public")
@Slf4j
public class MemberPublicController {

    @Autowired
    private UserService userService;

    @Autowired
    private ClassroomService classroomService;

    @Autowired
    private AssignGroupService assignGroupService;

    @Autowired
    private SchInfoService schInfoService;

    @RequestMapping("/general/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000006")
    public List<User> listMemberPublicAjax(@Pageable UserSearch search) {

        if (CollectionUtils.isEmpty(search.getMbrCualfCds())) {
            search.setMbrCualfCds(PUBLIC_CUALF_CDS);
        }
        if (CollectionUtils.isEmpty(search.getMbrStatCds())) {
            search.setMbrStatCds(MBR_STAT_CDS);
        }

        log.debug("[REQ] search: {}", search);

        return userService.listUserBy(search);
    }

    @RequestMapping({"/general/view.do", "/teacher/view.do"})
    @Historic(workId = "1000000007")
    public void viewMemberPublic(User user, Model model) {

        log.debug("[REQ] search: {}", user);

        Map param = Maps.newHashMap();
        param.put("mbrNo", user.getMbrNo());
        user = userService.retrieveUser(param);

        model.addAttribute("reAgrees", userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100942_재가입동의_재동의_));
        model.addAttribute("user",user);
    }

    @RequestMapping("/general/ajax.tabClassList.do")
    @ResponseBody
    public List<ClasRoomRegReqHist> tabClassListForPublic(@Pageable ClasRoomRegReqHist clasRoomRegReqHist) {

        return classroomService.listStudentClassroom(clasRoomRegReqHist);
    }

    @RequestMapping("/general/ajax.tabLectureList.do")
    @ResponseBody
    public List<MemberLectureInfo> tabLectureList(@Pageable LectureSearch lectureSearch) {

        return userService.listLectureByMember(lectureSearch);
    }

    @RequestMapping({"/general/edit.do", "/teacher/edit.do"})
    public void editMemberPublic(@RequestParam("mbrNo") String mbrNo, Model model) {

        User user = userService.getUserByNo(mbrNo);
        user.setAgrees(userService.listMbrAgrInfo(user.getMbrNo(), null));

        model.addAttribute("user", user);
    }

    @RequestMapping({"/general/editSubmit.do", "/teacher/editSubmit.do"})
    @Historic(workId = "1000000009")
    public String updateSchoolMember(User user, RedirectAttributes redirectAttributes, HttpServletRequest request) {

        User sessionUser = SessionUtils.getUser();
        user.setChgMbrNo(sessionUser.getMbrNo());

        userService.updateSchoolMember(user);

        redirectAttributes.addAttribute("mbrNo", user.getMbrNo());

        String requestUrl = request.getRequestURL().toString();

        if(requestUrl.indexOf("/general/editSubmit.do") > -1) {
            return "redirect:/member/public/general/view.do";
        } else {
            return "redirect:/member/public/teacher/view.do";
        }
    }

    /**
     * <pre>
     * 대표 학교 설정
     * </pre>
     *
     * @param clasRoomInfo
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("/general/ajax.requestRpsClass.do")
    @ResponseBody
    public JSONResponse requestRpsClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication) throws Exception {

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            classroomService.updateRpsClassroom(clasRoomInfo, null);
            return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage(user.getUsername()));
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

    }

    /**
     * <pre>
     * 대표 학교 삭제
     * </pre>
     *
     * @param clasRoomInfo
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("/general/ajax.removeClass.do")
    @ResponseBody
    public JSONResponse removeClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication) throws Exception {

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            classroomService.removeClassroomRegReq(clasRoomInfo);
            return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage(user.getUsername()));
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

    @RequestMapping("/teacher/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000008")
    public List<User> listMemberTeacherAjax(@Pageable UserSearch search) {

        if (CollectionUtils.isEmpty(search.getMbrCualfCds())) {
            search.setMbrCualfCds(TEACHER_CUALF_CDS);
        }
        if (CollectionUtils.isEmpty(search.getMbrStatCds())) {
            search.setMbrStatCds(MBR_STAT_CDS);
        }

        log.debug("[REQ] search: {}", search);

        return userService.listUserBy(search);
    }

    @RequestMapping("/teacher/ajax.tabClassList.do")
    @ResponseBody
    public List<ClasRoomInfo> tabClassListForTeacher(@Pageable ClasRoomRegReqHist clasRoomRegReqHist) {

        return classroomService.listTeacherClassroom(clasRoomRegReqHist);
    }

    @RequestMapping("/teacher/ajax.tabClassRepList.do")
    @ResponseBody
    public List<ClasRoomRepInfo> tabClassRepList(@Pageable ClasRoomRegReqHist clasRoomRegReqHist) {

        return classroomService.listClassroomRepresent(clasRoomRegReqHist);
    }

    @RequestMapping("/teacher/ajax.tabSchRpsList.do")
    @ResponseBody
    public List<SchInfo> tabSchRpsList(@Pageable SchInfo schInfo) {

        return assignGroupService.schoolClassTcherRepresent(schInfo);
    }

    /**
     * <pre>
     * 대표 학교 삭제
     * </pre>
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping("/teacher/ajax.deleteSchCualf.do")
    @ResponseBody
    public JSONResponse deleteSchCualf(SchInfo schInfo, Authentication authentication) throws Exception {

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            schInfo.setMbrNo(user.getMbrNo());
            schInfoService.deleteSchCualf(schInfo);
            return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage(user.getUsername()));
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

    /**
     * <pre>
     * 대표 학교 등록
     * </pre>
     *
     * @param info
     * @return
     * @throws Exception
     */
    @RequestMapping( value="/teacher/ajax.insertSchCualf.do", method = RequestMethod.POST)
    @ResponseBody
    public JSONResponse insertSchCualf(BizGrpInfo info, Authentication authentication) throws Exception {

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            schInfoService.insertSchCualf(info.getListSchInfo(), authentication);
            return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage(user.getUsername()));
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

    //@formatter:off
    private static final List<String> PUBLIC_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_100205_초등학생,
            CodeConstants.CD100204_100206_중학생,
            CodeConstants.CD100204_100207_고등학생,
            CodeConstants.CD100204_100208_대학생,
            CodeConstants.CD100204_100209_일반,
            CodeConstants.CD100204_100210_일반_학부모_);
    private static final List<String> TEACHER_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_100214_교사,
            CodeConstants.CD100204_100215_교사_진로상담_);
    private static final List<String> MBR_STAT_CDS = Arrays.asList(
            CodeConstants.CD100861_100862_정상이용,
            CodeConstants.CD100861_100863_이용중지,
            CodeConstants.CD100861_101506_승인요청);
    //@formatter:on
}
