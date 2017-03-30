package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.AuthInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      AuthService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-29 오후 2:11
 */
public interface AuthService {

    public List<AuthInfo> listAuthInfo(AuthInfo authInfo);

    public boolean isValidateId(String authCd);

    void insertAuthMenuInfo(AuthInfo authInfo);

    void updateAuthMenuInfo(AuthInfo authInfo);

    boolean idValidate(String code);

    List<AuthInfo> listAuthCdList(AuthInfo authInfo);
}
