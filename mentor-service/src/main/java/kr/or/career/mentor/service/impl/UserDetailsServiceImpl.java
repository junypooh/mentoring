package kr.or.career.mentor.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.Authority;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.AuthorityException;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;


@Service("userDetailsService")
public class UserDetailsServiceImpl implements UserDetailsService {
    private static Logger logger = LoggerFactory.getLogger(UserDetailsServiceImpl.class);

    @Autowired
    private UserService userService;

    private static final List<GrantedAuthority> DEFAULT_ROLES = new ArrayList<GrantedAuthority>();
    static {
        DEFAULT_ROLES.add(new SimpleGrantedAuthority("ROLE_USER"));
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        logger.info("UserDetailsService.loadUserByUsername");
        HashMap<String,String> param = new HashMap<>();
        param.put("id", username);
        param.put("userType", EgovProperties.getLocalProperty("Local.site"));
        //param.put("loginPermYn", "Y");
        User user = userService.retrieveUser(param);
        if (user == null) {
            throw new UsernameNotFoundException(CodeMessage.ERROR_000003_등록된_사용자_정보를_찾을_수_없습니다_.toMessage());
        }
        /*if(user != null && CodeConstants.CD100861_101506_승인요청.equals(user.getMbrStatCd())){
            if(Constants.MENTOR.equals(EgovProperties.getLocalProperty("Local.site"))){
                //throw new AuthorityException(AuthorityException.NOT_AUTHORIZED_USER);
                throw new AuthorityException(CodeMessage.ERROR_000006_관리자의_승인을_기다리고_있습니다_.toMessage());
            }
        }*/
        List<Authority> authorities = userService.findAuthoritiesByUserId(user.getMbrNo());
        user.setAuthorities(authorities);
        return user;
    }

}
