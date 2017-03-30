package kr.or.career.mentor.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

import kr.or.career.mentor.domain.ArclFileInfo;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.FileInfo;
import kr.or.career.mentor.domain.LectInfo;
import kr.or.career.mentor.domain.LectPicInfo;

public interface FileManagementService {

    public void downloadFile(int fileSer, boolean origin,HttpServletRequest request, HttpServletResponse response) throws Exception;
    public void downloadFile(int arclSer, String boardId, HttpServletRequest request, HttpServletResponse response) throws Exception;

    public FileInfo fileProcess(MultipartFile mFile, String KeyStr) throws Exception;

    public FileInfo retrieveFile(FileInfo fileInfo) throws Exception;

    public List<ArclFileInfo> listArclFileInfo(ArclFileInfo arclFileInfo);

    public List<ArclFileInfo> insertArclFileInfo(ArclFileInfo arclFileInfo, List<MultipartFile> files) throws Exception;
    public List<ArclFileInfo> saveArclFileInfo(ArclInfo arclInfo, List<MultipartFile> files) throws Exception;

    public List<LectPicInfo> listLectPicInfo(LectPicInfo lectPicInfo);
    public List<LectPicInfo> saveLectPicInfo(LectInfo lectInfo, List<MultipartFile> files) throws Exception;

    public int insertArclFileInfo(ArclFileInfo arclFileInfo)throws Exception;

    int updateFileInfo(FileInfo fileInfo);

}
