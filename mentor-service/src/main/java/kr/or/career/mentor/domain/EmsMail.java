package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * Created by chaos on 2016. 7. 25..
 */
@Data
public class EmsMail {
    private Integer masterSeq;
    private Integer mailCode;
    private String toId;
    private String toName;
    private String toEmail;
    private String fromName;
    private String fromEmail;
    private String subject;
    private String mapLong;
}
