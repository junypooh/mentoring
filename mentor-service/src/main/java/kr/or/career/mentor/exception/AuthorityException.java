package kr.or.career.mentor.exception;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AuthorityException extends RuntimeException {
    /**
     *
     */
    private static final long serialVersionUID = -9179760845206128879L;

    public static final int NOT_LOGINED = 0x0001;

    public static final int NOT_AUTHORIZED_ADMIN = 0x0002;

    public static final int NOT_AUTHORIZED_MENU = 0x0003;

    public static final int NOT_AUTHORIZED_USER = 0x0004;

    private int error_type;

    public AuthorityException(int error_type) {
        super();
        this.error_type = error_type;
    }

    public AuthorityException(String message){
        super(message);
    }
}
