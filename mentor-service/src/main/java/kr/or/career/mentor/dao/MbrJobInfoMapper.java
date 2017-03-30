package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.MbrJobInfo;

import org.apache.ibatis.annotations.Param;


public interface MbrJobInfoMapper {

    /**
     * 회원 직업정보
     *
     * @param mbrNo
     * @return
     */
    MbrJobInfo getMbrJobInfoByMbrNo(@Param("mbrNo") String mbrNo);


    /**
     * 회원 직업정보 등록
     *
     * @param mbrJobInfo
     * @return
     */
    int insertMbrJobInfo(MbrJobInfo mbrJobInfo);


    /**
     * 회원 직업정보 수정 및 등록
     *
     * @param mbrJobInfo
     * @return
     */
    int mergeMbrJobInfo(MbrJobInfo mbrJobInfo);

}
