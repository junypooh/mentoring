package kr.or.career.mentor.util;

import org.codehaus.jackson.map.ObjectMapper;

/**
 * <pre>
 * kr.or.career.mentor.util
 *      JSONUtil
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-29 오후 5:16
 */
public class JSONUtil {
    /** JSON 기본 설정*/
    private static final String JSON = "{}";

    /**
     * 인스턴스 생성 방지.
     */
    private JSONUtil() {
    }

    /**
     * JSON 형태로 변환.
     * @param object JSON 변환할 객체.
     * @return object JSON 형태.
     */
    public static String toJSON(final Object object) {
        ObjectMapper objectMapper = new ObjectMapper();
        String json = "null";
        try {
            json = objectMapper.writeValueAsString(object);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // JSON 변환이 없으면 기본 JSON
        if (json.equals("null")) {
            return JSONUtil.JSON;
        } else {
            return json;
        }
    }

    public static Object toObject(String content, Class<?> valueType) {
        ObjectMapper objectMapper = new ObjectMapper();
        Object object = null;

        try {
            object = objectMapper.readValue(content, valueType);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return object;
    }
}
