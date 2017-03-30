package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.ComFileInfo;

public interface ComFileInfoMapper {

  public List<ComFileInfo> getComFileList(ComFileInfo comFileInfo);
  public int registComFileInfo(ComFileInfo comFileInfo);
  public int deleteComFileInfo(ComFileInfo comFileInfo);

}
