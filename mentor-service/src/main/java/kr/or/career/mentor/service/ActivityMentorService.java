package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.ActivityMentorInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      ActivityMentorService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-21 오후 3:39
 */
public interface ActivityMentorService {

    List<ActivityMentorInfo> selectActivityMentors(ActivityMentorInfo activityMentorInfo);
}
