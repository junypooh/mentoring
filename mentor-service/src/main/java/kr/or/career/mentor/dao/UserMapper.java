package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;

import java.util.List;
import java.util.Map;

public interface UserMapper {

    User getUserByNo(String mbrNo);

    User getSupUserByNo(String mbrNo);

    User getUserWithStatChgByNo(UserSearch userSearch);

    List<User> retrieveUser(Map<String, String> param);

    List<User> listUserBy(UserSearch search);

    List<User> listUserForNotification(UserSearch search);

    List<Authority> findAuthoritiesByUserId(String userId);

    Integer updatePwd(User user);

    Integer updateStat(User user);

    Integer updateSecession(User user);

    Integer updateUser(User user);

    public int insertUser(User user);

    public int insertMbrAgrInfo(MbrAgrInfo mbrAgrInfo);

    public Integer saveProfPicInfo(MbrProfPicInfo mbrProfPicInfo);

    public Integer deleteProfPicInfo(MbrProfPicInfo mbrProfPicInfo);

    int insertMbrMapp(MbrMapp mbrMapp);

    List<String> belongingMentor(String posCoNo);

    int insertLoginHist(MbrLoginHist mbrLoginHist);

    int updateUserLoginDtm(User user);

    boolean isValidateId(String id);

    boolean isValidateEmail(String email);

    int upsertDeviceInfo(MbrDvcInfo deviceInfo);

    int deleteDeviceInfo(MbrDvcInfo deviceInfo);

    //화상회의 계정 생성일시
    int updateCnslStartDay(String mbrNo);

    public List<MemberLectureInfo> listLectureByMember(LectureSearch lectureSearch);

    int withDrawalUser(User user);

    List<User> listUserForNotificationHistory(UserSearch search);
}
