package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.*;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by chaos on 15. 8. 31..
 */

public interface LectureManagementService {

    /**
     * <pre>
     *     monthlyLectureInfo
     * </pre>
     *
     * @param params
     * @return
     */
    List<Map<String, Object>> monthlyLectureInfo(Map<String, Object> params);

    /**
     * <pre>
     *     dailyLectureInfo
     * </pre>
     *
     * @param params
     * @return
     */
    List<LectSchdInfo> dailyLectureInfo(Map<String, Object> params);

    /**
     * <pre>
     *  수업목록 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectSchdInfo> listLect(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *  수업목록 총겟숫
     * </pre>
     *
     * @param params
     * @return
     * @throws Exception
     */
    int listLectCnt(LectureSearch params) throws Exception;

    /**
     * <pre>
     *  수업개설 및 수정
     * </pre>
     *
     * @param lectInfo
     * @return
     * @throws Exception
     */
    int saveOpenLect(LectInfo lectInfo) throws Exception;

    /**
     * <pre>
     *     수업일시정보 목록조회
     * </pre>
     *
     * @param lectInfo
     * @return
     * @throws Exception
     */
    List<LectSchdInfo> listLectureScheduleInfomation(LectInfo lectInfo) throws Exception;

    /**
     * <pre>
     *     수업일시정보 추가
     *     개인멘토일 경우에는 관리자의 승인과정이 필요하기 때문에 등록할때 수업상태코드를 승인대기로 입력하고 기업멘토, 소속멘토일 경우에는 모집중 상태로 입력한다.
     * </pre>
     *
     * @param lectInfo
     * @return
     */
    int insertLectureScheduleInfomation(LectInfo lectInfo) throws NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException;

    /**
     * <pre>
     *   수업신청 전에 현 신청인원 숫자확인
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     * @throws Exception
     */
    boolean saveLectureScheduleInfomation(LectSchdInfo lectSchdInfo) throws Exception;

    /**
     * <pre>
     *     수업일시정보 수정
     *     수업일시정보에서 스튜디오와 MC만 수정한다.
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    int cntLectApplInfo(LectApplInfo lectApplInfo) throws Exception;

    /**
     * <pre>
     *   강의 수업신청 수강신청인원 체크후 입력
     * </pre>
     *
     * @param lectApplInfo
     * @return
     */
    int applLectApplInfo(LectApplInfo lectApplInfo);

    /**
     * <pre>
     *     MC정보 목록조회
     * </pre>
     *
     * @param mcInfo
     * @return
     * @throws Exception
     */
    List<McInfo> listMc(McInfo mcInfo) throws Exception;

    /**
     * <pre>
     *     MC정보 목록조회(페이징)
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<McInfo> listMcPaging(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     스튜디오정보 목록조회
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    @Deprecated
    List<StdoInfo> listStudio(StdoInfo stdoInfo) throws Exception;

    /**
     * <pre>
     *     스튜디오정보 목록조회(페이징)
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    List<StdoInfo> listStudioPaging(StdoInfo stdoInfo) throws Exception;

    /**
     * <pre>
     *     수업요청 등록
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    boolean insertLectureRequest(LectReqInfo lectReqInfo) throws Exception;

    /**
     * <pre>
     *     수업요청 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectReqInfo> listLectureRequest(LectureSearch lectureSearch) throws Exception;


    /**
     * <pre>
     *     멘토에 의한 수업취소
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    int cnclLectSchdInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     MC정보 저장
     * </pre>
     *
     * @param mcInfo
     * @return
     * @throws Exception
     */
    boolean saveMcInfo(McInfo mcInfo) throws Exception;

    /**
     * <pre>
     *     MC정보 상세조회
     * </pre>
     *
     * @param mcInfo
     * @return
     * @throws Exception
     */
    McInfo retrieveMcInfo(McInfo mcInfo) throws Exception;

    /**
     * <pre>
     *     스튜디오정보 저장
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    boolean saveStudioInfo(StdoInfo stdoInfo) throws Exception;

    /**
     * <pre>
     *     스튜디오정보 상세조회
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    StdoInfo retrieveStudioInfo(StdoInfo stdoInfo) throws Exception;

    /**
     * <pre>
     *     학교에의한 수업신청 취소
     * </pre>
     *
     * @param lectApplInfo
     * @return
     */
    int cnclLectApplInfo(LectApplInfo lectApplInfo) throws Exception;

    /**
     * <pre>
     *     수업예정 안내메일 발송
     *     수업일 기준으로 D-2일인 경우인 수업들을 조회하고, 해당되는 수업에 신청한 교사들에게
     *     수업예정 안내메일을 발송한다.
     * </pre>
     *
     * @return
     * @throws Exception
     */
    int sendPrearrangedLectureInfomationMail() throws Exception;

    /**
     * <pre>
     * 기기설정정보 조회
     * </pre>
     *
     * @return
     * @throws Exception
     */
    ClasSetHist retrieveClasSetHist() throws Exception;

    /**
     * <pre>
     * 기기설정정보 입력
     * </pre>
     *
     * @param clasSetHist
     * @return
     * @throws Exception
     */
    int insertClasSetHist(ClasSetHist clasSetHist) throws Exception;

    /**
     * <pre>
     * 수업신청대상 조회(기기조회시 사용)
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    LectSchdInfo listLectApplDvc(LectSchdInfo lectSchdInfo) throws Exception;

    /**
     * <pre>
     * 수업신청기기(교실) 조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    List<LectureInfomationDTO> listLectApplClas(LectSchdInfo lectSchdInfo) throws Exception;

    /**
     * <pre>
     *     모집마감으로 인한 수업상태변경
     *     수업일 D-7일이 되는 수업들은 자동으로 모집마감이 되기 때문에
     *     수업상태를 모집중에서 수업예정으로 변경한다.
     * </pre>
     *
     * @return
     * @throws Exception
     */
    int lectureStatusChangeRecruitmentClose(HashMap param);

    /**
     * <pre>
     * 수업상세조회(단건)
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    Map retireveLectSchdInfo(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     수업차감회수 조회
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     * @throws Exception
     */
    int retireveLectureCnt(LectTimsInfo lectTimsInfo, String lectTargtCd);

    /**
     * <pre>
     *     수업신청횟수 업데이트
     * </pre>
     *
     * @param lectApplCnt
     * @return
     * @throws Exception
     */
    int updateLectApplCnt(LectApplCnt lectApplCnt, int incLectVar);

    /**
     * <pre>
     *     수업정보 조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    LectInfo retireveLectureInfo(LectSchdInfo lectSchdInfo) throws Exception;

    /**
     * <pre>
     *     수업유형에따른 카운트
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    Map myLectureList(LectApplInfo lectApplInfo) throws Exception;

    /**
     * <pre>
     *     수업에 대한 평점 조회
     * </pre>
     *
     * @param arclInfo
     * @return
     * @throws Exception
     */
    LectureInfomationDTO retireveLectureRating(ArclInfo arclInfo) throws Exception;

    /**
     * <pre>
     *     관련수업 목록조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> listRelationLecture(LectSchdInfo lectSchdInfo) throws Exception;

    /**
     * <pre>
     *     수업일시정보 목록조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     * @throws Exception
     */
    List<LectSchdInfo> listLectSchdInfo(LectSchdInfo lectSchdInfo) throws Exception;

    /**
     * <pre>
     *     교사가 담당하는 학교정보 목록 조회(selectbox)
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<SchInfo> listSchInfo(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     학교에 속한 교실목록 조회
     * </pre>
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    List<ClasRoomInfo> listClasRoomInfo(SchInfo schInfo) throws Exception;

    /**
     * <pre>
     *     학교의 수업신청 목록 조회
     * </pre>
     *
     * @param bizSetInfo
     * @return
     * @throws Exception
     */
    List<LectureApplInfoDTO> listSchoolLect(BizSetInfo bizSetInfo) throws Exception;

    /**
     * <pre>
     *     내가 신청한 수업 목록
     * </pre>
     *
     * @param lectureApplInfoDTO
     * @return
     */
    List<LectureApplInfoDTO> listAppliedLecture(LectureApplInfoDTO lectureApplInfoDTO);

    /**
     * <pre>
     *     내가 속한 교실에서 신청한 수업목록
     * </pre>
     *
     * @param lectureApplInfoDTO
     * @return
     */
    List<LectureApplInfoDTO> listAppliedLectureByMyClassroom(LectureApplInfoDTO lectureApplInfoDTO);

    /**
     * <pre>
     *     멘토및 직업검색
     * </pre>
     *
     * @param jobSearch
     * @return
     */
    List<JobMentorInfoDTO> mentorjobSearch(JobSearch jobSearch) throws Exception;

    /**
     * <pre>
     *     직업검색팝업
     * </pre>
     *
     * @param jobSearch
     * @return
     */
    List<JobMentorInfoDTO> jobDetailSearch(JobSearch jobSearch) throws Exception;

    /**
     * <pre>
     *     listRecentRecommandLecture
     * </pre>
     *
     * @return
     */
    List<LectureInfomationDTO> listRecentRecommandLecture();

    /**
     * <pre>
     *     listSoonCloseLecture
     * </pre>
     *
     * @return
     */
    List<LectureInfomationDTO> listSoonCloseLecture();

    /**
     * <pre>
     *     listNewLecture
     * </pre>
     *
     * @return
     */
    List<LectureInfomationDTO> listNewLecture();

    /**
     * <pre>
     *     listBestLecture
     * </pre>
     *
     * @return
     */
    List<LectureInfomationDTO> listBestLecture();

    /**
     * <pre>
     *     수업 정보 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectInfo> listLectInfo(LectureSearch lectureSearch);

    /**
     * <pre>
     *     멘토포탈 정산관리(개인멘토 대상) 수업목록 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    LectureInfomationDTO listCalculateLectureByMentor(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     * 수업요청취소
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    int cancelReqLectInfo(LectReqInfo lectReqInfo) throws Exception;

    /**
     * <pre>
     *     기관(교육청) 조회(selectbox)
     *     수업신청 팝업화면에서 선택된 학교가 속해 있는 사업의 교육청을 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<CoInfo> listCoInfoByLectAppl(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     교육청의 사업 조회(selectbox)
     *     수업신청 팝업화면에서 교육청을 선택했을 시 교육청이 가지고 있는 사업정보, 배정횟수, 잔여횟수 등 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<BizSetInfo> listBizSetGrpByCoInfo(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     학교 자체 배정된 배정횟수, 잔여횟수 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    BizSetInfo listBizSetInfoBySchool(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     학교 전체에 배정된 배정횟수, 잔여횟수 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<BizSetInfo> listAllBizSetInfoBySchool(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *      멘토수업리스트 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectureApplInfoDTO> mentorLectureList(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업의 상태를 변경해 준다.
     * </pre>
     *
     * @return
     */
    Date updateLectureStatus();

    /**
     * <pre>
     *     updateLectureStatCd
     * </pre>
     *
     * @param approvalDTO
     * @return
     * @throws InvalidKeyException
     * @throws NoSuchAlgorithmException
     * @throws NoSuchPaddingException
     * @throws InvalidAlgorithmParameterException
     * @throws IllegalBlockSizeException
     * @throws BadPaddingException
     * @throws UnsupportedEncodingException
     */
    int updateLectureStatCd(ApprovalDTO approvalDTO) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException;

    int updateLectureInfoStatCd(ApprovalDTO approvalDTO);

    /**
     * <pre>
     *     cancelEnrolling
     * </pre>
     *
     * @param approvalDTO
     * @return
     * @throws Exception
     */
    int cancelEnrolling(ApprovalDTO approvalDTO) throws Exception;

    /**
     * <pre>
     *     cancelLectureApplying
     * </pre>
     *
     * @param approvalDTO
     * @throws Exception
     */
    void cancelLectureApplying(ApprovalDTO approvalDTO) throws Exception;

    /**
     * <pre>
     *     복사수업저장
     * </pre>
     *
     * @param lectInfo
     * @return
     */
    int copySaveOpenLect(LectInfo lectInfo);

    /**
     * <pre>
     *     각 상태별 수업 개수
     * </pre>
     *
     * @param user
     * @return
     */
    StateCnt retrieveLectStatusCnt(User user);

    /**
     * <pre>
     *     listLectureSchedule
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listLectureSchedule(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업요청 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectReqInfo> listRequestLecture(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     수업기본정보 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    LectInfo retrieveLectInfo(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     기업멘토 관련수업 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> listCompanyMentorRelationLecture(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     기업멘토 관련수업 수업상태별 건수 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    LectureInfomationDTO retrieveCompanyMentorRelationLectureCnt(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업현황
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> lectureTotalList(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     수업을 신청한 교사목록 조회(안내메일 발송 대상자)
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     */
    List<LectureInfomationDTO> listLectureApplicationTeacher(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     관리자포탈 수업일시정보 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> listLectTimsInfoByAdmin(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업현황 엑셀다운로드
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    LectureInfomationDTO excelDownListLectureStatus(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업현황 학교목록조회
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    List<LectureApplInfoDTO> excelDownSchoolList(LectApplInfo lectApplInfo) throws Exception;

    /**
     * <pre>
     *     관리자 수업현황 대기학교목록조회
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    List<LectureApplInfoDTO> excelDownStandBySchoolList(LectApplInfo lectApplInfo) throws Exception;

    /**
     * <pre>
     *     관리자 수업일시상세
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     */
    List<LectSchdInfo> listLectTimsSchdInfo(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     관리자 수업대기 기기
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    List<LectureInfomationDTO> listLectApplWaitClas(LectSchdInfo lectSchdInfo);

    /**
     * <pre>
     *     수업신청기기 상태변경
     * </pre>
     *
     * @param approvalDTO
     * @return
     */
    int updateLectureTimsStatCd(ApprovalDTO approvalDTO);

    /**
     * <pre>
     *     수업신청목록 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectureInfomationDTO> selectApplSchoolList(LectureSearch lectureSearch);

    List<LectureInfomationDTO> lectureStatusCnt(LectureSearch lectureSearch);


    User setUser(String mbrNo) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException;

    ApprovalDTO createSession(ApprovalDTO approvalDTO) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException;

    /**
     * <pre>
     *     멘토탈퇴 전 개설된 수업이 존재하는지 체크
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    Integer secessionCheck(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     직업현황 통계
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> listJobStatistics(LectureSearch lectureSearch);


    List<LectureInfomationDTO> listJobStatisticsByLv1(LectureSearch lectureSearch);

    List<LectureInfomationDTO> listJobStatisticsByLv2(LectureSearch lectureSearch);

    /**
     * <pre>
     *     수업현황 통계
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> listLectStatistics(LectureSearch lectureSearch) throws Exception;


    String selectLectTarget(String lectSer);

    String selectSchoolClass(String schNo);

    Date retrieveNextStatusChangeTime(HashMap<String, Integer> param);

    List<PeopleInLecture> getCurrentPeopleInLecture();

    void changeLectSchdInfo(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     수업 차수 노출/비노출 수정
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     * @throws Exception
     */
    int updateExpsLectureInfo(LectTimsInfo lectTimsInfo);

    /**
     * <pre>
     *     캘린더 데이터 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectCalendarInfo> selectLectureSchCalendarInfo(LectureSearch lectureSearch) throws Exception;

    List<LectureStatusExcelDTO> excelDownLoadLectureList(LectureSearch lectureSearch) throws Exception;

    List<LectureStatusExcelDTO> excelDownLoadLectureClassList(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 차수현황
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> lectureTimsList(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 상세현황
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    LectInfo lectureInfo(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectInfo> lectureInfoList(LectureSearch lectureSearch) throws Exception;


    /**
     * <pre>
     *     관리자 수업 상세현황
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    LectTimsInfo lectureTimsSchdInfo(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 상태별 카운트현황
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> lectureTimsStatusCnt(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     수업현황 조회시 학교급 조건 제외 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    void setDtSchoolGrdExList(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 신청/참관 정보 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> lectureApplList(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 다른 차수 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectTimsInfo> lectureOtherTimsList(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 수동취소
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     * @throws Exception
     */
    int cnclLect(LectTimsInfo lectTimsInfo) throws Exception;

    /**
     * <pre>
     *     관리자 수업 Class 수업 신청취소
     * </pre>
     *
     * @param lectureInfomationDTO
     * @return
     * @throws Exception
     */
    int cnclLectClass(LectureInfomationDTO lectureInfomationDTO) throws Exception;

    /**
     * <pre>
     *     관리자 수업 취소사유 수정
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     * @throws Exception
     */
    int cnclRsnUpdate(LectTimsInfo lectTimsInfo) throws Exception;


    /**
     * <pre>
     *  수업 참여 가능 MC 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<McInfo> listMcInfo(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *  수업 스튜디오 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<StdoInfo> listStdoInfo(LectureSearch lectureSearch) throws Exception;


    /**
     * <pre>
     *     관리자 수업 MC/스튜디오 수정
     * </pre>
     *
     * @param lectTimsInfo, mbrNo
     * @return
     * @throws Exception
     */
    int lectUpdateMcStdo(LectTimsInfo lectTimsInfo, String mbrNo) throws Exception;


    /**
     * <pre>
     *  수업 수동 신청 Class 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<ClasRoomInfo> listLectClass(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *  수업 수동 신청 Class 리스트
     * </pre>
     *
     * @param lectureInfomationDTO
     * @return
     * @throws Exception
     */
    int lectInsertClass(LectureInfomationDTO lectureInfomationDTO,  String callPath) throws Exception;

    /**
     * <pre>
     *  수업 일시추가 차수/회차 등록
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     * @throws Exception
     */
    int IectureSchdInfoInsert(LectTimsInfo lectTimsInfo) throws NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException;
    /**
     * <pre>
     * 수업참관기기(교실) 조회
     * </pre>
     * @param lectSchdInfo
     * @return
     */
    List<LectureInfomationDTO> listLectObsvClas(LectSchdInfo lectSchdInfo) throws Exception;



    /**
     * <pre>
     *  수업수정
     * </pre>
     *
     * @param lectInfo
     * @return
     * @throws Exception
     */
    int updateLectInfo(LectInfo lectInfo, String potalType) throws Exception;

    /**
     * <pre>
     *      멘토수업 회차리스트 (멘토 수업현황)
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    List<LectureApplInfoDTO> mentorLectureSchdList(LectureSearch lectureSearch);


    /**
     * <pre>
     *     스튜디오정보 목록조회
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    List<StdoInfo> stdoList(StdoInfo stdoInfo) throws Exception;

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
     *  멘토 수업개설신청 등록
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    int insertLectOpenReqInfo(LectReqInfo lectReqInfo) throws Exception;


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
     *  멘토 수업개설신청 수정
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    int updateLectOpenReqInfo(LectReqInfo lectReqInfo) throws Exception;


    /**
     * <pre>
     *   강의 참관시 참관이력 저장
     * </pre>
     *
     * @param lectApplInfo
     * @return
     */
    int regObsvHist(LectApplInfo lectApplInfo) throws Exception;


    int withdrawApplyCount();

    /**
     * <pre>
     *   대표학생여부 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    int getRpsClasStdt(LectureSearch lectureSearch) throws Exception;

    /**
     * <pre>
     *     관리자 수업 현황 엑셀 다운로드 리스트
     * </pre>
     *
     * @param listLecture
     * @return
     * @throws Exception
     */
    ExcelInfoDTO lectInfoExcelList(List<LectureInfomationDTO> listLecture) throws Exception;


    /**
     * <pre>
     *     관리자 수업 클래스별 신청현황 엑셀 다운로드 리스트
     * </pre>
     *
     * @param listApplClas
     * @return
     * @throws Exception
     */
    ExcelInfoDTO lectApplClasExcelList(List<LectureInfomationDTO> listApplClas, String excelType) throws Exception;

    /**
     * <pre>
     *     관리자 수업 클래스별 신청 현황 엑셀 다운로드 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<LectureInfomationDTO> lectApplClasList(LectureSearch lectureSearch) throws Exception;


    /**
     * <pre>
     *  진행 배정사업그룹 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    List<BizGrpInfo> listBizGrpList(LectureSearch lectureSearch) throws Exception;
}
