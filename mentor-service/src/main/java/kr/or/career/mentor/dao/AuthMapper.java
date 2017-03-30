package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.AuthInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *      AuthMapper
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-29 오후 2:14
 */
public interface AuthMapper {

    public List<AuthInfo> listAuthInfo(AuthInfo authInfo);

    boolean isValidateId(String authCd);

    void insertAuthInfo(AuthInfo authInfo);

    void updateAuthInfo(AuthInfo authInfo);

    void insertUserAuthMappInfo(AuthInfo authInfo);

    void deleteMnuAuthMappInfo(AuthInfo authInfo);

    void insertMnuAuthMappInfo(AuthInfo authInfo);

    void deleteRollAuthMappInfo(AuthInfo authInfo);

    void insertRollAuthMappInfo(AuthInfo authInfo);

    List<AuthInfo> listAuthCdList(AuthInfo authInfo);

    void insertRollRelMappInfo(AuthInfo authInfo);
}
