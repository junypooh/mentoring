/* ntels */
package kr.or.career.mentor.service;

import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.Article;
import kr.or.career.mentor.util.PagedList;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    BoardServiceTest
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 21. 오전 12:24
 */
@ContextConfiguration(locations = {"classpath:spring/application-context.xml","classpath:spring/application-datasource.xml","classpath:spring/application-transaction.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class BoardServiceTest {

    public static final Logger log = LoggerFactory.getLogger(BoardServiceTest.class);

    @Autowired
    public BoardService boardService;

    @Test
    public void listArticles() throws Exception  {

        Article article = new Article();
        article.setBoardId(Constants.BOARD_ID_LEC_QNA);
        article.setCurrentPageNo(2);
        article.setPageable(true);

        List artcles = boardService.listArticles(article);


        //Assert.assertEquals(artcles.size(), 10);

        log.info("totalCount : {}" , ((PagedList)artcles).getTotalCount());


    }
}
