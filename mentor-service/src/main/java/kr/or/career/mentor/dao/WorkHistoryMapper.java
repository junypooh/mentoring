package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.WorkInfo;

import java.util.List;

/**
 * Created by chaos on 2016. 8. 23..
 */
public interface WorkHistoryMapper {
    int saveWorkHistory(WorkInfo workInfo);

    void saveWorkInfo(WorkInfo workInfo);

    List<WorkInfo> selectWorkHistList(WorkInfo workInfo);
}
