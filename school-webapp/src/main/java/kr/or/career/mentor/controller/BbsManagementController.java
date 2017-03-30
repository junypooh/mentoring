package kr.or.career.mentor.controller;


import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.ArclInfoRS;
import kr.or.career.mentor.service.BbsService;
import kr.or.career.mentor.util.PagedList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;







/**
 * <pre>
 * kr.or.career.mentor.controller
 *  BbsManagementController.java
 *
 * 	게시판 관리
 *
 * </pre>
 * @since   2015. 9. 16.
 * @author
 * @see
 */




@Controller
public class BbsManagementController{

    public static final Logger log = LoggerFactory.getLogger(BbsManagementController.class);


    @Autowired
    private BbsService bbsService;




	/**
	 * <pre>
	 * 게시판 리스트
	 * </pre>
	 *
	 */

   @RequestMapping(value = {"/community/qna/qnaList2.do"})
   @ModelAttribute
   public String listPageBbs(@Pageable ArclInfo arclInfo, ModelMap model) {
     arclInfo.setBoardId(Constants.BOARD_ID_LEC_QNA);
     int tot = arclInfo.getCurrentPageNo()*10;
     PagedList<ArclInfoRS> resultList = (PagedList<ArclInfoRS>)bbsService.listBbs(arclInfo);
     arclInfo.setTotalRecordCount(resultList.getTotalCount());
     //arclInfo.setResult(resultList);
     //arclInfo.setRemainRecordCount(resultList.getTotalCount()-tot);
     return "community/qna/qnaList";
   }



/**
 * <pre>
 * 게시판 리스트
 * </pre>
 *
 */
@RequestMapping(value= "/community/qna/qnaMoreList.do", method = RequestMethod.GET)
@ResponseBody
public List<ArclInfoRS> listMoreBbs(@Pageable ArclInfo arclInfo, ModelMap model){
	 return bbsService.listBbs(arclInfo);
}



@RequestMapping("/community/qna/saveBbs.do")
public String saveBbs(@ModelAttribute ArclInfo arclInfo) throws Exception {
	    arclInfo.setRegMbrNo("1020000002");
	    bbsService.saveBbs(arclInfo);
	    return "redirect:/community/qna/qnaList.do";
}




@RequestMapping("/community/qna/plusCount.do")
public void updateRetrieveCountBbs(@ModelAttribute ArclInfo arclInfo) {
	 bbsService.updateRetrieveCountBbs(arclInfo);
	//return ;
}

@RequestMapping("/community/qna/view.do")
@ResponseBody
public ArclInfo retrieveBbs(@Pageable ArclInfo arclInfo) throws Exception {
	  log.info("retrieveBbs3333:::::: : {}", arclInfo.getArclSer());
	 return bbsService.retrieveBbs(arclInfo);
}



@RequestMapping("/community/qna/updateBbs.do")
@ResponseBody
public void  updateBbs(@ModelAttribute ArclInfo arclInfo) throws Exception {
	 arclInfo.setChgMbrNo("1020000002");
	 bbsService.updateBbs(arclInfo);
	// return ;
}



@RequestMapping("/community/qna/deleteBbs.do")
public String  deleteBbs(@ModelAttribute ArclInfo arclInfo) throws Exception {
	 log.info("deletes3333:::::: : {}", arclInfo.getArclSer());
	 bbsService.deleteBbs(arclInfo);
	 return "redirect:/community/qna/qnaList.do";
}



}

