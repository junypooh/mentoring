package kr.or.career.mentor.service;

import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.Article;
import kr.or.career.mentor.domain.BnrInfo;
import kr.or.career.mentor.util.PagedList;
import lombok.extern.log4j.Log4j2;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@Log4j2
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class BannerServiceTest {

    @Autowired
    protected BannerService bannerService;

    /**
     * <pre>
     * 학교 메인 화면에서 배너의 목록을 조회할 때 사용
     * 현재 화면에 표시되어야 할 목록을 조회
     *
     * 101633 : 구역코드
     * 101634 : 전체
     * 101635 : 학교
     * 101636 : 멘토
     *
     *
     * 101637 : 유형코드
     * 101638 : A타입
     * 101639 : B타입
     * 101640 : C타입
     * </pre>
     *
     */
    @Test
    public void retrieveBanner() {
        //조회조건이 없이 현재 시간 기준으로 등록된 목록을 가져옴.
        //학교 메인에서 조회
        bannerService.retrieveBanner(Constants.SCHOOL);

        //멘토 메인에서 조회
        bannerService.retrieveBanner(Constants.MENTOR);

        //관리자 메인에서 조회
        //bannerService.retrieveBanner(Constants.MANAGER);
    }

    /**
     * 관리자에서 배너 목록을 조회 할 때 사용
     */
    @Test
    public void listBannerByParam() {
        //조회 조건이 없음
        //페이징
        //한페이지 표시 개수
        BnrInfo bnrInfo = new BnrInfo();
        bnrInfo.setPageable(true);
        bnrInfo.setRecordCountPerPage(10);
        bnrInfo.setCurrentPageNo(2);
        PagedList<BnrInfo> list = (PagedList<BnrInfo>)bannerService.listBanner(bnrInfo);
        log.info(list.toString());
        //bannerService.retrieveBannerCnt(bnrInfo);
    }

    /**
     * 관리자에서 배너 신규 생성 할 때 사용
     */
    @Test
    public void insertBanner() {
        int i=0;
        //for(i=0; i < 130 ; i++)
        {
            BnrInfo bnrInfo = new BnrInfo();
            bnrInfo.setBnrImgUrl("1"+i);
            bnrInfo.setBnrLinkUrl("2"+i);
            bnrInfo.setBnrNm("name"+i);
            bnrInfo.setDispSeq(1);
            bnrInfo.setUseYn("Y");
            int seq = bannerService.insertBanner(bnrInfo);
            log.info("SEQUENCE {}",seq);
        }
    }

    /**
     * 관리자에서 배너 신규 수정 할 때 사용
     */
    @Test
    public void updateBanner() {
        BnrInfo bnrInfo = new BnrInfo();
        bnrInfo.setBnrImgUrl("1_update");
        bnrInfo.setBnrLinkUrl("2_update");
        bnrInfo.setBnrNm("name_update");
        bnrInfo.setDispSeq(100);
        bnrInfo.setBnrSer(100135);
        bnrInfo.setUseYn("Y");
        bannerService.updateBanner(bnrInfo);
    }
}
