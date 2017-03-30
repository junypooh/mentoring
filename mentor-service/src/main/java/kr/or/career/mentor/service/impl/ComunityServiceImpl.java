package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.ArclCmtInfoMapper;
import kr.or.career.mentor.dao.ArclFileInfoMapper;
import kr.or.career.mentor.dao.ArclInfoMapper;
import kr.or.career.mentor.dao.FileMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.FileManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.map.HashedMap;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service("comunityService")
public class ComunityServiceImpl implements ComunityService {

    @Autowired
    ArclInfoMapper arclInfoMapper;

    @Autowired
    ArclCmtInfoMapper arclCmtInfoMapper;

    @Autowired
    FileMapper fileMapper;

    @Autowired
    ArclFileInfoMapper arclFileInfoMapper;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Override
    public ArclInfo<T> getLectureArticleInfo(ArclInfo<T> arclInfo) {
        return arclInfoMapper.getLectureArclInfo(arclInfo);
    }

    @Override
    public List<ArclInfo<T>> getArticleList(ArclInfo<T> arclInfo) {
        return arclInfoMapper.getArclList(arclInfo);
    }

    @Override
    public List<ArclInfo<T>> getArticleListWithNotiable(ArclInfo<T> arclInfo) {

        boolean pageable = arclInfo.isPageable();
        arclInfo.setPageable(false);
        List<ArclInfo<T>> arclInfoList = arclInfoMapper.getArticleListJustNotiable(arclInfo);

        arclInfo.setPageable(pageable);
        List<ArclInfo<T>> arcls =  arclInfoMapper.getArclList(arclInfo);

        if(arcls.size() > 0 && arclInfoList.size() > 0){
            arclInfoList.get(0).setTotalRecordCount(arcls.get(0).getTotalRecordCount());
        }

        CollectionUtils.addAll(arclInfoList,arcls.iterator());

        return arclInfoList;
    }

    @Override
    public List<ArclInfo<T>> getArticleListWithoutFile(ArclInfo<T> arclInfo) {
        return arclInfoMapper.getArticleListWithoutFile(arclInfo);
    }

    @Override
    public int registArcl(ArclInfo<T> arclInfo, String fileSers) {
        int rtn = arclInfoMapper.registArcl(arclInfo);
        int rtn2 = arclFileInfoProcess(arclInfo, fileSers);
        return rtn * rtn2;
    }

    @Override
    public int updateArcl(ArclInfo<T> arclInfo, String fileSers) {
        int rtn = arclInfoMapper.updateArcl(arclInfo);
        int rtn2 = arclFileInfoProcess(arclInfo, fileSers);
        return rtn * rtn2;
    }

    @Override
    public int deleteArcl(ArclInfo<T> arclInfo) {
        return arclInfoMapper.deleteArcl(arclInfo);
    }

    @Override
    public int deleteArclReply(ArclInfo<T> arclInfo) {
        return arclInfoMapper.deleteArclReply(arclInfo);
    }

    @Override
    public List<ArclCmtInfo> getCmtInfoList(ArclCmtInfo arclCmtInfo) {
        return arclCmtInfoMapper.getCmtInfoList(arclCmtInfo);
    }

    @Override
    public int registCmt(ArclCmtInfo arclCmtInfo) {
        return arclCmtInfoMapper.registCmt(arclCmtInfo);
    }

    @Override
    public int deleteCmt(ArclCmtInfo arclCmtInfo) {
        return arclCmtInfoMapper.deleteCmt(arclCmtInfo);
    }

    @Override
    public List<BoardPrefInfo> getBoardPrefInfoList(BoardPrefInfo boardPrefInfo) {
        return arclInfoMapper.getBoardPrefInfoList(boardPrefInfo);
    }

    /**
     *
     * <pre>
     * 최신 후기
     * </pre>
     *
     * @return
     */
    @Override
    public List<ArclCmtInfoRS> listRecentPostscript() {
        return arclInfoMapper.listRecentPostscript();
    }

    @Override
    public List<Map<String, String>> getLastLectList(String mbrNo) {
        return arclInfoMapper.getLastLectList(mbrNo);
    }

    @Override
    public int insertArclFileInfo(ArclFileInfo arclFileInfo) {
        return fileMapper.insertArclFileInfo(arclFileInfo);
    }

    @Override
    public int deleteArclFileInfoByArclSer(ArclFileInfo arclFileInfo) {
        return fileMapper.deleteArclFileInfoByArclSer(arclFileInfo);
    }

    private int arclFileInfoProcess(ArclInfo<T> arclInfo, String fileSers) {
        int rtn = 0;
        if (fileSers != null) {
            ArclFileInfo arclFileInfo = new ArclFileInfo();
            arclFileInfo.setArclSer(arclInfo.getArclSer());
            arclFileInfo.setBoardId(arclInfo.getBoardId());
            arclFileInfo.setRegMbrNo(arclInfo.getRegMbrNo());
            fileMapper.deleteArclFileInfoByArclSer(arclFileInfo);
            for (String fileSer : fileSers.split(",")) {
                if (fileSer != null && !fileSer.equals("")) {
                    arclFileInfo.setFileSer(Integer.parseInt(fileSer));
                    rtn = insertArclFileInfo(arclFileInfo);
                }
            }
        }
        return rtn;
    }

    @Override
    public int insertAnswer(ArclInfo<T> arclInfo) {
        return arclInfoMapper.insertAnswer(arclInfo);
    }

    @Override
    public List<ArclInfo<T>> getMentorDataArclList(ArclInfo<T> arclInfo) {
        return arclInfoMapper.getMentorDataArclList(arclInfo);
    }

    @Override
    public int getNotiCount(ArclInfo<T> arclInfo) {
        return arclInfoMapper.getNotiCount(arclInfo);
    }

    @Override
    public int registLectureDataArcl(ArclInfo<T> arclInfo) throws Exception {

        int rtn = arclInfoMapper.registArcl(arclInfo);

        // 수업자료 등록
        for (int i = 0; i < arclInfo.getListArclFileInfo().size(); i++) {
            if (arclInfo.getListArclFileInfo().get(i).getComFileInfo() !=null && !arclInfo.getListArclFileInfo().get(i).getComFileInfo().getFile().getOriginalFilename().equals("")) { // 파일정보가
                // 있을시만
                ArclFileInfo arclFileInfo = new ArclFileInfo();
                FileInfo fileInfo = fileManagementService.fileProcess(arclInfo.getListArclFileInfo().get(i).getComFileInfo().getFile(), "TEST");
                arclFileInfo.setFileSer(fileInfo.getFileSer());
                arclFileInfo.setArclSer(arclInfo.getArclSer());
                arclFileInfo.setBoardId(arclInfo.getBoardId());
                arclFileInfo.setRegMbrNo(arclInfo.getRegMbrNo());
                rtn += this.insertArclFileInfo(arclFileInfo);
            }
        }
        return rtn;
    }

    @Override
    public List<ArclInfo<T>> lectureFiledResult(ArclInfo<T> arclInfo) {
        return arclInfoMapper.lectureFiledResult(arclInfo);
    }

    @Override
    public int isGradeYn(ArclCmtInfo arclCmtInfo) {
        //수업을 신청하고 종료된 수업인지 CHECK
        if(arclCmtInfoMapper.isApplyedLecture(arclCmtInfo) > 0){
            return arclCmtInfoMapper.isGradeYn(arclCmtInfo);
        }
        return -1;
    }

    @Override
    public List<CompLectInfoDTO> selectCompLectList(CompLectInfoDTO compLectInfo) {
        return arclInfoMapper.selectCompLectList(compLectInfo);
    }

    @Override
    public List<ArclInfoDTO> getReplayInfoList(ArclInfoDTO dto) {
        return arclInfoMapper.getReplayInfoList(dto);
    }

    @Override
    public ArclInfoDTO getReplayInfoDetail(ArclInfoDTO dto) {
        arclInfoMapper.addVcnt(dto);
        return arclInfoMapper.getReplayInfoDetail(dto);
    }

    @Override
    public List<ArclInfo<T>> getSimpleArclList(ArclInfo<T> arclInfo) {
        List<ArclInfo<T>> arclList = new ArrayList<>();
        if(arclInfo.isDispNotice()) {
            arclList.addAll(arclInfoMapper.getSimpleNoticeList(arclInfo));
        }
        arclList.addAll(arclInfoMapper.getSimpleArclList(arclInfo));
        return arclList;
    }

    @Override
    public ArclInfo<T> getSimpleArclInfo(ArclInfo<T> arclInfo) {
        arclInfoMapper.addVcnt(arclInfo);
        return arclInfoMapper.getSimpleArclInfo(arclInfo);
    }

    @Override
    public int addVcnt(ArclInfo<T> arclInfo) {
        return arclInfoMapper.addVcnt(arclInfo);
    }

    @Override
    public List<ArclFileInfo> getFileInfoList(ArclInfo<T> arclInfo) {
        return arclFileInfoMapper.getArclFileList(arclInfo);
    }

    @Override
    public CompLectInfoDTO selectCompLectInfo(CompLectInfoDTO dto) {
        return arclInfoMapper.selectCompLectInfo(dto);
    }

    @Override
    public List<ArclCmtInfo> getSimpleCmtInfoList(ArclCmtInfo arclCmtInfo) {
        return arclCmtInfoMapper.getSimpleCmtInfoList(arclCmtInfo);
    }

    @Override
    public int updateCmt(ArclCmtInfo arclCmtInfo) {
        return arclCmtInfoMapper.updateCmt(arclCmtInfo);
    }

    @Override
    public List<RatingDTO> listRating(RatingDTO ratingDTO) {
        return arclInfoMapper.listRating(ratingDTO);
    }

    @Override
    public List<RatingDTO> ratingListByLecture(RatingDTO ratingDTO) {
        return arclInfoMapper.ratingListByLecture(ratingDTO);
    }

    @Override
    public List<RatingCmtDTO> listRatingCmt(RatingCmtDTO ratingCmtDTO){
        return arclInfoMapper.listRatingCmt(ratingCmtDTO);
    }

    @Override
    public RatingCmtDTO retrieveRatingCmt(RatingCmtDTO ratingCmtDTO){
        return arclInfoMapper.retrieveRatingCmt(ratingCmtDTO);
    }

    @Override
    public List<LectArclDTO> lectList(LectArclDTO dto) {
        return arclInfoMapper.lectList(dto);
    }

    @Override
    public List<BoardPrefInfo> getBoardPrefInfo(String boardId) {
        BoardPrefInfo boardPrefInfo = new BoardPrefInfo();
        boardPrefInfo.setBoardId(boardId);
        return arclInfoMapper.getBoardPrefInfoList(boardPrefInfo);
    }

    @Override
    public List<ArclInfo<T>> getClassTaskList(ArclInfo<T> arclInfo) {
        return arclInfoMapper.getClassTaskList(arclInfo);
    }

    @Override
    public Map<String, Object> getNoticeList(ArclInfo<T> arclInfo) {

        Map<String, Object> rtnMap = new HashedMap();

        // 중요공지 조회
        ArclInfo<T> notiArclInfo = new ArclInfo<>();
        notiArclInfo.setNotiYn("Y");
        notiArclInfo.setBoardId(Constants.BOARD_ID_NOTICE);
        notiArclInfo.setPageable(false);
        List<ArclInfo<T>> notiList = arclInfoMapper.getSimpleArclList(notiArclInfo);

        // 기본공지 조회
        List<ArclInfo<T>> list = arclInfoMapper.getSimpleArclList(arclInfo);

        rtnMap.put("noti", notiList);
        rtnMap.put("list", list);

        return rtnMap;
    }

    @Override
    public List<RatingDTO> getRatingByLecture(RatingDTO ratingDTO) throws Exception{
        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setSchoolGrd(ratingDTO.getSchoolGrd());
        lectureSearch.setSchoolEtcGrd(ratingDTO.getSchoolEtcGrd());
        lectureManagementService.setDtSchoolGrdExList(lectureSearch);
        ratingDTO.setSchoolGrdExList(lectureSearch.getSchoolGrdExList());
        ratingDTO.setSchoolEtcGrd(lectureSearch.getSchoolEtcGrd());

        return arclInfoMapper.getRatingByLecture(ratingDTO);
    }

    @Override
    public List<RatingDTO> getRatingByMentor(RatingDTO ratingDTO) {
        return arclInfoMapper.getRatingByMentor(ratingDTO);
    }

    @Override
    public List<RatingCmtDTO> getLectureReview(RatingCmtDTO ratingCmtDTO) throws Exception {
        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setSchoolGrd(ratingCmtDTO.getSchoolGrd());
        lectureSearch.setSchoolEtcGrd(ratingCmtDTO.getSchoolEtcGrd());
        lectureManagementService.setDtSchoolGrdExList(lectureSearch);
        ratingCmtDTO.setSchoolGrdExList(lectureSearch.getSchoolGrdExList());
        ratingCmtDTO.setSchoolEtcGrd(lectureSearch.getSchoolEtcGrd());

        return arclInfoMapper.getLectureReview(ratingCmtDTO);
    }

    @Override
    public int deleteLectureReview(RatingCmtDTO ratingCmtDTO) {
        return arclInfoMapper.deleteLectureReview(ratingCmtDTO);
    }

    @Override
    public List<ArclInfo<T>> getMentorArclInfoList(ArclInfo<T> arclInfo) {
        return arclInfoMapper.getMentorArclInfoList(arclInfo);
    }

}