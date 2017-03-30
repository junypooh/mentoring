/* ntels */
package kr.or.career.mentor.view;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.view
 *    APIRepsonse
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 21. 오전 11:47
 */
@Data
@AllArgsConstructor(staticName = "of")
public class APIRepsonse {

    //int statusCode;

    String success;

    //Object data;

    //public static APIRepsonse success(int statusCode,Object data) {
    //    return APIRepsonse.of(statusCode,null,data);
    //}

    //public static APIRepsonse failure(int statusCode,CodeMessage codeMessage) {
    //    return APIRepsonse.of(statusCode,codeMessage.toMessage(),null);
    //}

}
