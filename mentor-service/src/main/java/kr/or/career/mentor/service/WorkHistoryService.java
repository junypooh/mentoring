package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.WorkInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      WorkHistoryService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-08-30 오후 1:03
 */
public interface WorkHistoryService {

    List<WorkInfo> selectWorkHistList(WorkInfo workInfo);
}
