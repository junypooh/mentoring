package kr.or.career.mentor.util;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.springframework.web.util.HtmlUtils;

import java.nio.CharBuffer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Slf4j
public class PooqUtils {

    /**
     * HTML 로 변경할 부분이 있으면 추가
     *
     * @param src
     * @return
     */
    public static String toHTML(String src) {
        src = StringUtils.replace(src, "<", "&lt;");
        src = StringUtils.replace(src, ">", "&gt;");
        src = StringUtils.replace(src, StringUtils.LF, "<br />");

        return src;
    }


    /**
     * 문자 날짜를 Date로 변경
     *
     * @param src
     * @return
     */
    public static Date parseDate(String src) {

        try {
            return DateUtils.parseDate(src, "yyyyMMdd", "yyMMdd");
        }
        catch (ParseException e) {
            log.error("str({} -> date", src);
            return null;
        }
    }


    /**
     * 문자 시간을 Date로 변경
     *
     * @param src
     * @return
     */
    public static Date parseTime(String src) {
        try {
            return DateUtils.parseDate(src, "hhmmdd", "hhmm");
        }
        catch (ParseException e) {
            log.error("str({} -> time", src);
            return null;
        }
    }


    /**
     * 문자 시간 형식 맞추기
     *
     * @param src
     * @return
     */
    public static String datePattern(String src) {
        try {
            String temp = src.replaceAll("[^0-9]", "");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
            Date dt = sdf.parse(temp);
            sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
            return sdf.format(dt);
        }
        catch (ParseException e) {
            log.error("str({} -> time", src);
            return null;
        }
    }


    /**
     * 문자 날짜 시간 형태를 원하는 형태로 변경
     *
     * @param src
     * @param pattern
     * @return
     */
    public static String stringToDatePattern(String src, String pattern) {
        if (StringUtils.isBlank(src)) {
            return StringUtils.EMPTY;
        }

        try {
            Date dt = DateUtils.parseDate(src.replaceAll("[^0-9]", ""), "yyyyMMdd", "yyyyMMddHHmm", "yyyyMMddHHmmss");
            return DateFormatUtils.format(dt, pattern);
        }
        catch (ParseException e) {
            log.error("src({} -> time", src);
            return StringUtils.EMPTY;
        }
    }


    /**
     * 멘토 직업의 사진필드에서 하나의 사진만 정보만 잘라냄
     *
     * @param src
     * @return
     */
    public static String parsePicInfo(String src) {
        if (StringUtils.isNotBlank(src)) {
            return src.replaceAll("^([^,]+).*$", "$1");
        }
        return src;
    }


    /**
     * 검색어를 화면에 나타낼수 있도록 분리
     *
     * @param src
     * @return
     */
    public static String splitSearchKeyToHTML(String src) {
        //@formatter:off
        return HtmlUtils.htmlEscape(
                StringUtils.trimToEmpty(src)
                        .replaceAll(" +", ",")
                        .replaceAll("([^,]+)", "'$1'"));
        //@formatter:on
    }


    /**
     * 문자열을 Byte 단위로 잘라냄
     *
     * @param src
     * @param start
     * @param length
     * @return
     */
    public static String substrBytes(String src, int start, int length) {
        if (StringUtils.isBlank(src)) {
            return StringUtils.EMPTY;
        }

        int size = 0, offset = 0;
        CharBuffer buffer = CharBuffer.wrap(src);
        for (int i = start, len = src.length(); i < len; ++i) {
            int code = (int) buffer.get(i);
            do {
                code >>= 8;
                offset++;
            } while (code != 0);

            if (offset > length) {
                break;
            }
            size++;
        }
        return StringUtils.substring(src, start, start + size);
    }


    /**
     * 모든타입에 대해서 비어있는지 검사
     *
     * @param src
     */
    public static boolean isEmpty(Object src) {
        if (src instanceof Object[]) {
            return ArrayUtils.isEmpty((Object[]) src);
        }
        else if (src instanceof Collection) {
            return CollectionUtils.isEmpty((List<?>) src);
        }
        else if (src instanceof Map) {
            return MapUtils.isEmpty((Map<?, ?>) src);
        }
        else if (src instanceof String) {
            return StringUtils.isBlank((String) src);
        }
        else {
            return src == null;
        }
    }


    /**
     * 모든타입에 대해서 비어있지 않은지 검사
     *
     * @param src
     */
    public static boolean isNotEmpty(Object src) {
        return !isEmpty(src);
    }


    /**
     * 같은 값이 있는지 검사
     *
     * @param col
     * @param src
     * @return
     */
    public static boolean contains(Collection<?> col, Object src) {
        return isEmpty(col) ? false : col.contains(src);
    }


    /**
     * 같은 값이 있는지 검사
     *
     * @param array
     * @param src
     * @return
     */
    public static boolean contains(Object[] array, Object src) {
        return isEmpty(array) ? false : contains(Arrays.asList(array), src);
    }


    /**
     * 왼쪽에 필요한 문자를 추가
     *
     * @param src
     * @param length
     * @param padding
     * @return
     */
    public static String leftPad(String src, int length, String padding) {
        src = StringUtils.defaultString(src);
        padding = StringUtils.defaultString(padding, "_");
        return StringUtils.repeat(padding, length - src.length()) + src;
    }


    /**
     * 문자열을 잘라내서 해당 인덱스의 문자열을 반환
     *
     * @param src
     * @param separator
     * @param index
     * @return
     */
    public static String splitWithIndex(String src, String separator, int index) {
        String[] array = StringUtils.split(src, separator);
        if (array == null || ArrayUtils.isEmpty(array) || array.length <= index) {
            return StringUtils.EMPTY;
        }
        return array[index];
    }


    /**
     * 잘라낸 문자열중에 빈 문자열은 포함하지 않음
     *
     * @param src
     * @param separator
     * @return
     */
    public static List<String> splitOnTrim(String src, String separator) {
        List<String> list = new ArrayList<String>();
        String[] array = StringUtils.split(src, separator);
        if (array == null || ArrayUtils.isEmpty(array)) {
            return list;
        }

        for (String s : array) {
            if (StringUtils.isNotBlank(s)) {
                list.add(s);
            }
        }
        return list;
    }


    /**
     * 여러 리스트를 하나로 묶음
     *
     * @param args
     * @return
     */
    @SafeVarargs
    public static <T> List<T> merge(List<T>... args) {
        final List<T> result = new ArrayList<>();
        for (List<T> list : args) {
            result.addAll(list);
        }

        return result;
    }

    /*
     * <pre>
     * 줄임표
     * </pre>
     *
     * @param src
     * @param size
     * @return
     */
    public static String ellipsis(String src, int size){
        if(src == null || src.length() <= size){
            return src;
        }
        return src.substring(0,size)+"...";
    }



    public static boolean isMobile(String browserInfo){
        String[] mobileTags = { "cellphone","iemobile","midp","mini","mmp","mobile","nokia","pda","phone","pocket","ppc","psp","symbian","up.browser","up.link","wap","windows ce" };
        for ( int n=0; n<mobileTags.length; n++ )     {
            if ( browserInfo.toLowerCase().contains( mobileTags[n].toLowerCase() ) ){
                return true;
            }
        }
        return false;
    }

    public static Date calculateDate(Date date, String unit, int days) {

        if("y".equals(unit)) {
            return DateUtils.addYears(date, days);
        } else if("m".equals(unit)) {
            return DateUtils.addMonths(date, days);
        } else if("d".equals(unit)) {
            return DateUtils.addDays(date, days);
        } else {
            return DateUtils.addDays(date, days);
        }

    }
}
