package kr.or.career.mentor.util;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Locale;

@Component
public class MessageUtils {

    private static MessageSource messageSource;

    @Autowired(required = true)
    public MessageUtils(@Qualifier("messageSource") MessageSource messageSource) {
        MessageUtils.messageSource = messageSource;
    }

    private static Locale getLocale() {
        Locale defaultLocale = Locale.getDefault();

        RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
        if (requestAttributes == null) {
            return defaultLocale;
        }

        HttpServletRequest request = ((ServletRequestAttributes) requestAttributes)
                .getRequest();
        String headerLocale = request.getHeader("Accept-Language");
        if (StringUtils.isNotBlank(headerLocale)) {
            if (headerLocale.indexOf(Locale.JAPAN.getLanguage()) != -1) {
                defaultLocale = Locale.JAPAN;
            }
            else if (headerLocale.indexOf(Locale.KOREA.getLanguage()) != -1) {
                defaultLocale = Locale.KOREA;
            }
        }
        return defaultLocale;
    }

    public static String getMessage(String messageId) {
        return getMessage(messageId, null, getLocale());
    }

    public static String getMessage(String messageId, Object... params) {
        return getMessage(messageId, params, getLocale());
    }

    public static String getMessage(String messageId, Object[] params, Locale locale) {
        return messageSource.getMessage(messageId, params, locale);
    }

    public static String getMessage(String messageId, Object[] params, String arg, Locale locale) {
        return messageSource.getMessage(messageId, params, arg, locale);
    }
}