package kr.or.career.mentor.service;

import java.util.List;

import kr.or.career.mentor.domain.BnrInfo;
import kr.or.career.mentor.domain.OrderChanger;

public interface BannerService {
    List<BnrInfo> listBanner(BnrInfo banner);
    BnrInfo retrieveBanner(String siteType);
    BnrInfo retrieveBanner(BnrInfo banner);
    int retrieveBannerCnt(BnrInfo banner);
    int insertBanner(BnrInfo banner);
    int updateBanner(BnrInfo banner);

    List<BnrInfo> changeOrder(OrderChanger orderChanger);

    List<BnrInfo> deleteBnrInfo(List<OrderChanger> orderChangers);

    int deleteBanner(List<OrderChanger> orderChangers);
}
