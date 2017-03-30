/* license */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MyInterestDTO.java
 *
 * 	나의 관심정보 보기 내용 조회
 *
 * </pre>
 * @since   2015. 9. 24. 오후 4:53:54
 * @author  technear
 * @see
 */
@Data
public class MyInterestDTO extends MbrItrstInfo{

    private String lectSer;
    private String lectTims;
    private String schdSeq;
    private String lectTitle;
    private String fileSer;
    private String jobNm;
    private String nm;
    private String intdcInfo;
    /*
    String type;
    String key1;
    String key2;
    String key3;
    String title;
    String detail;
    Integer fileSer;
    String jobPicInfo;
    String mentorProfPicInfo;
    String jobNm;
    */
}
