package kr.or.career.mentor.domain;

import java.util.Collection;
import java.util.Date;

import lombok.Data;

/**
 * 게시물 관리를 위한 VO 클래스
 * @author 
 * @since 
 * @version 1.0
 * @see
 *
 */

@Data
public class Bbs {

     String boardId = ""; 	 /**   게시판ID  */
     int arclSer; 	 	/**   순번  */
     String prefNo = "";  	/**    카테고리 분류코드  */
     String titleSub = "";  		/**    제목  */
     String sustCont = "";  		/**    내용  */
     String cntntsTargtCd = ""; 	 /**   수업코드  */
     String cntntsTargtId = ""; 	 /**   코드순번  */
     String cntntsTypeCd = ""; 	 /**   멘토ID */
     String cntntsSust = "";  	/**   답글내용  */
     int vCnt;  		/**   조회수  */
     int rCnt;  		/**   추천점수  */
     String scrtArclYn = "N"; 		 /**   비밀글여부   */
     String notiYn = "N";  		/**   공지여부  */
     String useYn = "Y"; 		 /**   사용여부  */
     String regDtm = "";  		/**   작성일  */
     String regMbrNo = "";  		/**   작성자 회원번호 */
     String regMbrid = "";  		/**   작성자 아이디 */
     String regMbrNm = "";  		/**   작성자 이름 */
     String chgDtm = "";  		/**   수정일  */
     String chgMbrNo = ""; 		 /**   수정자  */
     String chgMbrid = ""; 		 /**   수정자 아이디 */
     String reRegDtm = "";  		/**   답변작성일  */
     String reRegMbrNo = ""; 		/**   답변작성자회원번호  */
     String reRegMbrid = ""; 		/**   답변작성자 아이디*/
     String reRegMbrNm = ""; 		/**   답변작성자 이름 */
 
     String cmtSer = "";   	 /**  댓글번호   */
     String cmtSust = "";   	 /**  댓글내용   */
     String cmtUseYn = "";   	 /**  댓글사용여부   */
     String numRow = "";         /**  글번호카운트   */
     String rNum = "";         /**    글순번  */
    
     String viewType = ""; 		 /**  화면구분      */
     String bbsType = ""; 		 /**  게시판구분      */
     String bbsRowType = ""; 		 /**  게시판레코드수구분      */
    
     int pageIndex= 1; 		 /**  현재페이지     */
     int recordCount; 		 /**  페이지레코드 개수      */
     int pageUnit; 		 /**  페이지갯수     */
     int pageSize; 		 /**  페이지사이즈    */
     int firstIndex= 1; 		 /**  첫페이지 인덱스     */
     int lastIndex= 1; 		 /**  마지막페이지 인덱스     */
     int recordCountPerPage= 10; 		 /**  페이지당 레코드 개수      */
    
    
    
    

}
