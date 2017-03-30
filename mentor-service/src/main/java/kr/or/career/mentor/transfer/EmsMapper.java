package kr.or.career.mentor.transfer;

import kr.or.career.mentor.domain.EmsMail;

import javax.annotation.Resource;

/**
 * Created by chaos on 2016. 7. 25..
 */
@Resource(name = "emsConfigure")
public interface EmsMapper {
    int insertEmsMailQueue(EmsMail emsMail);
}
