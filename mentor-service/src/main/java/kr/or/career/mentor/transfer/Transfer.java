/* ntels */
package kr.or.career.mentor.transfer;

import com.google.common.util.concurrent.FutureCallback;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    invokeTransfer
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 27. 오후 2:19
 */
public interface Transfer<T> {

    void transfer(List<T> messages,FutureCallback<T> callback, Integer msgSer);

}
