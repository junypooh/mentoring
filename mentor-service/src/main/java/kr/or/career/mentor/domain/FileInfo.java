package kr.or.career.mentor.domain;

import lombok.Data;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

@Data
public class FileInfo {
    private Integer fileSer;
    private String fileNm;
    private String filePath;
    private String fileSize;
    private String fileExt;
    private String fileMime;
    private String oriFileNm;
    private String useYn;
    private String regDtm;
    private String regMbrNo;
    private String chgDtm;
    private String chgMbrNo;
    private String dwCnt;
    private CommonsMultipartFile file;
    private String fileThumbPath;
}
