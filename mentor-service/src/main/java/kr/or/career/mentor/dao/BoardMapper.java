/* ntels */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.Article;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    BoardMapper
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 21. 오전 12:18
 */
@Repository
public interface BoardMapper {
    public List<Article> listArticle(Article article);
}
