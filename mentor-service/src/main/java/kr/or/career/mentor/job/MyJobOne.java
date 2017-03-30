package kr.or.career.mentor.job;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.stereotype.Service;
//@Service
public class MyJobOne {
	
	//@Autowired
	//QuartzConfiguration quartzConfiguration;
	
    protected void myTask() {
    	System.out.println("This is my task");
    	
    	//quartzConfiguration.schedulerFactoryBean();
    	//SchedulerFactoryBean scheduler = new SchedulerFactoryBean();
		//scheduler.setTriggers(quartzConfiguration.simpleTriggerFactoryBean().getObject());
    }
} 