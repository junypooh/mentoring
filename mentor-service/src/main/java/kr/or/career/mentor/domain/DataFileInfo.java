package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      DataFileInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-22 오후 3:32
 */
@Data
public class DataFileInfo {
    private Integer dataSer;
    private Integer fileSer;
    private String regDtm;
    private String regMbrNo;
    private FileInfo fileInfo;

    private ComFileInfo comFileInfo;

}
