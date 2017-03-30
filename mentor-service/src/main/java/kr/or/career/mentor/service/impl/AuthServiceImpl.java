package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.AuthMapper;
import kr.or.career.mentor.domain.AuthInfo;
import kr.or.career.mentor.domain.GlobalMnuInfo;
import kr.or.career.mentor.service.AuthService;
import kr.or.career.mentor.service.MnuInfoService;
import kr.or.career.mentor.util.EgovProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      AuthServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-29 오후 2:11
 */
@Service
public class AuthServiceImpl implements AuthService {

    private final String CODE_PATTERN = "^[A-Za-z0-9_-]{4,30}$";

    @Autowired
    private MnuInfoService mnuInfoService;

    @Autowired
    private AuthMapper authMapper;

    @Override
    public List<AuthInfo> listAuthInfo(AuthInfo authInfo) {
        return authMapper.listAuthInfo(authInfo);
    }

    @Override
    public boolean isValidateId(String authCd) {
        return authMapper.isValidateId(authCd);
    }

    @Override
    public void insertAuthMenuInfo(AuthInfo authInfo) {

        authMapper.insertAuthInfo(authInfo);
        authMapper.insertUserAuthMappInfo(authInfo);

        for(String mnuId : authInfo.getMnuIds()) {
            authInfo.setMnuId(mnuId);
            authMapper.insertMnuAuthMappInfo(authInfo);
        }

        authInfo.setSite(EgovProperties.getLocalProperty("Local.site"));
        authMapper.insertRollAuthMappInfo(authInfo);
        authMapper.insertRollRelMappInfo(authInfo);

        // 해당 권한의 변경 된 메뉴로 static 변수 값을 갱신한다.
        Map<String,String> param = new HashMap<>();
        param.put("mnuId", Constants.MNU_CODE_MANAGER2);
        param.put("authCd", authInfo.getAuthCd());
        List<GlobalMnuInfo> mnuInfoList = mnuInfoService.listMangerMnuInfoByAuthCd(param);

        mnuInfoService.setGlobalMenuInfo(authInfo.getAuthCd(), mnuInfoList);
    }

    @Override
    public void updateAuthMenuInfo(AuthInfo authInfo) {

        authInfo.setSupMnuId(Constants.MNU_CODE_MANAGER2);
        authMapper.updateAuthInfo(authInfo);
        authMapper.deleteMnuAuthMappInfo(authInfo);

        for(String mnuId : authInfo.getMnuIds()) {
            authInfo.setMnuId(mnuId);
            authMapper.insertMnuAuthMappInfo(authInfo);
        }

        authInfo.setSite(EgovProperties.getLocalProperty("Local.site"));
        authMapper.deleteRollAuthMappInfo(authInfo);
        authMapper.insertRollAuthMappInfo(authInfo);

        // 해당 권한의 변경 된 메뉴로 static 변수 값을 갱신한다.
        Map<String,String> param = new HashMap<>();
        param.put("mnuId", Constants.MNU_CODE_MANAGER2);
        param.put("authCd", authInfo.getAuthCd());
        List<GlobalMnuInfo> mnuInfoList = mnuInfoService.listMangerMnuInfoByAuthCd(param);

        mnuInfoService.setGlobalMenuInfo(authInfo.getAuthCd(), mnuInfoList);

    }

    @Override
    public boolean idValidate(String code) {
        Pattern pattern = Pattern.compile(CODE_PATTERN);
        return pattern.matcher(code).matches();
    }

    @Override
    public List<AuthInfo> listAuthCdList(AuthInfo authInfo) {
        return authMapper.listAuthCdList(authInfo);
    }
}
