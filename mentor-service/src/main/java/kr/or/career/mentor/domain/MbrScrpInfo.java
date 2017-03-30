package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * 회원이 스크랩한 정보를 관리하는 VO 클래스
 * @author
 * @since
 * @version 1.0
 * @see
 *
 */

@Data
public class MbrScrpInfo {

	/** 스크랩 일련번호 */
	private	int	scripSer;
	/** 회원번호 */
	private	String	mbrNo;
	/** 스크랩 구분코드 */
	private	String	scrpClassCd;
	/** 스크랩 제목 */
	private	String	scrpTitle;
	/** 스크랩 URL */
	private	String	scrpUrl;
	/** 등록일시 */
	private	String	regDtm;

	private String	jobIntdcInfo;


}
