package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.MbrJobChrstcInfoMapper;
import kr.or.career.mentor.dao.MbrProfPicInfoMapper;
import kr.or.career.mentor.dao.MbrProfScrpInfoMapper;
import kr.or.career.mentor.dao.MentorMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.MentorIntroduceService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      MentorIntroduceServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-01 오후 5:38
 */
@Service
@Slf4j
public class MentorIntroduceServiceImpl implements MentorIntroduceService{

    @Autowired
    private MentorMapper mentorMapper;

    @Autowired
    private MbrJobChrstcInfoMapper mbrJobChrstcInfoMapper;

    @Autowired
    private MbrProfPicInfoMapper mbrProfPicInfoMapper;

    @Autowired
    private MbrProfScrpInfoMapper mbrProfScrpInfoMapper;

    @Override
    public List<MentorDTO> selectMentorIntroduce(MentorSearch mentorSearch) {
        return mentorMapper.selectMentorIntroduce(mentorSearch);
    }

    @Override
    public MentorDTO getMentorInfoBy(String mbrNo) {
        return mentorMapper.getMentorInfoBy(mbrNo);
    }

    @Override
    public List<MbrJobChrstcInfo> listMbrJobChrstcInfoBy(String mbrNo) {
        return mbrJobChrstcInfoMapper.listMbrJobChrstcInfoBy(mbrNo);
    }

    @Override
    public List<MbrProfPicInfo> listMbrProfPicInfoBy(String mbrNo) {
        return mbrProfPicInfoMapper.listMbrProfPicInfoBy(mbrNo);
    }

    @Override
    public List<MbrProfScrpInfo> listMbrProfScrpInfoBy(String mbrNo) {
        return mbrProfScrpInfoMapper.listMbrProfScrpInfoBy(mbrNo, null);
    }

    @Override
    public List<MentorDTO> selectMentorRelation(MentorSearch mentorSearch) {
        return mentorMapper.selectMentorRelation(mentorSearch);
    }
}
