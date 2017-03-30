package kr.or.career.mentor.dao;

import java.util.List;

import kr.or.career.mentor.domain.*;

public interface SchInfoMapper {

    List<SchInfo> listSchInfo(SchInfo schInfo);

    List<SchInfoDTO> listSchInfoWithGroup(BizGrpSearch bizGrpSearch);

    SchInfoDTO retrieveSchInfoDetail(SchInfo schInfo);

    SchInfo retrieveSchInfo(SchInfo schInfo);

    SchInfo getSchInfo();

    int insertSchInfo(SchInfo schInfo);

    int updateSchInfo(SchInfo schInfo);

    int deleteSchInfo();

    List<SchInfoExcelDTO> excelDownListSchInfoWithGroup(BizGrpSearch bizGrpSearch);

    List<SubSchInfoExcelDTO> excelDownSubListSchInfoWithGroup(LectureSearch lectureSearch);

    int insertSchCualf(SchInfo schInfo);

    int deleteSchCualf(SchInfo schInfo);

    int deleteSchDevice(SchInfo schInfo);
    int insertSchDevice(SchInfo schInfo);

    int insertSchJobGroup(SchJobGroup schJobGroup);
    int deleteSchJobGroup(SchInfo schInfo);

    List<SchJobGroup> listSchJobGroupInfo(SchJobGroup schJobGroup);

}
