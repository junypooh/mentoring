package kr.or.career.mentor.view;

import kr.or.career.mentor.util.CodeMessage;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor(staticName = "of")
public class JSONResponse {

    private Boolean success;

    private Object data;

    private String message;

    public static JSONResponse success(Object data) {
        return JSONResponse.of(Boolean.TRUE, data, null);
    }

    public static JSONResponse failure(String failureMessage) {
        return JSONResponse.of(Boolean.FALSE, null, failureMessage);
    }

    public static JSONResponse failure(CodeMessage codeMessage) {
        return JSONResponse.of(Boolean.FALSE, null, codeMessage.toMessage());
    }

    public static JSONResponse failure(CodeMessage codeMessage, Object... params) {
        return JSONResponse.of(Boolean.FALSE, null, codeMessage.toMessage(params));
    }
}
