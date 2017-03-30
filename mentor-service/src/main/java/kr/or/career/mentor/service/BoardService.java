/* ntels */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.Article;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    BoardService
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 20. 오후 11:42
 */
public interface BoardService {

    List<Article> listArticles(Article article);
}
