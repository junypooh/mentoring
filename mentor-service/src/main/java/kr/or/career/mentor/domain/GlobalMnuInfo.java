package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      GlobalMnuInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-08 오후 3:42
 */
@Data
public class GlobalMnuInfo {

    private String mnuId;
    private String supMnuId;
    private String mnuNm;
    private Integer dispSeq;
    private String scutYn;
    private String urlPttn;
    private String linkUrl;
    private List<GlobalMnuInfo> globalSubMnuInfos;
}
