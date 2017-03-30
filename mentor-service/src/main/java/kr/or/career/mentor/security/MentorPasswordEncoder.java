package kr.or.career.mentor.security;

import kr.or.career.mentor.util.CodeMessage;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.encoding.BaseDigestPasswordEncoder;




@Slf4j
public class MentorPasswordEncoder extends BaseDigestPasswordEncoder{

//	@Override
//	public String encode(CharSequence rawPassword) {
//		String enpassword;
//		try {
//			enpassword = EgovFileScrty.encryptPassword(rawPassword.toString(), "userId");
//		} catch (Exception e) {
//			enpassword = "";
//		}
//		return enpassword;
//	}
//
//	@Override
//	public boolean matches(CharSequence rawPassword, String encodedPassword) {
//		// TODO Auto-generated method stub
//		return true;
//	}

    @Override
    public String encodePassword(String rawPass, Object salt) {

        String encodedPassword = "";

        if(salt != null && rawPass != null)
            encodedPassword = EgovFileScrty.encryptPassword(rawPass, salt.toString());

        return  encodedPassword;
    }

    @Override
    public boolean isPasswordValid(String encPass, String rawPass, Object salt) {
        if (StringUtils.isEmpty(encPass) || !encPass.equals(encodePassword(rawPass, salt.toString()))){
            throw new BadCredentialsException(CodeMessage.ERROR_000004_ID가_없거나_비밀번호가_잘못_입력되었습니다_.toMessage());
        }
        return true;
    }

}
