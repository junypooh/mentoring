/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import java.sql.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    Artcle
 *
 * 	DataBase의 게시글에 해당하는 Domain
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 20. 오후 8:48
 */
@Data
@Alias("Article")
public class Article<T> extends Base{
    private Date ansChgDtm;
    private String ansChgMbrNo;
    private Date ansRegDtm;
    private String ansRegMbrNo;
    private long arclSer;
    private String boardId;
    private Date chgDtm;
    private String chgMbrNo;
    private String cntntsApiPath;
    private String cntntsDay;
    private String cntntsId;
    private String cntntsSmryInfo;
    private String cntntsSust;
    private String cntntsTargtCd;
    private String cntntsTargtId;
    private String cntntsTargtNm;
    private String cntntsTargtNo;
    private String cntntsTypeCd;
    private String expsTargtCd;
    private char mrArclYn;
    private char notiYn;
    private String prefNo;
    private int rcnt;
    private char recomYn;
    private Date regDtm;
    private String regMbrNo;
    private char rssPubYn;
    private char scrtArclYn;
    private String subTitle;
    private long supArclSer;
    private String sust;
    private String title;
    private char useYn;
    private int vcnt;

    /**
     * Article 도메인으로 조회한 결과값을 담는다.
     */
    private T result;

    /**
     * 공통적으로 사용되는 검색조건
     */
    private T searchOption;
}
