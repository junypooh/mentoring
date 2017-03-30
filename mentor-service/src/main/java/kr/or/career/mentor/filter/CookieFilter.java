package kr.or.career.mentor.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.career.mentor.util.CookieUtils;

import org.apache.commons.lang3.StringUtils;

public class CookieFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        
        Cookie cookie = CookieUtils.getCookie(request, "mentor");
        if(cookie == null || StringUtils.isEmpty(cookie.getValue())){
        	CookieUtils.setCookie((HttpServletResponse)res, "mentor", "1", "", -1);
        }
        
        chain.doFilter(req, res);
    }
    public void init(FilterConfig config) throws ServletException {
        // some initialization code called when the filter is loaded
    }
    public void destroy() {
        // executed when the filter is unloaded
    }
}