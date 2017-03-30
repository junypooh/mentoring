/* license */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.AssignGroupService;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.SchInfoService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.ClassroomService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.view.AdminSchoolExcelView;
import kr.or.career.mentor.view.GenericExcelView;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.*;

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
@RequestMapping("school/info")
public class SchoolController {

    @Autowired
    protected AssignGroupService assignGroupService;

    @Autowired
    protected SchInfoService schInfoService;

    @Autowired
    CodeManagementService codeManagementService;

    @Autowired
    UserService userService;


    @Autowired
    ClassroomService classroomService;


    @Autowired
    LectureManagementService lectureManagementService;

    @RequestMapping("ajax.listAssignGroupAll.do")
    @ResponseBody
    public List<BizSetInfo> listAssignGroupAll(BizGrpSearch bizGrpSearch) {
        return assignGroupService.listAssignGroup(bizGrpSearch);
    }

    @RequestMapping(value={"editAssignGroup"})
    public void retireveAssignGroup(BizSetInfo bizSetInfo, Model model) {
        model.addAttribute("bizSetInfo",bizSetInfo);
    }


    @RequestMapping("ajax.saveSchoolAssignGroup.do")
    @ResponseBody
    public JSONResponse saveSchoolAssignGroup(BizSetInfo bizSetInfo, Model model, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        bizSetInfo.setSetTargtCd(CodeConstants.CD101599_101600_학교);
        List<SchInfo> listSch = assignGroupService.saveBizGrpInfo(bizSetInfo, user);
        if(listSch == null || listSch.size() == 0){
            return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage());
        }else{
            return JSONResponse.failure(CodeMessage.MSG_100018_이미_배정정보가_있습니다_.toMessage());
        }
    }



    @RequestMapping("ajax.listSchInfoWithGroup.do")
    @ResponseBody
    @Historic(workId = "1000000017")
    public List<SchInfoDTO> listSchInfoWithGroup(@Pageable BizGrpSearch bizGrpSearch) {
        return schInfoService.listSchInfoWithGroup(bizGrpSearch);
    }

    @RequestMapping("excel.listSchInfoWithGroup.do")
    public ModelAndView excelSchInfoWithGroup(BizGrpSearch bizGrpSearch, Model model) throws NoSuchFieldException, SecurityException {

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(GenericExcelView.getField(SchInfoDTO.class,"schNm"));
        listHeaderField.add(GenericExcelView.getField(SchInfoDTO.class,"grpData"));
        model.addAttribute("fileName", "schoolList.xls");
        model.addAttribute("domains",schInfoService.listSchInfoWithGroup(bizGrpSearch));
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("excelView","data",model);
    }


    @RequestMapping("ajax.retrieveSchInfoDetail.do")
    @ResponseBody
    @Historic(workId = "1000000018")
    public SchInfoDTO retrieveSchInfoDetail(SchInfo schInfo) {
        return schInfoService.retrieveSchInfoDetail(schInfo);
    }

    @RequestMapping("ajax.listAssignGroupListBySchool.do")
    @ResponseBody
    public List<AssignGroupDTO> listAssignGroupListBySchool(@Pageable SchInfo schInfo) {
        return schInfoService.listAssignGroupListBySchool(schInfo);
    }

    @RequestMapping("edit.do")
    public void listAssignGroupListBySchool(@ModelAttribute SchInfo schInfo, Model model) {
        Code code = new Code();
        code.setCd("100494");
        code.setUseYn("Y");
        model.addAttribute("code100494",codeManagementService.listCode(code));

        code.setCd("101685");
        model.addAttribute("code101685",codeManagementService.listCode(code));

        if(StringUtils.isNotEmpty(schInfo.getSchNo())){
            SchJobGroup schJobGroup = new SchJobGroup();
            schJobGroup.setSchNo(schInfo.getSchNo());
            schInfo = schInfoService.retrieveSchInfo(schInfo);
            schInfo.setSchJobGroup(schInfoService.listSchJobGroupInfo(schJobGroup));
            model.addAttribute("schInfo",schInfo);
        }else{
            schInfo.setUseYn("Y");
            schInfo.setDeviceType("101683");
            model.addAttribute("schInfo",schInfo);
        }
    }

    @RequestMapping("saveSchoolInfo.do")
    @Historic(workId = "1000000019")
    public String saveSchoolInfo(@ModelAttribute SchInfo schInfo, User user) {
            schInfoService.saveSchInfo(schInfo);
        return "redirect:view.do?schNo="+schInfo.getSchNo();
    }

    /**
     * <pre>
     *     배정그룹 엑셀다운로드
     * </pre>
     * @param bizGrpSearch
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.excelDownListAssignGroup.do")
    public ModelAndView excelDownListAssignGroup(BizGrpSearch bizGrpSearch, Model model) throws Exception{
        if (SessionUtils.hasRole("ROLE_ADMIN_GROUP")) {
            User user = SessionUtils.getUser();
            bizGrpSearch.setCoNo(user.getPosCoNo());
        }

        List<AssignGroupExcelDTO> originList = assignGroupService.excelDownListAssignGroup(bizGrpSearch);
        List<AssignGroupExcelDTO> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(AssignGroupExcelDTO originSource: originList){
            AssignGroupExcelDTO targetSource = new AssignGroupExcelDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            targetList.add(targetSource);
        }

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_admingroup.xls");
        model.addAttribute("domains", targetList);

        return new ModelAndView("excelView", "data", model);
    }

    /**
     * <pre>
     *     학교정보관리 엑셀다운로드
     * </pre>
     * @param bizGrpSearch
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "ajax.excelDownListSchInfoWithGroup.do",method = RequestMethod.POST)
    public ModelAndView excelDownListSchInfoWithGroup(BizGrpSearch bizGrpSearch, Model model) throws Exception{

        List<SchInfoExcelDTO> originList = schInfoService.excelDownListSchInfoWithGroup(bizGrpSearch);
        /*
        List<SchInfoExcelDTO> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(SchInfoExcelDTO originSource: originList){
            SchInfoExcelDTO targetSource = new SchInfoExcelDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            targetList.add(targetSource);
        }
        */

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "sidoNm"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "locaAddr"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "locaDetailAddr"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "schClassCdNm"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "schNm"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "schNo"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "username"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "mobile"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "deviceType"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "setTargtCdNm"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "grpNm"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "clasCnt"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "clasApplCnt"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "clasPeriod"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "coNm"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "lectDateTime"));
        listHeaderField.add(AdminSchoolExcelView.getField(SchInfoExcelDTO.class, "lectTitle"));

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_adminschool.xls");
        model.addAttribute("domains", originList);
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("adminSchoolExcelView", "data", model);
    }



    /**
     * 지역시에 따른 지역구 조회
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.sidoInfo.do")
    @ResponseBody
    public List<SchInfo> sidoInfo(SchInfo schInfo)  {
        return assignGroupService.listSidoInfo(schInfo);
    }

    /**
     * 지역시에 따른 지역구 조회
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.sgguInfo.do")
    @ResponseBody
    public List<SchInfo> sgguInfo(SchInfo schInfo)  {
        return assignGroupService.listSgguInfo(schInfo);
    }



    /**
     * 교사/학생 현황
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"ajax.schoolTcherInfo.do"}, method = {RequestMethod.POST,RequestMethod.GET })
    @ResponseBody
    public List<SchInfo> schoolTcherInfo(@Pageable SchInfo schInfo, Model model){
        return assignGroupService.schoolTcherInfo(schInfo);
    }


    /**
     * 교실 정보
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"ajax.schoolClassRoomInfo.do"}, method = {RequestMethod.POST,RequestMethod.GET })
    @ResponseBody
    public List<SchInfo> schoolClassRoomInfo(@Pageable SchInfo schInfo, Model model){
        return assignGroupService.schoolClassRoomInfo(schInfo);
    }

    /**
     * 교실 등록 현황
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"ajax.schoolClassRoomHistory.do"}, method = {RequestMethod.POST,RequestMethod.GET })
    @ResponseBody
    public List<SchInfo> schoolClassRoomHistory(@Pageable SchInfo schInfo, Model model){
        return assignGroupService.schoolClassRoomHistory(schInfo);
    }


    /**
     * 배정 사업 현황
     *
     * @param bizGrpSearch
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"ajax.schoolAssignGroupState.do"}, method = {RequestMethod.POST,RequestMethod.GET })
    @ResponseBody
    public List<SchInfo> schoolAssignGroupState(@Pageable BizGrpSearch bizGrpSearch, Model model){
        return assignGroupService.schoolAssignGroupState(bizGrpSearch);
    }



    /**
     * 반대표 현황
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"ajax.schoolClassRoomRepresent.do"}, method = {RequestMethod.POST,RequestMethod.GET })
    @ResponseBody
    public List<SchInfo> schoolClassRoomRepresent(@Pageable SchInfo schInfo, Model model){
        return assignGroupService.schoolClassRoomRepresent(schInfo);
    }


    /**
     * 학교 대표 교사
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"ajax.schoolClassTcherRepresent.do"}, method = {RequestMethod.POST,RequestMethod.GET })
    @ResponseBody
    public List<SchInfo> schoolClassTcherRepresent(SchInfo schInfo, Model model){
        return assignGroupService.schoolClassTcherRepresent(schInfo);
    }


    @RequestMapping("ajax.deleteSchoolTcher.do")
    @ResponseBody
    public JSONResponse deleteSchoolTcher(@Pageable SchInfo schInfo, Model model, Authentication authentication) {
        String rtnStr = assignGroupService.deleteSchoolTcher(schInfo);

        if("SUCC".equals(rtnStr)) {
            return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
        }else {
            return JSONResponse.success(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toMessage());
        }

    }

    @RequestMapping("ajax.deleteSchoolRoom.do")
    @ResponseBody
    public JSONResponse deleteSchoolRoom(@Pageable SchInfo schInfo, Model model, Authentication authentication) {
        String rtnStr = assignGroupService.deleteSchoolRoom(schInfo);

        if("SUCC".equals(rtnStr)) {
            return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
        }else {
            return JSONResponse.success(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toMessage());
        }

    }

    @RequestMapping("ajax.listSchoolLect.do")
    @ResponseBody
    public List<LectureApplInfoDTO> listSchoolLect(@Pageable @ModelAttribute BizSetInfo bizSetInfo) throws Exception {
        return lectureManagementService.listSchoolLect(bizSetInfo);
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


    /**
     * <pre> 교육청의 사업 조회(selectbox) 수업신청 팝업화면에서 교육청을 선택했을 시 교육청이 가지고 있는 사업정보, 배정횟수, 잔여횟수 등 조회 </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listBizSetGrp.do")
    @ResponseBody
    public List<BizSetInfo> listBizSetGrp(LectureSearch lectureSearch) throws Exception {

        List<BizSetInfo> bizSetInfoList = lectureManagementService.listBizSetGrpByCoInfo(lectureSearch);

        return bizSetInfoList;
    }


    @RequestMapping("ajax.schoolClassRoom.do")
    @ResponseBody
    public List<ClasRoomInfo> listSchoolClassRoom(ClasRoomInfo clasRoomInfo) throws Exception {

        List<ClasRoomInfo> listSchoolClassRoom = classroomService.listClassroom(clasRoomInfo);

        return listSchoolClassRoom;
    }



















}
