/* license */
package kr.or.career.mentor.service.impl;

import java.util.List;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.MbrItrstInfoMapper;
import kr.or.career.mentor.domain.MbrItrstInfo;
import kr.or.career.mentor.domain.MyInterestDTO;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.MyInterestService;
import kr.or.career.mentor.util.CodeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    MyInterestServiceImpl.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오후 6:54:17
 * @author technear
 * @see
 */
@Service
public class MyInterestServiceImpl implements MyInterestService {

    @Autowired
    private MbrItrstInfoMapper mbrItrstInfoMapper;

    @Override
    public List<MyInterestDTO> listMyInterest(MbrItrstInfo mbrItrstInfo) {
        return mbrItrstInfoMapper.listMyInterest(mbrItrstInfo);
    }

    @Override
    public List<MyInterestDTO> listMyInterestLecture(MbrItrstInfo mbrItrstInfo) {
        return mbrItrstInfoMapper.listMyInterestLecture(mbrItrstInfo);
    }

    @Override
    public List<MyInterestDTO> listMyInterestMentor(MbrItrstInfo mbrItrstInfo) {
        return mbrItrstInfoMapper.listMyInterestMentor(mbrItrstInfo);
    }

    @Override
    public int deleteMyInterest(MbrItrstInfo mbrItrstInfo) {
        return mbrItrstInfoMapper.deleteMyInterest(mbrItrstInfo);
    }

    @Override
    public int saveMyInterestForMentor(User user, String itrstTargtNo) {
        MbrItrstInfo mbrItrstInfo = new MbrItrstInfo();
        mbrItrstInfo.setItrstTargtCd(CodeConstants.CD101513_101516_관심멘토); // 멘토
        mbrItrstInfo.setItrstTargtNo(itrstTargtNo);
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        if (mbrItrstInfoMapper.getMbrItrstInfo(mbrItrstInfo.getMbrNo(), mbrItrstInfo.getItrstTargtCd(),
                mbrItrstInfo.getItrstTargtNo()) != null) {
            throw CodeMessage.MSG_100005_이미_등록된_관심_멘토입니다_.toException();
        }

        return mbrItrstInfoMapper.insertMbrItrstInfo(mbrItrstInfo);
    }

    @Override
    public boolean isMyInterestForMentor(User user, String itrstTargtNo) {
        MbrItrstInfo mbrItrstInfo = new MbrItrstInfo();
        mbrItrstInfo.setItrstTargtCd(CodeConstants.CD101513_101516_관심멘토); // 멘토
        mbrItrstInfo.setItrstTargtNo(itrstTargtNo);
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        return (mbrItrstInfoMapper.getMbrItrstInfo(mbrItrstInfo.getMbrNo(), mbrItrstInfo.getItrstTargtCd(),
                mbrItrstInfo.getItrstTargtNo()) != null);
    }

    @Override
    public int saveMyInterestForJob(User user, String itrstTargtNo) {
        MbrItrstInfo mbrItrstInfo = new MbrItrstInfo();
        mbrItrstInfo.setItrstTargtCd(CodeConstants.CD101513_101514_관심직업); // 직업
        mbrItrstInfo.setItrstTargtNo(itrstTargtNo);
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        if (mbrItrstInfoMapper.getMbrItrstInfo(mbrItrstInfo.getMbrNo(), mbrItrstInfo.getItrstTargtCd(),
                mbrItrstInfo.getItrstTargtNo()) != null) {
            throw CodeMessage.MSG_100006_이미_등록된_관심_직업입니다_.toException();
        }

        return mbrItrstInfoMapper.insertMbrItrstInfo(mbrItrstInfo);
    }

    @Override
    public boolean isMyInterestForJob(User user, String itrstTargtNo) {
        MbrItrstInfo mbrItrstInfo = new MbrItrstInfo();
        mbrItrstInfo.setItrstTargtCd(CodeConstants.CD101513_101514_관심직업); // 직업
        mbrItrstInfo.setItrstTargtNo(itrstTargtNo);
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        return (mbrItrstInfoMapper.getMbrItrstInfo(mbrItrstInfo.getMbrNo(), mbrItrstInfo.getItrstTargtCd(),
                mbrItrstInfo.getItrstTargtNo()) != null);

    }

    @Override
    public int saveMyInterestForLecture(User user, String itrstTargtNo) {
        MbrItrstInfo mbrItrstInfo = new MbrItrstInfo();
        mbrItrstInfo.setItrstTargtCd(CodeConstants.CD101513_101515_관심수업); // 수업
        mbrItrstInfo.setItrstTargtNo(itrstTargtNo);
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        if (mbrItrstInfoMapper.getMbrItrstInfo(mbrItrstInfo.getMbrNo(), mbrItrstInfo.getItrstTargtCd(),
                mbrItrstInfo.getItrstTargtNo()) != null) {
            throw CodeMessage.MSG_100007_이미_등록된_관심_수업입니다_.toException();
        }

        return mbrItrstInfoMapper.insertMbrItrstInfo(mbrItrstInfo);
    }

    @Override
    public boolean isMyInterestForLecture(User user, String itrstTargtNo) {
        MbrItrstInfo mbrItrstInfo = new MbrItrstInfo();
        mbrItrstInfo.setItrstTargtCd(CodeConstants.CD101513_101515_관심수업); // 수업
        mbrItrstInfo.setItrstTargtNo(itrstTargtNo);
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        return (mbrItrstInfoMapper.getMbrItrstInfo(mbrItrstInfo.getMbrNo(), mbrItrstInfo.getItrstTargtCd(),
                mbrItrstInfo.getItrstTargtNo()) != null);
    }
}
