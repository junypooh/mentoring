package kr.or.career.mentor.service;

import java.util.List;

import org.apache.poi.ss.formula.functions.T;

import kr.or.career.mentor.domain.ArclCmtInfo;
import kr.or.career.mentor.domain.ArclCmtInfoRS;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.ArclInfoRS;

public interface FreeBoardService {

  public List<ArclInfoRS> getFreeBoardList(ArclInfoRS arclInfo);
  public int registArcl(ArclInfo<T> arclInfo);
  public int updateArcl(ArclInfo<T> arclInfo);
  public int deleteArcl(ArclInfo<T> arclInfo);
  public List<ArclCmtInfoRS>getCmtInfoList(ArclCmtInfo arclCmtInfo);
  public int registCmt(ArclCmtInfo arclCmtInfo);
  public int deleteCmt(ArclCmtInfo arclCmtInfo);

}
