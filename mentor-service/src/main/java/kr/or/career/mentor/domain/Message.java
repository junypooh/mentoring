/* ntels */
package kr.or.career.mentor.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    Message
 *
 * 	알림 기능의 메시지
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 27. 오후 2:09
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ToString
public class Message<T extends PayLoad> {

    /**
     * 메시지를 발송 대샹 정보
     */
    private MessageSender messageSender;

    private String osType;

    /**
     * 메시지를 송신할 대상 목록
     */
    private List<MessageReciever> targets;

    /**
     * content 내용 (보내는 메시지 대상에 따라서 변경되어져야 함.)
     */
    @JsonIgnore
    private T payload;

    /**
     * content의 유형( 1 : 14세 미만 회원가입동의 ,....수업신청 대기 확정 ..)
     */
    private MessageType contentType;

    /**
     * 메시지 발송 회원
     */
    private String mbrNo;

    /**
     * 메시지 등록 일자
     */
    private Date regDtm;

    /**
     * 전송 메시지 대상 유형(SMS, Email, Push)의 조합키
     */
    private int sendType;

    private String sendTitle;

    public void setSendType(int messageSendType){
        this.sendType = messageSendType;
/*        int value = 0;
        for (MessageSendType type : values) {
            value |= type.getValue();
        }
        sendType = value;*/
    }

    public void setPayload(T payLoad){
        this.payload = payLoad;
        payLoad.setMessage(this);
    }

    public void addReciever(MessageReciever reciever){
        if(this.targets == null){
            this.targets = Lists.newArrayList();
        }

        this.targets.add(reciever);
    }

    public void addReciever(List<MessageReciever> recievers){
        if(this.targets == null){
            this.targets = Lists.newArrayList();
        }

        this.targets.addAll(recievers);
    }

    public void addReceiver(String mbrNo){
        this.targets.add(MessageReciever.of(mbrNo,false));
    }

}
