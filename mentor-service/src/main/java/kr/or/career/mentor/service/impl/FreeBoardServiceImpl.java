package kr.or.career.mentor.service.impl;

import java.util.List;

import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.career.mentor.dao.FreeBoardMapper;
import kr.or.career.mentor.domain.ArclCmtInfo;
import kr.or.career.mentor.domain.ArclCmtInfoRS;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.ArclInfoRS;
import kr.or.career.mentor.service.FreeBoardService;

@Service
public class FreeBoardServiceImpl implements FreeBoardService {

  @Autowired
  private FreeBoardMapper freeBoardMapper;

  @Override
  public List<ArclInfoRS> getFreeBoardList(ArclInfoRS arclInfo) {
    return freeBoardMapper.getFreeBoardList(arclInfo);
  }

  @Override
  public int registArcl(ArclInfo<T> arclInfo) {
    return freeBoardMapper.registArcl(arclInfo);
  }

  @Override
  public int updateArcl(ArclInfo<T> arclInfo) {
    return freeBoardMapper.updateArcl(arclInfo);
  }

  @Override
  public int deleteArcl(ArclInfo<T> arclInfo) {
    return freeBoardMapper.deleteArcl(arclInfo);
  }

  @Override
  public List<ArclCmtInfoRS> getCmtInfoList(ArclCmtInfo arclCmtInfo) {
    return freeBoardMapper.getCmtInfoList(arclCmtInfo);
  }

  @Override
  public int registCmt(ArclCmtInfo arclCmtInfo) {
    return freeBoardMapper.registCmt(arclCmtInfo);
  }

  @Override
  public int deleteCmt(ArclCmtInfo arclCmtInfo) {
    return freeBoardMapper.deleteCmt(arclCmtInfo);
  }

}