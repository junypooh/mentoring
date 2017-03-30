/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.util.ApplicationContextUtils;
import kr.or.career.mentor.util.EgovProperties;
import lombok.*;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.ui.velocity.VelocityEngineUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SimplePayLoad
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 24. 오전 3:26
 */
@Data
@RequiredArgsConstructor(staticName = "of")
@AllArgsConstructor
@NoArgsConstructor
@ToString(exclude = "message")
public class SimplePayLoad implements PayLoad {

    private String content;

    private String title;

    @NonNull
    private Message message;

    @Override
    public String payload(MessageSendType messageSendType) {
        String sendMessage = "";
        if(this.content == null)
            sendMessage = this.title;
        else
            sendMessage = this.content;
        //return sendMessage;

        if(messageSendType == MessageSendType.EMS){
            return generateMailMessage(null);
        }else {
            /*StringBuffer sb = new StringBuffer();
            sb.append(name).append(":").append(startDate).append(":").append(mentor);
            return sb.toString();*/
            return sendMessage;
        }
    }

    private String generateMailMessage(String what){


        String returnMessage = "";

        String vmFile = "";
        String url = "";

        vmFile = "velocity/mentor/notifyMail.vm";
        url = EgovProperties.getProperty("MENTORING_SCHOOL");

        returnMessage = this.title;



        Map model = new HashMap();

        model.put("message", this);
        model.put("url",url);
        model.put("imgUrl", EgovProperties.getProperty("MENTORING_ADMIN"));


        if(what == null) {
            VelocityEngine velocityEngine = (VelocityEngine) ApplicationContextUtils.getBean("velocityEngine");
            return VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, vmFile, "UTF-8", model);
        }else{
            return returnMessage;
        }
        //VelocityEngine velocityEngine = (VelocityEngine) ApplicationContextUtils.getBean("velocityEngine");
        //return  VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, vmFile, "UTF-8", model);
    }

    @Override
    public void setMessage(Message message) {

    }

    @Override
    public boolean isCompleted() {
        return false;
    }
}
