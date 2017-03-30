package kr.or.career.mentor.filter;

import org.apache.logging.log4j.ThreadContext;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.io.IOException;


public class Log4jMDCFilter extends GenericFilterBean {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException,
            ServletException {
        try {
            //@formatter:off
            ThreadContext.put("tid", String.format("T%05d:%X",
                    Thread.currentThread().getId(),
                    System.currentTimeMillis() & 0xFFF));
            //@formatter:on
            ;
            chain.doFilter(request, response);
        }
        finally {
            ThreadContext.remove("tid");
        }
    }


}
