package kr.or.career.mentor.job;

import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.ApplicationContextUtils;
import lombok.extern.log4j.Log4j2;
import org.quartz.*;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.util.Date;

/**
 * Created by chaos on 2016. 8. 16..
 */
@PersistJobDataAfterExecution
@DisallowConcurrentExecution
@Log4j2
public class WithdrawApplyCountByFailedObservationJob extends QuartzJobBean {
    @Override
    protected void executeInternal(JobExecutionContext context) throws JobExecutionException {

        LectureManagementService lectureManagementService = (LectureManagementService)ApplicationContextUtils.getBean("lectureManagementServiceImpl");

        log.info("WithdrawApplyCountByFailedObservationJob executeInternal : {} {}",new Date(), lectureManagementService);

        try {
            lectureManagementService.withdrawApplyCount();
        } catch (Exception e) {
            throw new JobExecutionException(e.getCause());
        }

    }
}
