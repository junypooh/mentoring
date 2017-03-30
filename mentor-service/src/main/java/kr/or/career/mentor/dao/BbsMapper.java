package kr.or.career.mentor.dao;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *  BbsMapper.java
 *
 * 	게시판 관리
 *
 * </pre>
 * @since   2015. 9. 16.
 * @author  eh
 * @see
 */



import org.springframework.stereotype.Repository;

import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.ArclInfoRS;


@Repository
public interface BbsMapper {


	/**
	 * <pre>
	 * 게시판 리스트
	 * </pre>
	 *
	 */
     public  List<ArclInfoRS> listBbs(ArclInfo arclInfo);


     /**
 	 * <pre>
 	 * 게시판 레코드수
 	 * </pre>
 	 *
 	 */
     public  int listCntBbs(ArclInfo arclInfo);

     /**
 	 * <pre>
 	 * 게시판  글수정
 	 * </pre>
 	 *
 	 */
     public  void updateBbs(ArclInfo arclInfo);

     /**
 	 * <pre>
 	 * 게시판 글저장
 	 * </pre>
 	 *
 	 */
     public void saveBbs(ArclInfo arclInfo);

     /**
 	 * <pre>
 	 * 게시판 내용 상세보기
 	 * </pre>
 	 *
 	 */
     public ArclInfo retrieveBbs(ArclInfo arclInfo);

     /**
 	 * <pre>
 	 * 게시판 게시글 삭제
 	 * </pre>
 	 *
 	 */
     public  void deleteBbs(ArclInfo arclInfo);

     /**
 	 * <pre>
 	 * 게시판 조회수 증가
 	 * </pre>
 	 *
 	 */
     public  void updateRetrieveCountBbs(ArclInfo arclInfo);

     /**
 	 * <pre>
 	 * 게시판 댓글리스트
 	 * </pre>
 	 *
 	 */
     public List<ArclInfo> listCommentBbs(ArclInfo arclInfo);

     /**
 	 * <pre>
 	 * 게시판 댓글저장
 	 * </pre>
 	 *
 	 */
     public void saveCommentBbs(ArclInfo arclInfo);


     /**
  	 * <pre>
  	 * 게시판 댓글삭제
  	 * </pre>
  	 *
  	 */
      public void deleteCommentBbs(ArclInfo arclInfo);



}
