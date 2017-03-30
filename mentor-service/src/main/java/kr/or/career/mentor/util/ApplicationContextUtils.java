/* ntels */
package kr.or.career.mentor.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * <pre>
 * kr.or.career.mentor.util
 *    ApplicationContextUtils
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 1. 오후 8:40
 */
public class ApplicationContextUtils implements ApplicationContextAware {

    private static ApplicationContext ctx;
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.ctx = applicationContext;
    }

    public static Object getBean(String beanName){
        return ctx.getBean(beanName);
    }
}
