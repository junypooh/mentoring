package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.ActivityMentorInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *      ActivityMentorMapper
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-21 오후 3:47
 */
public interface ActivityMentorMapper {

    List<ActivityMentorInfo> selectActivityMentors(ActivityMentorInfo activityMentorInfo);
}
