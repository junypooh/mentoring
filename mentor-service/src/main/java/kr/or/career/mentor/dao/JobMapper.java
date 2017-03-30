package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface JobMapper {

    /**
     * 직업 기준의 검색 결과
     *
     * @param search
     * @return
     */
    List<JobInfo> listJobInfoWithMento(MentorSearch search);

    /**
     * 멘토 위주의 검색결과
     *
     * @param search
     * @return
     */
    List<JobInfo> listJobInfoFromMentor(MentorSearch search);

    /**
     * 직업 상세 정보
     *
     * @param jobNo
     * @return
     */
    JobInfo getJobInfo(String jobNo);

    /**
     * 직업의 멘토가 작성한 뉴스 정보
     *
     * @param jobNo
     * @param scrpClassCd
     * @return
     */
    List<Object> listScrpInfoByJob(@Param("jobNo") String jobNo, @Param("scrpClassCd") String scrpClassCd);

    /**
     * 관련 멘토 정보
     *
     * @param search
     * @return
     */
    List<MentorDTO> listRelationMentor(MentorSearch search);

    /**
     * 관련 수업 정보
     *
     * @param search
     * @return
     */
    List<LectureDTO> listRelationLecture(MentorSearch search);

    /**
     * 추천 직업 목록
     *
     * @return
     */
    List<JobInfo> listRecomJobInfo();

    /**
     * 1차직업분류 조회
     *
     * @return
     */
    List<JobClsfDTO> jobListCode();

    /**
     * 직업 그룹별 목록
     *
     * @param search
     * @return
     */
    List<JobInfo> listJobInfoFromGroup(MentorSearch search);

}
