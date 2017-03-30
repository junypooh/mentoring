package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.MentorCommonMapper;
import kr.or.career.mentor.domain.CalendarInfo;
import kr.or.career.mentor.domain.ChrstcClsfDTO;
import kr.or.career.mentor.domain.JobClsfDTO;
import kr.or.career.mentor.domain.MentorDTO;
import kr.or.career.mentor.service.MentorCommonService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      MentorCommonServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-20 오후 4:48
 */
@Service
@Slf4j
public class MentorCommonServiceImpl implements MentorCommonService {

    @Autowired
    private MentorCommonMapper mentorCommonMapper;

    @Override
    public List<ChrstcClsfDTO> listChrstcClsf() {
        return mentorCommonMapper.listChrstcClsf();
    }

    @Override
    public List<JobClsfDTO> listJobClsf() {
        return mentorCommonMapper.listJobClsf();
    }

    @Override
    public List<ChrstcClsfDTO> listChrstcStatistics() {
        return mentorCommonMapper.listChrstcStatistics();
    }

    @Override
    public List<JobClsfDTO> listJobClsfInfoStndMentoWithSearch(String value) {
        return mentorCommonMapper.listJobClsfInfoStndMentoWithSearch(value);
    }

    @Override
    public List<CalendarInfo> listThisWeekInfo(CalendarInfo calendarInfo) {
        return mentorCommonMapper.listThisWeekInfo(calendarInfo);
    }

    @Override
    public List<MentorDTO> listNewMentorInfo() {
        return mentorCommonMapper.listNewMentorInfo();
    }

    @Override
    public List<JobClsfDTO> listJobClsfInfoStndMento() {
        return mentorCommonMapper.listJobClsfInfoStndMento();
    }
}
