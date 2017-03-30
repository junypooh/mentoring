package kr.or.career.mentor.dao;

import java.util.List;

import org.apache.poi.ss.formula.functions.T;

import kr.or.career.mentor.domain.ArclFileInfo;
import kr.or.career.mentor.domain.ArclInfo;

public interface ArclFileInfoMapper {

  public List<ArclFileInfo> getArclFileList(ArclInfo<T> arclInfo);
  public int registArclFileInfo(ArclFileInfo arclFileInfo);
  public int deleteArclFileInfo(ArclFileInfo arclFileInfo);

}
