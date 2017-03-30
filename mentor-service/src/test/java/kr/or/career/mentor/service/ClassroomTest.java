/* license */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.ClasRoomInfo;
import kr.or.career.mentor.domain.ClasRoomRegReqHist;
import kr.or.career.mentor.domain.SchInfo;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    ClassroomTest.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 22. 오전 10:13:15
 * @author  technear
 * @see
 */
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class ClassroomTest {

    public static final Logger log = LoggerFactory.getLogger(ClassroomTest.class);

    @Autowired
    ClassroomService classroomService;
    /**
     *
     * <pre>
     * 나의 교실 정보 가져오기
     * 학생일 경우 나의 교실정보 가지고 오기
     * </pre>
     *
     */
    @Test
    public void myClassroomStudent() {
        ClasRoomRegReqHist clasRoomRegReqHist = new ClasRoomRegReqHist();
        clasRoomRegReqHist.setReqMbrNo("1020000009");
        classroomService.listStudentClassroom(clasRoomRegReqHist);
    }

    @Test
    public void myClassroomTeacher() {
        ClasRoomRegReqHist clasRoomRegReqHist = new ClasRoomRegReqHist();
        clasRoomRegReqHist.setReqMbrNo("1020000002");
        classroomService.listTeacherClassroom(clasRoomRegReqHist);
    }

    @Test
    public void listClassroom() {
        ClasRoomInfo clasRoomInfo = new ClasRoomInfo();
        SchInfo schInfo = new SchInfo();
        schInfo.setSidoNm("100352");
        schInfo.setSchClassCd("100495");
        schInfo.setSchNm("둔원");
        clasRoomInfo.setSchInfo(schInfo);
        classroomService.listClassroom(clasRoomInfo);
    }
}

