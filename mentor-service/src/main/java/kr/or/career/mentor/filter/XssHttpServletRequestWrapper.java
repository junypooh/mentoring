package kr.or.career.mentor.filter;

import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;
import org.owasp.esapi.ESAPI;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.util.*;

/**
 * Created by chaos on 15. 9. 3..
 */
public class XssHttpServletRequestWrapper extends HttpServletRequestWrapper implements HttpServletRequest {

    /**
     * Constructs a request object wrapping the given request.
     *
     * @param request
     * @throws IllegalArgumentException if the request is null
     */
    public XssHttpServletRequestWrapper(HttpServletRequest request) {
        super(request);
    }

    public String[] getParameterValues(String name) {
        String[] values = super.getParameterValues(name);

        if (values == null) return null;

        int count = values.length;
        String[] cleanValues = new String[count];

        for (int i = 0; i < count; i++) {
            if(!Jsoup.isValid(values[i],Whitelist.none()))
                cleanValues[i] = strip(values[i]);
            else
                cleanValues[i] = values[i];
        }

        return cleanValues;
    }

    public String getParameter(String name) {
        String value = super.getParameter(name);
        if(value == null)
            return null;
        if(!Jsoup.isValid(value,Whitelist.none()))
            value = strip(value);
        return value;
    }

    public Enumeration getHeaders(String name) {
        Vector<String> cleanValues = new Vector<>();
        Enumeration<String> enumeration = super.getHeaders(name);

        while (enumeration.hasMoreElements()) {
            cleanValues.add(strip(enumeration.nextElement()));
        }

        return Collections.enumeration(cleanValues);
    }

    public String getHeader(String name) {
        String value = super.getHeader(name);
        return strip(value);
    }

    public Cookie[] getCookies() {
        Cookie[] cookies = super.getCookies();
        if (cookies == null) return new Cookie[0];

        List<Cookie> newCookies = new ArrayList<Cookie>();
        for (Cookie c : cookies) {
            String name = c.getName();
            String value = strip(c.getValue());
            int maxAge = c.getMaxAge();
            String domain = c.getDomain();
            String path = c.getPath();
            String comment = c.getComment();

            Cookie n = new Cookie(name, value);

            n.setMaxAge(maxAge);
            if(domain != null)
                n.setDomain(domain);
            if(path != null)
                n.setPath(path);
            if(comment != null)
                n.setComment(comment);
            newCookies.add(n);
        }
        return newCookies.toArray(new Cookie[newCookies.size()]);
    }

    private String strip(String value) {

        if (value == null) return null;

        value = ESAPI.encoder().canonicalize(value);

        value.replaceAll("\0", "");

        Whitelist whitelist = Whitelist.relaxed();
        whitelist.addAttributes("img", "src", "class","style");
        whitelist.removeProtocols("img", "src", "http", "https");
        whitelist.addAttributes("p", "style", "class");
        whitelist.addAttributes("td", "style", "class");
        whitelist.addAttributes("span", "style", "class");
        whitelist.addAttributes("table", "style", "class");
        whitelist.addAttributes("a", "target", "class", "style");

        value = Jsoup.clean(value, whitelist);

        return value;

    }


}
