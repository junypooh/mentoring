package kr.or.career.mentor.security;

import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsChecker;

/**
 * Created by chaos on 2016. 8. 16..
 */
public class AccountStatusUserDetailsChecker implements UserDetailsChecker {
    @Override
    public void check(UserDetails user) {
        if (!user.isAccountNonLocked()) {
            if("SCHOOL".equals(EgovProperties.getLocalProperty("Local.site"))) {
                throw new LockedException(CodeMessage.SECURITY_200005_만_14세_미만의_어린이_회원은_보호자_동의가_필요합니다_.toMessage());
            } else if("MENTOR".equals(EgovProperties.getLocalProperty("Local.site"))) {
                throw new LockedException(CodeMessage.SECURITY_200001_관리자의_승인을_기다리고_있습니다_.toMessage());
            } else {
                throw new LockedException(CodeMessage.SECURITY_200001_관리자의_승인을_기다리고_있습니다_.toMessage());
            }
        }

        if (!user.isEnabled()) {
            throw new DisabledException(CodeMessage.SECURITY_200002_사용자_계정을_사용할_수_없습니다_.toMessage());
        }

        if (!user.isAccountNonExpired()) {
            throw new AccountExpiredException(CodeMessage.SECURITY_200003_expired_.toMessage());
        }

        if (!user.isCredentialsNonExpired()) {
            throw new CredentialsExpiredException(CodeMessage.SECURITY_200004_credentialsExpired_.toMessage());
        }
    }
}
