package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.DataFileInfo;
import kr.or.career.mentor.domain.LectDataInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *      LectureDataService
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-21 오전 10:19
 */
public interface LectureDataService {


    /**
     * 회원자료정보 등록
     *
     * @param lectDataInfo
     * @return
     */
    String insertMbrDataInfo(LectDataInfo lectDataInfo);


    /**
     * 멘토 자료를 수업자료로 맵핑
     *
     * @param lectDataInfo
     * @return
     */
    int insertLectDataInfo(LectDataInfo lectDataInfo);

    /**
     * 회원자료정보 리스트
     *
     * @param lectDataInfo
     * @return
     */
    List<LectDataInfo> selectMbrDataInfo(LectDataInfo lectDataInfo) throws Exception;

    /**
     * 회원자료정보 연결수업 조회
     *
     * @param lectDataInfo
     * @return
     */
    List<LectDataInfo> selectConnectLectList(LectDataInfo lectDataInfo);

    /**
     * 회원자료정보 파일 조회
     *
     * @param lectDataInfo
     * @return
     */
    List<DataFileInfo> selectDataFileList(LectDataInfo lectDataInfo);

    /**
     * 회원자료정보 수정
     *
     * @param lectDataInfo
     * @return
     */
    String updateMbrDataInfo(LectDataInfo lectDataInfo);

    /**
     * 회원자료정보 삭제
     *
     * @param lectDataInfo
     * @return
     */
    String updateMbrDataInfoDel(LectDataInfo lectDataInfo);


    /**
     * 수업 자료 리스트
     *
     * @param lectDataInfo
     * @return
     */
    List<LectDataInfo> selectLectDataList(LectDataInfo lectDataInfo) throws Exception;

    /**
     * 멘토 자료와 수업자료맵핑 해제
     *
     * @param lectDataInfo
     * @return
     */
    int deleteLectDataFile(LectDataInfo lectDataInfo);

    /**
     * 학교포탈 > 나의커뮤니티 > 수업자료
     *
     * @param lectDataInfo
     * @return
     */
    List<LectDataInfo> selectCommunityLectData(LectDataInfo lectDataInfo) throws Exception;

}
