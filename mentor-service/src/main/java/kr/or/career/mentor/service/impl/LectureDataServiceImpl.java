package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.ArclInfoMapper;
import kr.or.career.mentor.dao.LectureDataMapper;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.DataFileInfo;
import kr.or.career.mentor.domain.LectDataInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.service.LectureDataService;
import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      LectureDataServiceImpl
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-21 오전 10:20
 */
@Service
public class LectureDataServiceImpl implements LectureDataService{

    @Autowired
    private LectureDataMapper lectureDataMapper;

    @Autowired
    private ArclInfoMapper arclInfoMapper;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Override
    public String insertMbrDataInfo(LectDataInfo lectDataInfo) {
        String rtnData = "FAIL";
        // 동영상등록
        if("101760".equals(lectDataInfo.getDataTypeCd())){
            lectDataInfo.setArclSer(videoUpload(lectDataInfo).getArclSer());
        }
        int chk = lectureDataMapper.insertMbrDataInfo(lectDataInfo);
        if(chk > 0) {
            // 파일정보가 있을때 매핑테이블에 INSERT
            if(lectDataInfo.getFileSer() != null){
                int chk2 = lectureDataMapper.insertDataFile(lectDataInfo);
                if(chk2 > 0){
                    rtnData = "SUCCESS";
                }
            }else{
                rtnData = "SUCCESS";
            }
        }
        return rtnData;
    }

    @Override
    public List<LectDataInfo> selectMbrDataInfo(LectDataInfo lectDataInfo) throws Exception{
        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setSchoolGrd(lectDataInfo.getSchoolGrd());
        lectureSearch.setSchoolEtcGrd(lectDataInfo.getSchoolEtcGrd());
        lectureManagementService.setDtSchoolGrdExList(lectureSearch);
        lectDataInfo.setSchoolGrdExList(lectureSearch.getSchoolGrdExList());
        lectDataInfo.setSchoolEtcGrd(lectureSearch.getSchoolEtcGrd());
        return lectureDataMapper.selectMbrDataInfo(lectDataInfo);
    }

    @Override
    public List<LectDataInfo> selectConnectLectList(LectDataInfo lectDataInfo) {
        return lectureDataMapper.selectConnectLectList(lectDataInfo);
    }

    @Override
    public List<DataFileInfo> selectDataFileList(LectDataInfo lectDataInfo) {
        return lectureDataMapper.selectDataFileList(lectDataInfo);
    }

    @Override
    public String updateMbrDataInfo(LectDataInfo lectDataInfo) {
        String rtnStr = "FAIL";
        int updChk = 0;
        boolean newFile = true;

        if(lectDataInfo.getFileSer() != null) {                 // 기존 문서파일이 있을경우
            DataFileInfo dataFileInfo = new DataFileInfo();
            dataFileInfo.setDataSer(lectDataInfo.getDataSer());
            // 기존 파일 데이터 삭제
            lectureDataMapper.deleteDataFile(dataFileInfo);
        }else if(lectDataInfo.getArclSer() != null){            // 기존 동영상 파일이 있을경우
            ArclInfo arclInfo = new ArclInfo();
            arclInfo.setChgMbrNo(lectDataInfo.getChgMbrNo());
            arclInfo.setArclSer(lectDataInfo.getArclSer());

            // 기존동영상 파일과 신규 동영상 파일이 같을경우
            if(!arclInfoMapper.isValidateArcl(lectDataInfo.getArclSer())){
                newFile = false;
                arclInfo.setTitle(lectDataInfo.getDataNm());
                arclInfo.setBoardId(lectDataInfo.getBoardId());
                arclInfoMapper.updateArcl(arclInfo);
            }else{
                // 기존 동영상 데이터 삭제
                arclInfoMapper.deleteArcl(arclInfo);
                lectDataInfo.setArclSer(null);  // 초기화
            }

        }

        if("101759".equals(lectDataInfo.getDataTypeCd())) {   // 문서등록시
            // 새로운파일 등록
            lectureDataMapper.insertDataFile(lectDataInfo);
        }else if("101760".equals(lectDataInfo.getDataTypeCd())){ // 동영상 등록시
            if(newFile){
                // 새로운동영상 등록
                lectDataInfo.setArclSer(videoUpload(lectDataInfo).getArclSer());
            }
        }
        updChk = lectureDataMapper.updateMbrDataInfo(lectDataInfo);

        if(updChk > 0){
            rtnStr = "SUCCESS";
        }

        return rtnStr;
    }

    @Override
    public String updateMbrDataInfoDel(LectDataInfo lectDataInfo) {
        String rtnStr = "FAIL";
        int chk = lectureDataMapper.updateMbrDataInfoDel(lectDataInfo);
        if(chk > 0) {
            rtnStr = "SUCCESS";
        }
        return rtnStr;
    }

    /** 동영상 업로드 */
    private ArclInfo videoUpload(LectDataInfo lectDataInfo){
        ArclInfo arclInfo = new ArclInfo();
        arclInfo.setBoardId(lectDataInfo.getBoardId());
        arclInfo.setTitle(lectDataInfo.getDataNm());
        arclInfo.setCntntsTargtCd("101762");
        arclInfo.setCntntsId(Integer.parseInt(lectDataInfo.getCntntsId()));
        arclInfo.setCntntsApiPath(lectDataInfo.getCntntsApiPath());
        arclInfo.setCntntsPlayTime(lectDataInfo.getCntntsPlayTime());
        arclInfo.setCntntsThumbPath(lectDataInfo.getCntntsThumbPath());
        arclInfo.setUseYn(lectDataInfo.getUseYn());
        arclInfo.setRegMbrNo(lectDataInfo.getRegMbrNo());
        arclInfoMapper.registArcl(arclInfo);

        return arclInfo;
    }

    /** 멘토 자료를 수업자료로 맵핑 */
    @Override
    public int insertLectDataInfo(LectDataInfo lectDataInfo) {

        int chk = lectureDataMapper.insertLectDataInfo(lectDataInfo);

        return chk;
    }

    /** 수업 자료 리스트 */
    @Override
    public List<LectDataInfo> selectLectDataList(LectDataInfo lectDataInfo) throws Exception{

        return lectureDataMapper.selectLectDataInfo(lectDataInfo);
    }

    /** 멘토 자료와 수업자료맵핑 해제  */
    @Override
    public int deleteLectDataFile(LectDataInfo lectDataInfo) {

        int chk = lectureDataMapper.deleteLectDataFile(lectDataInfo);

        return chk;
    }

    @Override
    public List<LectDataInfo> selectCommunityLectData(LectDataInfo lectDataInfo) throws Exception {
        return lectureDataMapper.selectCommunityLectData(lectDataInfo);
    }

}
