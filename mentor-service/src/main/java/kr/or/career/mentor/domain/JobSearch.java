package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class JobSearch extends Base {

    /**
     * 검색입력값
     */
    private String searchKey;

    /**
     * 검색구분종류
     */
    private String searchType;

    /**
     * 강의수업명
     */
    private String lectTitle;

    /**
     * 멘토명
     */
    private String mentorNm;

    /**
     * 검색태그
     */
    private String jobTagInfo;

    /**
     * 직업명
     */
    private String jobNm;

}
