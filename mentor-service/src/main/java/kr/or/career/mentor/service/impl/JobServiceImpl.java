package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.JobMapper;
import kr.or.career.mentor.domain.JobClsfDTO;
import kr.or.career.mentor.domain.JobInfo;
import kr.or.career.mentor.domain.MentorSearch;
import kr.or.career.mentor.service.JobService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class JobServiceImpl implements JobService {

    @Autowired
    private JobMapper jobMapper;

    @Override
    public List<JobInfo> listJobInfoBy(MentorSearch search) {

        //@formatter:off
        if (search != null
                && (StringUtils.isNotBlank(search.getSearchKey())
                        || StringUtils.isNotBlank(search.getJobClsfCd())
                        || CollectionUtils.isNotEmpty(search.getChrstcClsfCds()))) {
        //@formatter:on
            return jobMapper.listJobInfoFromMentor(search);
        }
        else {
            return jobMapper.listJobInfoWithMento(search);
        }
    }

    @Override
    public List<JobClsfDTO> jobListCode() {
        return jobMapper.jobListCode();
    }

    @Override
    public List<JobInfo> listJobInfo(MentorSearch search) {
        //@formatter:off
        if (search != null
                && (StringUtils.isNotBlank(search.getSearchKey())
                || StringUtils.isNotBlank(search.getJobClsfCd())
                || CollectionUtils.isNotEmpty(search.getChrstcClsfCds()))) {
            //@formatter:on
            return jobMapper.listJobInfoFromGroup(search);
        }
        else {
            return jobMapper.listJobInfoWithMento(search);
        }
    }
}
