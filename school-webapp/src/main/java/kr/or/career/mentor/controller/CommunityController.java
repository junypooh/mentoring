package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.FileManagementService;
import kr.or.career.mentor.service.LectureDataService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.poi.ss.formula.functions.T;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    CommunityController.java
 *
 * 	Community Menu Controller
 *
 * </pre>
 *
 * @since 2015. 10. 01.
 * @author kadolmk2
 * @see
 */

@Controller
@RequestMapping("community")
public class CommunityController {

    public static final Logger log = LoggerFactory.getLogger(CommunityController.class);

    @Autowired
    private ComunityService comunityService;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private LectureDataService lectureDataService;

    @RequestMapping("ajax.arclList.do")
    @ResponseBody
    public List<ArclInfo<T>> arclList(@Pageable ArclInfo<T> arclInfo) {
        return comunityService.getArticleList(arclInfo);
    }

    @RequestMapping("ajax.arclListWithNotice.do")
    @ResponseBody
    public List<ArclInfo<T>> arclListWithNotice(@Pageable ArclInfo<T> arclInfo) {
        arclInfo.setDispNotice(false);
        return comunityService.getArticleListWithNotiable(arclInfo);
    }

    @RequestMapping("ajax.arclListWithoutFile.do")
    @ResponseBody
    public List<ArclInfo<T>> arclListWithoutFile(@Pageable ArclInfo<T> arclInfo) {
        return comunityService.getArticleListWithoutFile(arclInfo);
    }

    @RequestMapping("ajax.lectureArclInfo.do")
    @ResponseBody
    public ArclInfo<T> lectureArclInfo(ArclInfo<T> arclInfo) {
        return comunityService.getLectureArticleInfo(arclInfo);
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
            if (arclInfo.getArclSer() == null || arclInfo.getArclSer() == 0) {
                comunityService.registArcl(arclInfo, arclInfo.getFileSers());
                codeMessage = CodeMessage.MSG_900001_등록_되었습니다_;
            } else {
                comunityService.updateArcl(arclInfo, arclInfo.getFileSers());
                codeMessage = CodeMessage.MSG_900003_수정_되었습니다_;
            }
        } catch (Exception e) {
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }

    @RequestMapping("/registArcl.do")
    public String registArcl(ArclInfo<T> arclInfo,  @RequestParam(value="redirectUrl", required = false) String redirectUrl, Authentication authentication) throws CnetException {
        User user = (User) authentication.getPrincipal();
        arclInfo.setRegMbrNo(user.getMbrNo());
        arclInfo.setChgMbrNo(user.getMbrNo());

        if (arclInfo.getArclSer() == null || arclInfo.getArclSer() == 0) {
            comunityService.registArcl(arclInfo, arclInfo.getFileSers());
        } else {
            comunityService.updateArcl(arclInfo, arclInfo.getFileSers());
        }
        return "redirect:"+redirectUrl;
    }

    @RequestMapping(value="ajax.deleteArcl.do", method={RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public JSONResponse deleteArcl(@RequestBody ArclInfo<T> arclInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
        arclInfo.setChgMbrNo(user.getMbrNo());

        try {
            comunityService.deleteArcl(arclInfo);
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

        return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
    }

    @RequestMapping("ajax.getCmtList.do")
    @ResponseBody
    public List<ArclCmtInfo> getCmtList(ArclCmtInfo arclCmtInfo) {
        return comunityService.getCmtInfoList(arclCmtInfo);
    }

    @RequestMapping("ajax.getLectureArclInfo.do")
    @ResponseBody
    public ArclInfo<T> getLectureArclInfo() {
        return null;
    }

    @RequestMapping("ajax.getPagedCmtList.do")
    @ResponseBody
    public List<ArclCmtInfo> getPagedCmtList(@Pageable ArclCmtInfo arclCmtInfo) {
        return comunityService.getCmtInfoList(arclCmtInfo);
    }

    @RequestMapping(value="ajax.registCmt.do", method=RequestMethod.POST)
    @ResponseBody
    public JSONResponse registCmt(@RequestBody ArclCmtInfo arclCmtInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
        arclCmtInfo.setRegMbrNo(user.getMbrNo());

        try {
            comunityService.registCmt(arclCmtInfo);
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

        return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage());
    }

    @RequestMapping(value="ajax.deleteCmt.do", method=RequestMethod.POST)
    @ResponseBody
    public JSONResponse deleteCmt(@RequestBody ArclCmtInfo arclCmtInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
        arclCmtInfo.setChgMbrNo(user.getMbrNo());
        arclCmtInfo.setDelMbrNo(user.getMbrNo());

        try {
            comunityService.deleteCmt(arclCmtInfo);
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

        return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
    }

    @RequestMapping("ajax.getBoardPrefList.do")
    @ResponseBody
    public List<BoardPrefInfo> getBoardPrefInfoList(BoardPrefInfo boardPrefInfo) {
        return comunityService.getBoardPrefInfoList(boardPrefInfo);
    }

    @RequestMapping("ajax.getLastLectList.do")
    @ResponseBody
    public List<Map<String, String>> getLastLectList(String mbrNo) {
        return comunityService.getLastLectList(mbrNo);
    }

    @RequestMapping(value="ajax.insertAnswer.do",method=RequestMethod.POST)
    @ResponseBody
    public JSONResponse insertAnswer(@RequestBody ArclInfo<T> arclInfo, Authentication authentication, @RequestParam(value = "updateFlag", required = false) String updateFlag) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }
        User user = (User) authentication.getPrincipal();
        if (updateFlag.equals("U")) {
            arclInfo.setAnsChgMbrNo(user.getMbrNo());
        } else {
            arclInfo.setAnsRegMbrNo(user.getMbrNo());
        }

        try {
            comunityService.insertAnswer(arclInfo);
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

        return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage());
    }

    @RequestMapping("ajax.checkGradeYn.do")
    @ResponseBody
    public int checkGradeYn(ArclCmtInfo arclCmtInfo) {
        User user = SessionUtils.getUser();
        if(user != null){
            arclCmtInfo.setMbrClassCd(user.getMbrClassCd());
            return comunityService.isGradeYn(arclCmtInfo);
        }
        return -1;
    }

    @RequestMapping("ajax.arclReplaylList.do")
    @ResponseBody
    public List<ArclInfoDTO> arclReplayList(@Pageable ArclInfoDTO dto) {
        return comunityService.getReplayInfoList(dto);
    }

    @RequestMapping("ajax.replayView.do")
    @ResponseBody
    public ArclInfoDTO viewReplay(ArclInfoDTO dto) {
        return comunityService.getReplayInfoDetail(dto);
    }

    @RequestMapping("ajax.addVcnt.do")
    @ResponseBody
    public int addVcnt(ArclInfo<T> info) {
        return comunityService.addVcnt(info);
    }


    /**
     * <pre>
     *     마이페이지 > 나의커뮤니티 > 수업과제
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
     *     마이페이지 > 나의커뮤니티 > 수업과제 > 첨부파일조회
     * </pre>
     * @param arclFileInfo
     * @return
     */
    @RequestMapping("/ajax.listArclFileInfo.do")
    @ResponseBody
    public List<ArclFileInfo> listArclFileInfo(ArclFileInfo arclFileInfo){
        return fileManagementService.listArclFileInfo(arclFileInfo);
    }

    /**
     * 기타 자료
     *
     * @param lectDataInfo
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.lectureDataList.do")
    public List<LectDataInfo> lectureDataListAjax(@Pageable LectDataInfo lectDataInfo) throws Exception{
        return lectureDataService.selectMbrDataInfo(lectDataInfo);
    }

}