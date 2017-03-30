package kr.or.career.mentor.dao;

import java.util.List;
import java.util.Map;

import kr.or.career.mentor.domain.GlobalMnuInfo;
import kr.or.career.mentor.domain.MnuInfo;

public interface MnuInfoMapper {
	public List<MnuInfo> listMnuInfoByMbrNo(Map<String,String> param);
	public List<GlobalMnuInfo> listMangerMnuInfo(Map<String,String> param);
	public List<GlobalMnuInfo> listMangerFullMnuInfo(Map<String,String> param);
}
