package kr.or.career.mentor.service;

import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.AssertTrue;

import kr.or.career.mentor.domain.Code;
import lombok.extern.log4j.Log4j2;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@Log4j2
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class CodeServiceTest {

    @Autowired
    protected CodeManagementService codeManagementService;

    /**
     * 특정 코드 목록을 조회할 때 사용
     */
    @Test
    public void listCode() {
        Code code = new Code();
        code.setSupCd("100204");//회원_자격_코드
        //code.setPageable(true);
        //code.setRecordCountPerPage(10);
        //code.setCurrentPageNo(2);
        codeManagementService.listCode(code);
    }

    /**
     * 관리자에서 배너 목록을 조회 할 때 사용 (관리자에 코드 관리 없음)
     */
    @Test
    public void listCodeByParam() {
        Code code = new Code();
        //code.setSupCd("100204");//회원_자격_코드
        //code.setCd("100215");
        //code.setCdNm("교사");
        code.setCdDesc("교사");
        //code.setRecordCountPerPage(10);
        code.setCurrentPageNo(1);
        codeManagementService.listCodeWithPaging(code);
    }

    /**
     * 관리자에서 배너 신규 생성 할 때 사용
     */
    @Test
    @Rollback
    public void saveCode() {
        List<Code> listCode = new ArrayList<>();
        Code code = new Code();
        code.setCd("test01");
        code.setSupCd("test0");
        code.setCdNm("test1");
        code.setCdDesc("test1Desc");
        code.setDispSeq(1);
        listCode.add(code);
        int cnt = codeManagementService.saveCode(listCode);
        log.info("return value = {}",cnt);
        //Assert.isTrue(cnt==1);
    }
}
