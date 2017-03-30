/* ntels */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.CoInfo;
import kr.or.career.mentor.domain.User;

import java.util.List;


/**
 * <pre> kr.or.career.mentor.dao McMapper
 *
 * 기관/업체 정보를 관리하는 Mapper클래스
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-21 오후 1:12
 */
public interface CoInfoMapper {

    /**
     * <pre> 기관/업체 목록조회 </pre>
     *
     * @param coInfo
     * @return
     */
    List<CoInfo> listCoInfo(CoInfo coInfo);

    /**
     * <pre> 기관/업체 등록 </pre>
     *
     * @param coInfo
     * @return
     */
    void insertCoInfo(CoInfo coInfo);

    /**
     * <pre> 기관/업체 수정 </pre>
     *
     * @param coInfo
     * @return
     */
    void updateCoInfo(CoInfo coInfo);

    /**
     * <pre>
     *     회원의 기관/업체정보 조회
     * </pre>
     * @param user
     * @return
     */
    @Deprecated
    CoInfo retrieveCoInfoByUser(User user);

    @Deprecated
    String getInstMbrNo(CoInfo coInfo);


    /**
     * <pre> 기관/업체 목록조회 </pre>
     *
     * @param coClassCd
     * @return
     */
    List<CoInfo> listCoInfoByCoClassCd(String coClassCd);

}
