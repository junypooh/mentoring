/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SendAndResult
 *
 * 	{@link kr.or.career.mentor.domain.Message}를 전송시 송신자별로 분리하여 전송하고 그 결과를 담고 있는 도메인
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 27. 오후 3:00
 */
@Data
@NoArgsConstructor
public class SendAndResult<T extends PayLoad> {
    private MessageReciever reciever;
    private T payload;
    private MessageType contentType;
    private String regMbrNo;
    private MessageSender sender;
    /**
     * 메시지 전송 결과
     */
    private int result;
    /**
     * 메시지 전송 결과 메시지
     */
    private String resultMsg;

    /**
     * 발송 대상 코드 (SMS, Push, Email)
     */
    private String messageSendType;

    private MessageSendType sendType;

    /**
     * 발송 상태 코드  (발송대기,발송완료,발송취소,발송실패)
     * SUP_CD : 101036
     */
    private String statusCode;

    /**
     * 발송 일시
     */
    private Date sendDate;

    /**
     * 등록일시
     */
    private Date regDate;

    private Integer msgSer;

    private Integer sendTargetSer;

    private String sendTargetInfo;

    private String sendTitle;

    public String getSendContent(){
        String message = payload.payload(null);

        if(payload.getMessage() != null)
            this.sendTitle = payload.getMessage().getSendTitle();

        return message;
    }

    public String getSendMessage(){

        String message = payload.payload(getSendType());

        if(payload.getMessage() != null)
            this.sendTitle = payload.getMessage().getSendTitle();

        return message;
    }

    public String getSendTargetInfo(){
        String returnValue = "";
        switch (sendType){
            case EMS :
                returnValue = reciever.getMailAddress();
            break;
            case SMS :
                returnValue = reciever.getTelNo();
                break;
            case PUSH :
                returnValue = reciever.getDeviceToken();
                break;
            default:
                break;
        }

        return returnValue;
    }

}
