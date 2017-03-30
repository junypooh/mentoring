/* ntels */
package kr.or.career.mentor.aop;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.dao.BannerMapper;
import kr.or.career.mentor.dao.WorkHistoryMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.PredicateUtils;
import org.apache.commons.lang.StringUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.lang.annotation.Annotation;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.aop
 *    FormConfigurationAspect
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 20. 오후 4:09
 */
@Aspect
@Slf4j
public class FormConfigurationAspect {

    @Autowired(required = true)
    private HttpServletRequest request;

    @Autowired
    private WorkHistoryMapper workHistoryMapper;

    @Before(value = "execution(* kr.*.career.mentor.controller..*.*(..,@kr.or.career.mentor.annotation.Pageable (*),..))")
//    @Before(value = "execution(* kr.or.career.mentor.controller..*.*(..,@kr.or.career.mentor.annotation.Pageable (*),..))")
    public void setParameter(JoinPoint joinPoint) {

        Object[] args = joinPoint.getArgs();

        for (Object obj : args) {
            if (obj != null) {
                try {
                    if (obj instanceof Base) {
                        ((Base) obj).setPageable(true);

                        MethodSignature signature = ((MethodSignature) joinPoint.getSignature());
                        int size = 0;
                        for (Annotation[] ans : signature.getMethod().getParameterAnnotations()) {
                            size = getSizeFromAnnotation(ans, size);
                        }

                        if (size != 0) {
                            ((Base) obj).setRecordCountPerPage(size);
                        }
                    }
                } catch (IllegalArgumentException e) {
                    continue;
                }
            }
        }
    }

    @Before(value = "execution(* kr.*.career.mentor.controller..*.*(..))")
    public void setWorkHistory(JoinPoint joinPoint) {

        Object[] args = joinPoint.getArgs();

        Annotation[] methodAnnotations = ((MethodSignature) (joinPoint.getSignature())).getMethod().getDeclaredAnnotations();
        Annotation[] classAnnotations = ((Class) joinPoint.getTarget().getClass()).getDeclaredAnnotations();

        RequestMapping classRequestMapping = (RequestMapping) CollectionUtils.find(Arrays.asList(classAnnotations)
                , PredicateUtils.instanceofPredicate(RequestMapping.class));

        RequestMapping methodRequestMappings = (RequestMapping) CollectionUtils.find(Arrays.asList(methodAnnotations)
                , PredicateUtils.instanceofPredicate(RequestMapping.class));

        Historic historic = (Historic) CollectionUtils.find(Arrays.asList(methodAnnotations)
                , PredicateUtils.instanceofPredicate(Historic.class));

        try {
            if (historic != null) {
                String workNo = historic.workId();
                String[] classUrls = classRequestMapping.value();
                String[] methodUrls = methodRequestMappings.value();

                User user = SessionUtils.getUser();

                if (StringUtils.isNotEmpty(workNo) && user != null) {

                    WorkInfo workInfo = createWorkInfo(args, workNo, classUrls, methodUrls, user);

                    log.debug("workInfo :: {}", workInfo);

                    saveWrokInfo(workInfo);

                    saveWorkHistory(workInfo);

                }
            }
        } catch (Exception e) {
            //Nothing
        }
    }

    private WorkInfo createWorkInfo(Object[] args, String workNo, String[] classUrls, String[] methodUrls, User user) throws UnknownHostException {
        WorkInfo workInfo = new WorkInfo();
        workInfo.setWorkNo(workNo);
        workInfo.setMbrNo(user.getMbrNo());

        if (args.length > 0) {
            List targetObjs = Lists.newArrayList();

            for(Object obj : args){
                if(obj instanceof Model)
                    continue;
                else if(obj instanceof Authentication)
                    continue;
                else if(obj instanceof BindingResult)
                    continue;
                else {
                    targetObjs.add(obj);
                    setTargtMbrInfo(obj, workNo, workInfo);
                }
            }

            if(targetObjs.size() > 0) {
                Gson gson = new Gson();
                workInfo.setReqInfoSmry(gson.toJson(targetObjs));
            }


        }

        workInfo.setConnIp(getRealIpAddr());

        String workUrl = compositeUrl(classUrls,methodUrls);
        workInfo.setWorkUrl(workUrl);

        return workInfo;
    }

    private String compositeUrl(String[] classUrls, String[] methodUrls) {
        StringBuilder url = new StringBuilder();

        if(classUrls.length > 0) {
            if (classUrls[0].charAt(0) == '/') {
                url.append(classUrls[0]);
            } else {
                url.append('/').append(classUrls[0]);
            }
        }

        if(methodUrls.length > 0) {
            if (methodUrls[0].charAt(0) == '/') {
                url.append(methodUrls[0]);
            } else {
                url.append('/').append(methodUrls[0]);
            }
        }

        return url.toString();
    }

    private void saveWrokInfo(WorkInfo workInfo) {
        workHistoryMapper.saveWorkInfo(workInfo);
    }

    private void setTargtMbrInfo(Object obj, String workNo, WorkInfo workInfo) {
        if ("1000000007".equals(workNo)) {
            workInfo.setTargtMbrNo(((User) obj).getMbrNo());
        } else if ("1000000014".equals(workNo)) {
            workInfo.setTargtMbrNo(((UserSearch) obj).getMbrNo());
        } else if ("1000000011".equals(workNo)) {
            workInfo.setTargtMbrNo(((String) obj));
        }
    }

    private String getRealIpAddr() throws UnknownHostException {

        String remoteAddr = request.getHeader("X-Forwarded-For");

        if (remoteAddr == null || remoteAddr.length() == 0 || "unknown".equalsIgnoreCase(remoteAddr)) {
            remoteAddr = request.getHeader("Proxy-Client-IP");
        }
        if (remoteAddr == null || remoteAddr.length() == 0 || "unknown".equalsIgnoreCase(remoteAddr)) {
            remoteAddr = request.getHeader("WL-Proxy-Client-IP");
        }
        if (remoteAddr == null || remoteAddr.length() == 0 || "unknown".equalsIgnoreCase(remoteAddr)) {
            remoteAddr = request.getHeader("HTTP_CLIENT_IP");
        }
        if (remoteAddr == null || remoteAddr.length() == 0 || "unknown".equalsIgnoreCase(remoteAddr)) {
            remoteAddr = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (remoteAddr == null || remoteAddr.length() == 0 || "unknown".equalsIgnoreCase(remoteAddr)) {
            remoteAddr = request.getRemoteAddr();
        }

        if (remoteAddr.equals("0:0:0:0:0:0:0:1")) {
            InetAddress localIp = InetAddress.getLocalHost();
            remoteAddr = localIp.getHostAddress();
        }
        return remoteAddr;
    }

    private int getSizeFromAnnotation(Annotation[] ans, int size) {
        for (Object paramAnno : ans) {
            if (paramAnno instanceof Pageable) {
                size = ((Pageable) paramAnno).size();
            }
        }
        return size;
    }

    private int saveWorkHistory(WorkInfo workInfo) {
        return workHistoryMapper.saveWorkHistory(workInfo);
    }

}
