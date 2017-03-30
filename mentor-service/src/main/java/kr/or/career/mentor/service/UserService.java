package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.view.APIRepsonse;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;

/**
 * Created by chaos on 15. 8. 31..
 */

public interface UserService {

    public User retrieveUser(Map<String,String> param) throws UsernameNotFoundException;

    public List<User> listUser(Map<String,String> param) throws UsernameNotFoundException;

    public List<User> listUserBy(UserSearch search);

    public List<User> listUserForNotification(UserSearch search);

    public User getUserByNo(String mbrNo);

    public User getSupUserByNo(String mbrNo);

    public MbrJobInfo getMbrJobInfoByMbrNo(String mbrNo);

    public List<MbrJobChrstcInfo> getMbrJobChrstcInfos(String mbrNo);

    public List<MbrProfPicInfo> listMbrProfPicInfoByMbrNo(String mbrNo);

    public MbrProfInfo getMbrProfInfoBy(String mbrNo);

    public List<MbrProfScrpInfo> listMbrProfScrpInfos(String mbrNo, String scrpClassCd);

    public List<User> retrieveUserByEmail(Map<String,String> param) throws UsernameNotFoundException;

    public List<Authority> findAuthoritiesByUserId(String userId) throws UsernameNotFoundException;

    public List<MbrAgrInfo> listMbrAgrInfo(String mbrNo, String agrClassCd);

    public MbrIconInfo getMbrIconInfo(String mbrNo, String iconKindCd);

    public int updatePwd(User user);

    public int updatePwd(User user, String newPwd) throws Exception ;

    public int updateUser(User user) throws Exception;

    public int updateUserAndEmailAgree(User user) throws Exception;

    public int updateUserAgrees(User user);

    public void updateJobAndProfile(User user);

    public int updateSecession(User user) throws Exception;

    public String updatePwdRandom(User user) throws Exception ;

    public String updatePwdRandom(List<User> user) throws Exception ;

    public boolean emailValidate(String email);

    public boolean idValidate(String id);

    public int insertUser(User user) throws Exception;

    public void saveManager(User user);

    public void saveCorporationMentor(User user);

    public void updateCorporationMentor(User user);

    public void updateSchoolMember(User user);

    public void updateMentorMember(User user);

    public int approveUser(User user) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException;

    public int saveProfPicInfo(MbrProfPicInfo mbrProfPicInfo);

    public int deleteProfPicInfo(MbrProfPicInfo mbrProfPicInfo);

    public MbrRelMapp getMbrRelMappByTargt(String targtMbrNo);

    public boolean isValidateId(String id);

    public boolean isValidateEmail(String email);

    APIRepsonse syncCnetUser(User user);

    public CoInfo retrieveCoInfoByUser(User user) throws Exception;

    int mergeMbrAgrInfo(String mbrNo,String agrClassCd);

    int deleteMbrAgrInfo(String mbrNo,String agrClassCd);

    int upsertDeviceInfo(MbrDvcInfo deviceInfo);

    int deleteDeviceInfo(MbrDvcInfo deviceInfo);

    public List<MemberLectureInfo> listLectureByMember(LectureSearch lectureSearch);

    public User getUserWithStatChgByNo(UserSearch userSearch);

    public List<User> listUserForNotificationHistory(UserSearch search);

}
