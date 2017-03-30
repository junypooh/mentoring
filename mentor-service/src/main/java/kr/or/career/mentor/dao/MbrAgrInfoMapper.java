package kr.or.career.mentor.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.career.mentor.domain.MbrAgrInfo;

public interface MbrAgrInfoMapper {

    List<MbrAgrInfo> listMbrAgrInfo(@Param("mbrNo") String mbrNo, @Param("agrClassCd") String agrClassCd);

    int insertMbrAgrInfo(MbrAgrInfo mbrAgrInfo);

    int mergeMbrAgrInfo(@Param("mbrNo") String mbrNo, @Param("agrClassCd") String agrClassCd);

    int deleteMbrAgrInfo(@Param("mbrNo") String mbrNo, @Param("agrClassCd") String agrClassCd);

}
