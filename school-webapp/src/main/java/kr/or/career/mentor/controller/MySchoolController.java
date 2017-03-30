/* license */
package kr.or.career.mentor.controller;

import java.util.Collection;
import java.util.List;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.ClassroomService;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.AssignGroupService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    MySchoolController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 12. 오전 10:23:21
 * @author  technear
 * @see
 */
@Controller
@RequestMapping("myPage/mySchool")
public class MySchoolController {

    @Autowired
    ClassroomService classroomService;

    @Autowired
    LectureManagementService lectureManagementService;

    @Autowired
    CodeManagementService codeManagementService;

    @Autowired
    AssignGroupService assignGroupService;

    @RequestMapping("mySchool")
    public void mySchool(Model model) throws Exception {
        Code code = new Code();
        code.setSupCd("101599");
        model.addAttribute("code101599", codeManagementService.listCode(code));
    }


    @RequestMapping("ajax.listMySchool.do")
    @ResponseBody
    public List<SchInfo> listMySchool(SchInfo schInfo, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();

        Collection<SimpleGrantedAuthority> authorities = (Collection<SimpleGrantedAuthority>)    SecurityContextHolder.getContext().getAuthentication().getAuthorities();
        Authority authority = new Authority();
        authority.setAuthority("ROLE_SCHOOL");
        schInfo.setMbrNo(user.getMbrNo());
        if(authorities.contains(authority)){
            schInfo.setSchMbrCualfCd("101699");
            return classroomService.listMyRecSchool(schInfo);
        }

        /*authority.setAuthority("ROLE_RPS_TEACHER");
        if(authorities.contains(authority)){
            schInfo.setSchMbrCualfCd("101698");
            return classroomService.listMyRecSchool(schInfo);
        }*/
        return classroomService.listMySchool(schInfo);


    }


    @RequestMapping("ajax.listMyRecSchool.do")
    @ResponseBody
    public List<SchInfo> listMyRecSchool(SchInfo schInfo, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();

        Collection<SimpleGrantedAuthority> authorities = (Collection<SimpleGrantedAuthority>)    SecurityContextHolder.getContext().getAuthentication().getAuthorities();
        Authority authority = new Authority();
        authority.setAuthority("ROLE_SCHOOL");
        schInfo.setMbrNo(user.getMbrNo());
        if(authorities.contains(authority)){
            schInfo.setSchMbrCualfCd("101699");
            return classroomService.listMyRecSchool(schInfo);
        }
        authority.setAuthority("ROLE_RPS_TEACHER");
        if(authorities.contains(authority)){
            schInfo.setSchMbrCualfCd("101698");
            return classroomService.listMyRecSchool(schInfo);
        }
        return classroomService.listMySchool(schInfo);


    }

    @RequestMapping("ajax.listBizGrp.do")
    @ResponseBody
    public List<BizSetInfo> listBizGrp(BizSetInfo bizSetInfo, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();

        bizSetInfo.setRegMbrNo(user.getMbrNo());

        return classroomService.listBizGrp(bizSetInfo);
    }

    @RequestMapping("ajax.listSchoolLect.do")
    @ResponseBody
    public List<LectureApplInfoDTO> listSchoolLect(@Pageable @ModelAttribute BizSetInfo bizSetInfo) throws Exception {
        return lectureManagementService.listSchoolLect(bizSetInfo);
    }


    @RequestMapping("ajax.listSchAssignGroup.do")
    @ResponseBody
    public List<BizSetInfo> listSchAssignGroup(@Pageable BizGrpSearch bizSetInfo) {
        return assignGroupService.listSchAssignGroup(bizSetInfo);
    }
}
