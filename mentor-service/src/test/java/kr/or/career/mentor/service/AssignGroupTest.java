/* license */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.BizGrpSearch;
import kr.or.career.mentor.domain.BizSetInfo;
import lombok.extern.log4j.Log4j2;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    AssignGroupTest.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 22. 오전 9:09:25
 * @author  technear
 * @see
 */

@Log4j2
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class AssignGroupTest {

    @Autowired
    AssignGroupService assignGroupService;

    @Autowired
    SchInfoService schInfoService;

    @Test
    public void listAssignGroup() {
        log.trace("Trace");
        log.debug("Debug");
        log.info("Info");
        log.warn("Warn");
        log.error("Error");
        log.fatal("Fatal");
        BizGrpSearch bizGrpSearch = new BizGrpSearch();
        assignGroupService.listAssignGroup(bizGrpSearch);
    }

    /**
     *
     * <pre>
     * 배정그룹 상세 조회
     * </pre>
     *
     */
    @Test
    public void retrieveAssignGroup() {
        BizSetInfo bizSetInfo = new BizSetInfo();
        bizSetInfo.setSetTargtNo("1020000012");
        log.info("{} assign group : {}",bizSetInfo.getSetTargtNo(), assignGroupService.retrieveAssignGroup(bizSetInfo));
    }

    /**
     *
     * <pre>
     * 학교 목록 및 해당 학교의 배정그룹 조회
     * </pre>
     *
     */
    @Test
    public void listSchInfoWithGroup() {
        BizGrpSearch bizGrpSearch = new BizGrpSearch();
        bizGrpSearch.setGrpNm("등록");
        bizGrpSearch.setClasEndDay("20151201");
        bizGrpSearch.setClasStartDay("20150101");
        schInfoService.listSchInfoWithGroup(bizGrpSearch);
    }

}
