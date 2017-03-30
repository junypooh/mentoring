package kr.or.career.mentor.service;


import kr.or.career.mentor.domain.MbrNotiInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      NotifInfoService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-27 오후 6:05
 */
public interface NotifInfoService {


    /**
     * 알림내역 리스트 조회
     *
     * @param mbrNotiInfo
     * @return
     */
    public List<MbrNotiInfo> selectMbrNotifInfo(MbrNotiInfo mbrNotiInfo);

    /**
     * 알림내역 확인 UPDATE
     *
     * @param mbrNotiInfo
     * @return
     */
    public String updateNotifVerf(MbrNotiInfo mbrNotiInfo);

    /**
     * 알림내역 삭제
     *
     * @param mbrNotiInfo
     * @return
     */
    public int deleteMbrNotifInfo(MbrNotiInfo mbrNotiInfo);

    /**
     * header.jsp 알림 내역
     * 읽지 않은 최신 알림 내역 (1개)
     *
     * @return
     */
    public MbrNotiInfo selectNotReadMbrNotifInfo();


    /**
     * 알림내역 등록
     *
     * @param mbrNotiInfo
     * @return
     */
    public int insertNotifVerf(MbrNotiInfo mbrNotiInfo);

}
