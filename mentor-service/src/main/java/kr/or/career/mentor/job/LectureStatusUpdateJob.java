package kr.or.career.mentor.job;

import kr.or.career.mentor.domain.PeopleInLecture;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.ApplicationContextUtils;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.util.HttpRequestUtils;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.lang3.time.DateUtils;
import org.quartz.*;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
@Log4j2
public class LectureStatusUpdateJob extends QuartzJobBean {

    public static final String COUNT = "count";

    @Override
    protected void executeInternal(JobExecutionContext context)
            throws JobExecutionException {

        LectureManagementService lectureManagementService = (LectureManagementService) ApplicationContextUtils.getBean("lectureManagementServiceImpl");

        HashMap<String, Integer> param = new HashMap<>();
        param.put("assign", Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY")));    //수업예정 상태로 바뀌는 기준 '일'
        param.put("ready", Integer.parseInt(EgovProperties.getProperty("READY_MINUTE")));    //수업대기 상태로 바뀌는 기준 '분'
        param.put("cutLine", Integer.parseInt(EgovProperties.getProperty("READY_APPLY_CNT"))); // 수업이 모집실패되는 기준 '신청수'

        lectureManagementService.lectureStatusChangeRecruitmentClose(param);

        Date nextTime = lectureManagementService.retrieveNextStatusChangeTime(param);

        //다음 예정 시간이 없다면 1시간 후를 반환
        if (nextTime == null) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.HOUR, 1);
            nextTime = cal.getTime();
        } else {
            nextTime = DateUtils.addSeconds(nextTime, 10);
        }

        Scheduler scheduler;
        try {
            scheduler = context.getScheduler();

            if (!scheduler.isStarted()) {
                scheduler.start();
            }

            Trigger trigger = scheduler.getTrigger(TriggerKey.triggerKey("LECT_STATUS_CHANGER", "trigger1"));

            if (trigger == null) {
                JobDetail lectureStatusJob = JobBuilder.newJob(LectureStatusUpdateJob.class)
                        .withIdentity("LECT_STATUS_CHANGER", "group1")
                        .build();

                trigger = TriggerBuilder.newTrigger()
                        .withIdentity("LECT_STATUS_CHANGER", "trigger1")
                        .startAt(nextTime).build();

                scheduler.scheduleJob(lectureStatusJob, trigger);
            } else {

                Trigger newTrigger = TriggerBuilder.newTrigger()
                        .withIdentity("LECT_STATUS_CHANGER", "trigger1")
                        .startAt(nextTime).build();

                scheduler.rescheduleJob(trigger.getKey(), newTrigger);
            }

            log.info("next batch schedule : {}", nextTime.toString());
        } catch (SchedulerException e) {
            log.error("SCHEDULER ERROR - please restart schedular");
        }

        log.info("next batch schedule ::::::::>>>>>");
        try {
            List<PeopleInLecture> peopleInLectures = lectureManagementService.getCurrentPeopleInLecture();
            for (PeopleInLecture each : peopleInLectures) {
                HttpRequestUtils.addAttendance(each.getLectSessId(), each.getLectrMbrNo(), each.getApplMbrNo() + each.getClasRoomSer(), "P", "I", "0");
            }
        } catch (Exception e) {
            //Nothing
        }

    }


}
