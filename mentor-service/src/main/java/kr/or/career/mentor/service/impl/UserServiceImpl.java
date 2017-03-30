package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.dao.*;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.security.EgovFileScrty;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.HttpRequestUtils;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.view.APIRepsonse;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Created by chaos on 15. 8. 31..
 */
@Service
@Slf4j
public class UserServiceImpl implements UserService {

    private final String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
            + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    private final String ID_PATTERN = "^[a-z]+[a-z0-9_-]{4,11}$";
    private final String PWD_PATTERN = "^.*(?=^.{10,100}$)(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$";
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private MbrJobChrstcInfoMapper mbrJobChrstcInfoMapper;
    @Autowired
    private MbrJobInfoMapper mbrJobInfoMapper;
    @Autowired
    private MbrProfInfoMapper mbrProfInfoMapper;
    @Autowired
    private MbrAgrInfoMapper mbrAgrInfoMapper;
    @Autowired
    private MbrProfPicInfoMapper mbrProfPicInfoMapper;
    @Autowired
    private MbrProfScrpInfoMapper mbrProfScrpInfoMapper;
    @Autowired
    private MbrRelMappMapper mbrRelMappMapper;
    @Autowired
    private MbrIconInfoMapper mbrIconInfoMapper;
    @Autowired
    private JobInfoMapper jobInfoMapper;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @Autowired
    private CoInfoMapper coInfoMapper;

    @Override
    public User retrieveUser(Map<String, String> param) {
        User user = null;
        List<User> list = userMapper.retrieveUser(param);
        if (list != null && list.size() > 0) {
            user = list.get(0);
            if(user != null && CodeConstants.CD100861_101506_승인요청.equals(user.getMbrStatCd())){
                user.setAccountNonLocked(false);
            }else if(user != null && "N".equals(user.getLoginPermYn())){
                user.setEnabled(false);
            }
            return user;
        }else {
            return null;
        }
    }

    @Override
    public List<User> listUser(Map<String, String> param) {
        return userMapper.retrieveUser(param);
    }

    @Override
    public List<User> listUserBy(UserSearch search) {
        return userMapper.listUserBy(search);
    }

    @Override
    public List<User> listUserForNotification(UserSearch search) {
        return userMapper.listUserForNotification(search);
    }

    @Override
    public User getUserByNo(String mbrNo) {
        return userMapper.getUserByNo(mbrNo);
    }

    @Override
    public User getSupUserByNo(String mbrNo) {
        return userMapper.getSupUserByNo(mbrNo);
    }

    @Override
    public MbrJobInfo getMbrJobInfoByMbrNo(String mbrNo) {
        return mbrJobInfoMapper.getMbrJobInfoByMbrNo(mbrNo);
    }

    @Override
    public List<MbrJobChrstcInfo> getMbrJobChrstcInfos(String mbrNo) {
        return mbrJobChrstcInfoMapper.listMbrJobChrstcInfoBy(mbrNo);
    }

    @Override
    public MbrProfInfo getMbrProfInfoBy(String mbrNo) {
        return mbrProfInfoMapper.getMbrProfInfoBy(mbrNo);
    }

    @Override
    public List<MbrProfPicInfo> listMbrProfPicInfoByMbrNo(String mbrNo) {
        return mbrProfPicInfoMapper.listMbrProfPicInfoBy(mbrNo);
    }

    @Override
    public List<MbrProfScrpInfo> listMbrProfScrpInfos(String mbrNo, String scrpClassCd) {
        return mbrProfScrpInfoMapper.listMbrProfScrpInfoBy(mbrNo, scrpClassCd);
    }

    @Override
    public List<User> retrieveUserByEmail(Map<String, String> param) {
        return userMapper.retrieveUser(param);
    }

    @Override
    public List<Authority> findAuthoritiesByUserId(String userId) {
        return userMapper.findAuthoritiesByUserId(userId);
    }

    @Override
    public List<MbrAgrInfo> listMbrAgrInfo(String mbrNo, String agrClassCd) {
        return mbrAgrInfoMapper.listMbrAgrInfo(mbrNo, agrClassCd);
    }

    @Override
    public MbrIconInfo getMbrIconInfo(String mbrNo, String iconKindCd) {
        return mbrIconInfoMapper.getMbrIconInfo(mbrNo, iconKindCd);
    }

    @Override
    public int updatePwd(User user) {
        return userMapper.updatePwd(user);
    }

    @Override
    public int updatePwd(User user, String newPwd) throws Exception {
        User dbUser = userMapper.getUserByNo(user.getMbrNo());
        if(dbUser.getPassword().equals(user.getPassword())) {
            user.setPassword(EgovFileScrty.encryptPassword(newPwd,user.getId()));
            return userMapper.updatePwd(user);
        } else {
            return 0;
        }
    }

    @Override
    public int updateUser(User user) throws Exception {
        if (StringUtils.isNotEmpty(user.getPassword())) {
            user.setPassword(EgovFileScrty.encryptPassword(user.getPassword(), user.getId()));
        }
        // 관리자 > 관리자 관리에서 사용되는 parameter
        if (StringUtils.isNotEmpty(user.getMbrGradeCd())) {
            if("2".equals(user.getMbrGradeCd())) {
                user.setMbrClassCd(CodeConstants.CD100857_101504_기관_업체);
                user.setMbrGradeCd("0");
            } else {
                user.setMbrClassCd(CodeConstants.CD100857_100860_관리자);
                user.setMbrGradeCd(StringUtils.defaultString(user.getMbrGradeCd(), "0"));
            }
        }
        int val =  userMapper.updateUser(user);

        List<MbrAgrInfo> agrees = user.getAgrees();
        if (CollectionUtils.isEmpty(agrees) || StringUtils.isEmpty(agrees.get(0).getAgrClassCd())) {
            mbrAgrInfoMapper.deleteMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }
        else {
            mbrAgrInfoMapper.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }

        return val;
    }

    @Override
    public int updateUserAndEmailAgree(User user) throws Exception {
        if (StringUtils.isNotEmpty(user.getPassword())) {
            user.setPassword(EgovFileScrty.encryptPassword(user.getPassword(), user.getId()));
        }

        List<MbrAgrInfo> agrees = user.getAgrees();
        if (CollectionUtils.isEmpty(agrees) || StringUtils.isEmpty(agrees.get(0).getAgrClassCd())) {
            mbrAgrInfoMapper.deleteMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }
        else {
            mbrAgrInfoMapper.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }
        return userMapper.updateUser(user);
    }

    @Override
    public int updateUserAgrees(User user) {
        int rtn = 0;
        List<MbrAgrInfo> agrees = user.getAgrees();
        for(MbrAgrInfo info :agrees){
            rtn += mbrAgrInfoMapper.mergeMbrAgrInfo(user.getMbrNo(), info.getAgrClassCd());
        }
        return rtn;
    }

    @Override
    public void updateJobAndProfile(User user) {
        log.debug("[REQ] user: {}", user);

        MbrJobInfo mbrJobInfo = user.getMbrJobInfo();
        if (mbrJobInfo != null) {
            mbrJobInfo.setMbrNo(user.getMbrNo());
            mbrJobInfoMapper.mergeMbrJobInfo(mbrJobInfo);
        }

        if (CollectionUtils.isNotEmpty(user.getMbrJobChrstcInfos())) {
            mbrJobChrstcInfoMapper.deleteMbrJobChrstcInfosBy(user.getMbrNo(), null);
            for (MbrJobChrstcInfo eachObj : user.getMbrJobChrstcInfos()) {
                eachObj.setMbrNo(user.getMbrNo());
                mbrJobChrstcInfoMapper.insertMbrJobChrstcInfo(eachObj);
            }
        }

        // 사진정보
        SessionUtils.getUser().setProfFileSer(null); // 세션 정보 삭제 (등록이던 삭제던 우선 삭제)
        mbrProfPicInfoMapper.deleteMbrProfPicInfosBy(user.getMbrNo());
        if (CollectionUtils.isNotEmpty(user.getMbrpropicInfos())) {
            for (MbrProfPicInfo eachObj : user.getMbrpropicInfos()) {
                if (eachObj.getFileSer() == null) {
                    continue;
                }
                eachObj.setMbrNo(user.getMbrNo());
                mbrProfPicInfoMapper.insertMbrProfPicInfo(eachObj);

                SessionUtils.getUser().setProfFileSer(String.valueOf(eachObj.getFileSer())); // 세션 정보 변경
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
    public int updateSecession(User user) throws Exception {

        user.setChgMbrNo(user.getMbrNo());
        user.setLoginPermYn("N");

        if(CodeConstants.CD100861_100864_탈퇴.equals(user.getMbrStatCd())) {
            user.setMbrWithdrawnType(CodeConstants.CD101512_101755_회원_직접_탈퇴);
            user.setAuthProcSust("회원직접탈퇴");
            userMapper.withDrawalUser(user); // 개인정보 삭제
        }

        return userMapper.updateStat(user);
    }

    @Override
    public boolean emailValidate(String email) {
        Pattern pattern = Pattern.compile(EMAIL_PATTERN);
        return pattern.matcher(email).matches();
    }

    @Override
    public boolean idValidate(String id) {
        Pattern pattern = Pattern.compile(ID_PATTERN);
        return pattern.matcher(id).matches();
    }

    @Override
    @Transactional
    public int insertUser(User user) throws Exception {
        // 14세 미만 회원의 경우 부모에게 동의 메일 발송
        // 비밀번호 암호화.
        user.setPassword(EgovFileScrty.encryptPassword(user.getPassword(), user.getId()));
        if (StringUtils.isEmpty(user.getMbrStatCd())) {
            user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
        }
        int cnt = userMapper.insertUser(user);
        for (MbrAgrInfo mbrAgrInfo : user.getAgrees()) {
            if (StringUtils.isNotEmpty(mbrAgrInfo.getAgrClassCd())) {
                mbrAgrInfo.setMbrNo(user.getMbrNo());
                userMapper.insertMbrAgrInfo(mbrAgrInfo);
            }
        }
        if (user.getMbrProfInfo() != null) {
            MbrProfInfo mpi = user.getMbrProfInfo();
            mpi.setMbrNo(user.getMbrNo());
            mbrProfInfoMapper.insertMbrProfInfo(mpi);
        }
        if (CollectionUtils.isNotEmpty(user.getMbrJobChrstcInfos())) {
            for (MbrJobChrstcInfo mjci : user.getMbrJobChrstcInfos()) {
                mjci.setMbrNo(user.getMbrNo());
                mbrJobChrstcInfoMapper.insertMbrJobChrstcInfo(mjci);
            }
        }
        if (user.getMbrJobInfo() != null) {
            MbrJobInfo mji = user.getMbrJobInfo();

            // 직업명 직접 입력 시 직업을 등록한다.
            if(StringUtils.isEmpty(mji.getJobNo()) && StringUtils.isNotEmpty(mji.getJobNm())) {
                JobInfo jobInfo = new JobInfo();
                jobInfo.setJobClsfCd(mji.getJobClsfCd());
                jobInfo.setJobNm(mji.getJobNm());
                jobInfo.setRegMbrNo(user.getMbrNo());
                jobInfoMapper.insertJobInfo(jobInfo);

                mji.setJobNo(jobInfo.getJobNo());
            }

            mji.setMbrNo(user.getMbrNo());
            mbrJobInfoMapper.insertMbrJobInfo(mji);
        }

        // 학생,교사도 참관할 수 있으므로 학생,교사아이디도 같이 생성한다.
        // 교사 반등록시 아이디+반의 계정도 생성해야함.(교실등록에서 처리)
        if(cnt > 0 && CodeConstants.CD100861_100862_정상이용.equals(user.getMbrStatCd())){
            //TOMMS에 사용자 추가
            JSONObject json = HttpRequestUtils.setUser("I",user.getMbrNo(), user.getUsername(), user.getMbrNo(), user.getEmailAddr());
            log.info("TOMMS ACCOUNT ADD : {}",json.toString());

            String resultStr = (String) json.get("message");
            log.info("rtn ::::> " + resultStr);

            if ("Duplicated user id".equals(resultStr)) {
                json = HttpRequestUtils.setUser("U", user.getMbrNo(), user.getUsername(), user.getMbrNo(), user.getEmailAddr());

                resultStr = (String) json.get("message");
                if ("Successfully Saved".equals(resultStr))
                    log.info("success ::::> " + resultStr);
                else
                    log.info("failed ::::> " + resultStr + "[]");
            }

            //계정 생성에 성공했으면
            if ("Successfully Saved".equals(resultStr)){
                userMapper.updateCnslStartDay(user.getMbrNo());
            }else{
                log.error("TOMMS SETUSER FAIL : ",user.getMbrNo());
            }
        }
        return cnt;
    }

    public String updatePwdRandom(User user, String password) throws Exception {
        String _password = password;
        if(StringUtils.isEmpty(_password)){
            SecureRandom random = new SecureRandom();
            _password = new BigInteger(130, random).toString(32).substring(0, 8);
        }
        user.setPassword(EgovFileScrty.encryptPassword(_password, user.getId()));
        user.setTmpPwdYn("N");
        int cnt = userMapper.updatePwd(user);

        user.setPassword(_password);

        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         *
         */

        try {
            MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
            reciever.setMailAddress(user.getEmailAddr());

            Message message = new Message();
            message.setSendType(MessageSendType.EMS.getValue());
            message.setContentType(MessageType.SEARCH_INFO);
            message.addReciever(reciever);

            MemberPayLoad  memberPayLoad = MemberPayLoad.of(user.getMbrNo(),message,true);
            memberPayLoad.setName(user.getUsername());
            memberPayLoad.setId(user.getId());
            memberPayLoad.setPassword(user.getPassword());
            message.setPayload(memberPayLoad);

            messageTransferManager.invokeTransfer(message);
        } catch (Exception e) {
            log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
        }

        if (cnt > 0) {
            return _password;
        }
        return null;
    }

    @Override
    public String updatePwdRandom(User user) throws Exception {
        SecureRandom random = new SecureRandom();
        String password = new BigInteger(130, random).toString(32).substring(0, 8);
        return updatePwdRandom(user, password);
    }

    @Override
    public String updatePwdRandom(List<User> user) throws Exception {
        String rtn = "";
        for (User u : user) {
            rtn = updatePwdRandom(u, rtn);
        }
        return rtn;
    }


    @Override
    public void saveManager(User user) {
        try {
            if (StringUtils.isNotEmpty(user.getPassword())) {
                user.setPassword(EgovFileScrty.encryptPassword(user.getPassword(), user.getId()));
            }
        }
        catch (Exception e) {
            throw CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toException(e);
        }

        user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
        if("2".equals(user.getMbrGradeCd())) {
            user.setMbrClassCd(CodeConstants.CD100857_101504_기관_업체);
            user.setMbrGradeCd("0");
        } else {
            user.setMbrClassCd(CodeConstants.CD100857_100860_관리자);
            user.setMbrGradeCd(StringUtils.defaultString(user.getMbrGradeCd(), "0"));
        }
        userMapper.insertUser(user);
    }

    @Override
    public void saveCorporationMentor(User user) {
        try {
            if (StringUtils.isNotEmpty(user.getPassword())) {
                user.setPassword(EgovFileScrty.encryptPassword(user.getPassword(), user.getId()));
            }
        }
        catch (Exception e) {
            throw CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toException(e);
        }

        user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
        user.setMbrClassCd(CodeConstants.CD100857_101504_기관_업체);
        user.setMbrCualfCd(CodeConstants.CD100204_101501_업체담당자);
        user.setMbrGradeCd("2");
        userMapper.insertUser(user);

        if (CollectionUtils.isNotEmpty(user.getAgrees())) {
            for (MbrAgrInfo mbrAgrInfo: user.getAgrees()) {
                mbrAgrInfo.setMbrNo(user.getMbrNo());
                mbrAgrInfoMapper.insertMbrAgrInfo(mbrAgrInfo);
            }
        }

        MbrRelMapp mbrRelMapp = user.getMbrRelMapp();
        mbrRelMapp.setTargtMbrNo(user.getMbrNo());
        mbrRelMapp.setRelClassCd(CodeConstants.CD100872_101507_소속기관);
        mbrRelMapp.setAuthStatCd(CodeConstants.CD101025_101026_신청);
        mbrRelMappMapper.insertMbrRelMapp(mbrRelMapp);
    }

    @Override
    public void updateCorporationMentor(User user) {
        try {
            userMapper.updateUser(user);

            List<MbrAgrInfo> agrees = user.getAgrees();
            if (CollectionUtils.isEmpty(agrees) || StringUtils.isEmpty(agrees.get(0).getAgrClassCd())) {
                mbrAgrInfoMapper.deleteMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
            }
            else {
                mbrAgrInfoMapper.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
            }

            mbrRelMappMapper.deleteMbrRelMappByTargt(user.getMbrNo());

            MbrRelMapp mbrRelMapp = user.getMbrRelMapp();
            mbrRelMapp.setTargtMbrNo(user.getMbrNo());
            mbrRelMapp.setRelClassCd(CodeConstants.CD100872_101507_소속기관);
            mbrRelMapp.setAuthStatCd(CodeConstants.CD101025_101026_신청);
            mbrRelMappMapper.insertMbrRelMapp(mbrRelMapp);
        }
        catch (Exception e) {
            throw CodeMessage.ERROR_000001_시스템_오류_입니다_.toExceptio(e);
        }
    }

    @Override
    public void updateSchoolMember(User user) {
        try {
            userMapper.updateUser(user);

            List<MbrAgrInfo> agrees = user.getAgrees();
            if (CollectionUtils.isEmpty(agrees) || StringUtils.isEmpty(agrees.get(0).getAgrClassCd())) {
                mbrAgrInfoMapper.deleteMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
            }
            else {
                mbrAgrInfoMapper.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
            }
        }
        catch (Exception e) {
            throw CodeMessage.ERROR_000001_시스템_오류_입니다_.toExceptio(e);
        }
    }

    @Override
    public void updateMentorMember(User user) {
        // 기본정보 수정
        userMapper.updateUser(user);

        // 이메일 수집동의 수정
        List<MbrAgrInfo> agrees = user.getAgrees();
        if (CollectionUtils.isEmpty(agrees) || StringUtils.isEmpty(agrees.get(0).getAgrClassCd())) {
            mbrAgrInfoMapper.deleteMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }
        else {
            mbrAgrInfoMapper.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의);
        }

        // 직업정보 수정
        MbrJobInfo mbrJobInfo = user.getMbrJobInfo();

        // 직업명 직접 입력 시 직업을 등록한다.
        if(mbrJobInfo != null && StringUtils.isEmpty(mbrJobInfo.getJobNo()) && StringUtils.isNotEmpty(mbrJobInfo.getJobNm())) {
            JobInfo jobInfo = new JobInfo();
            jobInfo.setJobClsfCd(mbrJobInfo.getJobClsfCd());
            jobInfo.setJobNm(mbrJobInfo.getJobNm());
            jobInfo.setRegMbrNo(user.getMbrNo());
            jobInfoMapper.insertJobInfo(jobInfo);

            mbrJobInfo.setJobNo(jobInfo.getJobNo());
        }

        if (mbrJobInfo != null && StringUtils.isNotEmpty(mbrJobInfo.getJobNo())) {
            mbrJobInfo.setMbrNo(user.getMbrNo());
            mbrJobInfoMapper.mergeMbrJobInfo(mbrJobInfo);
        }

        // 특징분류 수정
        mbrJobChrstcInfoMapper.deleteMbrJobChrstcInfosBy(user.getMbrNo(), null);
        if (CollectionUtils.isNotEmpty(user.getMbrJobChrstcInfos())) {
            for (MbrJobChrstcInfo eachObj : user.getMbrJobChrstcInfos()) {
                eachObj.setMbrNo(user.getMbrNo());
                mbrJobChrstcInfoMapper.insertMbrJobChrstcInfo(eachObj);
            }
        }

        // 아이콘 정보 수정
        MbrIconInfo mbrIconInfo = user.getMbrIconInfo();
        if (mbrIconInfo != null && StringUtils.isNotEmpty(mbrIconInfo.getIconKindCd())) {
            mbrIconInfo.setMbrNo(user.getMbrNo());
            mbrIconInfoMapper.mergeMbrIconInfo(mbrIconInfo);
        }

        MbrProfInfo mbrProfInfo = user.getMbrProfInfo();
        if (mbrProfInfo != null && StringUtils.isNotEmpty(mbrProfInfo.getIntdcInfo())) {
            mbrProfInfo.setMbrNo(user.getMbrNo());
            mbrProfInfoMapper.mergeMbrProfInfo(mbrProfInfo);
        }

    }

    @Override
    public int saveProfPicInfo(MbrProfPicInfo mbrProfPicInfo) {
        return userMapper.saveProfPicInfo(mbrProfPicInfo);
    }

    @Override
    public int deleteProfPicInfo(MbrProfPicInfo mbrProfPicInfo) {
        return userMapper.deleteProfPicInfo(mbrProfPicInfo);
    }

    @Override
    public MbrRelMapp getMbrRelMappByTargt(String targtMbrNo) {
        return mbrRelMappMapper.getMbrRelMappByTargt(targtMbrNo);
    }

    @Override
    public boolean isValidateId(String id) {
        return userMapper.isValidateId(id);
    }

    @Override
    public boolean isValidateEmail(String email) {
        return userMapper.isValidateEmail(email);
    }

    @Override
    public APIRepsonse syncCnetUser(User user) {


        APIRepsonse apiRepsonse;

        //HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
        //        .getRequest();

        //String userId = request.getParameter("USER_ID");
        //String password = request.getParameter("USER_PW");
        //String syncMbrNo = request.getParameter("syncMbrNo");
        String password = "";

        /*
        InetAddress ip = null;
        try {
            ip = InetAddress.getByName(request.getHeader("x-forwarded-for"));

            log.debug("password : {}", password);
            password = AESCipherUtils.encriptHex(password);
            log.debug("password(encripted) : {}", password);
            password = AESCipherUtils.decriptHex(password);
            log.debug("password(decripted) : {}", password);



        }
        catch (Exception e) {
            e.printStackTrace();
        }
        */

        password = EgovFileScrty.encryptPassword(user.getPassword(), user.getId());

        /*
        String[] allowIps = EgovProperties.getProperty("CAREER.SYNCUSER.IPs").split(",");

        if (!ArrayUtils.contains(allowIps, ip.getHostAddress())) {
            return APIRepsonse.of(HttpStatus.SC_UNAUTHORIZED, "Unauthorized", null);
        }
        */

        Map<String, String> searchInfo = new HashMap<>();
        searchInfo.put("id", user.getId());
        searchInfo.put("pwd", password);


        //User user = null;

        try {
            user = retrieveUser(searchInfo);

            if (user == null)
                apiRepsonse = APIRepsonse.of("false"); // No
            else
                apiRepsonse = APIRepsonse.of("true");
                                                                                     // Content

            //MbrMapp mbrMapp = MbrMapp.of(user.getMbrNo(), syncMbrNo);

            //userMapper.insertMbrMapp(mbrMapp);
        }
        catch (Exception e) {
            apiRepsonse =  APIRepsonse.of("false");
        }

        //Map<String, String> returnObj = new HashMap<>();
        //returnObj.put("mbrNo", user.getMbrNo());

        return apiRepsonse; // OK

    }

    @Override
    public CoInfo retrieveCoInfoByUser(User user) throws Exception {
        return coInfoMapper.retrieveCoInfoByUser(user);
    }

    /**
     * 14세 미만 회의등의 시청상태를 승인하여 정상사용으로 만들어준다.
     *
     * @see kr.or.career.mentor.service.UserService#approveUser(kr.or.career.mentor.domain.User)
     * @param user
     * @return
     * @throws InvalidKeyException
     * @throws NoSuchAlgorithmException
     * @throws NoSuchPaddingException
     * @throws InvalidAlgorithmParameterException
     * @throws IllegalBlockSizeException
     * @throws BadPaddingException
     * @throws UnsupportedEncodingException
     */
    @Override
    public int approveUser(User user) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException {
        //user.setMbrNo(AESCipherUtils.decript(user.getMbrNo()));
        user.setMbrNo(user.getMbrNo());
        user.setChgMbrNo(user.getMbrNo());
        user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);

        mbrAgrInfoMapper.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100971_미성년자가입부모동의);

        return userMapper.updateStat(user);
    }

    @Override
    public int mergeMbrAgrInfo(String mbrNo, String agrClassCd) {
        return mbrAgrInfoMapper.mergeMbrAgrInfo(mbrNo, agrClassCd);
    }

    @Override
    public int deleteMbrAgrInfo(String mbrNo, String agrClassCd) {
        return mbrAgrInfoMapper.deleteMbrAgrInfo(mbrNo,agrClassCd);
    }

    @Override
    public int upsertDeviceInfo(MbrDvcInfo deviceInfo) {
        return userMapper.upsertDeviceInfo(deviceInfo);
    }

    @Override
    public int deleteDeviceInfo(MbrDvcInfo deviceInfo) {
        return userMapper.deleteDeviceInfo(deviceInfo);
    }

    @Override
    public List<MemberLectureInfo> listLectureByMember(LectureSearch lectureSearch) {
        return  userMapper.listLectureByMember(lectureSearch);
    }

    @Override
    public User getUserWithStatChgByNo(UserSearch userSearch) {
        return userMapper.getUserWithStatChgByNo(userSearch);
    }



    @Override
    public List<User> listUserForNotificationHistory(UserSearch search) {
        return userMapper.listUserForNotificationHistory(search);
    }
}
