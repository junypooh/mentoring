package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.MentorSearch;
import kr.or.career.mentor.domain.OrderChanger;
import kr.or.career.mentor.domain.RecommandInfo;

import java.util.List;

/**
 * Created by chaos on 2016. 8. 2..
 */
public interface FrontManageMapper {

    List<RecommandInfo> listRecommandLecture();

    int updateChangeOrder(OrderChanger orderChanger);

    int updateMoved(OrderChanger orderChanger);

    List<RecommandInfo> searchLectTimesInfoList(LectureSearch lectureSearch);

    int removeRecommand(List<OrderChanger> orderChangers);

    int updateRecommand(String targtCd);

    int insertRecommand(RecommandInfo recomLectureInfo);

    List<RecommandInfo> listRecommandMentor(String targtCd);

    List<RecommandInfo> searchMentorInfoList(MentorSearch search);

    List<RecommandInfo> listRecommandJob();

    List<RecommandInfo> selectRecommandTargetJob(MentorSearch search);

    List<RecommandInfo> listMentorByJobNo(MentorSearch search);
}
