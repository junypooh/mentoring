/* ntels */
package kr.or.career.mentor.util;

import java.util.ArrayList;

/**
 * <pre>
 * kr.or.career.mentor.hello.domain
 *    PagedList
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 19. 오후 9:58
 */
public class PagedList<E> extends ArrayList<E> {

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    private int totalCount = 0;


}
