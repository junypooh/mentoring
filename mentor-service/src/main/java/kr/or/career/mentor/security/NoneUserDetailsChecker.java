package kr.or.career.mentor.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsChecker;

/**
 * Created by chaos on 2016. 8. 16..
 */
public class NoneUserDetailsChecker implements UserDetailsChecker {
    @Override
    public void check(UserDetails toCheck) {
        //Nothing
    }
}
