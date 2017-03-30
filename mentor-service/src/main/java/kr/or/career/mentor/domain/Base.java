/* license */
package kr.or.career.mentor.domain;

import java.io.Serializable;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    Base.java
 *
 * 	페이징 정보를 담고있는 클래스
 *
 * </pre>
 * @since   2015. 9. 16. 오후 2:10:27
 * @author  technear
 * @see
 */
@Data
public class Base implements Serializable{
    private int totalRecordCount = 0;
    private int currentPageNo = 1;
    private int recordCountPerPage = 10;
    private int rn;
    private int pageSize;
    private String gridRowId;
    /**
     * paging 여부를 결정한다.
     */
    private boolean pageable;

}
