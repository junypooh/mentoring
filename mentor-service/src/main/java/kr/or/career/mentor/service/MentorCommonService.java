package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.CalendarInfo;
import kr.or.career.mentor.domain.ChrstcClsfDTO;
import kr.or.career.mentor.domain.JobClsfDTO;
import kr.or.career.mentor.domain.MentorDTO;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      MentorCommonService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-20 오후 4:47
 */
public interface MentorCommonService {

    List<ChrstcClsfDTO> listChrstcClsf();

    List<JobClsfDTO> listJobClsf();

    List<ChrstcClsfDTO> listChrstcStatistics();

    List<JobClsfDTO> listJobClsfInfoStndMentoWithSearch(String value);

    List<CalendarInfo> listThisWeekInfo(CalendarInfo calendarInfo);

    List<MentorDTO> listNewMentorInfo();

    List<JobClsfDTO> listJobClsfInfoStndMento();
}
