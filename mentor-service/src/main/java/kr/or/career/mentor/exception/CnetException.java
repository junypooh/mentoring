package kr.or.career.mentor.exception;

import kr.or.career.mentor.util.CodeMessage;

public class CnetException extends RuntimeException {
    private static final long serialVersionUID = -3677954907497844023L;

    private CodeMessage code;

    private Object[] params;

    public CnetException(CodeMessage code) {
        this(code, (Object[]) null);
    }

    public CnetException(CodeMessage code, Object[] params) {
        this.code = code;
        this.params = params;
    }

    public CnetException(CodeMessage code, Object[] params, Throwable cause) {
        super(cause);
        this.code = code;
        this.params = params;
    }

    public CodeMessage getCode() {
        return code;
    }

    @Override
    public String getMessage() {
        return code.toMessage(params);
    }
}
