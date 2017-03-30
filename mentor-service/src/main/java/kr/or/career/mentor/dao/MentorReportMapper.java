/* license */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;

import java.util.List;


/**
 * <pre>
 * kr.or.career.mentor.dao
 *    MentorReportMapper.java
 *
 * 	class의 기능을 설명한다.
 *
 * 관리자포탈 > 통계 > 멘토리포트
 *
 * </pre>
 * @since   2016. 05. 24. 오전 10:35:35
 * @author
 * @see
 */
public interface MentorReportMapper {

    /* 멘토목록 조회 */
    List<MentorReportDTO> selectMentorList(LectureSearch lectureSearch);

    /* 멘토별 수업목록 조회 */
    List<MentorClassReportDTO> selectMentorClassList(LectureSearch lectureSearch);


}
