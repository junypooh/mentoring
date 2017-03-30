/* license */
package kr.or.career.mentor.service;

import java.util.List;

import kr.or.career.mentor.domain.*;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    AssignGroupService.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 21. 오후 11:14:45
 * @author  technear
 * @see
 */
public interface AssignGroupService {

    public List<BizSetInfo> listAssignGroup(BizGrpSearch bizSetInfo);

    public List<BizSetInfo> listSchAssignGroup(BizGrpSearch bizSetInfo);

    public List<SchInfo> listAssignSchool(BizGrpInfo bizGrpInfo);

    public BizSetInfo retrieveAssignGroup(BizSetInfo bizSetInfo);

    public List<SchInfo> saveBizGrpInfo(BizSetInfo bizSetInfo, User user);

    public List<SchInfo> insertAssignSchool(BizGrpInfo bizGrpInfo, User user);

    /**
     * <pre>
     *     배정그룹 엑셀다운로드
     * </pre>
     * @param bizGrpSearch
     * @return
     */
    public List<AssignGroupExcelDTO> excelDownListAssignGroup(BizGrpSearch bizGrpSearch);

    /**
     * <pre>
     *     배정그룹관리 수정
     * </pre>
     * @param bizSetInfo
     * @return
     */
    public void modifyAssignGroupPoc(BizSetInfo bizSetInfo, User user);

    /**
     * <pre>
     *     배정그룹관리 배정학교 삭제
     * </pre>
     * @param bizSetInfo
     * @return
     */
    public String deleteAssignSchool(BizSetInfo bizSetInfo, User user);

    /**
     * <pre>
     *     배정그룹 삭제
     * </pre>
     * @param bizGrpInfo
     */
    public String deleteAssignGroupPoc(BizGrpInfo bizGrpInfo);

    /**
     * <pre>
     *     배정학교 추가시 중복 체크
     * </pre>
     * @param bizGrpInfo
     */
    public List<SchInfo> dupListAssignSchool(BizGrpInfo bizGrpInfo);


    /**
     * <pre>
     *     지역시에 따른 지역구 조회
     * </pre>
     * @param schInfo
     */
    public List<SchInfo> listSidoInfo(SchInfo schInfo);

    /**
     * <pre>
     *     지역시에 따른 지역구 조회
     * </pre>
     * @param schInfo
     */
    public List<SchInfo> listSgguInfo(SchInfo schInfo);

    /**
     * <pre>
     *     학교정보관리 교사/학생현황
     * </pre>
     * @param schInfo
     */
    public List<SchInfo> schoolTcherInfo(SchInfo schInfo);

    /**
     * <pre>
     *     학교정보관리 교실정보
     * </pre>
     * @param schInfo
     */
    public List<SchInfo> schoolClassRoomInfo(SchInfo schInfo);

    /**
     * <pre>
     *     학교정보관리 교실 등록 이력
     * </pre>
     * @param schInfo
     */
    public List<SchInfo> schoolClassRoomHistory(SchInfo schInfo);


    /**
     * <pre>
     *     학교정보관리 배정 사업 현황
     * </pre>
     * @param bizGrpSearch
     */
    public List<SchInfo> schoolAssignGroupState(BizGrpSearch bizGrpSearch);

    /**
     * <pre>
     *     반대표 현황
     * </pre>
     * @param schInfo
     */
    public List<SchInfo> schoolClassRoomRepresent(SchInfo schInfo);


    /**
     * <pre>
     *     반대표 현황
     * </pre>
     * @param schInfo
     */
    public List<SchInfo> schoolClassTcherRepresent(SchInfo schInfo);


    /**
     * <pre>
     *    교사 현황 삭제
     * </pre>
     * @param schInfo
     * @return
     */
    public String deleteSchoolTcher(SchInfo schInfo);


    /**
     * <pre>
     *    교실 정보 삭제
     * </pre>
     * @param schInfo
     * @return
     */
    public String deleteSchoolRoom(SchInfo schInfo);


    /**
     * <pre>
     *     배정그룹 삭제
     * </pre>
     * @param bizGrpInfo
     */
    public String saveAssignLectAppl(BizGrpInfo bizGrpInfo, User user);



    public List<BizSetInfo> listAssignGroupHist(BizGrpSearch bizSetInfo);


    public String assignGroupName(BizGrpInfo bizGrpInfo);


    List<BizGrpInfo> listAssignGroupByDistinct();


}
