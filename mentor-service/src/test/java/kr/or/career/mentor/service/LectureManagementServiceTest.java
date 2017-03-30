package kr.or.career.mentor.service;

import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.util.EgovProperties;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * Created by song on 2015-09-15.
 */
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class LectureManagementServiceTest {

    public static final Logger log = LoggerFactory.getLogger(LectureManagementServiceTest.class);

    @Autowired
    protected LectureManagementService lectureManagementService;

    /*
     * 수업목록리스트 조회
     */
    @Test
    public void listLect() throws Exception{
        LectureSearch param = new LectureSearch();

        param.setSearchStDate("2015.10.01"); //시작날짜
        param.setSearchEndDate("2015.10.30"); //종료날짜0.
        param.setSchoolGrd("101535"); //학교급
        param.setLectTime("0800");        //수업시각
        param.setLectType("101530");        //수업유형
        param.setLectrJob("1000000000");        //직업(추후변경될 예정 코드값)
        param.setCurrentPageNo(1);
        param.setRecordCountPerPage(9);

        List<LectSchdInfo> listLecture= lectureManagementService.listLect(param);
        Assert.assertEquals(1, listLecture.size());
    }

    /*
     * 수업목록리스트 갯수조회
     */
    @Test
    public void listLectCnt() {
        HashMap<String, String> SearchVO = new HashMap<>();
        SearchVO.put("job", "teacher");

    }

    /*
    * 수업상세 조회
    */
    @Test
    public void retireveLectSchdInfo() {
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(10000000);  //강의 일련번호
        lectSchdInfo.setLectTims(3);        //강의 차수

        Map retireveLectSchdInfo = lectureManagementService.retireveLectSchdInfo(lectSchdInfo);

        Assert.assertEquals(1, retireveLectSchdInfo.get("obsvCnt"));
    }

    /*
     * 수업 신규개설 및 수정
     */
    @Test
    @Transactional
    @Rollback
    public void saveOpenLect() throws Exception{

        LectInfo lectInfo = new LectInfo();
        lectInfo.setLectTitle("집밥백선생");
        lectInfo.setLectrNm("구몬");
        lectInfo.setLectrJobNo("1000000000");
        lectInfo.setLectPicPath("그림");
        lectInfo.setLectOutlnInfo("구몬개요");
        lectInfo.setLectIntdcInfo("구몬소개정보");
        lectInfo.setLectSustInfo("구몬내용정보");
        lectInfo.setLectTypeCd("101529");
        lectInfo.setLectTargtCd("101536");

//		lectInfo.setLectReqSer(10000006);//수업요청정보  테스트
//		lectInfo.setLectSer("10000001");  //수정 테스트
        //lectInfo.setLectSer("");   //신규개설 테스트

        int insetResult = lectureManagementService.saveOpenLect(lectInfo);

        log.info("return value = {}", insetResult);
    }

    /*
     * 수업수강인원 체크
     */
    @Test
    public void cntLectApplInfo() throws Exception{

        LectApplInfo lectApplInfo = new LectApplInfo();
        lectApplInfo.setLectSer(10000001);  //강의 일련번호
        lectApplInfo.setLectTims(1);        //강의 차수

        int insetResult = lectureManagementService.cntLectApplInfo(lectApplInfo);

        log.info("return value = {}", insetResult);
    }

    /*
     * 수업수강 신청
     */
    @Test
    @Transactional
    public void applLectApplInfo() throws Exception{
        LectApplInfo lectApplInfo = new LectApplInfo();

        lectApplInfo.setLectSer(10000000);  //강의 일련번호
        lectApplInfo.setSetSer(100011);     //수업설정 일련번호
        lectApplInfo.setLectTims(4);        //강의 차수
        lectApplInfo.setClasRoomSer(10000000); //교실정보
        lectApplInfo.setSchNo("SCH0000001");  //학교id
        lectApplInfo.setApplMbrNo("1020000002"); //신청자id(교사)
        lectApplInfo.setRegMbrNo("1020000002");  //입력자 id(교사, 관리자)

        int insetResult = lectureManagementService.applLectApplInfo(lectApplInfo);

        log.info("return value = {}", insetResult);
    }

    /*
     * 수업요청
     */
    @Test
    @Transactional
    @Rollback
    public void insertLectureRequest() throws Exception{
        LectReqInfo lectReqInfo = new LectReqInfo();
        lectReqInfo.setReqMbrNo("1020000002"); //요청_회원_번호 : 수업을 요청한 교사의 회원번호
        lectReqInfo.setTargtJobNo(""); //대상_직업_코드 : 팝업화면에서 직업을 지정
        lectReqInfo.setTargtMbrNo(""); //대상_회원_번호 : 팝업화면에서 멘토를 지정
        lectReqInfo.setClasRoomSer("10000000"); //교실_일련번호 : 팝업화면에서 학교와 교실을 선택
        lectReqInfo.setLectTitle("요리사가 되는 길3"); //강의_제목 : 팝업화면에서 주제 항목
        lectReqInfo.setLectSust("요리사가 되는 길3은.....어쩌구..... 저쩌구....."); //강의_내용 : 팝업화면에서 내용 항목
        lectReqInfo.setSchClassCd("100731"); //학교_구분_코드 : 팝업화면에서 학교급 selectbox : 공통코드 100730

        //수업요청시간정보
        List<LectReqTimeInfo> rectReqTimeInfo = new ArrayList<LectReqTimeInfo>();

        LectReqTimeInfo rectReqTimeInfo1 = new LectReqTimeInfo();
        rectReqTimeInfo1.setLectPrefDay("20151001"); //수업요청일자
        rectReqTimeInfo1.setLectPrefTime("0900"); //수업요청시간

        rectReqTimeInfo.add(rectReqTimeInfo1);

        LectReqTimeInfo rectReqTimeInfo2 = new LectReqTimeInfo();
        rectReqTimeInfo2.setLectPrefDay("20151002"); //수업요청일자
        rectReqTimeInfo2.setLectPrefTime("1000"); //수업요청시간

        rectReqTimeInfo.add(rectReqTimeInfo2);

        LectReqTimeInfo rectReqTimeInfo3 = new LectReqTimeInfo();
        rectReqTimeInfo3.setLectPrefDay("20151003"); //수업요청일자
        rectReqTimeInfo3.setLectPrefTime("1100"); //수업요청시간

        rectReqTimeInfo.add(rectReqTimeInfo3);

        LectReqTimeInfo rectReqTimeInfo4 = new LectReqTimeInfo();
        rectReqTimeInfo4.setLectPrefDay("20151004"); //수업요청일자
        rectReqTimeInfo4.setLectPrefTime("1200"); //수업요청시간

        rectReqTimeInfo.add(rectReqTimeInfo4);

        LectReqTimeInfo rectReqTimeInfo5 = new LectReqTimeInfo();
        rectReqTimeInfo5.setLectPrefDay("20151005"); //수업요청일자
        rectReqTimeInfo5.setLectPrefTime("1300"); //수업요청시간

        rectReqTimeInfo.add(rectReqTimeInfo5);

        lectReqInfo.setLectReqTimeInfoDomain(rectReqTimeInfo);

        boolean returnValue = lectureManagementService.insertLectureRequest(lectReqInfo);

        Assert.assertTrue(returnValue);
    }

    /*
     * (멘토)수업취소
     */
    @Test
    @Transactional
    public void cnclLectSchdInfo() throws Exception{
        //세션 추후사용
        //User user = (User) authentication.getPrincipal();
        //String regMbrNo = user.getId();

        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(10000000);  //강의 일련번호
        lectSchdInfo.setLectTims(2);  //강의차수
        lectSchdInfo.setSchdSeq(1);  //일정순서
        lectSchdInfo.setLectCnclRsnSust("시간촉박");  //강의취소 사유
        lectSchdInfo.setChgMbrNo("1020000004");
        lectSchdInfo.setLectDay("20151027");

        int cnclLectSchdInfo = lectureManagementService.cnclLectSchdInfo(lectSchdInfo);

        Assert.assertEquals(1, cnclLectSchdInfo);
    }

    /*
    * (학교)수업신청 취소
    */
    @Test
    @Transactional
    public void cancelLectAppl()throws Exception {
        //세션 추후사용
        //User user = (User) authentication.getPrincipal();
        //String regMbrNo = user.getId();

        LectApplInfo lectApplInfo = new LectApplInfo();
        lectApplInfo.setLectSer(10000000);  //강의 일련번호
        lectApplInfo.setLectTims(2);  //강의차수
        lectApplInfo.setClasRoomSer(10000000);
        lectApplInfo.setChgMbrNo("1020000004");
        lectApplInfo.setLectDay("20151027");

        int cnclLectSchdInfo = lectureManagementService.cnclLectApplInfo(lectApplInfo);

        Assert.assertEquals(1, cnclLectSchdInfo);
    }

    /*
     * MC찾기(MC목록조회)
     */
    @Test
    public void listMc() throws Exception{
        /*LectureSearch lectureSearch = new LectureSearch();

        *//*페이징 기능 불필요한 경우 : MC찾기 팝업화면*//*
        lectureSearch.setKeyword(""); //키워드 : MC명
        lectureSearch.setPageable(false);
        List<McInfo> mcInfoList = lectureManagementService.listMc(lectureSearch);
        *//*페이징 기능 불필요한 경우*//*

        Assert.assertEquals(1, mcInfoList.size());*/
    }

    /*
     * MC찾기(MC목록조회)
     */
    @Test
    public void listMcPaging() throws Exception{
        LectureSearch lectureSearch = new LectureSearch();

        /*페이징 기능이 필요한 경우 : MC관리 화면 */
        lectureSearch.setRecordCountPerPage(10); //화면에서 변경 가능한 값 selectbox
        lectureSearch.setCurrentPageNo(1);
        lectureSearch.setPageable(true);

        lectureSearch.setCategory(""); //카테고리 : 전체, 스튜디오, 기업멘토
        lectureSearch.setKeyword(""); //키워드
        lectureSearch.setPageable(true);
        List<McInfo> mcInfoList = lectureManagementService.listMcPaging(lectureSearch);
        /*페이징 기능이 필요한 경우*/

        Assert.assertEquals(10, mcInfoList.size());
    }

    /*
     * 수업신청디바이스조회
     */
    @Test
    public void listLectApplDvc() throws Exception{
        LectSchdInfo lectSchdInfo = new LectSchdInfo();

        lectSchdInfo.setLectSer(10000000);
        lectSchdInfo.setLectTims(3);
        lectSchdInfo.setSchdSeq(1);

        //수업정보 조회
        LectSchdInfo lectSchdInfoList = lectureManagementService.listLectApplDvc(lectSchdInfo);

        //해당수업 기기(교실정보)조회
        List<LectureInfomationDTO> lectApplInfoList = lectureManagementService.listLectApplClas(lectSchdInfo);
    }

    /*
     * 수업일시정보 목록조회
     */
    @Test
    public void listLectureScheduleInfomation() throws Exception{
        LectInfo lectInfo = new LectInfo();
        /*단강수업*/
        lectInfo.setLectSer(10000000);
        lectInfo.setRecordCountPerPage(10); //화면에서 변경 가능한 값 selectbox
        lectInfo.setCurrentPageNo(1);
        lectInfo.setPageable(true);

        /*연강수업*/
//		lectInfo.setLectSer("10000003");
//		lectInfo.setRecordCountPerPage(10);
//		lectInfo.setCurrentPageNo(1);
//		lectInfo.setPageable(true);

        List<LectSchdInfo> lectSchdInfoList = lectureManagementService.listLectureScheduleInfomation(lectInfo);

        log.info("수업일시정보 목록조회 lectSchdInfoList count : {}", lectSchdInfoList.size());

        Assert.assertEquals(10, lectSchdInfoList.size());
    }

    /*
     * 수업일시정보수정
     */
    @Test
    @Transactional
    @Rollback
    public void saveLectureScheduleInfomation() throws Exception{
        //User user = (User) authentication.getPrincipal();
        //String regMbrNo = user.getId();
        String chgMbrNo = "1020000004"; //수정자회원번호

        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(10000001); //수업일련번호
        lectSchdInfo.setLectTims(1); //수업차수
        lectSchdInfo.setSchdSeq(1); //일정순서
        lectSchdInfo.setLectDay("20150918"); //수업일자
        lectSchdInfo.setLectStartTime("0900"); //수업시작시간
        lectSchdInfo.setLectEndTime("1000"); //수업종료시간
        lectSchdInfo.setStdoNo("1000000001"); //스튜디오번호
        lectSchdInfo.setMcNo("1000000001"); //MC번호
        lectSchdInfo.setChgMbrNo(chgMbrNo); //수정자회원번호

        boolean returnValue = lectureManagementService.saveLectureScheduleInfomation(lectSchdInfo);

        Assert.assertTrue(returnValue);
    }

    /*
     * 수업일시추가
     */
    @Test
    @Transactional
    @Rollback
    public void insertLectureScheduleInfomation() throws Exception{
        //User user = (User) authentication.getPrincipal();
        //String regMbrNo = user.getId();
        String regMbrNo = "1020000004"; //등록자회원번호

        /*단강일 경우*/
        LectInfo lectInfo = new LectInfo();
        lectInfo.setLectSer(10000001); //수업일련번호
        lectInfo.setLectTitle("아나운서로가는길"); //수업명
        lectInfo.setLectrMbrNo("1020000007"); //멘토회원번호
        lectInfo.setRegMbrNo(regMbrNo); //등록자회원번호

        LectTimsInfo lectTimsInfo = new LectTimsInfo();
        lectTimsInfo.setLectSer(10000001); //수업일련번호
        lectTimsInfo.setRegMbrNo(regMbrNo); //등록자회원번호

        List<LectSchdInfo> lectSchdInfoList = new ArrayList<LectSchdInfo>();
        LectSchdInfo lectSchdInfo1 = new LectSchdInfo();
        lectSchdInfo1.setLectDay("20151001"); //수업일자
        lectSchdInfo1.setLectStartTime("0900"); //시작시간
        lectSchdInfo1.setLectEndTime("1000"); //종료시간
        lectSchdInfo1.setMcNo(""); //mc
        lectSchdInfo1.setStdoNo(""); //스튜디오

        lectSchdInfoList.add(lectSchdInfo1);

        lectTimsInfo.setLectSchdInfo(lectSchdInfoList);

        lectInfo.setLectTimsInfo(lectTimsInfo);

        /*연강일 경우*/
//		LectInfo lectInfo = new LectInfo();
//		lectInfo.setLectSer(10000003); //수업일련번호
//		lectInfo.setLectTitle("야구선수가되는길"); //수업명
//		lectInfo.setLectrMbrNo("1020000004"); //멘토회원번호
//		lectInfo.setRegMbrNo(regMbrNo); //등록자회원번호
//
//		LectTimsInfo lectTimsInfo = new LectTimsInfo();
//		lectTimsInfo.setLectSer(10000001); //수업일련번호
//		lectTimsInfo.setRegMbrNo(regMbrNo); //등록자회원번호
//
//		List<LectSchdInfo> lectSchdInfoList = new ArrayList<LectSchdInfo>();
//		LectSchdInfo lectSchdInfo1 = new LectSchdInfo();
//		lectSchdInfo1.setLectDay("20150923"); //수업일자
//		lectSchdInfo1.setLectStartTime("0900"); //시작시간
//		lectSchdInfo1.setLectEndTime("1000"); //종료시간
//		lectSchdInfo1.setMcNo(""); //mc
//		lectSchdInfo1.setStdoNo(""); //스튜디오
//
//		lectSchdInfoList.add(lectSchdInfo1);
//
//		LectSchdInfo lectSchdInfo2 = new LectSchdInfo();
//		lectSchdInfo2.setLectDay("20150923"); //수업일자
//		lectSchdInfo2.setLectStartTime("1000"); //시작시간
//		lectSchdInfo2.setLectEndTime("1100"); //종료시간
//		lectSchdInfo2.setMcNo(""); //mc
//		lectSchdInfo2.setStdoNo(""); //스튜디오
//
//		lectSchdInfoList.add(lectSchdInfo1);
//
//		LectSchdInfo lectSchdInfo3 = new LectSchdInfo();
//		lectSchdInfo3.setLectDay("20150923"); //수업일자
//		lectSchdInfo3.setLectStartTime("1100"); //시작시간
//		lectSchdInfo3.setLectEndTime("1200"); //종료시간
//		lectSchdInfo3.setMcNo(""); //mc
//		lectSchdInfo3.setStdoNo(""); //스튜디오
//
//		lectSchdInfoList.add(lectSchdInfo3);
//
//		lectTimsInfo.setLectSchdInfo(lectSchdInfoList);
//
//		lectInfo.setLectTimsInfo(lectTimsInfo);

        int returnValue = lectureManagementService.insertLectureScheduleInfomation(lectInfo);

        Assert.assertTrue(returnValue == (Constants.LECTURE_CREATE_SUCCESS|Constants.TOMMS_CREATE_SUCCESS));
    }

    /*
     * 수업입장(수업입장가능여부조회)
     */
    @Test
    public void retrieveLectEntncYn() {

    }

    /*
     * 스튜디오찾기(스튜디오목록조회)
     */
    @Test
    public void listStdo() throws Exception{
        StdoInfo stdoInfo = new StdoInfo();

        /*페이징 기능 불필요한 경우 : 스튜디오찾기 팝업화면*/
        stdoInfo.setSidoCd(""); //시도코드
        stdoInfo.setStdoNm(""); //스튜디오명
        stdoInfo.setPageable(false);

        List<StdoInfo> stdoInfoList = lectureManagementService.listStudio(stdoInfo);
        /*페이징 기능 불필요한 경우*/

        Assert.assertEquals(10, stdoInfoList.size());
    }

    /*
     * 스튜디오찾기(스튜디오목록조회)
     */
    @Test
    public void listStdoPaging() throws Exception{
        StdoInfo stdoInfo = new StdoInfo();

        /*페이징 기능이 필요한 경우 : 스튜디오관리 화면 */
        stdoInfo.setRecordCountPerPage(10); //화면에서 변경 가능한 값 selectbox
        stdoInfo.setCurrentPageNo(1);

        stdoInfo.setSidoCd(""); //시도코드
        stdoInfo.setSgguCd(""); //시군구코드
        stdoInfo.setIndrYn("Y"); //실내_여부 Y : 실내 , N : 실외
        stdoInfo.setStdoNm(""); //스튜디오명
        stdoInfo.setPageable(true);
        List<StdoInfo> stdoInfoList = lectureManagementService.listStudioPaging(stdoInfo);
        /*페이징 기능이 필요한 경우*/

        Assert.assertEquals(10, stdoInfoList.size());
    }

    /*
     * 요청수업목록조회
     */
    @Test
    public void listReqLect() throws Exception{
        LectureSearch lectureSearch = new LectureSearch();

        lectureSearch.setCategory1("101646"); //검색조건 selectbox  : 전체, 오픈, 멘토지정, 직업지정
        lectureSearch.setCategory2("101650"); //검색조건 selectbox  : 전체, 수업, 직업, 멘토
        lectureSearch.setKeyword("요리사"); //검색조건 키워드
        lectureSearch.setPageable(false);

        List<LectReqInfo> lectReqInfoList = lectureManagementService.listLectureRequest(lectureSearch);

        Assert.assertEquals(4, lectReqInfoList.size());
    }

    /*
     * 수업상태변경 모집중 => 수업예정(배치?)
     * 수업일 D-7일 자동모집마감으로 인한 수업상태를 모집중에서 수업예정으로 변경한다.
     */
    @Test
    @Transactional
    @Rollback
    public void lectureStatusChangeRecruitmentClose() throws Exception{

        HashMap<String,Integer> param = new HashMap<>();
        param.put("assign", Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY")));	//수업예정 상태로 바뀌는 기준 '일'
        param.put("ready", Integer.parseInt(EgovProperties.getProperty("READY_MINUTE")));	//수업대기 상태로 바뀌는 기준 '분'
        param.put("cutLine", Integer.parseInt(EgovProperties.getProperty("READY_APPLY_CNT"))); // 수업이 모집실패되는 기준 '신청수'

        int cnt = lectureManagementService.lectureStatusChangeRecruitmentClose(param);

        Assert.assertEquals(1, cnt);
    }

    /*
     * 수업일 기준 D-2, D-1일 교사에게 수업예정 안내메일 발송(배치?)
     */
    @Test
    public void sendPrearrangedLectureInfomationMail() throws Exception{
        int cnt = lectureManagementService.sendPrearrangedLectureInfomationMail();

        Assert.assertEquals(1, cnt);
    }

    /**
     * MC정보 저장(등록,수정)
     * @throws Exception
     */
    @Test
    @Transactional
    @Rollback
    public void saveMcInfo() throws Exception{
        McInfo mcInfo = new McInfo();
//		mcInfo.setMcNo("1000000017");
        mcInfo.setMcNm("구라엠씨"); //MC명
        mcInfo.setContTel("01011112222"); //휴대전화 번호
        mcInfo.setPosCoNo("1020000008"); //기업멘토 회원번호
        mcInfo.setStdoNo(""); //스튜디오번호
        mcInfo.setUseYn("Y"); //사용유무
        mcInfo.setRegMbrNo("1020000001"); //등록자회원번호

        boolean returnValue = lectureManagementService.saveMcInfo(mcInfo);

        Assert.assertTrue(returnValue);
    }

    /**
     * MC정보 상세조회
     * @throws Exception
     */
    @Test
    public void retrieveMcInfo() throws Exception{
        McInfo searchMcInfo = new McInfo();
        searchMcInfo.setMcNo("1000000015");
        searchMcInfo.setPageable(false);

        McInfo resultMcInfo = lectureManagementService.retrieveMcInfo(searchMcInfo);

        Assert.assertEquals("1000000015", resultMcInfo.getMcNo());
    }

    /**
     * 스튜디오정보 저장(등록,수정)
     * @throws Exception
     */
    @Test
//	@Transactional
//	@Rollback
    public void saveStudioInfo() throws Exception{
        StdoInfo stdoInfo = new StdoInfo();
//		stdoInfo.setStdoNo("0000000007"); //스튜디오_번호
        stdoInfo.setStdoNm("아몰랑스튜디오"); //스튜디오명 필수
        stdoInfo.setFlorNm(""); //층_이름 ?
        stdoInfo.setPlcNm("부가정보"); //장소_이름 => 화면에서는 부가정보 항목
        stdoInfo.setSidoCd(""); //시도_코드 필수
        stdoInfo.setSgguCd(""); //시군구_코드 필수
        stdoInfo.setUmdngCd(""); //읍면동_코드 필수
        stdoInfo.setPostCd(""); //우편번호 필수
        stdoInfo.setLocaAddr("강남빌딩 703호"); //소재지_주소 필수
        stdoInfo.setIndrYn("Y"); //실내_여부 필수
        stdoInfo.setPosCoNo("1020000008"); //기업멘토회원번호
        stdoInfo.setRepTel("0212345678"); //대표_전화번호
        stdoInfo.setChrgrNm("강남"); //담당자_이름
        stdoInfo.setUseYn("Y"); //사용_여부 필수
        stdoInfo.setRegMbrNo("1020000001"); //등록자회원번호
//		부가정보 항목 필요

        boolean returnValue = lectureManagementService.saveStudioInfo(stdoInfo);

        Assert.assertTrue(returnValue);
    }

    /**
     * 스튜디오정보 상세조회
     * @throws Exception
     */
    @Test
    public void retrieveStdoInfo() throws Exception{
        StdoInfo searchStdoInfo = new StdoInfo();
        searchStdoInfo.setStdoNo("1000000000");
        searchStdoInfo.setPageable(false);

        StdoInfo resultStdoInfo = lectureManagementService.retrieveStudioInfo(searchStdoInfo);

        Assert.assertEquals("1000000000", resultStdoInfo.getStdoNo());
    }


    /**
     * 기기제한 설정 조회
     * @throws Exception
     */
    @Test
    public void retrieveClasSetHist() throws Exception{
        ClasSetHist clasSetHist = lectureManagementService.retrieveClasSetHist();

        int cntClasSetHist = clasSetHist.getMaxApplCnt();

        Assert.assertEquals(22, cntClasSetHist);
    }

    /**
     * 기기제한 설정 수정
     * @throws Exception
     */
    @Test
    public void insertClasSetHist() throws Exception{
        ClasSetHist clasSetHist = new ClasSetHist();
        clasSetHist.setMaxApplCnt(25);
        clasSetHist.setMaxObsvCnt(25);
        clasSetHist.setSetDescSust("테스트기기변경");
        clasSetHist.setRegMbrNo("1020000004");

        int insertClasSetHist = lectureManagementService.insertClasSetHist(clasSetHist);

        Assert.assertEquals(1, insertClasSetHist);
    }

    /**
     * 나의수업 목록조회
     * @throws Exception
     */
    @Test
    public void myLectureList() throws Exception{

        LectApplInfo lectApplInfo = new LectApplInfo();
        lectApplInfo.setApplMbrNo("1020000002");
        lectApplInfo.setMbrClassCd("100859");

        Map insetResult = lectureManagementService.myLectureList(lectApplInfo);

        log.info("return value = {}", insetResult);
    }

    @Test
    public void rating() throws Exception{
        ArclInfo arclInfo = new ArclInfo();
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_APPR);
        arclInfo.setCntntsTargtCd("101511");
        arclInfo.setCntntsTargtNo(10000003);

        lectureManagementService.retireveLectureRating(arclInfo);
    }

    /**
     * <pre>
     *     관련수업 목록조회
     * </pre>
     * @throws Exception
     */
    @Test
    public void listRelationLecture() throws Exception{
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(10000003);
        lectSchdInfo.setLectTims(2);
        lectSchdInfo.setSchdSeq(1);
        lectSchdInfo.setPageable(true);
        lectSchdInfo.setRecordCountPerPage(5); //5건씩 보여주기

        List<LectureInfomationDTO> lectSchdInfoList = lectureManagementService.listRelationLecture(lectSchdInfo);

    }

    /**
     * <pre>
     *     멘토포탈 정산관리(개인멘토 대상) 목록 조회
     * </pre>
     * @throws Exception
     */
    @Test
    public void listCalculateLectureByMentor() throws Exception{
        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setSearchStDate("");  //검색조건 시작일
        lectureSearch.setSearchEndDate(""); //검색조건 종료일
        lectureSearch.setLectType("");      //수업유형
        lectureSearch.setKeyword("");       //수업명
        lectureSearch.setMbrNo("1020000004");         //로그인한 회원의 회원번호

        LectureInfomationDTO lectureInfomationDTO = lectureManagementService.listCalculateLectureByMentor(lectureSearch);
    }

    /**
     *
     * <pre>
     * 수업상태 변경
     * </pre>
     *
     * @throws Exception
     */
    @Test
    public void updateLectureStatus() throws Exception{
        Date d = lectureManagementService.updateLectureStatus();
        log.info("NEXT STATUS CHANGE TIME {}",d.toString());
    }
}
