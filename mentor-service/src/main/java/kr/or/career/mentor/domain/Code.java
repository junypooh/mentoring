package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class Code extends Base{
    private String cd;
    private String supCd;
    private String cdNm;
    private String cdDesc;
    private String cdClsfInfo;
    private int dispSeq;
    private String rmk;
    private String userDef1Info;
    private String userDef2Info;
    private String userDef3Info;
    private String useYn;
    private String regDtm;
    private String regMbrNo;
    private String chgDtm;
    private String chgMbrNo;

}
