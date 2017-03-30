package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.ArclCmtInfo;
import kr.or.career.mentor.domain.ArclRecomHist;

public interface ArclCmtInfoMapper {

    public List<ArclCmtInfo>  getSimpleCmtInfoList(ArclCmtInfo arclCmtInfo);

    public List<ArclCmtInfo> getCmtInfoList(ArclCmtInfo arclCmtInfo);

    public int registCmt(ArclCmtInfo arclCmtInfo);

    public int updateCmt(ArclCmtInfo arclCmtInfo);

    public int deleteCmt(ArclCmtInfo arclCmtInfo);

    public int insertRecomHist(ArclRecomHist arclRecomHist);

    public int isGradeYn(ArclCmtInfo arclCmtInfo);

    public int isApplyedLecture(ArclCmtInfo arclCmtInfo);

}
