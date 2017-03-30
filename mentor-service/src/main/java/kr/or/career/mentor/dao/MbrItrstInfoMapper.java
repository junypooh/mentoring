package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.MbrItrstInfo;
import kr.or.career.mentor.domain.MyInterestDTO;

import org.apache.ibatis.annotations.Param;

/**
 * 회원 관심 분야 검색
 *
 * @author dnekfl77
 */
public interface MbrItrstInfoMapper {

    /**
     * 등록 관심분야 정보
     *
     * @param mbrNo
     * @param itrstTargtCd
     * @param itrstTargtNo
     * @return
     */
    MbrItrstInfo getMbrItrstInfo(@Param("mbrNo") String mbrNo, @Param("itrstTargtCd") String itrstTargtCd,
            @Param("itrstTargtNo") String itrstTargtNo);

    /**
     * 나의 등록 관심 분야 목록
     *
     * @param mbrItrstInfo
     * @return
     */
    @Deprecated
    List<MyInterestDTO> listMyInterest(MbrItrstInfo mbrItrstInfo);

    /**
     * 나의 등록 관심 분야 목록
     *
     * @param mbrItrstInfo
     * @return
     */
    List<MyInterestDTO> listMyInterestLecture(MbrItrstInfo mbrItrstInfo);

    /**
     * 나의 등록 관심 분야 목록
     *
     * @param mbrItrstInfo
     * @return
     */
    List<MyInterestDTO> listMyInterestMentor(MbrItrstInfo mbrItrstInfo);

    /**
     * 관심분야 추가
     *
     * @param mbrItrstInfo
     * @return
     */
    int insertMbrItrstInfo(MbrItrstInfo mbrItrstInfo);

    /**
     * 관심분야 삭제
     *
     * @param mbrItrstInfo
     * @return
     */
    int deleteMyInterest(MbrItrstInfo mbrItrstInfo);

}
