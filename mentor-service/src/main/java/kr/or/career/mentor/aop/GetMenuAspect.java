package kr.or.career.mentor.aop;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.AuthorityException;
import kr.or.career.mentor.util.SessionUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 로그인 체크와 해당 로그인 아이디의 원한이 있는 메뮤 리스트 조회
 * @author acevedo
 *
 */
@Aspect
public class GetMenuAspect {

    private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired(required=true)
    private HttpServletRequest request;

    /**
     * 세션 아이디로 해당 권한이 있는 메뉴 조회
     * @param joinPoint
     */
    @Before(value = "execution(* kr.*.career.mentor.controller..*.*(..))"
            + "and @annotation(org.springframework.web.bind.annotation.RequestMapping)")
    public void beforeGetMenu(JoinPoint joinPoint) {

        // 로그인 제외.
        if (joinPoint.getTarget().getClass().getName().indexOf("JoinController") != -1) {
            return;
        }

        //HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();

        /*
        Cookie cookie = CookieUtils.getCookie(request, "mentor");
        if(cookie == null || StringUtils.isEmpty(cookie.getValue())){
            //쿠키가 없으면 발행
            LOGGER.info("최초접속 접속 이력을 남겨주세요");
        }
        */

        HttpSession session = request.getSession();
        if(session != null){
            User user = SessionUtils.getUser();
            if(user != null && CodeConstants.CD100861_101506_승인요청.equals(user.getMbrStatCd())){
                throw new AuthorityException(AuthorityException.NOT_AUTHORIZED_USER);
            }
        }
        else {
            throw new AuthorityException(AuthorityException.NOT_LOGINED);
        }
        // throw new AuthorityException(AuthorityException.NOT_AUTHORIZED_MENU);
    }

}
