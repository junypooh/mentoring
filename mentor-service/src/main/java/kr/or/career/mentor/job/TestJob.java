package kr.or.career.mentor.job;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import kr.or.career.mentor.service.UserService;
import lombok.extern.log4j.Log4j2;

import org.quartz.DisallowConcurrentExecution;
import org.quartz.JobBuilder;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobKey;
import org.quartz.PersistJobDataAfterExecution;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.quartz.QuartzJobBean;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
@Log4j2
public class TestJob extends QuartzJobBean{

    public static final String COUNT = "count";

    @Override
    protected void executeInternal(JobExecutionContext context)
            throws JobExecutionException {

        //(수업완료 상태가 아닌 수업중에)현재 시간까지의 수업들을 조회하여 적절한 상태로 변경한다.
        //현재 시간 기준으로 다음으로 상태 변경이 일어날 시간을 조회한다.
        //조회한 시간에 스케줄을 등록한다.
        // 조회되는 내용이 없을 경우 1시간 후로 스케줄을 등록한다.
        JobDetail jd = context.getJobDetail();
        JobDataMap dataMap = jd.getJobDataMap();
        JobKey jobKey = jd.getKey();

      //UserService userService = (UserService)dataMap.get("userService");

/*
        Scheduler scheduler;
        try {
            scheduler = new StdSchedulerFactory().getScheduler();


            JobKey jobKeyA = new JobKey("jobA"+cnt, "LectureStatusGroup");
            JobDetail jobA = JobBuilder.newJob(TestJob.class)
            .withIdentity(jobKeyA).setJobData(dataMap).build();
            Calendar calendar = Calendar.getInstance(); // gets a calendar using the default time zone and locale.
            calendar.add(Calendar.SECOND, 5);
            Trigger trigger1 = null;
            //if()//다음 수업이 있을경우와 없는 경우를 구분하여 스케줄러 동작
            {
                trigger1 = TriggerBuilder
                    .newTrigger()
                    //.withIdentity("dummyTriggerName1", "group1")
                    //.withSchedule(CronScheduleBuilder.cronSchedule("0/5 * * * * ?"))
                    .startAt(calendar.getTime())
                    .build();
            }

            if(!scheduler.isStarted()){
                scheduler.start();
            }
            scheduler.scheduleJob(jobA, trigger1);
        } catch (SchedulerException e) {
            e.printStackTrace();
            log.error("SCHEDULER ERROR - please restart schedular");
        }
        */
    }


}
