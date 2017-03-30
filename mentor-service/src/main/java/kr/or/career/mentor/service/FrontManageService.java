package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.*;

import java.util.List;

/**
 * Created by chaos on 2016. 8. 2..
 */
public interface FrontManageService {

    List<RecommandInfo> listRecommandLecture();

    List<RecommandInfo> changeOrder(OrderChanger orderChanger);

    List<RecommandInfo> deletePopularLecture(List<OrderChanger> orderChangers);

    List<RecommandInfo> searchLectTimesInfoList(LectureSearch lectureSearch);

    int insertRecommand(List<RecommandInfo> recomLectureInfos);

    List<RecommandInfo> listRecommandMentor(String targtCd);

    List<RecommandInfo> deletePopularMentor(List<OrderChanger> orderChangers);

    List<RecommandInfo> searchMentorInfoList(MentorSearch search);

    List<RecommandInfo> listRecommandJob();

    List<RecommandInfo> deleteRecommandJob(List<OrderChanger> orderChangers);

    List<RecommandInfo> selectRecommandTargetJob(MentorSearch search);

    List<RecommandInfo> listMentorByJobNo(MentorSearch search);
}
