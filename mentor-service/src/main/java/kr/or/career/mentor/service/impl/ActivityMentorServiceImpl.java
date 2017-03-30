package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.ActivityMentorMapper;
import kr.or.career.mentor.domain.ActivityMentorInfo;
import kr.or.career.mentor.service.ActivityMentorService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      ActivityMentorServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-21 오후 3:46
 */
@Service
@Slf4j
public class ActivityMentorServiceImpl implements ActivityMentorService {

    @Autowired
    private ActivityMentorMapper activityMentorMapper;

    @Override
    public List<ActivityMentorInfo> selectActivityMentors(ActivityMentorInfo activityMentorInfo) {
        return activityMentorMapper.selectActivityMentors(activityMentorInfo);
    }
}
