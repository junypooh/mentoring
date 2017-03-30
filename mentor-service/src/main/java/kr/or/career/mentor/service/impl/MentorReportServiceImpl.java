package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.MentorReportMapper;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.MentorClassReportDTO;
import kr.or.career.mentor.domain.MentorReportDTO;
import kr.or.career.mentor.service.MentorReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by DaDa on 2016-05-24.
 */
@Service
public class MentorReportServiceImpl implements MentorReportService {

    @Autowired
    private MentorReportMapper mentorReportMapper;

    @Override
    public List<MentorReportDTO> selectMentorList(LectureSearch lectureSearch) {
        return mentorReportMapper.selectMentorList(lectureSearch);
    }

    @Override
    public List<MentorClassReportDTO> selectMentorClassList(LectureSearch lectureSearch) {
        return mentorReportMapper.selectMentorClassList(lectureSearch);
    }
}
