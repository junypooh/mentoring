package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.*;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.security.EgovFileScrty;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.MentorManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.HttpRequestUtils;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;


/** Created by chan on 15. 9. 15.. */
@Service
@Slf4j
public class MentorManagementServiceImpl implements MentorManagementService {

    @Autowired
    private MentorMapper mentorMapper;
    @Autowired
    private BannerMapper bannerMapper;
    @Autowired
    private JobMapper jobMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private MbrRelMappMapper mbrRelMappMapper;
    @Autowired
    private LectureManagementService lectureManagementService;
    @Autowired
    private MbrAgrInfoMapper mbrAgrInfoMapper;
    @Autowired
    private MbrJobInfoMapper mbrJobInfoMapper;
    @Autowired
    private MbrJobChrstcInfoMapper mbrJobChrstcInfoMapper;
    @Autowired
    private MbrProfPicInfoMapper mbrProfPicInfoMapper;
    @Autowired
    private MbrProfInfoMapper mbrProfInfoMapper;
    @Autowired
    private MbrProfScrpInfoMapper mbrProfScrpInfoMapper;
    @Autowired
    private JobInfoMapper jobInfoMapper;


    @Override
    public List<JobInfo> listJobInfoFromMentor(MentorSearch search) {
        return jobMapper.listJobInfoFromMentor(search);
    }


    @Override
    public List<JobInfo> listRecomJobInfo() {
        return jobMapper.listRecomJobInfo();
    }


    public List<MentorDTO> listMentorInfo(MentorSearch search) {
        return mentorMapper.listMentorInfo(search);
    }


    @Override
    public int saveHofefulMentors(List<MngrRecomInfo> listMngrRecomInfo) {
        //기존 정보 삭제
        bannerMapper.deleteManagedMentorInfo(CodeConstants.CD101641_101642_인기멘토);

        int idx = 0;
        for (MngrRecomInfo info : listMngrRecomInfo) {
            info.setRecomTargtCd(CodeConstants.CD101641_101642_인기멘토);
            info.setRecomSer(Constants.START_HOOFULT_MENTOR_SEQ + idx++);
            info.setSortSeq(idx);
        }
        //새로운 정보 등록
        int nCnt = bannerMapper.insertManagedMentorInfo(listMngrRecomInfo);
        return nCnt;
    }


    @Override
    public List<MentorDTO> listBelongMentor(MentorSearch mentorSearch) {
        return mentorMapper.listBelongMentor(mentorSearch);
    }


    @Override
    public List<ApprovalDTO> listMentorApproval(ApprovalDTO approvalDTO, User user) {
        //조회하는 User가 전체관리자가 아닐경우 소속된 멘토의 정보만을 조회함.
        if (user != null && !CodeConstants.CD100204_100850_전체관리자.equals(user.getMbrCualfCd())) {
            approvalDTO.setListMbrNo(userMapper.belongingMentor(user.getPosCoNo()));
        }
        return mentorMapper.listMentorApproval(approvalDTO);
    }


    @Override
    public int secede(ApprovalDTO approvalDTO) throws Exception {
        //해당 멘토가 개설한 수업들의 상태를 모두 취소처리함.
        //'101542'	수업요청
        //'101543'	수강모집
        //'101544'	모집마감
        //'101546'	모집취소요청
        //'101548'	수업예정
        //'101549'	수업대기
        ////'101552'	수업취소요청

        //회원 상태를 탈퇴로 변경
        if (CodeConstants.CD100861_100864_탈퇴.equals(approvalDTO.getMbrStatCd())) {
            //회원이 개설하여 아직 진행하지 않은 수업은 취소 처리 함.
            //1.회원이 개설하여 아직 진행하지 않은 수업 조회
            List<ApprovalDTO> listApprovalDTO = mentorMapper.listALiveLecture(approvalDTO.getMbrNo());

            for (ApprovalDTO info : listApprovalDTO) {
                info.setLectStatCd(CodeConstants.CD101541_101547_모집취소);
                lectureManagementService.cancelLectureApplying(info);
            }
        }
        return mentorMapper.updateMbrStatCd(approvalDTO);
    }


    @Override
    public int mentorApproval(ApprovalDTO approvalDTO) throws InvalidKeyException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException {
        int rtn = mentorMapper.updateMbrStatCd(approvalDTO);

        if (approvalDTO.getMbrStatCd().equals(CodeConstants.CD100861_100862_정상이용)) {
            //TOMMS에 계정 생성
            User user = userMapper.getUserByNo(approvalDTO.getMbrNo());
            JSONObject json = HttpRequestUtils.setUser("I", user.getMbrNo(), user.getUsername(), user.getMbrNo(),user.getUsername(),
                    user.getEmailAddr(),"0", "C", "1");
            log.info(json.toString());
            String resultStr = (String) json.get("message");
            log.info("rtn ::::> " + resultStr);

            if ("Duplicated user id".equals(resultStr)) {
                json = HttpRequestUtils.setUser("U", user.getMbrNo(), user.getUsername(), user.getMbrNo(),
                        user.getEmailAddr());

                resultStr = (String) json.get("message");
                if ("Successfully Saved".equals(resultStr))
                    log.info("success ::::> " + resultStr);
                else
                    log.info("failed ::::> " + resultStr + "[]");
            }

           // if ("Successfully Saved".equals(resultStr))

          //계정 생성에 성공했으면
            if ("Successfully Saved".equals(resultStr)){
                userMapper.updateCnslStartDay(user.getMbrNo());
            }else{
                log.error("TOMMS SETUSER FAIL : ",user.getMbrNo());
            }
        }
        return rtn;
    }


    @Override
    public List<ApprovalDTO> listMentorApprovalCnt(User user) {
        ApprovalDTO approvalDTO = new ApprovalDTO();
        //조회하는 User가 전체관리자가 아닐경우 소속된 멘토의 정보만을 조회함.
        if (user != null && !CodeConstants.CD100204_100850_전체관리자.equals(user.getMbrCualfCd())) {
            approvalDTO.setListMbrNo(userMapper.belongingMentor(user.getPosCoNo()));
        }
        return mentorMapper.listMentorApprovalCnt(approvalDTO);
    }


    @Override
    public void saveBelongMentor(User mentor, User register) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
        try {
            if (StringUtils.isNotEmpty(mentor.getPassword())) {
                mentor.setPassword(EgovFileScrty.encryptPassword(mentor.getPassword(), mentor.getId()));
            }
        }
        catch (Exception e) {
            throw CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toExceptio(e);
        }
        // 기본정보 저장
        mentor.setMbrClassCd(CodeConstants.CD100857_101505_멘토);
        mentor.setMbrCualfCd(CodeConstants.CD100204_101502_소속멘토);
        mentor.setMbrGradeCd("3");
        mentor.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
        mentor.setRegMbrNo(register.getMbrNo());
        mentor.setPosCoNo(register.getPosCoNo());
        mentor.setLoginPermYn("N"); // 기본적으로 사용안함으로 설저
        userMapper.insertUser(mentor);

        // 관계 매핑
        MbrRelMapp mbrRelMapp = new MbrRelMapp();
        mbrRelMapp.setRegMbrNo(register.getMbrNo());
        mbrRelMapp.setTargtMbrNo(mentor.getMbrNo());
        mbrRelMapp.setRelClassCd(CodeConstants.CD100872_101508_소속업체);
        mbrRelMapp.setAuthStatCd(CodeConstants.CD101025_101027_수락_승인_);
        mbrRelMappMapper.insertMbrRelMapp(mbrRelMapp);

        // 이메일 수저장
        MbrAgrInfo mbrAgrInfo = new MbrAgrInfo();
        mbrAgrInfo.setMbrNo(mentor.getMbrNo());
        mbrAgrInfo.setAgrClassCd(CodeConstants.CD100939_100944_메일수집동의);
        mbrAgrInfoMapper.insertMbrAgrInfo(mbrAgrInfo);

        //TOMMS에 계정 생성
        JSONObject json = HttpRequestUtils.setUser("I",mentor.getMbrNo(),mentor.getUsername(),mentor.getMbrNo(),mentor.getUsername()
                ,mentor.getEmailAddr(),"0", "C", "1");
        //log.info(json.toString());

        String resultStr = (String) json.get("message");
        //log.info("rtn ::::> " + resultStr);

        if ("Duplicated user id".equals(resultStr)) {
            json = HttpRequestUtils.setUser("U", mentor.getMbrNo(),mentor.getUsername(),mentor.getMbrNo(),mentor.getEmailAddr());

            resultStr = (String) json.get("message");
            if ("Successfully Saved".equals(resultStr))
                log.info("success ::::> " + resultStr);
            else
                log.info("failed ::::> " + resultStr + "[]");
        }

        log.info("TOMMS ACCOUNT ADD : {}",json.toString());

      //계정 생성에 성공했으면
        if ("Successfully Saved".equals(resultStr)){
            userMapper.updateCnslStartDay(mentor.getMbrNo());
        }else{
            log.error("TOMMS SETUSER FAIL : ",mentor.getMbrNo());
        }
    }


    @Override
    public void updateBelongMentorBase(User mentor) {
        try {
            if (StringUtils.isNotEmpty(mentor.getPassword())) {
                mentor.setPassword(EgovFileScrty.encryptPassword(mentor.getPassword(), mentor.getId()));
            }
        }
        catch (Exception e) {
            throw CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toExceptio(e);
        }

        userMapper.updateUser(mentor);
        List<MbrAgrInfo> agrees = mentor.getAgrees();
        if (CollectionUtils.isEmpty(agrees) || StringUtils.isEmpty(agrees.get(0).getAgrClassCd())) {
            mbrAgrInfoMapper.deleteMbrAgrInfo(mentor.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }
        else {
            mbrAgrInfoMapper.mergeMbrAgrInfo(mentor.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }
    }


    @Override
    public void updateBelongMentorJob(User user) {
        log.debug("[REQ] user: {}", user);

        MbrJobInfo mbrJobInfo = user.getMbrJobInfo();

        // 직업명 직접 입력 시 직업을 등록한다.
        if("userWrite".equals(mbrJobInfo.getJobNo())) {
            JobInfo jobInfo = new JobInfo();
            jobInfo.setJobClsfCd(mbrJobInfo.getJobClsfCd());
            jobInfo.setJobNm(mbrJobInfo.getJobNm());
            jobInfoMapper.insertJobInfo(jobInfo);

            mbrJobInfo.setJobNo(jobInfo.getJobNo());
        }

        if (mbrJobInfo != null) {
            mbrJobInfo.setMbrNo(user.getMbrNo());
            mbrJobInfoMapper.mergeMbrJobInfo(mbrJobInfo);
        }

        mbrJobChrstcInfoMapper.deleteMbrJobChrstcInfosBy(user.getMbrNo(), null);
        if (CollectionUtils.isNotEmpty(user.getMbrJobChrstcInfos())) {
            for (MbrJobChrstcInfo eachObj : user.getMbrJobChrstcInfos()) {
                eachObj.setMbrNo(user.getMbrNo());
                mbrJobChrstcInfoMapper.insertMbrJobChrstcInfo(eachObj);
            }
        }
    }


    @Override
    public void updateBelongMentorProfile(User user) {

        // 사진정보
        mbrProfPicInfoMapper.deleteMbrProfPicInfosBy(user.getMbrNo());
        if (CollectionUtils.isNotEmpty(user.getMbrpropicInfos())) {
            for (MbrProfPicInfo eachObj : user.getMbrpropicInfos()) {
                if (eachObj.getFileSer() == null) {
                    continue;
                }
                eachObj.setMbrNo(user.getMbrNo());
                mbrProfPicInfoMapper.insertMbrProfPicInfo(eachObj);
            }
        }

        // 프로필 정보 업데이트
        MbrProfInfo mbrProfInfo = user.getMbrProfInfo();
        mbrProfInfo.setMbrNo(user.getMbrNo());
        mbrProfInfoMapper.mergeMbrProfInfo(mbrProfInfo);

        // 스크렙정보
        //mbrProfScrpInfoMapper.deleteMbrProfScrpInfoBy(user.getMbrNo());
        if (CollectionUtils.isNotEmpty(user.getMbrProfScrpInfos())) {
            for (MbrProfScrpInfo eachObj : user.getMbrProfScrpInfos()) {
                if (eachObj.getScrpSer() == null) {
                    if (StringUtils.isNotBlank(eachObj.getScrpTitle()) || StringUtils.isNotBlank(eachObj.getScrpURL())) {
                        eachObj.setMbrNo(user.getMbrNo());
                        mbrProfScrpInfoMapper.insertMbrProfScrpInfo(eachObj);
                    }
                }
                else {
                    mbrProfScrpInfoMapper.updateMbrProfScrpInfo(eachObj);
                }
            }
        }
    }


    @Override
    public List<MentorDTO> allMentorList(UserSearch search) {
        return mentorMapper.allMentorList(search);
    }




}
