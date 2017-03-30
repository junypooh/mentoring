package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.MbrProfScrpInfo;

import org.apache.ibatis.annotations.Param;


public interface MbrProfScrpInfoMapper {

    List<MbrProfScrpInfo> listMbrProfScrpInfoBy(@Param("mbrNo") String mbrNo, @Param("scrpClassCd") String scrpClassCd);


    int insertMbrProfScrpInfo(MbrProfScrpInfo mbrProfScrpInfo);


    int updateMbrProfScrpInfo(MbrProfScrpInfo eachObj);


    int deleteMbrProfScrpInfoBy(@Param("mbrNo") String mbrNo);

}
