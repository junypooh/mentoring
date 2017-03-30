package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.JobClsfCd;
import kr.or.career.mentor.domain.JobInfo;

import java.util.List;


public interface JobClsfCdManagementService {

    /**
     * 직업 분류 코드 목록
     *
     * @param jobClsfCd
     * @return
     */
    List<JobClsfCd> listJobClsfCd(JobClsfCd jobClsfCd);


    /**
     * 직업정보 목록
     *
     * @param jobInfo
     * @return
     */
    List<JobInfo> listJobInfo(JobInfo jobInfo);


    /**
     * 직업 번호로 상위 직업코드 얻음
     *
     * @param jobNo
     * @return
     */
    List<JobClsfCd> listJobClsfCdByJobNo(String jobNo);


    /**
     * 직업정보 등록
     *
     * @param jobInfo
     * @return
     */
    List<JobInfo> saveJobInfo(JobInfo jobInfo);

    /**
     * 관리자 > 운영관리 > 직업관리
     * 직업정보 리스트 조회
     *
     * @param jobInfo
     * @return
     */
    List<JobInfo> getJobInfo(JobInfo jobInfo);

    /**
     * 관리자 > 운영관리 > 직업관리
     * 직업정보 등록
     *
     * @param jobInfo
     * @return
     */
    String registJobInfo(JobInfo jobInfo);

    /**
     * 관리자 > 운영관리 > 직업관리
     * 직업정보 수정
     *
     * @param jobInfo
     * @return
     */
    String updateJobInfo(JobInfo jobInfo);

    /**
     * 관리자 > 운영관리 > 직업관리
     * 직업정보 삭제
     *
     * @param jobInfo
     * @return
     */
    String deleteJobInfo(JobInfo jobInfo);

}
