package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.StatChgHistInfo;
import kr.or.career.mentor.domain.UserSearch;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *      StatChgHistMapper
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-11 오후 2:02
 */
public interface StatChgHistMapper {

    Integer insertStatChgHistInfo(StatChgHistInfo statChgHistInfo);

    List<StatChgHistInfo> getStatChgHistByMbrNo(UserSearch userSearch);

    Integer updateStatChgHistLastStat(StatChgHistInfo statChgHistInfo);

    Integer insertStatChgHistSubmit(StatChgHistInfo statChgHistInfo);
}
