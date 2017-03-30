package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.CalendarInfo;
import kr.or.career.mentor.domain.ChrstcClsfDTO;
import kr.or.career.mentor.domain.JobClsfDTO;
import kr.or.career.mentor.domain.MentorDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MentorCommonMapper {

    List<ChrstcClsfDTO> listChrstcClsf();

    List<JobClsfDTO> listJobClsf();

    List<ChrstcClsfDTO> listChrstcStatistics();

    List<ChrstcClsfDTO> listChrstcClsfInfo();

    List<JobClsfDTO> listJobClsfInfo();

    List<JobClsfDTO> listJobClsfInfoStndMento();

    List<JobClsfDTO> listJobClsfInfoStndMentoWithSearch(@Param("value") String value);

    int listChrstcStatisticsByTotCnt();

    int listJobClsfByTotCnt();

    int listChrstcClsfByTotCnt();

    int listJobClsfInfoStndMentoByTotCnt();

    List<CalendarInfo> listThisWeekInfo(CalendarInfo calendarInfo);

    List<MentorDTO> listNewMentorInfo();


}
