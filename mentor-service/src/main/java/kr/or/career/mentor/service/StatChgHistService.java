package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.StatChgHistInfo;
import kr.or.career.mentor.domain.UserSearch;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      StatChgHistService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-11 오후 2:00
 */
public interface StatChgHistService {

    void insertStatChgHistInfo(StatChgHistInfo statChgHistInfo);

    List<StatChgHistInfo> getStatChgHistByMbrNo(UserSearch userSearch);

    void insertStatChgHistSubmit(StatChgHistInfo statChgHistInfo) throws Exception;
}
