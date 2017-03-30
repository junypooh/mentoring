/* license */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ClassroomService;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.NotifInfoService;
import kr.or.career.mentor.service.SchInfoService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ModelAttribute;


import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.swing.*;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    MyClassroomController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 22. 오전 9:07:26
 * @author  technear
 * @see
 */
@Controller
@RequestMapping("myPage/myClassroom")
@Slf4j
public class MyClassroomController {

    @Autowired
    ClassroomService classroomService;

    @Autowired
    CodeManagementService codeManagementService;

    @Autowired
    SchInfoService schInfoService;

    @Autowired
    private NotifInfoService notifInfoService;

    /**
     *
     * <pre>
     * 교실의 최초 등록 선생님 기준으로 찾을 경우
     * </pre>
     *
     * @param clasRoomRegReqHist
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.myClassroomTeacher.do")
    @ResponseBody
    public List<ClasRoomInfo> myClassroomTeacher(@Pageable ClasRoomRegReqHist clasRoomRegReqHist, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();

        clasRoomRegReqHist.setReqMbrNo(user.getMbrNo());
        return classroomService.listTeacherClassroom(clasRoomRegReqHist);
    }

    /**
     *
     * <pre>
     * 학생이 교실에 등록한 이력
     * </pre>
     *
     * @param clasRoomRegReqHist
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.myClassroomStudent.do")
    @ResponseBody
    public List<ClasRoomRegReqHist> myClassroom(@Pageable ClasRoomRegReqHist clasRoomRegReqHist, Authentication authentication, Model model) throws SchedulerException {
        User user = (User) authentication.getPrincipal();

        clasRoomRegReqHist.setReqMbrNo(user.getMbrNo());
        return classroomService.listStudentClassroom(clasRoomRegReqHist);
    }

    /**
     *
     * <pre>
     * 나의 교실 화면 생성
     * </pre>
     *
     * @param authentication
     * @param model
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("myClassroom.do")
    public String myClassroomPage(Authentication authentication, Model model) throws SchedulerException {
        //지역 공통코드 : 100245
        Code code = new Code();
        code.setSupCd("100245");
        model.addAttribute("code100351", codeManagementService.listCode(code));
        //학교구분코드
        code.setSupCd("100494");
        model.addAttribute("code100494", codeManagementService.listCode(code));

        if(hasRoleTeacher()){
            return "myPage/myClassroom/myClassroomTeacher";
            //return "myPage/myClassroom/myClassroomTeacherInfo";
        }else{
            User user = (User) authentication.getPrincipal();

            ClasRoomRegReqHist clasRoomRegReqHist = new ClasRoomRegReqHist();
            clasRoomRegReqHist.setReqMbrNo(user.getMbrNo());
            clasRoomRegReqHist.setUserType("Y");
            clasRoomRegReqHist.setClasRoomCualfCd("101691");
            List<ClasRoomInfo> clasRoomRegReqHistList = classroomService.listTeacherClassroom(clasRoomRegReqHist);
            System.out.println(">>>>>>>>>>>>>>" + clasRoomRegReqHistList);
            if(clasRoomRegReqHistList.size() > 0){
                model.addAttribute("clasRoomCualfCd", "101691");
            }else{
                model.addAttribute("clasRoomCualfCd", "101690");
            }
            //return "myPage/myClassroom/myManagementClassroomStudent";
            //return "myPage/myClassroom/myClassroomStudentInfo";
            return "myPage/myClassroom/myClassroomStudent";
        }
    }

    /**
     *
     * <pre>
     * 선생님이 자신이 등록 가능한 반 목록을 요청
     * </pre>
     *
     * @param clasRoomInfo
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.listClass.do")
    @ResponseBody
    public List<ClasRoomInfo> listClass(ClasRoomInfo clasRoomInfo, Authentication authentication) throws SchedulerException {
        //tchrMbrNo
        User user = (User) authentication.getPrincipal();
        clasRoomInfo.setTchrMbrNo(user.getMbrNo());
        List<ClasRoomInfo> rtn = null;
        if(hasRoleTeacher()){
            clasRoomInfo.getSchInfo().setMbrCualfCd(user.getMbrCualfCd());
            clasRoomInfo.getSchInfo().setMbrNo(user.getMbrNo());
            rtn = classroomService.listRequestClassroom(clasRoomInfo);
        }else{
            rtn = classroomService.listClassroomForStudent(clasRoomInfo);
        }
        return rtn;
    }

    /**
     *
     * <pre>
     * 등록 가능한 반 목록 중 선택하여 등록
     * </pre>
     *
     * @param clasRoomRegReqHist
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.insertClassroomRegReqHist.do")
    @ResponseBody
    public int insertClassroomRegReqHist(ClasRoomRegReqHist clasRoomRegReqHist, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();

        if(user.getMbrClassCd().equals("100858")){
            clasRoomRegReqHist.setClasRoomCualfCd("101690");
        }else if(user.getMbrClassCd().equals("100859")){
            clasRoomRegReqHist.setClasRoomCualfCd("101689");
        }else if(user.getMbrClassCd().equals("101707")){
            clasRoomRegReqHist.setClasRoomCualfCd("101764");
        }

        if(hasRoleTeacher()){
            clasRoomRegReqHist.setRegStatCd(CodeConstants.CD101524_101525_신청);
            user.setSchNm(clasRoomRegReqHist.getClasRoomInfo().getSchInfo().getSchNm());
            user.setClasNm(clasRoomRegReqHist.getClasRoomInfo().getClasRoomNm());
        }else{
            clasRoomRegReqHist.setRegStatCd(CodeConstants.CD101524_101525_신청);
        }
        clasRoomRegReqHist.setReqMbrNo(user.getMbrNo());
        int rtn = classroomService.insertClassroomRegReqHist(clasRoomRegReqHist);
        return rtn;
    }

    /**
     *
     * <pre>
     * 새로운 교실을 DB에 Insert (교실 생성한 교사는 기본으로 교실의 교사로 등록됨)
     * </pre>
     *
     * @param clasRoomInfo
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.insertClassroom.do")
    @ResponseBody
    public int insertClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication) throws Exception {
        int resultCnt = 0;



        User user = (User) authentication.getPrincipal();
        clasRoomInfo.setTchrMbrNo(user.getMbrNo());


        if(user.getMbrClassCd().equals("100858")){
            clasRoomInfo.setClasRoomCualfCd("101690");
        }else if(user.getMbrClassCd().equals("100859")){
            clasRoomInfo.setClasRoomCualfCd("101689");
        }else if(user.getMbrClassCd().equals("101707")){
            clasRoomInfo.setClasRoomCualfCd("101764");
        }

        List<ClasRoomInfo> regList = classroomService.listClassroom(clasRoomInfo);

        if(regList.size() > 0){
            resultCnt = -1;
        }else{
            resultCnt = classroomService.insertClasRoomInfo(clasRoomInfo);
        }
        return resultCnt;
    }

    @RequestMapping("ajax.removeClassroom.do")
    @ResponseBody
    public int removeClassroom(ClasRoomInfo clasRoomInfo) throws Exception {
        int resultCnt = 0;

        resultCnt = classroomService.removeClassroomRegReqHist(clasRoomInfo);
        return resultCnt;
    }


    @RequestMapping("ajax.removeClassRoomInfo.do")
    @ResponseBody
    public int removeClassRoomInfo(ClasRoomInfo clasRoomInfo) throws Exception {
        int resultCnt = 0;

        resultCnt = classroomService.removeClassRoomInfo(clasRoomInfo);
        return resultCnt;
    }




    @RequestMapping("/ajax.listApplyStudent.do")
    @ResponseBody
    public List<ClasRoomRegReqHist> listApplyStudent(@Pageable ClasRoomRegReqHist clasRoomRegReqHist, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        clasRoomRegReqHist.setClasRoomInfo(new ClasRoomInfo());
        clasRoomRegReqHist.getClasRoomInfo().setTchrMbrNo(user.getMbrNo());
        return classroomService.listApplyStudent(clasRoomRegReqHist);
    }

    /**
     *
     * <pre>
     * 선생님이 승인 요청 한 학생을 선택 하여 승인 해 줌.
     * </pre>
     *
     * @param listClasRoomRegReqHist
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.requestApprove.do")
    @ResponseBody
    public int requestApprove(ListClasRoomRegReqHist listClasRoomRegReqHist, Authentication authentication) throws SchedulerException, Exception {
        User user = (User) authentication.getPrincipal();
        return classroomService.updateRequestApprove(listClasRoomRegReqHist.getListClasRoomRegReqHist(), user.getMbrNo());
    }

    @RequestMapping("ajax.requestReject.do")
    @ResponseBody
    public int requestReject(ClasRoomRegReqHist clasRoomRegReqHist, Authentication authentication) throws SchedulerException, Exception  {
        User user = (User) authentication.getPrincipal();
        clasRoomRegReqHist.setRegStatCd(CodeConstants.CD101524_101527_거절_취소_);
        List<ClasRoomRegReqHist> listClasRoomRegReqHist = new ArrayList<>();
        listClasRoomRegReqHist.add(clasRoomRegReqHist);
        return classroomService.updateRequestApprove(listClasRoomRegReqHist, user.getMbrNo());
    }

    /**
     *
     * <pre>
     * 선생님이 대표 학교 설정
     * </pre>
     *
     * @param clasRoomInfo
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.requestRpsClassroom.do")
    @ResponseBody
    public int requestRpsClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        clasRoomInfo.setTchrMbrNo(user.getMbrNo());
        return classroomService.updateRpsClassroom(clasRoomInfo, authentication);
    }

    private boolean hasRoleTeacher(){
        Collection<SimpleGrantedAuthority> authorities = (Collection<SimpleGrantedAuthority>)    SecurityContextHolder.getContext().getAuthentication().getAuthorities();
        Authority authority = new Authority();
        authority.setAuthority("ROLE_TEACHER");
        Authority authority2 = new Authority();
        authority2.setAuthority("ROLE_SCHOOL");
        Authority authority3 = new Authority();
        authority3.setAuthority("ROLE_RPS_TEACHER");
        boolean roleCheck = false;
        if(authorities.contains(authority) || authorities.contains(authority2) || authorities.contains(authority3)){
            roleCheck = true;
        }
        return roleCheck;
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
        return classroomService.listSgguInfo(schInfo);
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
    @RequestMapping("/ajax.requestRpsClass.do")
    @ResponseBody
    public JSONResponse requestRpsStudentClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();
        clasRoomInfo.setTchrMbrNo(user.getMbrNo());


        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        if(user.getClasRoomSer().equals(Integer.toString(clasRoomInfo.getClasRoomSer()))){
            user.setClasRoomSer("");
        }else {
            user.setClasRoomSer(Integer.toString(clasRoomInfo.getClasRoomSer()));
        }

        try {
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
    @RequestMapping("/ajax.removeClass.do")
    @ResponseBody
    public JSONResponse removeStudentClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication) throws Exception {

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
    @RequestMapping("/ajax.rpsClass.do")
    @ResponseBody
    public JSONResponse rpsClass(ClasRoomInfo clasRoomInfo, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();
        clasRoomInfo.setTchrMbrNo(user.getMbrNo());


        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            classroomService.updateRpsClassUser(clasRoomInfo, null);
            return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage(user.getUsername()));
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

    }

    @RequestMapping("myClassroomTeacherInfo.do")
    public String myClassroomTeacherInfo(Authentication authentication, Model model) throws SchedulerException {
        //지역 공통코드 : 100245
        Code code = new Code();
        code.setSupCd("100245");
        model.addAttribute("code100351", codeManagementService.listCode(code));
        //학교구분코드
        code.setSupCd("100494");
        model.addAttribute("code100494", codeManagementService.listCode(code));

        return "myPage/myClassroom/myClassroomTeacherInfo";

        //return "myPage/myClassroom/myManagementClassroomStudent";
        //return "myPage/myClassroom/myClassroomStudentInfo";
        //return "myPage/myClassroom/myClassroomStudent";
    }


    @RequestMapping("myManagementClassroomStudent.do")
    public String myManagementClassroomStudent(Authentication authentication, Model model) throws SchedulerException {
        //지역 공통코드 : 100245
        Code code = new Code();
        code.setSupCd("100245");
        model.addAttribute("code100351", codeManagementService.listCode(code));
        //학교구분코드
        code.setSupCd("100494");
        model.addAttribute("code100494", codeManagementService.listCode(code));

        return "myPage/myClassroom/myManagementClassroomStudent";
    }

    @RequestMapping("myClassroomStudentInfo.do")
    public String myClassroomStudentInfo(Authentication authentication, Model model) throws SchedulerException {
        //지역 공통코드 : 100245
        Code code = new Code();
        code.setSupCd("100245");
        model.addAttribute("code100351", codeManagementService.listCode(code));
        //학교구분코드
        code.setSupCd("100494");
        model.addAttribute("code100494", codeManagementService.listCode(code));

        return "myPage/myClassroom/myClassroomStudentInfo";
    }




    /**
     *
     * <pre>
     * 새로운 교실을 DB에 Insert (교실 생성한 교사는 기본으로 교실의 교사로 등록됨)
     * </pre>
     *
     * @param clasRoomInfo
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.listClassroomRecognize.do")
    @ResponseBody
    public  List<ClasRoomInfo> listClassroomRecognize(@Pageable ClasRoomInfo clasRoomInfo, Authentication authentication) throws Exception {
        int resultCnt = 0;
        User user = (User) authentication.getPrincipal();
        clasRoomInfo.setTchrMbrNo(user.getMbrNo());

        return  classroomService.listClassroomRecognize(clasRoomInfo);
    }


    @RequestMapping("/ajax.listApplyStudentSchInfo.do")
    @ResponseBody
    public List<ClasRoomRegReqHist> listApplyStudentSchInfo(@Pageable ClasRoomRegReqHist clasRoomRegReqHist, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        clasRoomRegReqHist.setClasRoomInfo(new ClasRoomInfo());
        clasRoomRegReqHist.getClasRoomInfo().setTchrMbrNo(user.getMbrNo());
        return classroomService.listApplyStudentSchInfo(clasRoomRegReqHist);
    }


    @RequestMapping("/ajax.listSchRpsTchrInfo.do")
    @ResponseBody
    public List<SchInfo> listSchRpsTchrInfo(@Pageable ClasRoomInfo clasRoomInfo, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        return classroomService.listSchRpsTchrInfo(clasRoomInfo);
    }


    @RequestMapping("/ajax.listTchrInfo.do")
    @ResponseBody
    public List<SchInfo> listTchrInfo(ClasRoomInfo clasRoomInfo, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        return classroomService.listTchrInfo(clasRoomInfo);
    }


 /*   @RequestMapping("/ajax.insertSchCualf.do")
    @ResponseBody
    public int insertSchCualf(BizGrpInfo info, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        return schInfoService.insertSchCualf(info.getListSchInfo(), authentication);
    }
*/

    @RequestMapping( value="/ajax.insertSchCualf.do", method = RequestMethod.POST)
    @ResponseBody
    public JSONResponse insertSchCualf1(BizGrpInfo info, Authentication authentication) throws Exception {

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



    @RequestMapping("ajax.delTchrRps.do")
    @ResponseBody
    public int delTchrRps(@ModelAttribute SchInfo schInfo, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        schInfo.setMbrNo(user.getMbrNo());
        return schInfoService.deleteSchCualf(schInfo);
    }





}
