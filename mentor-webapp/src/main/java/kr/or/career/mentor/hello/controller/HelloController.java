package kr.or.career.mentor.hello.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.Article;
import kr.or.career.mentor.domain.SearchOption;
import kr.or.career.mentor.service.BoardService;
import kr.or.career.mentor.util.PagedList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by chaos on 15. 8. 31..
 */
@Controller
public class HelloController {

    private static final Logger LOGGER = LoggerFactory.getLogger(HelloController.class);

    @Autowired
    private BoardService boardService;


    /**
     *
     * <pre>
     *     @ModelAttribute : 화면단에서 넘어오는 검색조건 매핑 및 return하는 ModelMap에 담겨 화면단으로 다시 넘어가게 한다.
     *     @Pageable :  Mapper에 넘겨줄 대표 Domain에 이 annotation을 등록하여 Paging처리를 자동화한다.
     *                  해당 Domain은 Base Domain을 상속받는다.
     *
     *     - 화면단에서 받는 Parameter는 여러개의 Domain에 Mapping 될 수 있음.
     * </pre>
     * @param article
     * @return
     *
     * @see kr.or.career.mentor.dao.BoardMapper BoardMapper.xml 참조
     * @see kr.or.career.mentor.util.PagedList totalCount를 포함
     */
    @RequestMapping(value = {"/hello/hello.do"})
    @ModelAttribute
    public String listArticles(@Pageable Article article, SearchOption searchOption) {

        article.setPageable(true);
        // 화면단에서 받는 Parameter는 여러개의 Domain에 Mapping 될 수 있음.
        article.setSearchOption(searchOption);

        article.setBoardId(Constants.BOARD_ID_LEC_QNA);
        PagedList<Article> articles = (PagedList<Article>)boardService.listArticles(article);

        // list에 totalCount가 포함되어 있음.
        article.setTotalRecordCount(articles.getTotalCount());

        // article 도메인에 결과목록을 할당할 수 있음.
        article.setResult(articles);

        return "hello/hello";
    }

}
