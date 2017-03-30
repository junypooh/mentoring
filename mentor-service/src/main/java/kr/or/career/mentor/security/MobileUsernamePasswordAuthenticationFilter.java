/* ntels */
package kr.or.career.mentor.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import org.springframework.security.core.AuthenticationException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * <pre>
 * kr.or.career.mentor.security
 *    MobileUsernamePasswordAuthenticationFilter
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 16. 오전 11:29
 */
public class MobileUsernamePasswordAuthenticationFilter extends UsernamePasswordAuthenticationFilter{

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        final String osInfo = request.getParameter("osInfo");
        request.getSession().setAttribute("osInfo", osInfo);

        final String deviceToken = request.getParameter("token");
        request.getSession().setAttribute("deviceToken", deviceToken);

        return super.attemptAuthentication(request, response);
    }
}
