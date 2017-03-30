package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.AuthInfo;
import kr.or.career.mentor.domain.GlobalMnuInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.security.ReloadableFilterInvocationSecurityMetadataSource;
import kr.or.career.mentor.service.AuthService;
import kr.or.career.mentor.service.MnuInfoService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.util.ApplicationContextUtils;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      OprAuthController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-29 오후 2:06
 */
@Controller
@RequestMapping("/opr/auth")
@Slf4j
public class OprAuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private MnuInfoService mnuInfoService;

    @Autowired
    private UserService userService;

    /**
     * <pre>
     *     운영관리 직업관리 리스트 조회
     * </pre>
     * @param authInfo
     * @return
     */
    @RequestMapping("/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000306")
    public List<AuthInfo> listAuthInfo(@Pageable AuthInfo authInfo) throws Exception {
        return authService.listAuthInfo(authInfo);
    }

    @RequestMapping("/view.do")
    public void view(AuthInfo authInfo, Model model) throws Exception {

        if(StringUtils.isNotEmpty(authInfo.getAuthCd())) {
            List<AuthInfo> authInfos = authService.listAuthInfo(authInfo);
            model.addAttribute("authInfo", authInfos.get(0));
        }
    }

    @RequestMapping("/ajax.view.do")
    @ResponseBody
    public List<GlobalMnuInfo> viewAuthInfo() throws Exception {

        Map<String,String> param = new HashMap<>();
        param.put("mnuId", Constants.MNU_CODE_MANAGER2);
        return  mnuInfoService.listMangerMnuInfo(param);
    }

    @RequestMapping("/ajax.getMenuInfoByAuth.do")
    @ResponseBody
    @Historic(workId = "1000000307")
    public List<GlobalMnuInfo> getMenuInfoByAuth(AuthInfo authInfo) throws Exception {

        Map<String,String> param = new HashMap<>();
        param.put("mnuId", Constants.MNU_CODE_MANAGER2);
        param.put("authCd", authInfo.getAuthCd());
        return  mnuInfoService.listMangerMnuInfoByAuthCd(param);
    }

    @RequestMapping("/ajax.isValidateCode.do")
    @ResponseBody
    public Map<String, String> isValidateCode(AuthInfo authInfo) throws Exception {

        Map<String, String> rtn = new HashMap<>();
        boolean success = true;
        if (!authService.idValidate(authInfo.getAuthCd())) {// 접합한 Code인지 확인
            success = false;
            rtn.put("success", String.valueOf(success));
            rtn.put("message", "권한 코드는 영문 대/소문자 , 숫자 및 기호 '_', '-' 만 사용 가능합니다. (4~30 자리)");
        }
        if (success) {
            success = authService.isValidateId(authInfo.getAuthCd());

            rtn.put("success", String.valueOf(success));
            if (!success) {
                rtn.put("message", "동일한 ID가 존재합니다.");
            }
        }

        return rtn;
    }

    @RequestMapping("/editSubmit.do")
    @Historic(workId = "1000000308")
    public String updateAuthInfo(@ModelAttribute("authInfo") AuthInfo authInfo, BindingResult result, RedirectAttributes redirectAttributes) throws Exception {

        User sessionUser = SessionUtils.getUser();
        authInfo.setRegMbrNo(sessionUser.getMbrNo());

        if ("0".equals(authInfo.getAuthType())) {
            authInfo.setMbrCualfCd(CodeConstants.CD100204_101717_사용자정의운영관리자);
        } else if ("1".equals(authInfo.getAuthType())) {
            authInfo.setMbrCualfCd(CodeConstants.CD100204_101724_사용자정의기관담당자);
        } else {
            authInfo.setMbrCualfCd(CodeConstants.CD100204_101717_사용자정의운영관리자);
        }

        if ("C".equals(authInfo.getCrudType())) {
            // INSERT
            authService.insertAuthMenuInfo(authInfo);
        } else {
            // UPDATE
            authService.updateAuthMenuInfo(authInfo);
        }

        // org.springframework.security.web.access.intercept.FilterSecurityInterceptor > securityMetadataSource (권한별 URL 정보 갱신)
        ReloadableFilterInvocationSecurityMetadataSource reloadableFilterInvocationSecurityMetadataSource = (ReloadableFilterInvocationSecurityMetadataSource) ApplicationContextUtils.getBean("reloadableFilterInvocationSecurityMetadataSource");
        reloadableFilterInvocationSecurityMetadataSource.reload();

        redirectAttributes.addAttribute("authCd", authInfo.getAuthCd());
        return "redirect:/opr/auth/view.do";
    }
}
