package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.MbrJobChrstcInfo;

import org.apache.ibatis.annotations.Param;


public interface MbrJobChrstcInfoMapper {

    List<MbrJobChrstcInfo> listMbrJobChrstcInfoBy(@Param("mbrNo") String mbrNo);


    int insertMbrJobChrstcInfo(MbrJobChrstcInfo mbrJobChrstcInfo);


    int deleteMbrJobChrstcInfosBy(@Param("mbrNo") String mbrNo, @Param("jobChrstcCd") String jobChrstcCd);

}
