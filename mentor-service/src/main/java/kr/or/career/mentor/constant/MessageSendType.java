/* ntels */
package kr.or.career.mentor.constant;

/**
 * <pre>
 * kr.or.career.mentor.constant
 *    MessageSendType
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 29. 오후 3:06
 */
public enum MessageSendType {

    SMS(0x4),
    EMS(0x2),
    PUSH(0x1),
    ;

    private int value;

     MessageSendType(int value) {
        this.value = value;
    }
    public int getValue() {
        return this.value;
    }
}
