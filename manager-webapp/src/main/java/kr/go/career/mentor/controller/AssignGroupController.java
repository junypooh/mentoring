/* license */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.AssignGroupService;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.SchInfoService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.view.JSONResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    AssignController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 21. 오후 11:01:03
 * @author  technear
 * @see
 */
@Controller
@RequestMapping("assign/biz")
public class AssignGroupController {

    @Autowired
    protected AssignGroupService assignGroupService;

    @Autowired
    protected SchInfoService schInfoService;

    @Autowired
    CodeManagementService codeManagementService;

    @Autowired
    UserService userService;


    @RequestMapping(value={"edit.do"})
    public void retireveAssignGroup2(BizSetInfo bizSetInfo, Model model) {
        model.addAttribute("clasSetHist", codeManagementService.retrieveClasSetHist());
        model.addAttribute("bizSetInfo",bizSetInfo);
    }

    @RequestMapping(value={"update.do"})
    public void retireveAssignGroup(BizSetInfo bizSetInfo, Model model) {
        model.addAttribute("bizSetInfo",bizSetInfo);
    }

    @RequestMapping("saveAssignGroup")
    @Historic(workId = "1000000001")
    public String saveAssignGroup(BizSetInfo bizSetInfo, Model model, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        assignGroupService.saveBizGrpInfo(bizSetInfo, user);
        return "redirect:list.do";
    }


    @RequestMapping("ajax.listAssignGroup.do")
    @ResponseBody
    @Historic(workId = "1000000000")
    public List<BizSetInfo> listAssignGroup(@Pageable BizGrpSearch bizGrpSearch) {
        if (SessionUtils.hasRole("ROLE_ADMIN_GROUP")) {
            User user = SessionUtils.getUser();
            bizGrpSearch.setCoNo(user.getPosCoNo());
        }
        return assignGroupService.listAssignGroup(bizGrpSearch);
    }

    @RequestMapping("ajax.listAssignSchool.do")
    @ResponseBody
    @Historic(workId = "1000000002")
    public List<SchInfo> retireveAssignSchool(BizGrpInfo bizGrpInfo) {
        return assignGroupService.listAssignSchool(bizGrpInfo);
    }


    @RequestMapping("ajax.insertAssignSchool.do")
    @ResponseBody
    @Historic(workId = "1000000003")
    public JSONResponse insertAssignSchool(@ModelAttribute BizGrpInfo bizGrpInfo, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        assignGroupService.insertAssignSchool(bizGrpInfo, user);
        return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage());
    }

    /**
     * 배정그룹 수정
     *
     * @param bizSetInfo
     * @param model
     * @return
     */
    @RequestMapping("modifyAssignGroupPoc")
    public String modifyAssignGroupPoc(BizSetInfo bizSetInfo, Model model, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        assignGroupService.modifyAssignGroupPoc(bizSetInfo, user);

        return "redirect:viewAssignGroup.do?setTargtNo="+bizSetInfo.getBizGrpInfo().getGrpNo();

    }

    /**
     * 배정그룹 배정학교 삭제
     *
     * @param bizSetInfo
     * @param model
     * @param authentication
     * @return
     */
    @RequestMapping("ajax.deleteAssignSchool.do")
    @ResponseBody
    @Historic(workId = "1000000005")
    public JSONResponse deleteAssignSchool(@ModelAttribute BizSetInfo bizSetInfo, Model model, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        String rtnStr = assignGroupService.deleteAssignSchool(bizSetInfo, user);

        if("SUCC".equals(rtnStr)) {
            return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
        }else {
            return JSONResponse.success(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toMessage());
        }

    }


    /**
     * <pre>
     *     배정그룹 삭제
     * </pre>
     * @param bizGrpInfo
     * @param model
     * @param authentication
     * @return
     */
    @RequestMapping("ajax.deleteAssignGroupPoc.do")
    @ResponseBody
    public JSONResponse deleteAssignGroupPoc(BizGrpInfo bizGrpInfo, Model model, Authentication authentication) {
        String rtnStr = assignGroupService.deleteAssignGroupPoc(bizGrpInfo);

        if("SUCC".equals(rtnStr)) {
            return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
        }else {
            return JSONResponse.success(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toMessage());
        }

    }

    /**
     * 배정학교 추가시 중복 체크
     *
     * @param bizGrpInfo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"ajax.dupListAssignSchool.do"}, method = {RequestMethod.POST,RequestMethod.GET })
    @ResponseBody
    public List<SchInfo> dupListAssignSchool(BizGrpInfo bizGrpInfo)  {
        return assignGroupService.dupListAssignSchool(bizGrpInfo);
    }


    /**
     * <pre>
     * 강의 신청 횟수 등록/수정
     * </pre>
     * @param bizGrpInfo
     * @param model
     * @param authentication
     * @return
     */
    @RequestMapping("ajax.saveAssignLectAppl.do")
    @ResponseBody
    @Historic(workId = "1000000004")
    public JSONResponse saveAssignLectAppl(@ModelAttribute BizGrpInfo bizGrpInfo, Model model, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        String rtnStr = assignGroupService.saveAssignLectAppl(bizGrpInfo, user);

        if("SUCC".equals(rtnStr)) {
            return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
        }else {
            return JSONResponse.success(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toMessage());
        }

    }


    @RequestMapping("ajax.listAssignGroupHist.do")
    @ResponseBody
    public List<BizSetInfo> listAssignGroupHist(BizGrpSearch bizGrpSearch) {
        if (SessionUtils.hasRole("ROLE_ADMIN_GROUP")) {
            User user = SessionUtils.getUser();
            bizGrpSearch.setCoNo(user.getPosCoNo());
        }
        return assignGroupService.listAssignGroupHist(bizGrpSearch);
    }


    @RequestMapping("ajax.assignGroupName.do")
    @ResponseBody
    public JSONResponse assignGroupName(@ModelAttribute BizGrpInfo bizGrpInfo, Model model, Authentication authentication) {
        String rtnStr = assignGroupService.assignGroupName(bizGrpInfo);
        if("SUCC".equals(rtnStr)) {
            return JSONResponse.success("N");
        }else {
            return JSONResponse.success("Y");
        }

    }




















}
