package kr.or.career.mentor.service.impl;

import java.util.List;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.BannerMapper;
import kr.or.career.mentor.domain.BnrInfo;
import kr.or.career.mentor.domain.OrderChanger;
import kr.or.career.mentor.domain.RecommandInfo;
import kr.or.career.mentor.service.BannerService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BannerServiceImpl implements BannerService{

    @Autowired
    private BannerMapper bannerMapper;

    @Override
    public List<BnrInfo> listBanner(BnrInfo banner) {
        return bannerMapper.listBanner(banner);
    }

    @Override
    public int insertBanner(BnrInfo banner) {
        return bannerMapper.insertBanner(banner);
    }

    @Override
    public int updateBanner(BnrInfo banner) {
        return bannerMapper.updateBanner(banner);
    }

    @Override
    public int retrieveBannerCnt(BnrInfo banner) {
        return bannerMapper.retrieveBannerCnt(banner);
    }

    @Override
    public BnrInfo retrieveBanner(String siteType) {
        return bannerMapper.retrieveBanner(siteType);
    }

    @Override
    public BnrInfo retrieveBanner(BnrInfo banner) {
        return bannerMapper.retrieveBannerInfo(banner);
    }

    @Override
    public List<BnrInfo> changeOrder(OrderChanger orderChanger) {
        String targtCd = orderChanger.getTargtCd();

        bannerMapper.updateChangeOrder(orderChanger);

        bannerMapper.updateMoved(orderChanger);

        List<BnrInfo> result = null;

        BnrInfo info = new BnrInfo();
        info.setUseYn("Y");
        info.setBnrTypeCd(targtCd);

        result = listBanner(info);

        return result;
    }

    @Override
    public int deleteBanner(List<OrderChanger> orderChangers) {
        return bannerMapper.deleteBanner(orderChangers);
    }

    @Override
    public List<BnrInfo> deleteBnrInfo(List<OrderChanger> orderChangers) {
        String targtCd = orderChangers.get(0).getTargtCd();
        bannerMapper.removeBanner(orderChangers);
        bannerMapper.updateBannerInfo(targtCd);

        BnrInfo bnrInfo = new BnrInfo();
        bnrInfo.setBnrTypeCd(targtCd);
        bnrInfo.setUseYn("Y");
        return listBanner(bnrInfo);
    }
}
