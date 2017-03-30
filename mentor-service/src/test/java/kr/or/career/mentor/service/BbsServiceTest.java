package kr.or.career.mentor.service;


import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.ArclInfoRS;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;



@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
//@ActiveProfiles("jpa")
public class BbsServiceTest {

    public static final Logger log = LoggerFactory.getLogger(BbsServiceTest.class);


	@Autowired
    protected BbsService bbsService;


    /**
     * 게시판 일반 리스트
     * @throws Exception
     */
    @Test
	public void listBbs() throws Exception  {
    	ArclInfo bbs = new ArclInfo();
    	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
    	//bbs.setArclSer(10000007);
    	//bbs.setSearchCnd("3");
       // bbs.setSearchWrd("33");
    	//bbs.setSearchBgnDate("20150917");
    	//bbs.setSearchEndDate("20150917");


		List<ArclInfoRS> resultList = bbsService.listBbs(bbs);


		log.info("listBbs  String111:::::: : {}", resultList);
	   // log.info("cnt String3333:::::: : {}", cnt);

    }




    /**
     * 게시물등록
     * @throws Exception
     */
    @Test
	public void saveBbs() {

    	ArclInfo bbs = new ArclInfo();
     	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);

     	bbs.setPrefNo("qnaClass");
     	bbs.setTitle("문의드립니다.11test");
     	bbs.setSust("문의내용입니다. 11testaaaa");
     	bbs.setCntntsTargtId("1020000003");
     	bbs.setScrtArclYn("N");
     	bbs.setRegMbrNo("1020000002");

 		bbsService.saveBbs(bbs);
 		log.info(" endpoint insert:::::: : {}", "end");

    }



    /**
     * 게시물수정
     */
    @Test
	public void updateBbs() {
    	ArclInfo bbs = new ArclInfo();
    	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
    	bbs.setArclSer(10000031);
    	bbs.setPrefNo("qnaClass");
     	bbs.setTitle("문의드립니다.00001212121");
     	bbs.setSust("문의내용입니다. 34443222111");
     	bbs.setCntntsTargtId("1020000003");
     	bbs.setScrtArclYn("N");
     	bbs.setChgMbrNo("1020000002");

    	bbsService.updateBbs(bbs);
    	log.info(" endpoint update:::::: : {}", "end");

    }


    /**
     * 게시물 상세내용보기
     */
    @Test
	public void retrieveBbs() {
    	ArclInfo bbs = new ArclInfo();
    	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
    	bbs.setArclSer(10000007);

    	bbsService.retrieveBbs(bbs);
    	log.info(" endpoint retrieve:::::: : {}", "end");

    }


    /**
     * 게시물삭제
     */
    @Test
	public void deleteBbs() {
    	ArclInfo bbs = new ArclInfo();
    	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
    	bbs.setArclSer(10000031);
    	bbsService.deleteBbs(bbs);
    	bbsService.deleteCommentBbs(bbs);
    	log.info(" endpoint delete:::::: : {}", "end");

    }

    /**
     * 게시물조회수 증가
     */
    @Test
	public void updateRetrieveCountBbs() {
    	ArclInfo bbs = new ArclInfo();
    	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
    	bbs.setArclSer(10000007);

    	// 조회수 증가 여부 지정
		//bbs.setRetrieveCount(true);

    	bbsService.updateRetrieveCountBbs(bbs);
    	log.info(" endpoint updateRetrieveCountBbs:::::: : {}", "end");

    }


    /**
     * 게시판 댓글 리스트
     */

    @Test
	public void listCommentBbs()  {
    	ArclInfo bbs = new ArclInfo();
      	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
      	bbs.setArclSer(10000007);


  		List<ArclInfo> resultList = bbsService.listCommentBbs(bbs);

  		log.info("listCommentBbs String111:::::: : {}", "end");

    }

    /**
     * 게시판 댓글 등록
     */

    @Test
	public void saveCommentBbs()  {
    	ArclInfo bbs = new ArclInfo();
     	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
    	bbs.setArclSer(10000007);

     	//bbs.setCmtSust("000117777댓글등록합니다.3455666");
      	bbs.setRegMbrNo("1020000002");

 		bbsService.saveCommentBbs(bbs);
 		log.info(" endpoint saveCommentBbs:::::: : {}", "end");
    }



    /**
     * 게시물댓글삭제
     */
    @Test
	public void deleteCommentBbs() {
    	ArclInfo bbs = new ArclInfo();
    	bbs.setBoardId(Constants.BOARD_ID_LEC_QNA);
    	bbs.setArclSer(10000007);
    	//bbs.setCmtSer(10000020);
    	bbsService.deleteCommentBbs(bbs);
    	log.info(" endpoint deleteCommentBbs:::::: : {}", "end");

    }






}