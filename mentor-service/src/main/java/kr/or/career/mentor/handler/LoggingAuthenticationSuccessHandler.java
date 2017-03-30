package kr.or.career.mentor.handler;

import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.UserMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.MnuInfoService;
import kr.or.career.mentor.util.EgovProperties;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LoggingAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
    private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private MnuInfoService mnuInfoService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws ServletException, IOException {
        User user = (User) authentication.getPrincipal();
        LOGGER.info("LOGIN SUCCESS");
        //로그인 이력 쌓기
        MbrLoginHist mlh = new MbrLoginHist();
        mlh.setMbrNo(user.getMbrNo());
        mlh.setConnIp(request.getRemoteAddr());
        userMapper.insertLoginHist(mlh);
        //최종로그인 이력 UPDATE
        userMapper.updateUserLoginDtm(user);

        String osInfo = (String)request.getSession().getAttribute("osInfo");
        String deviceToken = (String)request.getSession().getAttribute("deviceToken");

        if(StringUtils.isNotEmpty(osInfo) && StringUtils.isNotEmpty(deviceToken)){

            MbrDvcInfo deviceInfo = new MbrDvcInfo();
            deviceInfo.setOsInfo(osInfo);
            deviceInfo.setDeviceToken(deviceToken);
            deviceInfo.setMbrNo(user.getMbrNo());

            userMapper.deleteDeviceInfo(deviceInfo);
            userMapper.upsertDeviceInfo(deviceInfo);
        }


        /*if (BooleanUtils.toBoolean(request.getParameter("_save_username"))) {
            CookieUtils.setCookie(response, "_username", user.getUsername(), null, 0);
        }
        else {
            CookieUtils.setCookie(response, "_username", "", null, 0);
        }*/

        // DB의 default 값이 Y 여서 의미는 반대로 됨.
        String tmpPassYn = user.getTmpPwdYn();
        if(!"N".equals(tmpPassYn))
            super.onAuthenticationSuccess(request, response, authentication);
        else {
            clearAuthenticationAttributes(request);

            // Use the DefaultSavedRequest URL
            String targetUrl = "/myPage/myInfo/myInfoEdit.do";
            logger.debug("Redirecting to DefaultSavedRequest Url: " + targetUrl);
            getRedirectStrategy().sendRedirect(request, response, targetUrl);
        }

        if("".equals("")){
            //User의 메뉴 정보를 조회한다.
            Map<String,String> param = new HashMap<>();
            List<MnuInfo> listMenuInfo = null;
            List<GlobalMnuInfo> listManagerMenuInfo = null;
            param.put("mbrNo", user.getMbrNo());
            param.put("authCd", user.getAuthCd());
            switch(EgovProperties.getLocalProperty("Local.site")){
            case Constants.MANAGER:
//                param.put("mnuId", Constants.MNU_CODE_MANAGER);
//                listMenuInfo = mnuInfoService.listMnuInfoByMbrNo(param);
//                request.getSession().setAttribute("menu",listMenuInfo);

                // 신규 관리자 메뉴
                param.put("mnuId", Constants.MNU_CODE_MANAGER2);
                mnuInfoService.setGlobalMnuInfo(param);
                break;
            case Constants.MENTOR:
//                param.put("mnuId", Constants.MNU_CODE_MENTOR);
//                listMenuInfo = mnuInfoService.listMnuInfoByMbrNo(param);
//                request.getSession().setAttribute("menu",listMenuInfo);

                // 신규 멘토 포탈 메뉴
                param.put("mnuId", Constants.MNU_CODE_MENTOR2);
                mnuInfoService.setGlobalMnuInfo(param);
                break;
            case Constants.SCHOOL:
                param.put("mnuId", Constants.MNU_CODE_SCHOOL);
                mnuInfoService.setGlobalMnuInfo(param);
                break;
            }



        }
    }
}
