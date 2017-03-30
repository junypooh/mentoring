/* license */
package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.BnrInfo;
import kr.or.career.mentor.domain.MngrRecomInfo;
import kr.or.career.mentor.domain.OrderChanger;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    BannerMapper.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 16. 오후 2:05:32
 * @author  technear
 * @see
 */
public interface BannerMapper {
    List<BnrInfo> listBanner(BnrInfo banner);
    BnrInfo retrieveBanner(String siteType);
    BnrInfo retrieveBannerInfo(BnrInfo banner);
    Integer retrieveBannerCnt(BnrInfo banner);
    int insertBanner(BnrInfo banner);
    int updateBanner(BnrInfo banner);

    /**
    *
    * <pre>
    * 유망멘토정보삭제
    * </pre>
    *
    * @return
    */
    int deleteManagedMentorInfo(String cd);

   /**
    * 유망멘토정보등록
    * <pre>
    * 해당 Method설명
    * </pre>
    *
    * @param listMngrRecomInfo
    * @return
    */
    int insertManagedMentorInfo(List<MngrRecomInfo> listMngrRecomInfo);

    void updateChangeOrder(OrderChanger orderChanger);

    void updateMoved(OrderChanger orderChanger);

    void removeBanner(List<OrderChanger> orderChangers);

    void updateBannerInfo(String targtCd);

    int deleteBanner(List<OrderChanger> orderChangers);
}
