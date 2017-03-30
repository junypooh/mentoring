package kr.or.career.mentor.util;

import java.util.Collection;
import java.util.Collections;

import kr.or.career.mentor.domain.Authority;
import kr.or.career.mentor.domain.User;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;


public class SessionUtils {

    private static Authentication getAuthentication() {
        SecurityContext context = SecurityContextHolder.getContext();
        if (context == null) {
            return null;
        }

        return context.getAuthentication();
    }


    public static User getUser() {
        Authentication authentication = getAuthentication();
        if(authentication != null){
            Object principal = authentication.getPrincipal();
            if (!(principal instanceof User)) {
                return null;
            }
            return (User) principal;
        }
        return null;
    }


    public static Collection<Authority> getAuthorities() {
        User user = getUser();
        if (user == null) {
            return Collections.emptyList();
        }
        return user.getAuthorities();
    }


    public static boolean hasRole(String role) {
        for (Authority authority : getAuthorities()) {
            if (StringUtils.equals(role, authority.getAuthority())) {
                return true;
            }
        }
        return false;
    }


    public static boolean hasAnyRole(String... roles) {
        for (Authority authority : getAuthorities()) {
            if (ArrayUtils.contains(roles, authority.getAuthority())) {
                return true;
            }
        }
        return false;
    }

}
