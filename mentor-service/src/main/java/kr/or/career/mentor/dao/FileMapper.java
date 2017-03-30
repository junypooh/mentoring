package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;

import java.util.List;

public interface FileMapper {
    public int insertFileInfs(List<FileInfo> fileList);
    public int insertFileInfo(FileInfo fileList);
    public FileInfo retrieveFile(FileInfo fileInfo);

    //게시판의 첨부파일 정보를 조회
    public List<ArclFileInfo> listArclFileInfo(ArclFileInfo arclFileInfo);

    public int insertArclFileInfo(ArclFileInfo arclFileInfo);

    public int deleteArclFileInfoByArclSer(ArclFileInfo arclFileInfo);

    public int deleteArclFileInfoExclude(ArclInfo arclInfo);

    public List<LectPicInfo> listLectPicInfo(LectPicInfo lectPicInfo);

    public int insertLectPicInfo(LectPicInfo lectPicInfo);

    public int deleteLectPicInfoExclude(LectInfo lectInfo);

    public int incrementFileDwCnt(Integer fileSer);

    public int deleteLectPicInfoFile(LectInfo delLectInfo);

    public int deleteLectComFileInfo(LectInfo delLectInfo);

    int updateFile(FileInfo fileInfo);
}
