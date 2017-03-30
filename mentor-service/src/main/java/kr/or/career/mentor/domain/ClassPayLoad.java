/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.constant.MessageSendType;
import lombok.Data;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ClassPayLoad
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 29. 오후 6:13
 */
@Data
@RequiredArgsConstructor(staticName = "of")
public class ClassPayLoad implements PayLoad {

    /**
     * 교실명
     */
    private String name;
    /**
     * 신청자
     */
    private String applier;
    /**
     * 승인자
     */
    private String admittance;
    /**
     * (반려,승인)사유
     */
    private String cause;

    @NonNull
    private Message message;

    @NonNull
    private Integer classId;

    private String sendMessage;

    @NonNull
    private boolean completed;

    @Override
    public String payload(MessageSendType messageSendType) {
        StringBuffer sb = new StringBuffer();
        sb.append(name).append(":").append(applier).append(":").append(admittance);
        return sb.toString();
    }
}
