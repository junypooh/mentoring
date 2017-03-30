/*
 * Copyright ntels.com.,LTD.
 * All rights reserved.
 * 
 * This software is the confidential and proprietary information
 * of ntels.com.,LTD. ("Confidential Information").
 */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SearchOption
 *
 * 	공통적으로 사용되는 검색 조건
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 14. 오후 10:55
 */
@Data
public class SearchOption extends Base{

    /**
     * 검색어 설정
     */
    String keyword;
    /**
     * 검색어 분류
     */
    String classfication;
    /**
     * 검색조건 시작일
     */
    Date fromDate;
    /**
     * 검색조건 종료일
     */
    Date toDate;

}
