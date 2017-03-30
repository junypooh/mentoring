/* ntels */
package kr.or.career.mentor.domain;

import com.google.common.collect.Maps;
import kr.or.career.mentor.constant.Constants;
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
 *    MemberPayLoad
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
public class MemberPayLoad implements PayLoad {

    private String id;
    private String password;
    private String name;
    private String type;
    @NonNull
    private String mbrNo;

    private String siteClass;

    @NonNull
    private Message message;

    /**
     * (취소,반려)사유
     */
    private String cause;

    @NonNull
    private boolean completed;

    //private String sendMessage;

    @Override
    public String payload(MessageSendType messageSendType) {

        Map<String,String> messageMap = Maps.newHashMap();
        if(messageSendType == MessageSendType.EMS){
            messageMap = generateMailMessage(null);

            //if(StringUtils.isEmpty(message.getSendTitle()))
            message.setSendTitle(messageMap.get("title"));
            return messageMap.get("returnMessage");
        }else {
            /*StringBuffer sb = new StringBuffer();
            sb.append(name).append(":").append(startDate).append(":").append(mentor);
            return sb.toString();*/
            messageMap = generateMailMessage("title");
            return messageMap.get("returnMessage");
        }
    }

    private Map generateMailMessage(String what){


        String returnMessage = "";

        String vmFile = "";

        String url = "";

        switch (message.getContentType()) {
            case JOIN_APPLY :
                vmFile = "velocity/mentor/mentor_join_finish.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 멘토 회원 가입 신청되었습니다.";
                break;
            case JOIN_CONFIRM :
                this.type = "회원 가입 승인 요청";
                vmFile = "velocity/mentor/mentor_admin_approve.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 관리자 승인을 알려드립니다.";
                break;
            case JOIN_SCHOOL :
                vmFile = "velocity/school/member_complete.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "산들바람 회원가입이 완료되었습니다.";
                break;
            case JOIN_AGREE :
                vmFile = "velocity/school/member_agreement.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "산들바람 회원 가입동의 안내";
                break;
            case SEARCH_INFO :
                vmFile = "velocity/school/member_password_search.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "산들바람 임시 비밀번호를 알려드립니다.";
                break;
            case SECEDE_SCHOOL :
                vmFile = "velocity/school/member_out.vm";
                url = EgovProperties.getProperty("MENTORING_SCHOOL");
                returnMessage = "산들바람 회원탈퇴가 정상 처리되었습니다.";
                break;
            case JOIN_MENTOR :
                vmFile = "velocity/mentor/mentor_idpw.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 소속멘토 회원 아이디 및 비밀번호가 발급되었습니다.";
                break;
            case SECEDE_MENTOR :
                vmFile = "velocity/mentor/mentor_member_out.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 멘토 서비스 회원탈퇴가 완료되었습니다.";
                break;
            case SECEDE_MENTOR_APPLY:
                vmFile = "velocity/mentor/mentor_member_out01.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 멘토 서비스 회원탈퇴 신청이 완료되었습니다.";
                break;
            case SECEDE_RETURN_MENTOR:
                vmFile = "velocity/mentor/mentor_out_return.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 멘토 회원 탈퇴 신청이 반려되었습니다.";
                break;
            case JOIN_REJECT :
                this.type = "개인멘토 회원가입 승인요청";
                vmFile = "velocity/mentor/mentor_admin_return.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 관리자 반려를 알려드립니다.";
                break;
            case JOIN_CONFIRM_ADMIN :
                vmFile = "velocity/admin/admin_idpw.vm";
                url = EgovProperties.getProperty("MENTORING_ADMIN");
                returnMessage = "산들바람 관리자 사이트에 가입하신 걸 환영합니다.";
                break;
            case JOIN_CONFIRM_MENTOR_ADMIN :
                vmFile = "velocity/admin/mentor_idpw_issue.vm";
                url = EgovProperties.getProperty("MENTORING_ADMIN");
                returnMessage = "산들바람 관리자 사이트에 가입하신 걸 환영합니다.";
                break;
            case ADMIN_APPROVE:
                this.type = "회원 가입 승인 요청";
                vmFile = "velocity/mentor/mentor_admin_approve.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 관리자 승인을 알려드립니다.";
                break;
            case MENTOR_APPROVE:
                this.type = "개인 멘토 승인";
                vmFile = "velocity/mentor/mentor_confirm.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 멘토 회원으로 승인되었습니다.";
                break;
            case MENTOR_RETURN:
                this.type = "개인 멘토 반려";
                vmFile = "velocity/mentor/mentor_confirm_return.vm";
                url = EgovProperties.getProperty("MENTORING_MENTOR");
                returnMessage = "산들바람 멘토 회원 가입이 반려되었습니다.";
                break;
            case RESET_PASSWD_BYADMIN:
                vmFile = "velocity/school/member_password_search.vm";

                if(Constants.SCHOOL.equals(siteClass))
                    url = EgovProperties.getProperty("MENTORING_SCHOOL");
                else if (Constants.MENTOR.equals(siteClass))
                    url = EgovProperties.getProperty("MENTORING_MENTOR");
                else
                    url = EgovProperties.getProperty("MENTORING_ADMIN");

                returnMessage = "산들바람 임시 비밀번호를 알려드립니다.";
                break;
            default:
                break;
        }

        Map model = new HashMap();

        model.put("member", this);
        model.put("url", url);
        model.put("title", returnMessage);
        model.put("imgUrl", EgovProperties.getProperty("MENTORING_ADMIN"));


        if(what == null) {
            VelocityEngine velocityEngine = (VelocityEngine) ApplicationContextUtils.getBean("velocityEngine");
            //return VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, vmFile, "UTF-8", model);

            model.put("returnMessage",VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, vmFile, "UTF-8", model));

        }else{
            model.put("returnMessage",returnMessage);
        }
        //VelocityEngine velocityEngine = (VelocityEngine) ApplicationContextUtils.getBean("velocityEngine");
        //return  VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, vmFile, "UTF-8", model);
        return model;
    }
}
