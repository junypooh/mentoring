/* license */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.*;
import org.springframework.security.core.Authentication;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    ClassroomService.java
 *
 * 	교실 정보 처리를 담당
 *
 * </pre>
 * @since   2015. 9. 22. 오전 10:18:55
 * @author  technear
 * @see
 */
public interface ClassroomService {
    List<ClasRoomRegReqHist> listStudentClassroom(ClasRoomRegReqHist clasRoomRegReqHist);
    List<ClasRoomInfo> listTeacherClassroom(ClasRoomRegReqHist clasRoomRegReqHist);
    List<ClasRoomInfo> listClassroom(ClasRoomInfo clasRoomInfo);
    List<ClasRoomInfo> listRequestClassroom(ClasRoomInfo clasRoomInfo);
    List<ClasRoomInfo> listClassroomForStudent(ClasRoomInfo clasRoomInfo);
    List<ClasRoomRepInfo> listClassroomRepresent(ClasRoomRegReqHist clasRoomRegReqHist);
    int insertClassroomRegReqHist(ClasRoomRegReqHist clasRoomRegReqHist) throws Exception;
    int insertClasRoomInfo(ClasRoomInfo clasRoomInfo) throws Exception;
    List<ClasRoomRegReqHist> listApplyStudent(ClasRoomRegReqHist clasRoomRegReqHist);
    int updateRequestApprove(List<ClasRoomRegReqHist> list, String mbrNo)  throws Exception;
    /**
     * mbrNo로 등록되어 있는 학교 목록
     */
    List<SchInfo> listMySchool(SchInfo schInfo);
    List<SchInfo> listMyRecSchool(SchInfo schInfo);

    List<BizSetInfo> listBizGrp(BizSetInfo bizSetInfo);

    int removeClassroomRegReqHist(ClasRoomInfo clasRoomInfo) throws Exception;

    int removeClassRoomInfo(ClasRoomInfo clasRoomInfo);
    int removeClassroomRegReq(ClasRoomInfo clasRoomInfo);
    int updateRpsClassroom(ClasRoomInfo clasRoomInfo, Authentication authentication);

    /** 지역시에 따른 지역구 조회 */
    List<SchInfo> listSgguInfo(SchInfo schInfo);

    int updateRpsClassUser(ClasRoomInfo clasRoomInfo, Authentication authentication);

    List<ClasRoomInfo> listClassroomRecognize(ClasRoomInfo clasRoomInfo);

    List<ClasRoomRegReqHist> listApplyStudentSchInfo(ClasRoomRegReqHist clasRoomRegReqHist);


    List<SchInfo> listSchRpsTchrInfo(ClasRoomInfo clasRoomInfo);

    List<SchInfo> listTchrInfo(ClasRoomInfo clasRoomInfo);

    public List<ClasRoomInfo> listSchoolClassRoom(ClasRoomInfo clasRoomInfo);


}
