package kr.or.career.mentor.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import kr.or.career.mentor.dao.BbsMapper;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.ArclInfoRS;
import kr.or.career.mentor.service.BbsService;


/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *  BbsServiceImpl.java
 *
 * 	게시판 관리
 *
 * </pre>
 * @since   2015. 9. 16.
 * @author
 * @see
 */


@Service("BbsService")
public class BbsServiceImpl implements BbsService{


	@Autowired(required=true)
    private BbsMapper bbsMapper;


	/**
	 * <pre>
	 * 게시판 리스트
	 * </pre>
	 *
	 */
	@Override
	public List<ArclInfoRS> listBbs(ArclInfo<T> arclInfo) {
		 return bbsMapper.listBbs(arclInfo);
	}




	/**
	 * <pre>
	 * 게시판 내용 저장
	 * </pre>
	 *
	 */
	@Override
	public  void saveBbs(ArclInfo arclInfo){
		bbsMapper.saveBbs(arclInfo);
	}

	/**
	 * <pre>
	 * 게시판 내용수정
	 * </pre>
	 *
	 */
	@Override
	public  void updateBbs(ArclInfo arclInfo){
		bbsMapper.updateBbs(arclInfo);
	}

	/**
	 * <pre>
	 * 게시판 상세내용보기
	 * </pre>
	 *
	 */
	@Override
	public ArclInfo retrieveBbs(ArclInfo arclInfo){
	   return bbsMapper.retrieveBbs(arclInfo);

	}


	/**
	 * <pre>
	 * 게시판 게시글 삭제
	 * </pre>
	 *
	 */
	@Override
	public  void deleteBbs(ArclInfo arclInfo){
		bbsMapper.deleteBbs(arclInfo);
	}


	/**
	 * <pre>
	 * 게시판 조회수 증가
	 * </pre>
	 *
	 */
	@Override
	public void updateRetrieveCountBbs(ArclInfo arclInfo){
			bbsMapper.updateRetrieveCountBbs(arclInfo);
	}

	/**
	 * <pre>
	 * 게시판 댓글 저장
	 * </pre>
	 *
	 */
	@Override
	public  void saveCommentBbs(ArclInfo arclInfo){
		bbsMapper.saveCommentBbs(arclInfo);
	}


	/**
	 * <pre>
	 * 게시판 댓글 리스트
	 * </pre>
	 *
	 */
	@Override
	public List<ArclInfo> listCommentBbs(ArclInfo arclInfo){
		 return bbsMapper.listCommentBbs(arclInfo);
	}

	/**
	 * <pre>
	 * 게시판 댓글 삭제
	 * </pre>
	 *
	 */
	@Override
	public  void deleteCommentBbs(ArclInfo arclInfo){
		bbsMapper.deleteCommentBbs(arclInfo);
	}




}
