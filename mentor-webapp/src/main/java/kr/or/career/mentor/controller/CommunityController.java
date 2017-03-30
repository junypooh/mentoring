package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.ArclFileInfo;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.BoardPrefInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("community")
public class CommunityController {

  @Autowired
  private ComunityService comunityService;

  @RequestMapping("ajax.arclList.do")
  @ResponseBody
  public List<ArclInfo<T>> arclList(@Pageable ArclInfo<T> arclInfo){
    return comunityService.getArticleList(arclInfo);
  }

  @RequestMapping("ajax.arclListWithNotice.do")
  @ResponseBody
  public List<ArclInfo<T>> arclListWithNotice(@Pageable ArclInfo<T> arclInfo) {
    arclInfo.setDispNotice(false);
    return comunityService.getArticleListWithNotiable(arclInfo);
  }

  /** 기존 질문과답변, 삭제예정*/
  @RequestMapping("ajax.mentorDataArclList.do")
  @ResponseBody
  public List<ArclInfo<T>> mentorDataArclList(@Pageable ArclInfo<T> arclInfo){
    return comunityService.getMentorDataArclList(arclInfo);
  }

  @RequestMapping(value="ajax.registArcl.do", method={RequestMethod.GET, RequestMethod.POST})
  @ResponseBody
  public JSONResponse registArcl(@RequestBody ArclInfo<T> arclInfo, Authentication authentication) {
    if (authentication == null || authentication.getPrincipal() == null) {
      return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
    }

    User user = (User) authentication.getPrincipal();
    arclInfo.setRegMbrNo(user.getMbrNo());
    arclInfo.setChgMbrNo(user.getMbrNo());
    CodeMessage codeMessage = null;

    try {
      if(arclInfo.getArclSer() == null || arclInfo.getArclSer() == 0) {
        comunityService.registArcl(arclInfo, arclInfo.getFileSers());
        codeMessage = CodeMessage.MSG_900001_등록_되었습니다_;
      } else {
        comunityService.updateArcl(arclInfo, arclInfo.getFileSers());
        codeMessage = CodeMessage.MSG_900003_수정_되었습니다_;
      }
    } catch(Exception e) {
      codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
      if (e instanceof CnetException) {
          codeMessage = ((CnetException) e).getCode();
      }
      return JSONResponse.failure(codeMessage, e);
    }
    return JSONResponse.success(codeMessage.toMessage());
  }

  @RequestMapping(value="ajax.deleteArcl.do",method = RequestMethod.POST)
  @ResponseBody
  public JSONResponse deleteArcl(@RequestBody ArclInfo<T> arclInfo, Authentication authentication) {
    if (authentication == null || authentication.getPrincipal() == null) {
      return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
    }

    User user = (User) authentication.getPrincipal();
    arclInfo.setChgMbrNo(user.getMbrNo());

    try {
      comunityService.deleteArcl(arclInfo);
    } catch(Exception e) {
      CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
      if (e instanceof CnetException) {
          codeMessage = ((CnetException) e).getCode();
      }
      return JSONResponse.failure(codeMessage, e);
    }

    return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_);
  }

    @RequestMapping(value="ajax.deleteArclReply.do",method = RequestMethod.POST)
    @ResponseBody
    public JSONResponse deleteArclReply(@RequestBody ArclInfo<T> arclInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
        arclInfo.setChgMbrNo(user.getMbrNo());

        try {
            comunityService.deleteArclReply(arclInfo);
        } catch(Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

        return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_);
    }

  @RequestMapping("ajax.getNoticeCount.do")
  @ResponseBody
  public int getNoticeCount(ArclInfo<T> arclInfo){
    return comunityService.getNotiCount(arclInfo);
  }

  @RequestMapping("ajax.getBoardPrefList.do")
  @ResponseBody
  public List<BoardPrefInfo> getBoardPrefInfoList(BoardPrefInfo boardPrefInfo) {
    return comunityService.getBoardPrefInfoList(boardPrefInfo);
  }

  @RequestMapping("ajax.addVcnt.do")
  @ResponseBody
  public int addVcnt(ArclInfo<T> info) {
      return comunityService.addVcnt(info);
  }


  /**
   * <pre>
   *     멘토포탈 > 수업과제, 질문과답변 리스트조회
   * </pre>
   * @param arclInfo
   * @return
   */
  @RequestMapping("/ajax.mentorArclInfoList.do")
  @ResponseBody
  public List<ArclInfo<T>> mentorArclInfoList(@Pageable ArclInfo<T> arclInfo, Authentication authentication){
    User user = (User) authentication.getPrincipal();

    arclInfo.setMbrCualfCd(user.getMbrCualfCd());
    arclInfo.setSrchMbrNo(user.getMbrNo());

    return comunityService.getMentorArclInfoList(arclInfo);
  }

  /**
   * <pre>
   *     첨부파일 조회
   * </pre>
   * @param arclInfo
   * @return
   */
  @RequestMapping("/ajax.getFileInfoList.do")
  @ResponseBody
  public List<ArclFileInfo> getFileInfoList(ArclInfo<T> arclInfo) {
    return comunityService.getFileInfoList(arclInfo);
  }

}