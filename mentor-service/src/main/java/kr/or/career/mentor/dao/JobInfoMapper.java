package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.JobClsfCd;
import kr.or.career.mentor.domain.JobInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;


public interface JobInfoMapper {

    /**
     * 직업정보 목록
     *
     * @param jobInfo
     * @return
     */
    List<JobInfo> listJobInfo(JobInfo jobInfo);


    /**
     * 직업번호로 상위 직업정보 코드 목록 찾기
     *
     * @param jobNo
     * @return
     */
    List<JobClsfCd> listJobClsfCdByJobNo(@Param("jobNo") String jobNo);


    /**
     * 직업정보 등록
     *
     * @param jobInfo
     * @return
     */
    int insertJobInfo(JobInfo jobInfo);


    List<JobInfo> selectJobInfo(JobInfo jobInfo);

    /**
     * 관리자포탈 > 운영관리 > 직업관리
     * 리스트 조회
     *
     * @param jobInfo
     * @return
     */
    List<JobInfo> getJobInfo(JobInfo jobInfo);

    /**
     * 관리자포탈 > 운영관리 > 직업관리
     * 직업정보 수정
     *
     * @param jobInfo
     * @return
     */
    int updateJobInfo(JobInfo jobInfo);

    /**
     * 관리자포탈 > 운영관리 > 직업관리
     * 해당직업을 사용중인 멘토 유무 확인
     *
     * @param jobInfo
     * @return
     */
    int selectJobUseMentorCnt(JobInfo jobInfo);

    /**
     * 관리자포탈 > 운영관리 > 직업관리
     * 직업정보 삭제
     *
     * @param jobInfo
     * @return
     */
    int deleteJobInfo(JobInfo jobInfo);

}
