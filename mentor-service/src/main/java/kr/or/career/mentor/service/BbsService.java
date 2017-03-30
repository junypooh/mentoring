package kr.or.career.mentor.service;

import java.util.List;
import java.util.Map;

import org.apache.poi.ss.formula.functions.T;

import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.ArclInfoRS;


/**
 * <pre>
 * kr.or.career.mentor.service
 *  BbsService.java
 *
 * 	게시판 관리
 *
 * </pre>
 * @since   2015. 9. 16.
 * @author
 * @see
 */

public interface BbsService {

	/**
	 * <pre>
	 * 게시판 리스트
	 * </pre>
	 *
	 */
	public List<ArclInfoRS> listBbs(ArclInfo<T> arclInfo);


	/**
	 * <pre>
	 * 게시판 게시글 저장
	 * </pre>
	 *
	 */
	public  void saveBbs(ArclInfo arclInfo);

	/**
	 * <pre>
	 * 게시판 게시글 수정
	 * </pre>
	 * @return
	 *
	 */
	public  void updateBbs(ArclInfo arclInfo);

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
	 * 게시판  댓글 리스트
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
	public  void saveCommentBbs(ArclInfo arclInfo);

	/**
	 * <pre>
	 * 게시판 댓글삭제
	 * </pre>
	 *
	 */
	public  void deleteCommentBbs(ArclInfo arclInfo);




}
