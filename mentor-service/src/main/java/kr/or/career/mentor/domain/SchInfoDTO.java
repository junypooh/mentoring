/* license */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SchInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오전 9:38:56
 * @author technear
 * @see
 */
@Data
public class SchInfoDTO extends SchInfo {
    int classCnt;
    int teacherCnt;
    int studentCnt;
    String grpData;
}
