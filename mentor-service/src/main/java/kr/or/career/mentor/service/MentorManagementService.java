package kr.or.career.mentor.service;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import kr.or.career.mentor.domain.*;


/**
 * Created by chan on 15. 9. 15..
 */

public interface MentorManagementService {

    // **** =============================================================================== ****//
    // **** TODO 정리후 삭제 (재작업 **** //
    // **** =============================================================================== ****//
    /**
     * <pre> 멘토 직업목록 </pre>
     *
     * @param
     * @return
     * @throws Exception
     */
    List<JobInfo> listJobInfoFromMentor(MentorSearch search);


    /**
     * <pre> 추천 직업 목록 </pre>
     *
     * @param
     * @return
     */
    List<JobInfo> listRecomJobInfo();


    /**
     * <pre> Mentor 조회 </pre>
     *
     * @param search
     * @return
     */
    List<MentorDTO> listMentorInfo(MentorSearch search);


    /**
     *
     * <pre> 유망멘토저장 </pre>
     *
     * @param listMngrRecomInfo
     * @return
     */
    int saveHofefulMentors(List<MngrRecomInfo> listMngrRecomInfo);


    /**
     * <pre> 소속멘토 목록조회 </pre>
     *
     * @param mentorSearch
     * @return
     * @throws Exception
     */
    List<MentorDTO> listBelongMentor(MentorSearch mentorSearch);


    List<ApprovalDTO> listMentorApproval(ApprovalDTO approvalDTO, User user);


    List<ApprovalDTO> listMentorApprovalCnt(User user);


    /**
     * 멘토 회원 탈퇴
     *
     * @see kr.or.career.mentor.service.MentorManagementService#secede(kr.or.career.mentor.domain.ApprovalDTO)
     * @param approvalDTO
     * @return
     * @throws Exception
     */
    int secede(ApprovalDTO approvalDTO) throws Exception;


    /**
     * 개인멘토를 승인해줌
     *
     * @see kr.or.career.mentor.service.MentorManagementService#mentorApproval(kr.or.career.mentor.domain.ApprovalDTO)
     * @param approvalDTO
     * @return
     */
    int mentorApproval(ApprovalDTO approvalDTO)  throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException ;

    /**
     * <pre> 소속멘토 등록 </pre>
     *
     * @param mentor
     * @param target
     */
    void saveBelongMentor(User mentor, User target) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException;


    /**
     * 소속 멘토 기본 정보 수정
     *
     * @param mentor
     */
    void updateBelongMentorBase(User mentor);


    /**
     * 소속 멘토 직업 정보 수정
     *
     * @param user
     */
    void updateBelongMentorJob(User user);


    /**
     * 멘토 프로필 정보 수정
     *
     * @param user
     */
    void updateBelongMentorProfile(User user);

    /**
     * 관리자- 멘토목록조회
     * @param search
     * @return
     */
    List<MentorDTO> allMentorList(UserSearch search);
}
