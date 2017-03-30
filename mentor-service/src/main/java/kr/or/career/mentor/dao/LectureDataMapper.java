package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.DataFileInfo;
import kr.or.career.mentor.domain.LectDataInfo;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *      LectureDataMapper
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-21 오전 10:27
 */
public interface LectureDataMapper {


    /**
     * 회원자료정보 등록
     *
     * @param lectDataInfo
     * @return
     */
    int insertMbrDataInfo(LectDataInfo lectDataInfo);


    /**
     * 자료정보와 파일 매핑정보 등록
     *
     * @param lectDataInfo
     * @return
     */
    int insertDataFile(LectDataInfo lectDataInfo);


    /**
     * 자료정보 리스트 조회
     *
     * @param lectDataInfo
     * @return
     */
    List<LectDataInfo> selectMbrDataInfo(LectDataInfo lectDataInfo);

    /**
     * 자료정보 연결수업 조회
     *
     * @param lectDataInfo
     * @return
     */
    List<LectDataInfo> selectConnectLectList(LectDataInfo lectDataInfo);

    /**
     * 자료정보 파일 조회
     *
     * @param lectDataInfo
     * @return
     */
    List<DataFileInfo> selectDataFileList(LectDataInfo lectDataInfo);

    /**
     * 자료정보 파일 삭제
     *
     * @param dataFileInfo
     * @return
     */
    int deleteDataFile(DataFileInfo dataFileInfo);

    /**
     * 자료정보 수정
     *
     * @param lectDataInfo
     * @return
     */
    int updateMbrDataInfo(LectDataInfo lectDataInfo);

    /**
     * 자료정보 삭제
     *
     * @param lectDataInfo
     * @return
     */
    int updateMbrDataInfoDel(LectDataInfo lectDataInfo);


    /**
     * 멘토 자료를 수업자료로 맵핑
     *
     * @param lectDataInfo
     * @return
     */
    int insertLectDataInfo(LectDataInfo lectDataInfo);


    /**
     * 수업 자료 리스트
     *
     * @param lectDataInfo
     * @return
     */
    List<LectDataInfo> selectLectDataInfo(LectDataInfo lectDataInfo);


    /**
     *  멘토 자료와 수업자료맵핑 해제
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
    List<LectDataInfo> selectCommunityLectData(LectDataInfo lectDataInfo);



}
