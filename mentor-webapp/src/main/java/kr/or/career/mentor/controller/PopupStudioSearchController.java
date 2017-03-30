/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.Code;
import kr.or.career.mentor.domain.StdoInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.StudioService;
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
 *    PopupStudioSearchController
 *
 * 스튜디오찾기 팝업화면 controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-23 오전 11:44
 */
@Controller
@RequestMapping("layer")
public class PopupStudioSearchController {

    @Autowired
    protected CodeManagementService codeManagementService;

    @Autowired
    LectureManagementService lectureManagementService;

    @Autowired
    private StudioService studioService;

    /**
     * <pre>
     *     스튜디오찾기 팝업화면 onload
     * </pre>
     * @param model
     * @throws Exception
     */
    @RequestMapping("popupStudioSearch.do")
    public void popupStudioSearch(Model model) throws Exception{
        Code code = new Code();
        code.setSupCd("100351"); //지역코드 : 17개 시도
        model.addAttribute("code100351", codeManagementService.listCode(code));
    }

    @RequestMapping("ajax.listStudio.do")
    @ResponseBody
    public List<StdoInfo> listStudio(StdoInfo stdoInfo, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        String mbrCualfCd = user.getMbrCualfCd();
        /**
         * Studio 등록시 업체코드가 이상하게 들어가는 버그가 존재함. (쿼리 변경 및 마이그레이션 으로 해결)
         */
        if(CodeConstants.CD100204_101501_업체담당자.equals(mbrCualfCd)){ //기업멘토인 경우
            stdoInfo.setPosCoNo(user.getPosCoNo());
        }

        stdoInfo.setUseYn("Y");
//        List<StdoInfo> stdoInfoList = lectureManagementService.listStudio(stdoInfo);  // Deprecated
        List<StdoInfo> stdoInfoList = studioService.getStudioInfo(stdoInfo);

        return stdoInfoList;
    }


    @RequestMapping("ajax.stdoList.do")
    @ResponseBody
    public List<StdoInfo> stdoList(StdoInfo stdoInfo, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();

        List<StdoInfo> stdoInfoList = lectureManagementService.stdoList(stdoInfo);

        return stdoInfoList;
    }

}

