/* license */
package kr.or.career.mentor.service;

import java.util.List;

import kr.or.career.mentor.domain.MbrItrstInfo;
import kr.or.career.mentor.domain.MyInterestDTO;
import kr.or.career.mentor.domain.User;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    MyInterestService.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오후 6:54:07
 * @author technear
 * @see
 */
public interface MyInterestService {

    @Deprecated
    List<MyInterestDTO> listMyInterest(MbrItrstInfo mbrItrstInfo);

    List<MyInterestDTO> listMyInterestLecture(MbrItrstInfo mbrItrstInfo);

    List<MyInterestDTO> listMyInterestMentor(MbrItrstInfo mbrItrstInfo);

    int deleteMyInterest(MbrItrstInfo mbrItrstInfo);

    int saveMyInterestForMentor(User user, String itrstTargtNo);

    boolean isMyInterestForMentor(User user, String itrstTargtNo);

    int saveMyInterestForJob(User user, String itrstTargtNo);

    boolean isMyInterestForJob(User user, String itrstTargtNo);

    int saveMyInterestForLecture(User user, String itrstTargtNo);

    boolean isMyInterestForLecture(User user, String itrstTargtNo);
}
