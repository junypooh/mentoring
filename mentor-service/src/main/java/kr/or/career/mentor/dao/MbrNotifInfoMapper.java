package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.MbrNotiInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *      MbrNotifInfoMapper
 *
 * 활동이력 > 알림내역
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-27 오후 5:43
 */
public interface MbrNotifInfoMapper {


    /**
     * 알림내역 리스트 조회
     *
     * @param mbrNotiInfo
     * @return
     */
    List<MbrNotiInfo> selectMbrNotifInfo(MbrNotiInfo mbrNotiInfo);

    /**
     * 알림내역 확인 UPDATE
     *
     * @param mbrNotiInfo
     * @return
     */
    int updateNotifVerf(MbrNotiInfo mbrNotiInfo);

    /**
     * 알림내역 삭제
     *
     * @param mbrNotiInfo
     * @return
     */
    int deleteMbrNotifInfo(MbrNotiInfo mbrNotiInfo);


    /**
     * 알림내역 등록
     */
    int insertNotifVerf(MbrNotiInfo mbrNotiInfo);

}
