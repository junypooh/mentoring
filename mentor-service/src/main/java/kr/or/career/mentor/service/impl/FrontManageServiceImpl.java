package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.FrontManageMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.FrontManageService;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by chaos on 2016. 8. 2..
 */
@Service
@Slf4j
public class FrontManageServiceImpl implements FrontManageService {

    @Autowired
    private FrontManageMapper frontManageMapper;

    @Override
    public List<RecommandInfo> listRecommandLecture() {
        return frontManageMapper.listRecommandLecture();
    }

    @Override
    public List<RecommandInfo> changeOrder(OrderChanger orderChanger) {
        String targtCd = orderChanger.getTargtCd();

        frontManageMapper.updateChangeOrder(orderChanger);

        frontManageMapper.updateMoved(orderChanger);

        List<RecommandInfo> result = null;

        if(CodeConstants.CD101641_101643_인기수업.equals(targtCd))
            result = listRecommandLecture();
        else if(CodeConstants.CD101641_101642_인기멘토.equals(targtCd))
            result = listRecommandMentor(targtCd);
        else if(CodeConstants.CD101641_101757_HOT멘토.equals(targtCd))
            result = listRecommandMentor(targtCd);
        else if(CodeConstants.CD101641_101756_추천직업.equals(targtCd))
            result = listRecommandJob();

        return result;
    }

    @Override
    public List<RecommandInfo> deletePopularLecture(List<OrderChanger> orderChangers) {
        String targtCd = orderChangers.get(0).getTargtCd();
        frontManageMapper.removeRecommand(orderChangers);
        frontManageMapper.updateRecommand(targtCd);
        return listRecommandLecture();
    }

    @Override
    public List<RecommandInfo> searchLectTimesInfoList(LectureSearch lectureSearch) {
        return frontManageMapper.searchLectTimesInfoList(lectureSearch);
    }

    @Override
    public int insertRecommand(List<RecommandInfo> recommandInfos) {

        int successCnt = 0;

        String mbrNo = SessionUtils.getUser().getMbrNo();

        for (RecommandInfo recommandInfo : recommandInfos) {
            recommandInfo.setRegMbrNo(mbrNo);
            successCnt += frontManageMapper.insertRecommand(recommandInfo);
        }
        return successCnt;
    }

    @Override
    public List<RecommandInfo> listRecommandMentor(String targtCd) {
        return frontManageMapper.listRecommandMentor(targtCd);
    }

    @Override
    public List<RecommandInfo> deletePopularMentor(List<OrderChanger> orderChangers) {
        String targtCd = orderChangers.get(0).getTargtCd();
        frontManageMapper.removeRecommand(orderChangers);
        frontManageMapper.updateRecommand(targtCd);
        return listRecommandMentor(targtCd);
    }

    @Override
    public List<RecommandInfo> searchMentorInfoList(MentorSearch search) {
        return frontManageMapper.searchMentorInfoList(search);
    }

    @Override
    public List<RecommandInfo> listRecommandJob() {
        return frontManageMapper.listRecommandJob();
    }

    @Override
    public List<RecommandInfo> deleteRecommandJob(List<OrderChanger> orderChangers) {
        String targtCd = orderChangers.get(0).getTargtCd();
        frontManageMapper.removeRecommand(orderChangers);
        frontManageMapper.updateRecommand(targtCd);
        return listRecommandJob();
    }

    @Override
    public List<RecommandInfo> selectRecommandTargetJob(MentorSearch search) {
        return frontManageMapper.selectRecommandTargetJob(search);
    }

    @Override
    public List<RecommandInfo> listMentorByJobNo(MentorSearch search) {
        return frontManageMapper.listMentorByJobNo(search);
    }
}
