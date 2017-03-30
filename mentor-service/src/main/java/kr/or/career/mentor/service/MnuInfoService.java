package kr.or.career.mentor.service;

import java.util.List;
import java.util.Map;

import kr.or.career.mentor.domain.AuthInfo;
import kr.or.career.mentor.domain.GlobalMnuInfo;
import kr.or.career.mentor.domain.MnuInfo;

/**
* <pre>
* @location : kr.or.career.mentor.service.MnuInfoService.java
* @writeDay : 2015. 9. 16. 오전 9:49:57
* @author : technear
* @desc :
* </pre>
*/
public interface MnuInfoService {

	/**
	* <pre>
	* @location : kr.or.career.mentor.service.MnuInfoService.listMnuInfoByMbrNo
	* @writeDay : 2015. 9. 16. 오전 9:46:10
	* @auth : technear
	* @desc :
	* </pre>
	* @param param
	* @return
	*/
	 
	List<MnuInfo> listMnuInfoByMbrNo(Map<String,String> param);

	List<GlobalMnuInfo> listMangerMnuInfo(Map<String,String> param);

	List<GlobalMnuInfo> listMangerMnuInfoByAuthCd(Map<String,String> param);

	void setGlobalMnuInfo(Map<String,String> param);

	void setGlobalMenuInfo(String authCd, List<GlobalMnuInfo> mnuInfoList);

	List<GlobalMnuInfo> getGlobalMnuInfo(String authCd);

	List<GlobalMnuInfo> getGlobalMnuInfo(String authCd, String supMnuId);
}
