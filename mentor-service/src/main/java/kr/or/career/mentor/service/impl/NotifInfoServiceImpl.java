package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.MbrNotifInfoMapper;
import kr.or.career.mentor.domain.MbrNotiInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.NotifInfoService;
import kr.or.career.mentor.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      NotifInfoServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-27 오후 6:05
 */
@Service
public class NotifInfoServiceImpl implements NotifInfoService {

    @Autowired
    private MbrNotifInfoMapper mbrNotifInfoMapper;

    @Override
    public List<MbrNotiInfo> selectMbrNotifInfo(MbrNotiInfo mbrNotiInfo) {
        return mbrNotifInfoMapper.selectMbrNotifInfo(mbrNotiInfo);
    }

    @Override
    public String updateNotifVerf(MbrNotiInfo mbrNotiInfo) {
        String rtnStr = "FAIL";
        int chk = mbrNotifInfoMapper.updateNotifVerf(mbrNotiInfo);
        if(chk > 0) {
            rtnStr = "SUCCESS";
        }
        return rtnStr;
    }

    @Override
    public int deleteMbrNotifInfo(MbrNotiInfo mbrNotiInfo) {
        return mbrNotifInfoMapper.deleteMbrNotifInfo(mbrNotiInfo);
    }

    @Override
    public MbrNotiInfo selectNotReadMbrNotifInfo() {
        User user = SessionUtils.getUser();
        if(user != null) {
            MbrNotiInfo mbrNotiInfo = new MbrNotiInfo();
            mbrNotiInfo.setMbrNo(user.getMbrNo());
            mbrNotiInfo.setNotifVerfYn("N");

            List<MbrNotiInfo> mbrNotiInfos = mbrNotifInfoMapper.selectMbrNotifInfo(mbrNotiInfo);
            if (mbrNotiInfos != null && mbrNotiInfos.size() > 0) {
                MbrNotiInfo returnNotiInfo = mbrNotiInfos.get(0);
                return returnNotiInfo;
            }else {
                return null;
            }
        } else {
            return null;
        }
    }


    @Override
    public int insertNotifVerf(MbrNotiInfo mbrNotiInfo) {
        return mbrNotifInfoMapper.insertNotifVerf(mbrNotiInfo);
    }
}
