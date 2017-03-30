package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.EmsMail;
import org.springframework.stereotype.Service;

/**
 * Created by chaos on 2016. 7. 25..
 */
public interface EmsService {

    int insertEmsMailQueue(EmsMail emsMail);
}
