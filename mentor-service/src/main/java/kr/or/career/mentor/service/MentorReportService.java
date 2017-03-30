package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.MentorClassReportDTO;
import kr.or.career.mentor.domain.MentorReportDTO;

import java.util.List;

/**
 * Created by DaDa on 2016-05-24.
 */
public interface MentorReportService {

    /* 멘토목록 조회 */
    List<MentorReportDTO> selectMentorList(LectureSearch lectureSearch);

    /* 멘토별 수업목록 조회 */
    List<MentorClassReportDTO> selectMentorClassList(LectureSearch lectureSearch);
}
