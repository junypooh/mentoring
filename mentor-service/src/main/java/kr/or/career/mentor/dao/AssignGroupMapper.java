/* license */
package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.*;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    AssignGroupMapper.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 21. 오후 11:10:17
 * @author  technear
 * @see
 */
public interface AssignGroupMapper {
    List<BizSetInfo> listAssignGroup(BizGrpSearch bizGrpSearch);
    List<BizSetInfo> listSchAssignGroup(BizGrpSearch bizGrpSearch);
    List<SchInfo> listAssignSchool(BizGrpInfo bizGrpInfo);

    BizSetInfo retrieveAssignGroup(BizSetInfo bizSetInfo);

    List<AssignGroupDTO> listAssignGroupListBySchool(SchInfo schInfo);

    int insertBizGrpInfo(BizGrpInfo bizGrpInfo);
    int updateBizGrpInfo(BizGrpInfo bizGrpInfo);
    int insertBizSetInfo(BizSetInfo bizSetInfo);
    int updateBizSetInfo(BizSetInfo bizSetInfo);

    int insertAssignSchool(BizGrpInfo bizGrpInfo);

    List<SchInfo> listSchoolAssign(BizSetInfo bizSetInfo);

    /**
     * <pre>
     *     배정그룹 엑셀다운로드
     * </pre>
     * @param bizGrpSearch
     * @return
     */
    List<AssignGroupExcelDTO> excelDownListAssignGroup(BizGrpSearch bizGrpSearch);


    /**
     * <pre>
     *     배정학교 전체 삭제
     * </pre>
     * @param BizGrpInfo
     * @return
     */
    int deleteSchGrpMapp(BizGrpInfo BizGrpInfo);

    /**
     * <pre>
     *     배정그룹설정 삭제
     * </pre>
     * @param BizGrpInfo
     * @return
     */
    int deleteBizSetInfo(BizGrpInfo BizGrpInfo);

    /**
     * <pre>
     *     배정그룹 삭제
     * </pre>
     * @param BizGrpInfo
     * @return
     */
    int deleteBizGrpInfo(BizGrpInfo BizGrpInfo);

    /**
     * <pre>
     *     배정학교 선택적 삭제
     * </pre>
     * @param schInfo
     * @return
     */
    int deleteTargetSchGrpMapp(SchInfo schInfo);

    /**
     * <pre>
     *     배정학교 추가시 중복학교 제외
     * </pre>
     * @param BizGrpInfo
     * @return
     */
    List<SchInfo> dupListAssignSchool(BizGrpInfo BizGrpInfo);


    /**
     * <pre>
     *     지역시 조회
     * </pre>
     * @param schInfo
     * @return
     */
    List<SchInfo> listSidoInfo(SchInfo schInfo);



    /**
     * <pre>
     *     지역시에 따른 지역구 조회
     * </pre>
     * @param schInfo
     * @return
     */
    List<SchInfo> selectSgguInfo(SchInfo schInfo);


    /**
     * <pre>
     *     교정보관리 교사/학생현황
     * </pre>
     * @param schInfo
     * @return
     */
    List<SchInfo> schoolTcherInfo(SchInfo schInfo);


    /**
     * <pre>
     *     교정보관리 교실 정보
     * </pre>
     * @param schInfo
     * @return
     */
    List<SchInfo> schoolClassRoomInfo(SchInfo schInfo);

    /**
     * <pre>
     *     교정보관리 교실 등록 이력
     * </pre>
     * @param schInfo
     * @return
     */
    List<SchInfo> schoolClassRoomHistory(SchInfo schInfo);


    /**
     * <pre>
     *     교정보관리 교실 등록 이력
     * </pre>
     * @param bizGrpSearch
     * @return
     */
    List<SchInfo> schoolAssignGroupState(BizGrpSearch bizGrpSearch);


    /**
     * <pre>
     *     반대표 현황
     * </pre>
     * @param schInfo
     * @return
     */
    List<SchInfo> schoolClassRoomRepresent(SchInfo schInfo);


    /**
     * <pre>
     *     학교 대표 교사
     * </pre>
     * @param schInfo
     * @return
     */
    List<SchInfo> schoolClassTcherRepresent(SchInfo schInfo);



    /**
     * <pre>
     *     교사 현황 삭제
     * </pre>
     * @param schInfo
     * @return
     */
    int deleteSchoolTcher(SchInfo schInfo);



    /**
     * <pre>
     *     교실 정보 삭제
     * </pre>
     * @param schInfo
     * @return
     */
    int deleteSchoolRoom(SchInfo schInfo);




    /**
     * <pre>
     *     강의 신청 횟수 등록/수정
     * </pre>
     * @param bizGrpInfo
     * @return
     */
    int saveAssignLectAppl(BizGrpInfo bizGrpInfo);


    /**
     * <pre>
     *     강의 신청 횟수 등록/수정
     * </pre>
     * @param bizGrpInfo
     * @return
     */
    int insertAssignSchoolHist(BizGrpInfo bizGrpInfo);



    List<BizSetInfo> listAssignGroupHist(BizGrpSearch bizGrpSearch);


    Integer getMaxSetChgSeq();

    List<BizGrpInfo> listBizGrpInfo();


    int assignGroupName(BizGrpInfo bizGrpInfo);

    List<BizGrpInfo> listAssignGroupByDistinct();
}
