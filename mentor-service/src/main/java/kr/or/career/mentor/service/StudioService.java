/* license */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.StdoInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    StudioService.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 26. 오후 6:55:24
 * @author  technear
 * @see
 */
public interface StudioService {
    /**
     * <pre>
     *     스튜디오정보 목록조회
     * </pre>
     * @param stdoInfo
     * @return
     */
    public List<StdoInfo> listStudio(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오정보 목록조회(페이징)
     * </pre>
     * @param stdoInfo
     * @return
     */
    public List<StdoInfo> listStudioPaging(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오 중복 스케줄 존재하는지 건수 조회
     *     변경하려는 수업일시정보의 수업시작시간 종료시간에 겹치는 스튜디오 스케줄 다른 수업일시정보에 존재하는지 확인한다.
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    public int retrieveStudioScheduleDuplicationCnt(LectSchdInfo lectSchdInfo);

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

    int saveStudioInfo(StdoInfo stdoInfo);

    int deleteStudioInfo(StdoInfo stdoInfo);

    int retrieveRelatedLecSched(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오정보 목록조회(신규)
     * </pre>
     * @param stdoInfo
     * @return
     */
    public List<StdoInfo> getStudioInfo(StdoInfo stdoInfo);

    /**
     * <pre>
     *     스튜디오현황 지역시조회
     * </pre>
     * @return
     */
    public List<StdoInfo> getStudioSido();

    /**
     * <pre>
     *     스튜디오현황 지역시별 시군구조회
     * </pre>
     * @param stdoInfo
     * @return
     */
    public List<StdoInfo> getStudioSggu(StdoInfo stdoInfo);



}
