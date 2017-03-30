package kr.or.career.mentor.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.career.mentor.domain.JobInfo;
import kr.or.career.mentor.domain.MbrJobInfo;
import kr.or.career.mentor.domain.MbrProfInfo;
import kr.or.career.mentor.domain.MbrProfPicInfo;
import kr.or.career.mentor.domain.MentorSearch;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.util.PagedList;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
//@ActiveProfiles("jpa")
public class MentorManagementServiceTest {

    public static final Logger log = LoggerFactory.getLogger(MentorManagementServiceTest.class);


	@Autowired
    protected MentorManagementService mentorService;


    /**
     * 멘토 작업 목록
     */
    @Test
	public void listJobIntroduce() throws Exception  {

    	MentorSearch mentorSearch = new MentorSearch();

    	/* 검색 조건 */
    	mentorSearch.setSearchType("mentor");
    	mentorSearch.setSearchKey("멘토");

    	JobInfo jobInfo = new JobInfo();

    	/* 더보기 버튼을 위한 페이징  */
    	//List<JobInfo> jobInfoList = mentorService.listJobIntroduce(mentorSearch);

//		jobInfo.setTotalRecordCount(jobInfoList.get(0).getTotalRecordCount());
//
//		// jobInfo 도메인에 결과목록을 할당할 수 있음.
//		jobInfo.setResult(jobInfoList);



    	//mentorService.listJobIntroduce(mentorSearch);
    }


}