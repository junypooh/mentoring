package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.MbrProfPicInfo;

import org.apache.ibatis.annotations.Param;


public interface MbrProfPicInfoMapper {

    List<MbrProfPicInfo> listMbrProfPicInfoBy(@Param("mbrNo") String mbrNo);


    int insertMbrProfPicInfo(MbrProfPicInfo mbrProfPicInfo);


    int deleteMbrProfPicInfosBy(@Param("mbrNo") String mbrNo);
}
