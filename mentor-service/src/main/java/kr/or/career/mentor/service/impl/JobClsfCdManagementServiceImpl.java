package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.JobClsfCdMapper;
import kr.or.career.mentor.dao.JobInfoMapper;
import kr.or.career.mentor.domain.JobClsfCd;
import kr.or.career.mentor.domain.JobInfo;
import kr.or.career.mentor.service.JobClsfCdManagementService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class JobClsfCdManagementServiceImpl implements JobClsfCdManagementService {

    @Autowired
    private JobClsfCdMapper jobClsfCdMapper;

    @Autowired
    private JobInfoMapper jobInfoMapper;


    @Override
    public List<JobClsfCd> listJobClsfCd(JobClsfCd jobClsfCd) {
        return jobClsfCdMapper.listJobClsfCd(jobClsfCd);
    }


    @Override
    public List<JobInfo> listJobInfo(JobInfo jobInfo) {
        return jobInfoMapper.listJobInfo(jobInfo);
    }


    @Override
    public List<JobClsfCd> listJobClsfCdByJobNo(String jobNo) {
        return jobInfoMapper.listJobClsfCdByJobNo(jobNo);
    }


    @Override
    public List<JobInfo> saveJobInfo(JobInfo jobInfo) {
        List<JobInfo> jobInfos = jobInfoMapper.selectJobInfo(jobInfo);
        if(jobInfos.size() == 0)
            jobInfoMapper.insertJobInfo(jobInfo);
        return jobInfos;
    }

    @Override
    public List<JobInfo> getJobInfo(JobInfo jobInfo) {
        return jobInfoMapper.getJobInfo(jobInfo);
    }

    @Override
    public String registJobInfo(JobInfo jobInfo) {
        String rtnStr = "FAIL";
        // 중복데이터인지 체크
        List<JobInfo> jobInfos = jobInfoMapper.getJobInfo(jobInfo);
        if(jobInfos.size() == 0) {
            jobInfo.setJobClsfCd(jobInfo.getJobClsfCdLv3());
            int insChk = jobInfoMapper.insertJobInfo(jobInfo);
            if(insChk > 0){
                rtnStr = "SUCCESS";
            }
        }else{
            rtnStr = "OVERLAP";
        }
        return rtnStr;
    }

    @Override
    public String updateJobInfo(JobInfo jobInfo) {
        String rtnStr = "FAIL";
        // 기존 데이터와 동일한지 체크
        List<JobInfo> jobInfoChk = jobInfoMapper.getJobInfo(jobInfo);
        if(jobInfoChk.size() == 1){
            rtnStr = "SUCCESS";
        }else{
            // 기존 데이터와 다르다면 직업명이 중복인지 체크
            String jobInfoTemp = jobInfo.getJobNo();
            jobInfo.setJobNo("");
            List<JobInfo> jobInfos = jobInfoMapper.getJobInfo(jobInfo);
            if(jobInfos.size() == 0){
                jobInfo.setJobNo(jobInfoTemp);
                jobInfo.setJobClsfCd(jobInfo.getJobClsfCdLv3());
                if(StringUtils.stripToNull(jobInfo.getJobNo()) != null){
                    int udtChk = jobInfoMapper.updateJobInfo(jobInfo);
                    if(udtChk > 0){
                        rtnStr = "SUCCESS";
                    }
                }
            }else{
                rtnStr = "OVERLAP";
            }
        }
        return rtnStr;
    }

    @Override
    public String deleteJobInfo(JobInfo jobInfo) {
        String rtnStr = "FAIL";
        if(StringUtils.stripToNull(jobInfo.getJobNo()) != null){
            // 해당직업명을 사용중인 멘토가 있는지 체크
            int useChk = jobInfoMapper.selectJobUseMentorCnt(jobInfo);
            if(useChk > 0){
                rtnStr = "OVERLAP";
            }else{
                int delCnk = jobInfoMapper.deleteJobInfo(jobInfo);
                if(delCnk > 0){
                    rtnStr = "SUCCESS";
                }
            }
        }
        return rtnStr;
    }

}
