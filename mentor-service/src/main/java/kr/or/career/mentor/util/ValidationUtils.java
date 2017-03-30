package kr.or.career.mentor.util;

import java.util.regex.Pattern;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.springframework.validation.Errors;

@Slf4j
public class ValidationUtils {

    //@formatter:off
    private static String ATOM = "[a-z0-9!#$%&'*+/=?^_`{|}~-]";
    private static String DOMAIN = "(" + ATOM + "+(\\." + ATOM + "+)*";
    private static String IP_DOMAIN = "\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\]";
    private static String ID = "^[a-z]+[a-z0-9_-]{4,12}$";
    private static String PASSWORD = "^.{10,20}$";
    private static String PHONE = "^0\\d{2,3}-\\d{3,4}-\\d{4}$";
    private static Pattern emailPattern = Pattern.compile(
            "^" + ATOM + "+(\\." + ATOM + "+)*@"
                    + DOMAIN + "|" + IP_DOMAIN
                    + ")$",
            Pattern.CASE_INSENSITIVE
    );
    private static Pattern idPattern = Pattern.compile(ID);
    private static Pattern passwordPattern = Pattern.compile(PASSWORD);
    private static Pattern phonePattern = Pattern.compile(PHONE);
    //@formatter:on

    public static void rejectIf(Errors errors, String message) {
        errors.reject(null, message);
    }

    public static void rejectIfEmpty(Errors errors, String field, String message) {
        Object fieldValue = errors.getFieldValue(field);
        log.debug("getFieldValue[{}={}]", field, fieldValue);

        if (isEmpty(fieldValue)) {
            errors.rejectValue(field, null, message);
        }
    }

    public static void rejectIfEmail(Errors errors, String field, String message) {
        Object fieldValue = errors.getFieldValue(field);
        log.debug("getFieldValue[{}={}]", field, fieldValue);

        if (isNotEmpty(fieldValue) && !emailPattern.matcher(String.valueOf(fieldValue)).matches()) {
            errors.rejectValue(field, null, message);
        }
    }

    public static void rejectIfId(Errors errors, String field, String message) {
        Object fieldValue = errors.getFieldValue(field);
        log.debug("getFieldValue[{}={}]", field, fieldValue);

        if (isNotEmpty(fieldValue) && !idPattern.matcher(String.valueOf(fieldValue)).matches()) {
            errors.rejectValue(field, null, message);
        }
    }

    public static void rejectIfPhone(Errors errors, String field, String message) {
        Object fieldValue = errors.getFieldValue(field);
        log.debug("getFieldValue[{}={}]", field, fieldValue);

        if (isNotEmpty(fieldValue) && !phonePattern.matcher(String.valueOf(fieldValue)).matches()) {
            errors.rejectValue(field, null, message);
        }
    }

    public static void rejectIfPassword(Errors errors, String field, String message) {
        Object fieldValue = errors.getFieldValue(field);
        log.debug("getFieldValue[{}={}]", field, fieldValue);

        if (isNotEmpty(fieldValue) && !passwordPattern.matcher(String.valueOf(fieldValue)).matches()) {
            errors.rejectValue(field, null, message);
        }
    }

    // =====================================================================
    public static void rejectIf(Errors errors, CodeMessage codeMessage) {
        errors.reject(null, codeMessage.toMessage());
    }

    public static void rejectIfEmpty(Errors errors, String field, CodeMessage codeMessage) {
        rejectIfEmpty(errors, field, codeMessage.toMessage());
    }

    public static void rejectIfEmail(Errors errors, String field, CodeMessage codeMessage) {
        rejectIfEmail(errors, field, codeMessage.toMessage());
    }

    public static void rejectIfId(Errors errors, String field, CodeMessage codeMessage) {
        rejectIfId(errors, field, codeMessage.toMessage());
    }

    public static void rejectIfPhone(Errors errors, String field, CodeMessage codeMessage) {
        rejectIfPhone(errors, field, codeMessage.toMessage());
    }

    public static void rejectIfPassword(Errors errors, String field, CodeMessage codeMessage) {
        rejectIfPassword(errors, field, codeMessage.toMessage());
    }

    private static boolean isEmpty(Object o) {
        if (o instanceof String) {
            return StringUtils.isBlank((String) o);
        }
        else {
            return (o == null);
        }
    }

    private static boolean isNotEmpty(Object o) {
        return !isEmpty(o);
    }
}
