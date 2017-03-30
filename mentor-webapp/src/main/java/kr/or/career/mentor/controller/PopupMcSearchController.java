/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.McInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    PopupMcSearchController
 *
 * MC찾기 팝업화면 controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-23 오전 11:44
 */
@Controller
@RequestMapping("layer")
public class PopupMcSearchController {

    @Autowired
    LectureManagementService lectureManagementService;

    @RequestMapping("ajax.listMc.do")
    @ResponseBody
    public List<McInfo> listMc(McInfo mcInfo, Authentication authentication) throws Exception{

        User user = (User)authentication.getPrincipal();

        String mbrCualfCd = user.getMbrCualfCd();
        /**
         * MC 등록시 업체코드가 이상하게 들어가서 정보 fix
         */
        if(CodeConstants.CD100204_101501_업체담당자.equals(mbrCualfCd)){ //기업멘토인 경우
            mcInfo.setPosCoNo(user.getPosCoNo());
        }

        mcInfo.setUseYn("Y");

        List<McInfo> mcInfoList = lectureManagementService.listMc(mcInfo);

        return mcInfoList;
    }
}

