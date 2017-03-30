/* ntels */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    LectureInfomationMapper
 *
 * 수업정보를 관리하는 Mapper클래스
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-21 오후 1:12
 */
public interface LectureInfomationMapper {
    List<Map<String,Object>> monthlyLectureInfo(Map<String, Object> params);

    List<LectSchdInfo> dailyLectureInfo(Map<String, Object> params);

    /**
     * <pre>
     *  수업목록 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectSchdInfo> listLect(LectureSearch lectureSearch);

    /**
     * <pre>
     *  수업목록 총갯수
     * </pre>
     * @param params
     * @return
     */
    int listLectCnt(LectureSearch params);

    /**
     * <pre>
     *     수업일시정보 목록조회
     * </pre>
     * @param lectInfo
     * @return
     */
    List<LectSchdInfo> listLectureScheduleInfomation(LectInfo lectInfo);

    /**
     * <pre>
     *     수업일시정보 단건 조회
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    LectSchdInfo retrieveLectSchdInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *  수업개설 및 수정
     * </pre>
     * @param lectInfo
     * @return
     */
    int saveOpenLect(LectInfo lectInfo);

    /**
     * <pre>
     *     수업차수정보 등록
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    int insertLectTimsInfo(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     수업일정정보 등록
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    int insertLectSchdInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *   수업신청 전에 현 신청인원 숫자확인
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int cntLectApplInfo(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *   강의 수업신청 수강신청인원 체크후 입력
     * </pre>
     * @param lectInfo
     * @return
     * @throws Exception
     */
    int applLectApplInfo(LectInfo lectInfo);

    /**
     * <pre>
     *   기기설정정보 조회
     * </pre>
     * @return
     * @throws Exception
     */
    ClasSetHist retrieveClasSetHist();


    /**
     * <pre>
     *   강의 수업신청 수강신청인원 체크후 입력
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int insertLectApplInfo(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     수업일시정보 수정
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    int updateLectureScheduleInfomation(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     수업요청 등록
     * </pre>
     * @param lectReqInfo
     * @return
     */
    int insertLectureRequest(LectReqInfo lectReqInfo);

    /**
     * <pre>
     *     수업요청시간정보 등록
     * </pre>
     * @param lectReqTimeInfo
     * @return
     */
    int insertLectureRequestTimeInfo(LectReqTimeInfo lectReqTimeInfo);

    /**
     * <pre>
     *     수업요청 목록조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectReqInfo> listLectureRequest(LectureSearch lectureSearch);

    /**
     * <pre>
     *     멘토에의한 수업취소
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    int cnclLectSchdInfo(LectSchdInfo lectSchdInfo);

    /**
    * <pre>
    *     신청상태코드 수정
    * </pre>
     * @param lectApplInfo
     * @return
     */
    int updateLectureApplyStatus(LectApplInfo lectApplInfo);

    //public int updateLectureApplyStatusBulk(List<LectApplInfo> lectApplInfos);

    int updateLectureTimeStatus(LectTimsInfo lectTimsInfo);

    int updateLectureSchdStatusBulk(LectTimsInfo lectTimsInfo);

    int updateLecutApplyCnt(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     수업취소 전 현재 수강인원 체크
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    List<LectApplInfo> cntLectListenMem(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *   기기설정정보 입력
     * </pre>
     * @param clasSetHist
     * @return
     * @throws Exception
     */
    int insertClasSetHist(ClasSetHist clasSetHist) throws Exception;


    /**
     * <pre>
     * 수업신청대상 조회(기기조회시 사용)
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    LectSchdInfo listLectApplDvc(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     D-2,D-1 수업차수정보(CNET_LECT_TIMS_INFO) 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectTimsInfo> listLectureStatus(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업을 신청한 교사목록 조회
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    List<LectureInfomationDTO> listLectureApplicationTeacher(LectTimsInfo lectTimsInfo);


    /**
     * <pre>
     * 수업신청기기(교실) 조회
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    List<LectureInfomationDTO> listLectApplClas(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     * 수업상세조회(LECT_SCHD_INFO 리스트조회 >>> BECAUSE 연강)
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    List<LectSchdInfo> listLectSchdInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     * 수업상세조회(단건)
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    LectInfo retireveLectSchdInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     * 해당수업 신청기기수 조회
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    LectureInfomationDTO applDvcCnt(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     모집마감 시켜야될 수업차수정보 목록조회
     * </pre>
     * @param param
     * @return
     */
    List<LectTimsInfo> listtRecruitmentCloseLectTimsInfo(Map<String,Integer> param);

    /**
     * <pre>
     *     수업상태코드 수정
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    int updateLectureStatus(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     수업신청정보 조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectApplInfo> listLectApplInfo(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     수업신청정보 조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    LectApplInfo retrieveLectApplInfo(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     하나의 차수정보에 대한 수업일시정보 조회
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    List<LectSchdInfo> listLectTimsSchdInfo(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     수업횟수 차감
     * </pre>
     * @param lectApplCnt
     * @return
     */
    int updateLectApplCnt(LectApplCnt lectApplCnt);

    /**
     * <pre>
     *     수업횟수 차감 정보조회
     * </pre>
     * @param lectApplCnt
     * @return
     */
    LectApplCnt retireveLectApplCntReuslt(LectApplCnt lectApplCnt);

    /**
     * <pre>
     *     수업중복 대기상태체크
     * </pre>
     * @param dupLectSchdInfo
     * @return
     */
    int dupLectApplInfo(LectSchdInfo dupLectSchdInfo);

    /**
     * <pre>
     *    나의수업 정보조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> myLectureInfoList(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     수업유형에 따른 갯수 조회(교사)
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> myLectureStatCnt(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     속한교실목록 리스트조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<ClasRoomRegReqHist> myLectureClasRoomList(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     수업정보 수정
     * </pre>
     * @param lectInfo
     * @return
     */
    int updateLectInfo(LectInfo lectInfo);

    /**
     * <pre>
     *     수업정보 등록
     * </pre>
     * @param lectInfo
     * @return
     */
    int insertLectInfo(LectInfo lectInfo);

    /**
     * <pre>
     *     수업에 대한 평점 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    LectureInfomationDTO retireveLectureRating(ArclInfo arclInfo);

    /**
     * <pre>
     *     수업요청정보조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> myLectureReqInfoList(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     수업요청정보/수업신청정보조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> myLectureInfoAllList(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     수업요청정보 희망시간조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> myLectureReqTimeList(LectApplInfo lectApplInfo);


    /**
     * <pre>
     *     관련수업 목록조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> listRelationLecture(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업일정정보 단건 조회
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    LectSchdInfo retireveLectureSchdInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     수업유형에 따른 갯수 조회(학생)
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> stuMyLectureStatCnt(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     교사가 담당하는 학교정보 목록 조회(selectbox)
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<SchInfo> listSchInfo(LectureSearch lectureSearch);

    /**
     * <pre>
     *     학교에 속한 교실목록 조회
     * </pre>
     * @param schInfo
     * @return
     */
    List<ClasRoomInfo> listClasRoomInfo(SchInfo schInfo);

    /**
     * <pre>
     *     학교에 속한 교실목록 조회
     * </pre>
     * @param bizSetInfo
     * @return
     */
    List<LectureApplInfoDTO> listSchoolLect(BizSetInfo bizSetInfo);

    /**
     * <pre>
     * 신청한 수업 목록
     * </pre>
     * @param lectureApplInfoDTO
     * @return
     */
    List<LectureApplInfoDTO> listAppliedLecture(LectureApplInfoDTO lectureApplInfoDTO);

    /**
     * <pre>
     * 내가 속한 교실에서 신청한 수업목록
     * </pre>
     * @param lectureApplInfoDTO
     * @return
     */
    List<LectureApplInfoDTO> listAppliedLectureByMyClassroom(LectureApplInfoDTO lectureApplInfoDTO);

    /**
     * <pre>
     *     멘토및 직업검색
     * </pre>
     * @param jobSearch
     * @return
     */
    List<JobMentorInfoDTO> mentorjobSearch(JobSearch jobSearch);

    /**
     * <pre>
     *     직업검색 팝업
     * </pre>
     * @param jobSearch
     * @return
     */
    List<JobMentorInfoDTO> jobDetailSearch(JobSearch jobSearch);


    List<LectureInfomationDTO> listRecentRecommandLecture();

    List<LectureInfomationDTO> listSoonCloseLecture();

    List<LectureInfomationDTO> listBestLecture();

    List<LectureInfomationDTO> listNewLecture();

    /**
     *
     * <pre>
     * 수업정보 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectInfo> listLectInfo(LectureSearch lectureSearch);

    /**
     * <pre>
     *     멘토포탈 정산관리 수업목록 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listCalculateLectureByMentor(LectureSearch lectureSearch);

    /**
     * <pre>
     *     멘토포탈 정산관리 총참여일수 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    Integer retireveTotalLectDayCalculateLectureByMentor(LectureSearch lectureSearch);

    /**
     * <pre>
     *     멘토포탈 정산관리 총수업횟수 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    Integer retireveTotallectCntCalculateLectureByMentor(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업요청취소
     * </pre>
     * @param lectReqInfo
     * @return
     */
    int cancelReqLectInfo(LectReqInfo lectReqInfo);

    /**
     * <pre>
     *     기관(교육청) 조회(selectbox)
     *     수업신청 팝업화면에서 선택된 학교가 속해 있는 사업의 교육청을 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<CoInfo> listCoInfoByLectAppl(LectureSearch lectureSearch);

    /**
     * <pre>
     *     교육청의 사업 조회(selectbox)
     *     수업신청 팝업화면에서 교육청을 선택했을 시 교육청이 가지고 있는 사업정보, 배정횟수, 잔여횟수 등 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<BizSetInfo> listBizSetGrpByCoInfo(LectureSearch lectureSearch);

    /**
     * <pre>
     *     학교 자체 배정된 배정횟수, 잔여횟수 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    BizSetInfo listBizSetInfoBySchool(LectureSearch lectureSearch);

    /**
     * <pre>
     *     멘토수업목록 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureApplInfoDTO> mentorLectureList(LectureSearch lectureSearch);

    /**
     *
     * <pre>
     * 연강의 수업상태 정보를 갱신해 준다.
     * </pre>
     *
     * @param param
     */
    void updateLinkedLectureSchdStatus(HashMap<String,Integer> param);
    /**
     *
     * <pre>
     * 강좌의 상태를 변경해 준다.
     * </pre>
     *
     */
    void updateLectureSchdStatus(HashMap<String,Integer> param);

    /**
     *
     * <pre>
     * 강좌의 상태를 변경해 준다.(Batch)
     * </pre>
     *
     */
    void updateLectureSchdStatusSchedule(HashMap<String,Integer> param);

    /**
     *
     * <pre>
     * 수업 차수정보 상태 갱신  (Batch)
     * </pre>
     *
     */
    void updateLectureTimsStatusSchedule(HashMap<String,Integer> param);

    /**
     *
     * <pre>
     * 수업 차수정보 상태 갱신
     * </pre>
     *
     */
    void updateLectureTimsStatus(HashMap<String,Integer> param);

    /**
     *
     * <pre>
     * 현재시간 기준으로 다음 수업 상태 갱신이 이루어져야 하는 시간 조회
     * </pre>
     *
     */
    Date retrieveNextStatusChangeTime(HashMap<String, Integer> param);

    /**
     * <pre>
     *     수업을 개설한 멘토(소속멘토)의 기업멘토와 기업멘토가 속한 교육청을 조회
     *     조회조건인 회원번호는 소속멘토의 회원번호라고 전제
     * </pre>
     * @param mbrNo
     * @return
     */
    LectureInfomationDTO listMentorRelMapp(String mbrNo);

    /**
     * <pre>
     *     수업이미지조회
     * </pre>
     * @param lectSer
     * @return
     */
    List<LectPicInfo> listLectPicInfo(Integer lectSer);

    /**
    * <pre>
    *     수업정보 조회 단건
    * </pre>
     * @param lectureSearch
     * @return
     */
    LectInfo retrieveLectInfo(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업정보 조회 단건(수업일시정보 추가)
     * </pre>
     * @param lectureSearch
     * @return
     */
    LectInfo retrieveLectSchdInfoResult(LectureSearch lectureSearch);

    /**
     *
     * <pre>
     * 수업의 상태를 변경한다.
     * </pre>
     *
     * @param approvalDTO
     * @return
     */
    int updateLectureSchdStatCd(ApprovalDTO approvalDTO);
    int updateLectureTimsStatCd(ApprovalDTO approvalDTO);
    int updateLectureInfoStatCd(ApprovalDTO approvalDTO);

    /**
     * <pre>
     *     복사수업저장
     * </pre>
     * @param lectInfo
     * @return
     */
    int copySaveOpenLect(LectInfo lectInfo);

    /**
     * <pre>
     *     수업스케줄 목록조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listLectureSchedule(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업일시정보 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectTimsInfo> listLectureScheduleTims(LectureSearch lectureSearch);

    /**
     * @param lectureSearch
     * @return
     */
    List<LectTimsInfo> listLectTimsInfo(LectureSearch lectureSearch);

    /**
     *
     * <pre>
     * 각 상태별 수업 개수
     * </pre>
     *
     * @param user
     * @return
     */
    StateCnt retrieveLectStatusCnt(User user);

    /**
     * <pre>
     *     수업신청이력 등록
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int insertLectApplHist(LectApplInfo lectApplInfo);


    List<LectSchdInfo> listLectureScheInfo(ApprovalDTO approvalDTO);
    /**
     * <pre>
     *     수업요청 목록조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectReqInfo> listRequestLecture(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업요청 목록조회
     * </pre>
     * @param lectReqInfo
     * @return
     */
    LectReqInfo retrieveLectReqInfo(LectReqInfo lectReqInfo);

    /**
     * <pre>
     *     수업신청횟수 등록
     * </pre>
     * @param lectApplCntl
     * @return
     */
    int insertLectApplCnt(LectApplCnt lectApplCntl);

    /**
     * <pre>
     *     배정된 수업횟수 조회
     * </pre>
     * @param bizSetInfo
     * @return
     */
    int retrieveClasCnt(BizSetInfo bizSetInfo);

    /**
     * <pre>
     *     수업신청정보 수정
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int updateLectApplInfo(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     기업멘토 관련수업 목록조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listCompanyMentorRelationLecture(LectureSearch lectureSearch);

    /**
     * <pre>
     *     기업멘토 관련수업 수업상태별 건수 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    LectureInfomationDTO retrieveCompanyMentorRelationLectureCnt(LectureSearch lectureSearch);

    /**
     * <pre>
     *     관리자 수업현황
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> lectureTotalList(LectureSearch lectureSearch);


    /**
     * <pre>
     *     관리자포탈 수업일시정보 목록조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listLectTimsInfoByAdmin(LectureSearch lectureSearch);
    /**
     * <pre>
     *     관리자 수업현황 엑셀다운로드
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> excelDownListLectureStatus(LectureSearch lectureSearch);

    /**
     * <pre>
     *     관리자 수업현황 엑셀학교목록
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> excelDownSchoolList(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     관리자 수업현황 엑셀대기학교목록
     * </pre>
     * @param lectApplInfo
     * @return
     */
    List<LectureApplInfoDTO> excelDownStandBySchoolList(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     관리자 수업현황 수업 신청 최초 여부
     * </pre>
     * @param schInfo
     * @return
     * @throws Exception
     */
    String excelLectureFirstSchoolText(SchInfo schInfo);

    /**
     * <pre>
     *     관리자 수업대기 기기
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    List<LectureInfomationDTO> listLectApplWaitClas(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     수업신청목록조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> selectApplSchoolList(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업시간이 겹치는 수업이 존재하는지 조회
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    LectureInfomationDTO retrieveLectureTimeOverlap(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     수업상태 현황카운트
     * </pre>
     * @param
     * @return
     */
    List<LectureInfomationDTO> lectureStatusCnt(LectureSearch lectureSearch);



    /**
     * <pre>
     *     멘토탈퇴 전 개설된 수업이 존재하는지 체크
     * </pre>
     * @param lectureSearch
     * @return
     */
    Integer secessionCheck(LectureSearch lectureSearch);

    Integer selectParticipant(Map participantLists);

    /**
     * <pre>
     *     직업현황 통계
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listJobStatistics(LectureSearch lectureSearch);

    /**
     * <pre>
     *     직업현황 통계
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listJobStatisticsByLv1(LectureSearch lectureSearch);

    List<LectureInfomationDTO> listJobStatisticsByLv2(LectureSearch lectureSearch);


    /**
     * <pre>
     *     수업현황 통계
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listLectStatistics(LectureSearch lectureSearch);

    String selectLectTarget(String lectSer);

    String selectSchoolClass(String schNo);

    List<PeopleInLecture> getCurrentPeopleInLecture();

    /**
     * <pre>
     *     수업 차수 노출/비노출 수정
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    int updateExpsLectureInfo(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     캘린더 데이터 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectCalendarInfo> selectLectureSchCalendarInfo(LectureSearch lectureSearch);

    List<LectureStatusExcelDTO> excelDownLoadLectureList(LectureSearch lectureSearch);

    List<LectureStatusExcelDTO> excelDownLoadLectureClassList(LectureSearch lectureSearch);


    /**
     * <pre>
     *     관리자 수업 차수 현황
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> lectureTimsList(LectureSearch lectureSearch);

    /**
     * <pre>
     *     관리자 수업 회차 현황 카운트
     * </pre>
     * @param lectureSearch
     * @return
     */
    int lectureTimsListCnt(LectureSearch lectureSearch);


    /**
     * <pre>
     *    관리자 수업 차수 상태 현황카운트
     * </pre>
     * @param
     * @return
     */
    List<LectureInfomationDTO> lectureTimsStatusCnt(LectureSearch lectureSearch);

    /**
     * <pre>
     *    관리자 수업정보 상세조회
     * </pre>
     * @param
     * @return
     */
    LectInfo lectureInfo(LectureSearch lectureSearch);

    /**
     * <pre>
     *    관리자 수업정보 상세조회
     * </pre>
     * @param
     * @return
     */
    List<LectInfo> lectureInfoList(LectureSearch lectureSearch);

    /**
     * <pre>
     *    관리자 수업 차수 및 회차 정보 상세조회
     * </pre>
     * @param
     * @return
     */
    LectTimsInfo lectureTimsSchdInfo(LectureSearch lectureSearch);

    /**
     * <pre>
     *    관리자 수업 회차 정보 조회
     * </pre>
     * @param
     * @return
     */
    List<LectSchdInfo> lectureSchdList(LectureSearch lectureSearch);

    /**
     * <pre>
     *    관리자 수업 차수 및 회차 정보 상세조회
     * </pre>
     * @param
     * @return
     */
    List<LectureInfomationDTO> lectureApplList(LectureSearch lectureSearch);

    /**
     * <pre>
     *    관리자 수업 다른 차수 리스트
     * </pre>
     * @param
     * @return
     */
    List<LectTimsInfo> lectureOtherTimsList(LectureSearch lectureSearch);


    /**
     * <pre>
     *     관리자 수업 취소 차수정보 테이블 업데이트
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    int updateLectStatTimsInfo(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     관리자 수업 취소 회차정보 테이블 업데이트
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    int updateLectStatSchdList(LectTimsInfo lectTimsInfo);


    /**
     * <pre>
     *     관리자 수업 취소후 차감회수 복구 처리
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int updateLectStatApplCntList(LectApplInfo lectApplInfo);


    /**
     * <pre>
     *     관리자 수업 취소 수업 신청정보 테이블 업데이트
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    int updateLectStatApplList(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     * 수업 참여 가능 MC 리스트
     * </pre>
     * @param
     * @return
     */
    List<McInfo> lectureMcList(LectureSearch lectureSearch);

    /**
     * <pre>
     * 수업 참여 가능 MC 리스트
     * </pre>
     * @param
     * @return
     */
    List<StdoInfo> lectureStdoList(LectureSearch lectureSearch);


    /**
     * <pre>
     *     관리자 수업 MC/스튜디오 수정
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    int updateLectMcStdoInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     관리자 수업 MC/스튜디오 수정
     * </pre>
     * @param lectTimsInfo
     * @return
     */
    int updateLectTimsBizCnt(LectTimsInfo lectTimsInfo);


    /**
     * <pre>
     * 수업 수동 신청 Class 리스트
     * </pre>
     * @param
     * @return
     */
    List<ClasRoomInfo> lectureApplClasList(LectureSearch lectureSearch);


    /**
     * <pre>
     * 수업 대상 학교 여부 확인
     * </pre>
     * @param
     * @return
     */
    List<String> selectChkLectTarget(LectureInfomationDTO lectureInfomationDTO);

    /**
     * <pre>
     *     수업신청이력 등록
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int updateUseLectAppl(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     반 수업중복 시간체크
     * </pre>
     * @param dupLectSchdInfo
     * @return
     */
    int dupLectSchdInfo(LectSchdInfo dupLectSchdInfo);

    /**
     * <pre>
     *     멘토 수업중복 시간체크
     * </pre>
     * @param dupLectSchdInfo
     * @return
     */
    int dupMentorSchdInfo(LectSchdInfo dupLectSchdInfo);

    /**
     * <pre>
     *   수업 수정시 수업이미지 파일정보 초기화
     * </pre>
     * @param lectInfo
     * @return
     */
    int delLectPicFile(LectInfo lectInfo);

    /**
     * <pre>
     *   수업 수정시 수업이미지 맵핑정보 초기화
     * </pre>
     * @param lectInfo
     * @return
     */
    int delLectPicInfo(LectInfo lectInfo);

    /**
     * <pre>
     *   관리자 수업 수정
     * </pre>
     * @param lectInfo
     * @return
     */
    int updateLectInformation(LectInfo lectInfo);

    /**
     * <pre>
     *     멘토 회차 기준 리스트 (멘토 수업현황)
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureApplInfoDTO> mentorLectSchdList(LectureSearch lectureSearch);

    /**
     * <pre>
     *     멘토포탈 메인 상단 수업 상태 별 현황
     * </pre>
     * @param lectureStatusCountInfo
     * @return
     */
    LectureStatusCountInfo mentorMainLectStatusCount(LectureStatusCountInfo lectureStatusCountInfo);

    /**
     * <pre>
     *     수업 요청 정보 조회
     * </pre>
     * @param lectReqInfo
     * @return List<LectReqInfo>
     */
    List<LectReqInfo> selectLectReqInfoList(LectReqInfo lectReqInfo);

    /**
     * <pre>
     *     수업 요청 정보 조회
     * </pre>
     * @param lectReqInfo
     * @return List<LectReqInfo>
     */
    LectReqInfo selectLectReqInfoCount(LectReqInfo lectReqInfo);


    /**
     * <pre>
     * 수업참관기기(교실) 조회
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    List<LectureInfomationDTO> listLectObsvClas(LectSchdInfo lectSchdInfo);


    /**
     * <pre>
     *   멘토 수업개설신청 등록
     * </pre>
     * @param lectReqInfo
     * @return
     */
    int insertLectOpenReq(LectReqInfo lectReqInfo);

    /**
     * <pre>
     *     수업 요청 정보 상세 조회
     * </pre>
     * @param lectReqInfo
     * @return List<LectReqInfo>
     */
    LectReqInfo selectLectReqInfo(LectReqInfo lectReqInfo);


    /**
     * <pre>
     *   멘토 수업개설신청 수정
     * </pre>
     * @param lectReqInfo
     * @return
     */
    int updateLectOpenReq(LectReqInfo lectReqInfo);

    /**
     * <pre>
     *     학교 마이페이지 -> 나의수업 신청현황 카운트 조회
     * </pre>
     * @param lectApplInfo
     * @return
     */
    LectureApplInfoDTO myLectureTotalStatCnt(LectApplInfo lectApplInfo);


    /**
     * <pre>
     *     학교 마이페이지 -> 나의 요청수업 현황 카운트 조회 (요청수업에서 개설된 수업중 신청된 수업은 제외)
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int myLectureReqCnt(LectApplInfo lectApplInfo);


    /**
     * <pre>
     *     특정 배정에 해당하는 학교 배정정보
     * </pre>
     * @param schInfo
     * @return
     */
    ClasRoomInfo selectSetSchoolInfo(SchInfo schInfo);


    /**
     * <pre>
     *    학교포털 특정 회차 상세 정보
     * </pre>
     * @param
     * @return
     */
    LectureInfomationDTO lectureSchdInfo(LectureSearch lectureSearch);



    /**
     * <pre>
     *   수업참관시 참관이력 저장
     * </pre>
     * @param lectApplInfo
     * @return
     */
    int regObsvHist(LectApplInfo lectApplInfo);

    List<WithdrawInfo> selectObsvHist();

    int updateObsvHist(List<WithdrawInfo> withdrawInfos);

    List<WithdrawInfo> selectWithdrawApplyCount();

    int withdrawApplyCount(List<WithdrawInfo> withdrawInfos);

    int updateObsvHistBatchSuccess(List<WithdrawInfo> obsvHists);

    /**
     * <pre>
     *   대표학생여부 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    int getRpsClasStdt(LectureSearch lectureSearch);

    /**
     * <pre>
     *     관리자 수업 클래스별 신청 현황 리스트
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> lectApplClasList(LectureSearch lectureSearch);

    /**
     * <pre>
     *  수업목록 조회
     * </pre>
     * @param lectureSearch
     * @return
     */
    List<BizGrpInfo> listBizGrpList(LectureSearch lectureSearch);

    /**
     *
     */
    int updateLectureAppl(BizGrpInfo bizGrpInfo);

}
