package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

@Data
public class BnrInfo extends Base{
    private Integer bnrSer;
    private String bnrNm;
    private String bnrImgUrl;
    private String bnrLinkUrl;
    private Integer dispSeq;
    private String useYn;
    private Date regDtm;
    private String regMbrNo;
    private String regMbrNm;
    private String bnrZoneCd;
    private String bnrZoneNm;
    private String bnrTypeCd;
    private String bnrTypeNm;
    private String bnrDesc;
    private String site;
}
