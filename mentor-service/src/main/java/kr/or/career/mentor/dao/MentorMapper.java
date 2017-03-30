package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface MentorMapper {

    /**
     *
     * <pre>
     * 멘토 직업목록
     * </pre>
     *
     * @param mentorSearch
     * @return
     */
    public List<JobInfo> listJobIntroduce(MentorSearch mentorSearch);

    /**
     *
     * <pre>
     * 멘토 직업목록 전체개수
     * </pre>
     *
     * @param mentorSearch
     * @return
     */
    public int listJobIntroduceCnt(MentorSearch mentorSearch);

    /**
     *
     * <pre>
     * 멘토 직업 상세
     * </pre>
     *
     * @param jobInfo
     * @return
     */
    public JobInfo viewDetailJobIntroduce(JobInfo jobInfo);

    /**
     *
     * <pre>
     * 직업관련 멘토
     * </pre>
     *
     * @param jobInfo
     * @return
     */
    public List<User> listRelationMentorInfo(JobInfo jobInfo);

    /**
     *
     * <pre>
     * 직업 관련정보
     * </pre>
     *
     * @param jobInfo
     * @return
     */
    public List<MbrScrpInfo> listRelationData(JobInfo jobInfo);

    /**
     *
     * <pre>
     * 해당 Method설명
     * </pre>
     *
     * @param jobInfo
     * @return
     */
    public List<User> tabRelationMentor(JobInfo jobInfo);

    /**
     * 관련멘토목록
     */
    public List<Map<String, Object>> listRelationMentor(User user);

    /**
     * 멘토소개목록
     */
    public List<User> listMentorIntroduce(MentorSearch mentorSearch);

    /**
     * 멘토 상세정보
     */
    public User viewDetailMentorInfo(User user);

    /**
     * 멘토조회목록
     */
    public List<Map<String, Object>> listMentorSelect(User user);

    /**
     * 관심멘토 등록
     */
    public Integer insertInterestMentor(User user);

    /**
     *
     * <pre>
     * 멘토 등록
     * </pre>
     *
     * @param user
     * @return
     */
    public Integer insertMentor(User user);

    /**
     *
     * <pre>
     * 멘토직업정보 등록
     * </pre>
     *
     * @param mbrJobInfo
     * @return
     */
    public Integer insertMentorJob(MbrJobInfo mbrJobInfo);

    /**
     *
     * <pre>
     * 멘토 프로파일 정보 등록
     * </pre>
     *
     * @param mbrProfInfo
     * @return
     */
    public Integer insertMentorProfile(MbrProfInfo mbrProfInfo);

    /**
     *
     * <pre>
     * 멘토프로파일사진정보 등록
     * </pre>
     *
     * @param mbrProfPicInfo
     * @return
     */
    public Integer insertMentorProfilePicture(MbrProfPicInfo mbrProfPicInfo);

    /**
     *
     * <pre>
     * 멘토 정보 수정
     * </pre>
     *
     * @param user
     * @return
     */
    public Integer updateMentor(User user);

    /**
     *
     * <pre>
     * 멘토 직업정보 수정
     * </pre>
     *
     * @param mbrJobInfo
     * @return
     */
    public Integer updateMentorJobInfo(MbrJobInfo mbrJobInfo);

    /**
     *
     * <pre>
     * 멘토프로파일 정보 수정
     * </pre>
     *
     * @param mbrProfInfo
     * @return
     */
    public Integer updateMentorProfile(MbrProfInfo mbrProfInfo);

    /**
     *
     * <pre>
     * 멘토프로파일사진정보 수정
     * </pre>
     *
     * @param mbrProfPicInfo
     * @return
     */
    public Integer updateMentorProfilePicture(MbrProfPicInfo mbrProfPicInfo);


    /** 재 작업 ==================================================================== */
    /**
     * 멘토 목록 정보
     *
     * @param search
     * @return
     */
    public List<MentorDTO> listMentorInfo(MentorSearch search);

    /**
     * 멘토 정보
     *
     * @param mbrNo
     * @return
     */
    public MentorDTO getMentorInfoBy(@Param("mbrNo") String mbrNo);

    /**
     * <pre>
     *     소속멘토 목록조회
     * </pre>
     * @param mentorSearch
     * @return
     */
    List<MentorDTO> listBelongMentor(MentorSearch mentorSearch);

    public List<ApprovalDTO> listMentorApproval(ApprovalDTO approvalDTO);

    public int updateMbrStatCd(ApprovalDTO approvalDTO);

    public List<ApprovalDTO> listALiveLecture(String mbrNo);

    public List<ApprovalDTO> listMentorApprovalCnt(ApprovalDTO approvalDTO);

    /**
     * 관리자- 멘토목록조회
     * @param search
     * @return
     */
    List<MentorDTO> allMentorList(UserSearch search);


    /**
     * 멘토포탈 - 켄토소개 메인
     * @param mentorSearch
     * @return
     */
    List<MentorDTO> selectMentorIntroduce(MentorSearch mentorSearch);

    /**
     * 멘토포탈 - 관련멘토 조회
     * @param mentorSearch
     * @return
     */
    List<MentorDTO> selectMentorRelation(MentorSearch mentorSearch);


}
