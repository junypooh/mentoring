/* license */
package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.ClasSetHist;
import kr.or.career.mentor.domain.CoInfo;
import kr.or.career.mentor.domain.Code;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    CodeMapper.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 17. 오후 2:22:01
 * @author  technear
 * @see
 */
public interface CodeMapper {
    public List<Code> listCode(Code code);
    public Code retrieveCode(String cd);
    public List<Code> listCodeWithPaging(Code code);
    public Integer saveCode(Code code);
    public Integer insertCode(Code code);
    public Integer updateCode(Code code);
    public ClasSetHist retrieveClasSetHist();
    public Integer insertClasSetHist(ClasSetHist clasSetHist);
    public List<Code> listSchSgguNm();
    public Integer deleteCode(Code code);
}
