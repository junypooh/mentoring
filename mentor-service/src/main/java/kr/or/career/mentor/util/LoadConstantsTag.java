package kr.or.career.mentor.util;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.reflect.FieldUtils;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Map;

@Slf4j
public class LoadConstantsTag extends TagSupport {
    private static final long serialVersionUID = -552581244670709101L;

    private static Cache<String, Map<String, Object>> cache = CacheBuilder.newBuilder().build();

    private static Object syncObject = new Object();

    private String className;

    private String var;

    @Override
    @SneakyThrows
    public int doStartTag() throws JspException {
        Map<String, Object> values = loadContains();

        if (MapUtils.isEmpty(values)) {
            return SKIP_BODY;
        }

        if (StringUtils.isBlank(var)) {
            JspWriter out = pageContext.getOut();
            out.print(values);
        }
        else {
            pageContext.setAttribute(var, values);
        }

        return SKIP_BODY;
    }

    @SneakyThrows
    private Map<String, Object> loadContains() {
        synchronized (syncObject) {
            if (cache.getIfPresent(className) != null) {
                return cache.getIfPresent(className);
            }

            Class<?> clazz = Class.forName(className);
            if (clazz.isEnum()) {
                Object[] enumObjects = clazz.getEnumConstants();
                Map<String, Object> contains = new HashMap<>();
                for (Object o : enumObjects) {
                    log.debug("Read enum: {}", o);
                    contains.put(((Enum<?>) o).name(), o);
                }
                cache.put(className, contains);
                return contains;
            }
            else {
                Map<String, Object> contains = new HashMap<>();
                Field[] fields = FieldUtils.getAllFields(clazz);
                for (Field field : fields) {
                    log.debug("Read field: {} (type: {})", field.getName(), field.getType());
                    int modifiers = field.getModifiers();
                    if ((modifiers & Modifier.PUBLIC) == 0 || (modifiers & Modifier.STATIC) == 0
                            || (modifiers & Modifier.FINAL) == 0) {
                        continue;
                    }
                    contains.put(field.getName(), field.get(null));
                }
                cache.put(className, contains);
                return contains;
            }
        }
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public void setVar(String var) {
        this.var = var;
    }



}
