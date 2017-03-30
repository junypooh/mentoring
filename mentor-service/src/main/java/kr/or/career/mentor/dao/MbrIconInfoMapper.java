package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.MbrIconInfo;

import org.apache.ibatis.annotations.Param;


public interface MbrIconInfoMapper {

    /**
     * 회원 아이콘 종류 정보
     *
     * @param mbrNo
     * @param iconKindCd
     * @return
     */
    MbrIconInfo getMbrIconInfo(@Param("mbrNo") String mbrNo, @Param("iconKindCd") String iconKindCd);


    /**
     * 회원 아이콘 종류 정보 저장
     *
     * @param mbrIconInfo
     * @return
     */
    int mergeMbrIconInfo(MbrIconInfo mbrIconInfo);

}
