/* license */
package kr.or.career.mentor.dao;

import com.sun.corba.se.spi.presentation.rmi.IDLNameTranslator;
import kr.or.career.mentor.domain.*;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    ClassroomMapper.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 22. 오전 10:22:48
 * @author  technear
 * @see
 */
public interface ClassroomMapper {
    public List<ClasRoomRegReqHist> listStudentClassroom(ClasRoomRegReqHist clasRoomRegReqHist);
    public List<ClasRoomInfo> listTeacherClassroom(ClasRoomRegReqHist clasRoomRegReqHist);
    public List<ClasRoomInfo> listClassroom(ClasRoomInfo clasRoomInfo);
    public List<ClasRoomInfo> listRequestClassroom(ClasRoomInfo clasRoomInfo);
    public List<ClasRoomInfo> listClassroomForStudent(ClasRoomInfo clasRoomInfo);
    public List<ClasRoomRepInfo> listClassroomRepresent(ClasRoomRegReqHist clasRoomRegReqHist);
    public int insertClassroomRegReqHist(ClasRoomRegReqHist clasRoomRegReqHist);
    public int insertClasRoomInfo(ClasRoomInfo clasRoomInfo);
    List<ClasRoomRegReqHist> listApplyStudent(ClasRoomRegReqHist clasRoomRegReqHist);
    public int updateRequestApprove(ClasRoomRegReqHist clasRoomRegReqHist);
    public int updateRequestRoomApprove(ClasRoomRegReqHist clasRoomRegReqHist);
    public ClasRoomRegReqHist listClassroomHistTchr(ClasRoomRegReqHist clasRoomRegReqHist);


    //mbrNo에 등록되어 있는 학교 목록을 가져온다.
    public List<SchInfo> listMySchool(SchInfo schInfo);

    public List<SchInfo> listMyRecSchool(SchInfo schInfo);

    public List<BizSetInfo> listBizGrp(BizSetInfo bizSetInfo);

    int removeClassroomRegReqHist(ClasRoomInfo clasRoomSer);

    int removeClassroomRegReq(ClasRoomInfo clasRoomSer);

    int selectLectApplyInfoByClassRoom(ClasRoomInfo clasRoomSer);

    int removeClassRoomInfo(Integer clasRoomSer);

    int updateRpsClassroomInitial(ClasRoomInfo clasRoomInfo);
    int updateRpsClassroom(ClasRoomInfo clasRoomInfo);

    public List<SchInfo> selectSgguInfo(SchInfo schInfo);

    int updateRpsClassUserInitial(ClasRoomInfo clasRoomInfo);
    int updateRpsClassUser(ClasRoomInfo clasRoomInfo);

    public List<ClasRoomInfo> listClassroomRecognize(ClasRoomInfo clasRoomInfo);

    int listRpsClassroomCnt(ClasRoomRegReqHist clasRoomRegReqHist);

    int listUpdateRpsClassroomCnt(ClasRoomRegReqHist clasRoomRegReqHist);
    List<ClasRoomRegReqHist> listApplyStudentSchInfo(ClasRoomRegReqHist clasRoomRegReqHist);

    List<SchInfo> listSchRpsTchrInfo(ClasRoomInfo clasRoomInfo);

    List<SchInfo> listTchrInfo(ClasRoomInfo clasRoomInfo);

    int clasRoomUserCnt(ClasRoomInfo clasRoomInfo);

    public List<ClasRoomInfo> listSchoolClassRoom(ClasRoomInfo clasRoomInfo);


    public ClasRoomInfo clasRoomSchInfo(ClasRoomInfo clasRoomInfo);







}
