/* license */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.ClassroomMapper;
import kr.or.career.mentor.dao.MbrNotifInfoMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ClassroomService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.util.HttpRequestUtils;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    ClassroomServiceImpl.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 22. 오전 10:21:24
 * @author  technear
 * @see
 */
@Service
@Slf4j
public class ClassroomServiceImpl implements ClassroomService{

    @Autowired
    private UserService userService;

    @Autowired
    ClassroomMapper classroomMapper;

    @Autowired
    MbrNotifInfoMapper mbrNotifInfoMapper;

    @Override
    public List<ClasRoomRegReqHist> listStudentClassroom(ClasRoomRegReqHist clasRoomRegReqHist) {
        return classroomMapper.listStudentClassroom(clasRoomRegReqHist);
    }

    @Override
    public List<ClasRoomInfo> listTeacherClassroom(ClasRoomRegReqHist clasRoomRegReqHist) {
        return classroomMapper.listTeacherClassroom(clasRoomRegReqHist);
    }

    @Override
    public List<ClasRoomInfo> listClassroom(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.listClassroom(clasRoomInfo);
    }

    @Override
    public List<ClasRoomInfo> listRequestClassroom(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.listRequestClassroom(clasRoomInfo);
    }

    @Override
    public List<ClasRoomInfo> listClassroomForStudent(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.listClassroomForStudent(clasRoomInfo);
    }

    @Override
    public List<ClasRoomRepInfo> listClassroomRepresent(ClasRoomRegReqHist clasRoomRegReqHist) {
        return classroomMapper.listClassroomRepresent(clasRoomRegReqHist);
    }

    @Override
    public int insertClassroomRegReqHist(ClasRoomRegReqHist clasRoomRegReqHist) throws Exception {

        int nCnt = 0;
        User user = (User)SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if(hasRoleTeacher()) {
            nCnt += classroomMapper.insertClassroomRegReqHist(clasRoomRegReqHist);

        }else{
            nCnt = classroomMapper.insertClassroomRegReqHist(clasRoomRegReqHist);
        }

        return nCnt;


    }

    @Override
    public int insertClasRoomInfo(ClasRoomInfo clasRoomInfo) throws Exception{

        User user = (User)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        int nCnt = 0;

        nCnt += classroomMapper.insertClasRoomInfo(clasRoomInfo);


        ClasRoomRegReqHist clasRoomRegReqHist = new ClasRoomRegReqHist();


        int regClasRoomCnt = 0;
        clasRoomRegReqHist.setRegStatCd(CodeConstants.CD101524_101525_신청);
        clasRoomRegReqHist.setClasRoomSer(clasRoomInfo.getClasRoomSer());
        clasRoomRegReqHist.setReqMbrNo(clasRoomInfo.getTchrMbrNo());
        clasRoomRegReqHist.setClasRoomCualfCd(clasRoomInfo.getClasRoomCualfCd());

        regClasRoomCnt = classroomMapper.listRpsClassroomCnt(clasRoomRegReqHist);
        if(regClasRoomCnt > 0){
            clasRoomRegReqHist.setRpsYn("N");
        }else{
            clasRoomRegReqHist.setRpsYn("Y");
        }
        nCnt += classroomMapper.insertClassroomRegReqHist(clasRoomRegReqHist);


        return nCnt;
    }

    @Override
    public List<ClasRoomRegReqHist> listApplyStudent(ClasRoomRegReqHist clasRoomRegReqHist) {
        return classroomMapper.listApplyStudent(clasRoomRegReqHist);
    }

    @Override
    public int updateRequestApprove(List<ClasRoomRegReqHist> list, String mbrNo) throws Exception{
        int nCnt = 0;
        //notifInfoService.insertNotifVerf(mbrNotiInfo);

        if(list.get(0).getClasRoomSer() != null ){

            ClasRoomRegReqHist tchrInfo = classroomMapper.listClassroomHistTchr(list.get(0));
            ClasRoomInfo clasRoomInfo = new ClasRoomInfo();
            clasRoomInfo = list.get(0).getClasRoomInfo();

            String id = tchrInfo.getReqMbrNo() + tchrInfo.getClasRoomInfo().getClasRoomSer();
            String name = tchrInfo.getClasRoomInfo().getSchNm() + "[" + tchrInfo.getClasRoomInfo().getClasRoomNm()+"]";

            JSONObject json = HttpRequestUtils.setUser("I", tchrInfo.getReqMbrNo() + tchrInfo.getClasRoomInfo().getClasRoomSer(), tchrInfo.getClasRoomInfo().getSchNm() + "[" + tchrInfo.getClasRoomInfo().getClasRoomNm()+"]", tchrInfo.getReqMbrNo(), tchrInfo.getEmailAddr());
            String resultStr = (String) json.get("message");
            log.info("rtn ::::> " + resultStr);

            if ("Duplicated user id".equals(resultStr)) {
                json = HttpRequestUtils.setUser("U", id, name, tchrInfo.getReqMbrNo(), "");

                resultStr = (String) json.get("message");
                if ("Successfully Saved".equals(resultStr))
                    log.info("success ::::> " + resultStr);
                else
                    log.info("failed ::::> " + resultStr + "[]");
            }

            log.info("TOMMS ACCOUNT ADD : {}",json.toString());

            if("Successfully Saved".equals(resultStr)) {
                list.get(0).setAuthMbrNo(mbrNo);
                list.get(0).setUseYn("Y");
                classroomMapper.updateRequestRoomApprove(list.get(0));

            }else{
                throw new CnetException(CodeMessage.ERROR_000001_시스템_오류_입니다_);
            }
        }


        for(ClasRoomRegReqHist clasRoomRegReqHist: list){
            if(clasRoomRegReqHist == null || clasRoomRegReqHist.getReqSer() == null){
                continue;
            }else{

                clasRoomRegReqHist.setClasRoomInfo(new ClasRoomInfo());
                clasRoomRegReqHist.getClasRoomInfo().setTchrMbrNo(mbrNo);

                ClasRoomInfo clasRoomSchInfo = new ClasRoomInfo();


                int regClasRoomCnt = 0;
                regClasRoomCnt = classroomMapper.listUpdateRpsClassroomCnt(clasRoomRegReqHist);
                if(regClasRoomCnt > 0){
                    clasRoomRegReqHist.setRpsYn("N");
                }else{
                    clasRoomRegReqHist.setRpsYn("Y");
                }
                nCnt += classroomMapper.updateRequestApprove(clasRoomRegReqHist);
            }
        }
        return nCnt;
    }

    @Override
    public List<SchInfo> listMySchool(SchInfo schInfo) {
        return classroomMapper.listMySchool(schInfo);
    }

    @Override
    public List<SchInfo> listMyRecSchool(SchInfo schInfo) {
        return classroomMapper.listMyRecSchool(schInfo);
    }



    @Override
    public List<BizSetInfo> listBizGrp(BizSetInfo bizSetInfo) {
        return classroomMapper.listBizGrp(bizSetInfo);
    }

    @Override
    public int removeClassroomRegReqHist(ClasRoomInfo clasRoomInfo) throws Exception{

        String reqMbrNo = clasRoomInfo.getTchrMbrNo();
        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if(StringUtils.isEmpty(reqMbrNo)) {
            clasRoomInfo.setTchrMbrNo(user.getMbrNo());
        }

        int applyCnt = classroomMapper.selectLectApplyInfoByClassRoom(clasRoomInfo);
        if(applyCnt > 0){
            return -1;
        }

        ClasRoomRegReqHist clasRoomRegReqHist = new ClasRoomRegReqHist();
        clasRoomRegReqHist.setReqSer(clasRoomInfo.getReqSer());
        ClasRoomRegReqHist tchrInfo = classroomMapper.listClassroomHistTchr(clasRoomRegReqHist);

        String id = tchrInfo.getReqMbrNo() + tchrInfo.getClasRoomInfo().getClasRoomSer();
        String name = tchrInfo.getClasRoomInfo().getSchNm() + "[" + tchrInfo.getClasRoomInfo().getClasRoomNm()+"]";

        JSONObject json = HttpRequestUtils.setUser("D", tchrInfo.getReqMbrNo() + tchrInfo.getClasRoomInfo().getClasRoomSer(), tchrInfo.getClasRoomInfo().getSchNm() + "[" + tchrInfo.getClasRoomInfo().getClasRoomNm()+"]", tchrInfo.getReqMbrNo(), tchrInfo.getEmailAddr());
        String resultStr = (String) json.get("message");
        log.info("rtn ::::> " + resultStr);

        if ("Duplicated user id".equals(resultStr)) {
            json = HttpRequestUtils.setUser("D", id, name, tchrInfo.getReqMbrNo(), "");

            resultStr = (String) json.get("message");
            if ("Successfully Saved".equals(resultStr))
                log.info("success ::::> " + resultStr);
            else
                log.info("failed ::::> " + resultStr + "[]");
        }

        log.info("TOMMS ACCOUNT ADD : {}",json.toString());

        if("Successfully Deleted".equals(resultStr)) {
            if(user.getClasRoomSer() != null) {
                if (user.getClasRoomSer().equals(clasRoomInfo.getClasRoomSer())) {
                    user.setClasRoomSer("");
                }
            }
            int roomCnt = classroomMapper.clasRoomUserCnt(clasRoomInfo);
            if (roomCnt <= 0) {

                classroomMapper.removeClassroomRegReqHist(clasRoomInfo);

                return classroomMapper.removeClassroomRegReq(clasRoomInfo);
            }
            return classroomMapper.removeClassroomRegReq(clasRoomInfo);
        }else{
            throw new CnetException(CodeMessage.ERROR_000001_시스템_오류_입니다_);
        }
    }

    @Override
    public int removeClassRoomInfo(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.removeClassRoomInfo(clasRoomInfo.getClasRoomSer());
    }

    @Override
    public int removeClassroomRegReq(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.removeClassroomRegReq(clasRoomInfo);
    }

    private boolean hasRoleTeacher(){
        Collection<SimpleGrantedAuthority> authorities = (Collection<SimpleGrantedAuthority>)    SecurityContextHolder.getContext().getAuthentication().getAuthorities();
        Authority authority = new Authority();
        authority.setAuthority("ROLE_TEACHER");
        return authorities.contains(authority);
    }

    @Override
    public int updateRpsClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication) {
        classroomMapper.updateRpsClassroomInitial(clasRoomInfo);
        int cnt = classroomMapper.updateRpsClassroom(clasRoomInfo);

        // 변경 된 학교 정보로 authentication 갱신
        if(authentication != null) {
            User user = (User) authentication.getPrincipal();

            HashMap<String,String> param = new HashMap<>();
            param.put("id", user.getId());
            param.put("userType", EgovProperties.getLocalProperty("Local.site"));
            param.put("loginPermYn", "Y");;
            User newUser = userService.retrieveUser(param);

            user.setSchNm(newUser.getSchNm());
            user.setClasNm(newUser.getClasNm());
            user.setClasRoomSer(newUser.getClasRoomSer());
        }

        return cnt;
    }

    @Override
    public List<SchInfo> listSgguInfo(SchInfo schInfo) {
        return classroomMapper.selectSgguInfo(schInfo);
    }


    @Override
    public int updateRpsClassUser(ClasRoomInfo clasRoomInfo, Authentication authentication) {
        //lassroomMapper.updateRpsClassUserInitial(clasRoomInfo);
        int cnt = classroomMapper.updateRpsClassUser(clasRoomInfo);

        // 변경 된 학교 정보로 authentication 갱신
        if(authentication != null) {
            User user = (User) authentication.getPrincipal();

            HashMap<String,String> param = new HashMap<>();
            param.put("id", user.getId());
            param.put("userType", EgovProperties.getLocalProperty("Local.site"));
            param.put("loginPermYn", "Y");;
            User newUser = userService.retrieveUser(param);

            user.setSchNm(newUser.getSchNm());
            user.setClasNm(newUser.getClasNm());
            user.setClasRoomSer(newUser.getClasRoomSer());
        }

        return cnt;
    }

    @Override
    public List<ClasRoomInfo> listClassroomRecognize(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.listClassroomRecognize(clasRoomInfo);
    }

    @Override
    public List<ClasRoomRegReqHist> listApplyStudentSchInfo(ClasRoomRegReqHist clasRoomRegReqHist) {
        return classroomMapper.listApplyStudentSchInfo(clasRoomRegReqHist);
    }

    @Override
    public List<SchInfo> listSchRpsTchrInfo(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.listSchRpsTchrInfo(clasRoomInfo);
    }

    @Override
    public List<SchInfo> listTchrInfo(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.listTchrInfo(clasRoomInfo);
    }


    @Override
    public List<ClasRoomInfo> listSchoolClassRoom(ClasRoomInfo clasRoomInfo) {
        return classroomMapper.listSchoolClassRoom(clasRoomInfo);
    }










}
