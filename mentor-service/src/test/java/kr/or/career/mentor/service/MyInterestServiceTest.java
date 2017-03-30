/* license */
package kr.or.career.mentor.service;

import lombok.extern.java.Log;
import lombok.extern.log4j.Log4j2;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    MyInterestServiceTest.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 22. 오후 6:51:35
 * @author  technear
 * @see
 */
@Log4j2
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class MyInterestServiceTest {

    @Autowired
    MyInterestService myInterestService;

    @Test
    public void listMyInterest() throws Exception{
        log.info("My Interest");
        //myInterestService.listMyInterest();
    }
}
