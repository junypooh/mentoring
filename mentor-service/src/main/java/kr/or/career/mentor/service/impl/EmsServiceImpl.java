package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.domain.EmsMail;
import kr.or.career.mentor.service.EmsService;
import kr.or.career.mentor.transfer.EmsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by chaos on 2016. 7. 25..
 */
@Service
public class EmsServiceImpl implements EmsService {
    @Autowired
    private EmsMapper emsMapper;
    @Override
    public int insertEmsMailQueue(EmsMail emsMail) {
        return emsMapper.insertEmsMailQueue(emsMail);
    }
}
