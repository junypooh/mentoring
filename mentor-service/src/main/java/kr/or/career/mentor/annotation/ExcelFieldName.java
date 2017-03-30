package kr.or.career.mentor.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 엑셀파일 다운로드 처리를 위한 필드명 매핑 인터페이스
 *
 */
@Target({ ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
public @interface ExcelFieldName {
    public abstract String name() default "";
    public abstract int order() default -1;
}
