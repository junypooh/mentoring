/* ntels */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.StdoInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    StudioMapper
 *
 * 스튜디오정보를 관리하는 Mapper클래스
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-21 오후 1:16
 */
public interface StudioMapper {

    /**
     * <pre>
     *     스튜디오정보 목록조회
     * </pre>
     * @param stdoInfo
     * @return
     */
    List<StdoInfo> listStudio(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오정보 목록조회(페이징)
     * </pre>
     * @param stdoInfo
     * @return
     */
    List<StdoInfo> listStudioPaging(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오 중복 스케줄 존재하는지 건수 조회
     *     변경하려는 수업일시정보의 수업시작시간 종료시간에 겹치는 스튜디오 스케줄 다른 수업일시정보에 존재하는지 확인한다.
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    int retrieveStudioScheduleDuplicationCnt(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     스튜디오정보 등록
     * </pre>
     * @param stdoInfo
     * @return
     */
    int insertStudioInfo(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오정보 수정
     * </pre>
     * @param stdoInfo
     * @return
     */
    int updateStudioInfo(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오정보 상세조회
     * </pre>
     * @param stdoInfo
     * @return
     */
    StdoInfo retrieveStudioInfo(StdoInfo stdoInfo);


    int deleteStudioInfo(StdoInfo stdoInfo);

    int retrieveRelatedLecture(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오정보 목록조회(신규)
     * </pre>
     * @param stdoInfo
     * @return
     */
    List<StdoInfo> getStudioInfo(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오현황 지역시조회
     * </pre>
     * @return
     */
    List<StdoInfo> getStudioSido();

    /**
     * <pre>
     *     스튜디오현황 지역시별 시군구조회
     * </pre>
     * @param stdoInfo
     * @return
     */
    List<StdoInfo> getStudioSggu(StdoInfo stdoInfo);



    /**
     * <pre>
     *     스튜디오정보 목록조회
     * </pre>
     * @param stdoInfo
     * @return
     */
    List<StdoInfo> stdoList(StdoInfo stdoInfo);


}

