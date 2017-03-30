/* ntels */
package kr.or.career.mentor.domain;

import com.google.common.collect.Maps;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.util.ApplicationContextUtils;
import kr.or.career.mentor.util.EgovProperties;
import lombok.*;
import org.apache.commons.lang.StringUtils;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.ui.velocity.VelocityEngineUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LecuturePayLoad
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 29. 오후 6:12
 */
@Data
@RequiredArgsConstructor(staticName = "of")
@AllArgsConstructor
@NoArgsConstructor
@ToString(exclude = "message")
public class LecturePayLoad implements PayLoad {

    /**
     * 수업명
     */
    private String name;
    /**
     * 수업일자 시작시간
     */
    private String startDate;
    /**
     * 해당 수업의 마지막 종료시간(연강일 경우 마지막 수업의 종료시간)
     */
    private String endTime;
    /**
     * 멘토명
     */
    private String mentor;

    private String type;
    /**
     * (취소,반려)사유
     */
    private String cause;

    @NonNull
    private Message message;

    private String sendMessage;

    @NonNull
    private Integer lectSer;

    @NonNull
    private Integer lectTims;

    @NonNull
    private boolean completed;

    @Override
    public String payload(MessageSendType messageSendType) {
        Map<String,String> messageMap = Maps.newHashMap();
        if(messageSendType == MessageSendType.EMS){
            messageMap = generateMailMessage(null);
            //if(StringUtils.isEmpty(message.getSendTitle()))
            message.setSendTitle(messageMap.get("title"));
            return messageMap.get("returnMessage");
        }else {
            messageMap = generateMailMessage("title");
            return messageMap.get("returnMessage");
        }
    }

    private Map generateMailMessage(String what){

        String returnMessage = "";

        String vmFile = "";
        String url = "";

        switch (message.getContentType()) {
            case LECTURE_APPLY:
                vmFile = "velocity/school/member_lesson_request.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "수업 신청이 완료되었습니다.";
                break;
            case LECTURE_STANDBY :
                vmFile = "velocity/school/member_lesson_standby.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "수업 대기 접수가 완료되었습니다.";
                break;
            case LECTURE_STANDBY_CONFIRM:
                vmFile = "velocity/school/member_lesson_decide.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "수업 대기 접수가 확정되었습니다.";
                break;
            case LECTURE_STANDBY_CANCEL:
                vmFile = "velocity/school/member_lesson_cancel.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "수업 대기 접수가 취소되었습니다.";
                break;
            case LECTURE_CANCEL_LECTURE:
                vmFile = "velocity/school/member_lesson_cancel_notice.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "산들바람 신청 수업 취소를 알립니다.";
                break;
            case LECTURE_CANCEL_SELF:
                vmFile = "velocity/school/member_lesson_cancel_notice2.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "산들바람 신청 수업 취소를 알립니다.";
                break;
            case LECTURE_OPEN:
                vmFile = "velocity/mentor/mentor_lesson_open.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 수업 개설이 완료되었습니다.";
                break;
            case LECTURE_CONFIRM:
                vmFile = "velocity/mentor/mentor_lesson_decide.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 수업이 확정되었습니다.";
                break;
            case LECTURE_CLOSE:
                vmFile = "velocity/mentor/mentor_lesson_abolish.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 수업이 폐지되었습니다.";
                break;
            case ADMIN_APPROVE:
                this.type = "수업개설 승인 요청";
                vmFile = "velocity/mentor/mentor_admin_approve.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 관리자 승인을 알려드립니다.";
                break;
            case ADMIN_RETURN:
                this.type = "수업개설 승인 요청";
                vmFile = "velocity/mentor/mentor_lecture_return.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 관리자 반려를 알려드립니다.";
                break;
            default:
                break;
        }

        Map model = new HashMap();
        model.put("lecture", this);
        model.put("url",url);
        model.put("title", returnMessage);
        model.put("imgUrl", EgovProperties.getProperty("MENTORING_ADMIN"));

        if(what == null) {
            VelocityEngine velocityEngine = (VelocityEngine) ApplicationContextUtils.getBean("velocityEngine");
            model.put("returnMessage",VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, vmFile, "UTF-8", model));
        }else{
            model.put("returnMessage",returnMessage);
        }

        return model;
    }
}
