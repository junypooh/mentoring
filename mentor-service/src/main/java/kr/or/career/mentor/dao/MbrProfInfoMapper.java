package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.MbrProfInfo;

import org.apache.ibatis.annotations.Param;


public interface MbrProfInfoMapper {

    MbrProfInfo getMbrProfInfoBy(@Param("mbrNo") String mbrNo);


    int insertMbrProfInfo(MbrProfInfo mbrProfInfo);


    int mergeMbrProfInfo(MbrProfInfo mbrProfInfo);
}
