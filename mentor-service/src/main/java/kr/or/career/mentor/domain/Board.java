/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import java.sql.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    Board
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 20. 오후 8:31
 */
@Alias("Board")
@Data
public class Board<T> extends Base{

    private String boardId;

    private String boardKindCd;

    private String boardNm;

    private String boardDesc;

    private int pageCnt;

    private int listCnt;

    private boolean useYn;

    private Date regDtm;

    private String regMbrId;

    private Date chgDtm;

    private String chgMbrId;

    /**
     * 공통적으로 사용되는 검색조건
     */
    private T searchOption;
}
