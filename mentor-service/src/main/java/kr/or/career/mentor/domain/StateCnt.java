/* license */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    StateCnt.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 28. 오후 6:16:00
 * @author  technear
 * @see
 */
@Data
public class StateCnt extends Base{

    /*101541    수업요청*/
    private String st101542;
    /*101541    수강모집*/
    private String st101543;
    /*101541    모집마감*/
    private String st101544;
    /*101541    수업예정*/
    private String st101548;
    /*101541    수업대기*/
    private String st101549;
    /*101541    수업중*/
    private String st101550;
    /*101541    수업완료*/
    private String st101551;
    /*101541    승인반려*/
    private String st101562;
}
