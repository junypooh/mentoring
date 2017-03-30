/* ntels */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.McInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    McMapper
 *
 * MC정보를 관리하는 Mapper클래스
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-21 오후 1:12
 */
public interface McMapper {

    /**
     * <pre>
     *     MC정보 목록조회
     * </pre>
     * @param mcInfo
     * @return
     */
    public List<McInfo> listMc(McInfo mcInfo);

    /**
     * <pre>
     *     MC정보 목록조회(페이징)
     * </pre>
     * @param lectureSearch
     * @return
     */
    public List<McInfo> listMcPaging(LectureSearch lectureSearch);

    /**
     * <pre>
     *     MC 중복 스케줄 존재하는지 건수 조회
     *     변경하려는 수업일시정보의 수업시작시간 종료시간에 겹치는 MC 스케줄 다른 수업일시정보에 존재하는지 확인한다.
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    public int retrieveMcScheduleDuplicationCnt(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     MC정보 등록
     * </pre>
     * @param mcInfo
     * @return
     */
    public int insertMcInfo(McInfo mcInfo);

    /**
     * <pre>
     *     MC정보 수정
     * </pre>
     * @param mcInfo
     * @return
     */
    public int updateMcInfo(McInfo mcInfo);

    /**
     * <pre>
     *     MC정보 상세조회
     * </pre>
     * @param mcInfo
     * @return
     */
    McInfo retrieveMcInfo(McInfo mcInfo);

}

