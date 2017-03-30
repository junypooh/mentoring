package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * Created by chaos on 2016. 8. 1..
 */
@Data
public class OrderChanger {

    private Integer fromIndex;
    private Integer toIndex;
    private Integer id;
    private String targtCd;
}
