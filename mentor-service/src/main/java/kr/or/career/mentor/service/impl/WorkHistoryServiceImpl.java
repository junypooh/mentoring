package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.WorkHistoryMapper;
import kr.or.career.mentor.domain.WorkInfo;
import kr.or.career.mentor.service.WorkHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      WorkHistoryServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-08-30 오후 1:04
 */
@Service
public class WorkHistoryServiceImpl implements WorkHistoryService {

    @Autowired
    private WorkHistoryMapper workHistoryMapper;

    @Override
    public List<WorkInfo> selectWorkHistList(WorkInfo workInfo) {
        return workHistoryMapper.selectWorkHistList(workInfo);
    }
}
