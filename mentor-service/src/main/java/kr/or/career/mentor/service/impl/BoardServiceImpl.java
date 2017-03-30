/* ntels */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.BoardMapper;
import kr.or.career.mentor.domain.Article;
import kr.or.career.mentor.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    BoardServiceImpl
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 21. 오전 12:17
 */
@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    BoardMapper boardMapper;

    @Override
    public List<Article> listArticles(Article article) {
        return boardMapper.listArticle(article);
    }
}
