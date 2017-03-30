package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.StdoInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.StudioService;
import kr.or.career.mentor.util.SessionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      LectureStudioController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-22 오전 11:40
 */
@Controller
@RequestMapping("lecture/studio")
public class LectureStudioController {

    @Autowired
    private StudioService studioService;

    /**
     * <pre>
     *     수업정보관리 > 스튜디오 목록
     * </pre>
     * @param stdoInfo
     * @return
     */
    @RequestMapping("ajax.list.do")
    @ResponseBody
    public List<StdoInfo> studioList(@Pageable StdoInfo stdoInfo) {

        User user = SessionUtils.getUser();
        stdoInfo.setPosCoNo(user.getPosCoNo());

        return studioService.getStudioInfo(stdoInfo);
    }

    /**
     * <pre>
     *     수업정보관리 > 스튜디오 상세
     * </pre>
     * @param stdoInfo
     * @return
     */
    @RequestMapping("view.do")
    public void studioView(StdoInfo stdoInfo, Model model) {

        User user = SessionUtils.getUser();
        stdoInfo.setPosCoNo(user.getPosCoNo());

        List<StdoInfo> stdoInfoList = studioService.getStudioInfo(stdoInfo);

        model.addAttribute("stdoInfo", stdoInfoList.get(0));

    }

    /**
     * <pre>
     *     수업정보관리 > 스튜디오 등록/수정
     * </pre>
     * @param stdoInfo
     * @return
     */
    @RequestMapping("edit.do")
    public void studioEdit(StdoInfo stdoInfo, Model model) {

        if(StringUtils.isNotEmpty(stdoInfo.getStdoNo())) {
            User user = SessionUtils.getUser();
            stdoInfo.setPosCoNo(user.getPosCoNo());

            List<StdoInfo> stdoInfoList = studioService.getStudioInfo(stdoInfo);

            model.addAttribute("stdoInfo", stdoInfoList.get(0));
        }

    }
    /**
     * <pre>
     *     수업정보관리 > 스튜디오 edit > 수정 및 등록
     * </pre>
     * @param stdoInfo
     * @return
     */
    @RequestMapping("ajax.saveStudioInfo.do")
    @ResponseBody
    public String saveStudioInfo( StdoInfo stdoInfo, Authentication authentication) {

        User user = (User) authentication.getPrincipal();
        stdoInfo.setRegMbrNo(user.getMbrNo());

        if(StringUtils.isEmpty(stdoInfo.getStdoNo())) {
            stdoInfo.setPosCoNo(user.getPosCoNo());
        }

        String rtnStr = "FAIL";
        int chk = studioService.saveStudioInfo(stdoInfo);
        if(chk > 0){
            rtnStr = "SUCCESS";
        }
        return rtnStr;
    }
}
