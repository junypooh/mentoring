package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      AuthInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-29 오후 2:07
 */
@Data
public class AuthInfo extends Base {

    private String crudType;

    private String authCd;

    private String authDesc;

    private String authNm;

    private String authType;

    private String regMbrNo;

    private String regMbrNm;

    private Date regDtm;

    private String mbrClassCd;

    private String mbrCualfCd;

    private String authTargtId;

    private String[] mnuIds;

    private String mnuId;

    private String supMnuId;

    private String site;
}
