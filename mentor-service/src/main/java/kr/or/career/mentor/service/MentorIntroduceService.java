package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.*;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      MentorIntroduceService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-01 오후 5:38
 */
public interface MentorIntroduceService {

    /**
     * <pre>
     *     학교포탈 - 멘토소개 조회
     * </pre>
     * @param mentorSearch
     * @return
     */
    List<MentorDTO> selectMentorIntroduce(MentorSearch mentorSearch);

    /**
     * <pre>
     *     학교포탈 - 멘토상세 조회
     * </pre>
     * @param mbrNo
     * @return
     */
    MentorDTO getMentorInfoBy(String mbrNo);

    /**
     * <pre>
     *     학교포탈 - 멘토상세 : 회원 직업 특성 정보 목록
     * </pre>
     * @param mbrNo
     * @return
     */
    List<MbrJobChrstcInfo> listMbrJobChrstcInfoBy(String mbrNo);

    /**
     * <pre>
     *     학교포탈 - 멘토상세 : 회원 프로필 정보
     * </pre>
     * @param mbrNo
     * @return
     */
    List<MbrProfPicInfo> listMbrProfPicInfoBy(String mbrNo);

    /**
     * <pre>
     *     학교포탈 - 멘토상세 : 회원 프로필 스크랩 정보 (뉴스, 인터뷰 등)
     * </pre>
     * @param mbrNo
     * @return
     */
    List<MbrProfScrpInfo> listMbrProfScrpInfoBy(String mbrNo);

    /**
     * <pre>
     *     학교포탈 - 멘토상세 : 관련멘토 조회
     * </pre>
     * @param mentorSearch
     * @return
     */
    List<MentorDTO> selectMentorRelation(MentorSearch mentorSearch);
}
