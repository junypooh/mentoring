package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.JobClsfDTO;
import kr.or.career.mentor.domain.JobInfo;
import kr.or.career.mentor.domain.MentorSearch;

import java.util.List;

/**
 * 직업관련 서비스
 *
 * @author dnekfl77
 */
public interface JobService {

    /**
     * 직업 목록 검색
     *
     * @param search
     * @return
     */
    List<JobInfo> listJobInfoBy(MentorSearch search);

    /**
     * 직업 코드 목록
     *
     * @return
     */
    List<JobClsfDTO> jobListCode();

    /**
     * 멘토 > 직업소개 리스트 조회
     *
     * @param search
     * @return
     */
    List<JobInfo> listJobInfo(MentorSearch search);



}
