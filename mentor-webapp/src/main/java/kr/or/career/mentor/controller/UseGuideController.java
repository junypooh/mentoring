package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.BoardPrefInfo;
import kr.or.career.mentor.service.ComunityService;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      UseGuideController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-29 오후 1:33
 */
@Controller
@RequestMapping("useGuide")
public class UseGuideController {

    @Autowired
    private ComunityService comunityService;

    @RequestMapping("ajax.arclListWithNotice.do")
    @ResponseBody
    public List<ArclInfo<T>> arclListWithNotice(@Pageable ArclInfo<T> arclInfo) {
        arclInfo.setDispNotice(false);
        return comunityService.getArticleListWithNotiable(arclInfo);
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

    @RequestMapping("ajax.arclList.do")
    @ResponseBody
    public List<ArclInfo<T>> arclList(@Pageable ArclInfo<T> arclInfo){
        return comunityService.getArticleList(arclInfo);
    }
}
