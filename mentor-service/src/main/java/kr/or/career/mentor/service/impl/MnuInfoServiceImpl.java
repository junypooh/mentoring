package kr.or.career.mentor.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.MnuInfoMapper;
import kr.or.career.mentor.domain.AuthInfo;
import kr.or.career.mentor.domain.GlobalMnuInfo;
import kr.or.career.mentor.domain.MnuInfo;
import kr.or.career.mentor.service.MnuInfoService;

import kr.or.career.mentor.util.EgovProperties;
import org.apache.commons.lang.StringUtils;
import org.omg.CORBA.Object;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.servlet.http.HttpServletRequest;


/**
* <pre>
* @location : kr.or.career.mentor.service.impl.MnuInfoServiceImpl.java
* @writeDay : 2015. 9. 16. 오전 9:50:21
* @author : technear
* @desc :
* </pre>
*/
@Service("mnuInfoService")
public class MnuInfoServiceImpl implements MnuInfoService{

    // 메뉴 정보 static 변수
    private static Map<String, List<GlobalMnuInfo>> globalMenuInfo = new HashMap<>();
	
	@Autowired
    private MnuInfoMapper mnuInfoMapper;

	/**(non-Javadoc)
	 * @see kr.or.career.mentor.service.MnuInfoService#listMnuInfoByMbrNo(java.util.Map)
	* @location : kr.or.career.mentor.service.impl.MnuInfoServiceImpl.listMnuInfoByMbrNo
	* @writeDay : 2015. 9. 16. 오전 9:50:13
	* @author : technear
	* @desc :
	*/
	 
	@Override
	public List<MnuInfo> listMnuInfoByMbrNo(Map<String,String> param) {
		return mnuInfoMapper.listMnuInfoByMbrNo(param);
	}

    @Override
    public List<GlobalMnuInfo> listMangerMnuInfo(Map<String,String> param) {

        List<GlobalMnuInfo> globalMenu = mnuInfoMapper.listMangerFullMnuInfo(param);

        for(GlobalMnuInfo mnuInfo : globalMenu) {
            // size가 1 인 null 3Dept 메뉴 remove
            for(GlobalMnuInfo subMnuInfo : mnuInfo.getGlobalSubMnuInfos()) {
                if(subMnuInfo.getGlobalSubMnuInfos().size() == 1 && subMnuInfo.getGlobalSubMnuInfos().get(0).getMnuId() == null) {
                    subMnuInfo.getGlobalSubMnuInfos().remove(0);
                }
            }
        }
        return globalMenu;
    }

    @Override
    public List<GlobalMnuInfo> listMangerMnuInfoByAuthCd(Map<String,String> param) {

        List<GlobalMnuInfo> mnuInfoList = mnuInfoMapper.listMangerMnuInfo(param);

        for(GlobalMnuInfo mnuInfo : mnuInfoList) {
            // size가 1 인 null 3Dept 메뉴 remove
            for(GlobalMnuInfo subMnuInfo : mnuInfo.getGlobalSubMnuInfos()) {
                if(subMnuInfo.getGlobalSubMnuInfos().size() == 1 && subMnuInfo.getGlobalSubMnuInfos().get(0).getMnuId() == null) {
                    subMnuInfo.getGlobalSubMnuInfos().remove(0);
                }
            }
        }
        return mnuInfoList;
    }

    @Override
    public void setGlobalMnuInfo(Map<String, String> param) {

        String authCd = param.get("authCd");
        List<GlobalMnuInfo> mnuInfoList = globalMenuInfo.get(authCd);

        if(CollectionUtils.isEmpty(mnuInfoList)) {
            globalMenuInfo.put(authCd, mnuInfoMapper.listMangerMnuInfo(param));
        }
    }

    @Override
    public void setGlobalMenuInfo(String authCd, List<GlobalMnuInfo> mnuInfoList) {

        globalMenuInfo.remove(authCd);
        globalMenuInfo.put(authCd, mnuInfoList);
    }

    @Override
    public List<GlobalMnuInfo> getGlobalMnuInfo(String authCd) {
        return getGlobalMnuInfo(authCd, null);
    }

    @Override
    public List<GlobalMnuInfo> getGlobalMnuInfo(String authCd, String supMnuId) {

        List<GlobalMnuInfo> mnuInfoList = globalMenuInfo.get(authCd);

        if(CollectionUtils.isEmpty(mnuInfoList)) {

            Map<String,String> param = new HashMap<>();
            param.put("authCd", authCd);
            switch(EgovProperties.getLocalProperty("Local.site")) {
                case Constants.MANAGER:
                    // 신규 관리자 메뉴
//                    param.put("mnuId", Constants.MNU_CODE_MANAGER);
                    param.put("mnuId", Constants.MNU_CODE_MANAGER2);
                    break;
                case Constants.MENTOR:
//                    param.put("mnuId", Constants.MNU_CODE_MENTOR);
                    param.put("mnuId", Constants.MNU_CODE_MENTOR2);
                    break;
                case Constants.SCHOOL:
                    param.put("mnuId", Constants.MNU_CODE_SCHOOL);
                    break;
            }

            mnuInfoList = mnuInfoMapper.listMangerMnuInfo(param);

            globalMenuInfo.put(authCd, mnuInfoList);
        }

        // 2/3Dept 메뉴 골라서 리턴
        if(StringUtils.isNotEmpty(supMnuId)) {
            for(GlobalMnuInfo mnuInfo : mnuInfoList) {
                // size가 1 인 null 3Dept 메뉴 remove
                for(GlobalMnuInfo subMnuInfo : mnuInfo.getGlobalSubMnuInfos()) {
                    if(subMnuInfo.getGlobalSubMnuInfos().size() == 1 && subMnuInfo.getGlobalSubMnuInfos().get(0).getMnuId() == null) {
                        subMnuInfo.getGlobalSubMnuInfos().remove(0);
                    }
                }
                if(supMnuId.equals(mnuInfo.getMnuId())) {
                    return mnuInfo.getGlobalSubMnuInfos();
                }
            }
        }

        return mnuInfoList;
    }

}
