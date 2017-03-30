package kr.or.career.mentor.domain;

import java.io.Serializable;
import java.util.List;

import lombok.Data;

@Data
public class MnuInfo extends Base{
    /**
     * Field 설명
     */
    private static final long serialVersionUID = -7881502352929875430L;
    private String mnuId;
    private String supMnuId;
    private String mnuNm;
    private String linkUrl;
    private String linkMthdCd;
    private String scutYn;
    private String dispSeq;
    private String useYn;
    private String regDtm;
    private String regMbrNo;
    private String chgDtm;
    private String chgMbrNo;
    private List<MnuInfo> subMnuInfo;
}
