package kr.or.career.mentor.service.impl;

import com.google.common.collect.Lists;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.dao.*;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.FileManagementService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.MentorManagementService;
import kr.or.career.mentor.tomms.TommsMapper;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.view.MultiSheetExcelView;
import kr.or.career.mentor.view.GenericExcelView;
import kr.or.career.mentor.util.*;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.lang.reflect.Field;
import org.springframework.beans.BeanUtils;
import java.util.*;

/**
 * Created by chaos on 15. 8. 31..
 */
@Service
@Slf4j
public class LectureManagementServiceImpl implements LectureManagementService {

    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;

    @Autowired
    private McMapper mcMapper;

    @Autowired
    private StudioMapper studioMapper;

    @Autowired
    private MentorMapper mentorMapper;

    @Autowired
    private MbrProfPicInfoMapper mbrProfPicInfoMapper;

    @Autowired
    private BannerMapper bannerMapper;

    @Autowired
    private ComunityService comunityService;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private FileMapper fileMapper;

    @Autowired
    private MentorManagementService mentorManagementService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private TommsMapper tommsMapper;

    /**
     * <pre>
     *     monthlyLectureInfo
     * </pre>
     *
     * @param params
     * @return
     */
    @Override
    public List<Map<String, Object>> monthlyLectureInfo(Map<String, Object> params) {
        User user = SessionUtils.getUser();
        params.put("mbrCualfCd", user.getMbrCualfCd());
        params.put("mbrNo", user.getMbrNo());
        params.put("posCoNo", user.getPosCoNo());
        return lectureInfomationMapper.monthlyLectureInfo(params);
    }

    /**
     * <pre>
     *     dailyLectureInfo
     * </pre>
     *
     * @param params
     * @return
     */
    @Override
    public List<LectSchdInfo> dailyLectureInfo(Map<String, Object> params) {
        User user = SessionUtils.getUser();
        params.put("mbrCualfCd", user.getMbrCualfCd());
        params.put("mbrNo", user.getMbrNo());
        params.put("posCoNo", user.getPosCoNo());
        List<LectSchdInfo> dailyLectures = lectureInfomationMapper.dailyLectureInfo(params);

        for (LectSchdInfo lectInfo : dailyLectures) {

            String sessionId = lectInfo.getLectSessId();
            if (StringUtils.isNotEmpty(sessionId)) {

                lectInfo.setObsvCnt(getObserverCnt(lectInfo));

            }

        }

        return dailyLectures;
    }

    private Integer getObserverCnt(LectSchdInfo lectSchdInfo) {
        Integer observeCnt = 0;

        try {
            observeCnt = HttpRequestUtils.getParticipantCnt(lectSchdInfo.getLectSessId());
        } catch (Exception e) {

        }

        return observeCnt;
    }

    /**
     * <pre>
     *  수업목록 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectSchdInfo> listLect(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.listLect(lectureSearch);
    }

    /**
     * <pre>
     *  수업목록 총갯수
     * </pre>
     *
     * @param params
     * @return
     * @throws Exception
     */
    @Override
    public int listLectCnt(LectureSearch params) throws Exception {
        return lectureInfomationMapper.listLectCnt(params);
    }

    /**
     * <pre>
     *  수업개설 및 수정
     * </pre>
     *
     * @param lectInfo
     * @return
     * @throws Exception
     */
    @Override
    public int saveOpenLect(LectInfo lectInfo) throws Exception {
        int saveCnt = 0;
        //saveCnt = lectureInfomationMapper.saveOpenLect(lectInfo);
        lectInfo.setChgMbrNo(lectInfo.getLectrMbrNo());

        if (lectInfo.getLectSer() != null) {
            //수업수정
            //saveCnt = lectureInfomationMapper.updateLectInfo(lectInfo);

            //삭제이미지 있을경우
            if (lectInfo.getDelFileSer() != null) {
                String[] delFileSer = lectInfo.getDelFileSer().split(",");

                for (int i = 0; i < delFileSer.length; i++) {
                    LectInfo delLectInfo = new LectInfo();
                    delLectInfo.setLectSer(lectInfo.getLectSer());
                    delLectInfo.setDelFileSer(delFileSer[i]);
                    //강의사진정보 삭제
                    fileMapper.deleteLectPicInfoFile(delLectInfo);
                    //공통파일정보 삭제
                    fileMapper.deleteLectComFileInfo(delLectInfo);
                }
            }

            //수업이미지 등록
            for (int i = 0; i < lectInfo.getListLectPicInfo().size(); i++) {
                //파일일련번호가 없을경우 신규 이미지입력

                if (lectInfo.getListLectPicInfo().get(i).getComFileInfo().getFileSer() == null) {

                    LectPicInfo lectPicInfo = new LectPicInfo();
                    FileInfo fileInfo = fileManagementService.fileProcess(lectInfo.getListLectPicInfo().get(i).getComFileInfo().getFile(), "TEST");
                    lectPicInfo.setFileSer(fileInfo.getFileSer());
                    lectPicInfo.setLectSer(lectInfo.getLectSer());
                    fileMapper.insertLectPicInfo(lectPicInfo);
                    if (i == 0) {
                        //수업정보 사진경로 업데이트
                        lectInfo.setLectPicPath(Integer.toString(fileInfo.getFileSer()));
                        //lectureInfomationMapper.updateLectInfo(lectInfo);
                    }
                } else {
                    if (i == 0) {
                        //수업정보 사진경로 업데이트
                        lectInfo.setLectPicPath(Integer.toString(lectInfo.getListLectPicInfo().get(i).getComFileInfo().getFileSer()));
                        //lectureInfomationMapper.updateLectInfo(lectInfo);
                    }
                }

            }
            saveCnt = lectureInfomationMapper.updateLectInfo(lectInfo);
        } else {
            //수업등록
            saveCnt = lectureInfomationMapper.insertLectInfo(lectInfo);

            //수업이미지 등록
            for (int i = 0; i < lectInfo.getListLectPicInfo().size(); i++) {
                LectPicInfo lectPicInfo = new LectPicInfo();
                FileInfo fileInfo = fileManagementService.fileProcess(lectInfo.getListLectPicInfo().get(i).getComFileInfo().getFile(), "TEST");
                lectPicInfo.setFileSer(fileInfo.getFileSer());
                lectPicInfo.setLectSer(lectInfo.getLectSer());
                fileMapper.insertLectPicInfo(lectPicInfo);
                if (i == 0) {
                    //수업정보 사진경로 업데이트
                    lectInfo.setLectPicPath(Integer.toString(fileInfo.getFileSer()));
                    lectureInfomationMapper.updateLectInfo(lectInfo);
                }
            }

            if (saveCnt > 0) {
                //게시판 테이블에 수업평점 및 후기에 대한 더미글 등록
                int lectSer = lectInfo.getLectSer(); //수업일련번호

                ArclInfo arclInfo = new ArclInfo();
                arclInfo.setBoardId(Constants.BOARD_ID_LEC_APPR); //수업평가에 대한 게시판ID
                arclInfo.setCntntsTargtCd(CodeConstants.CD100979_101511_강의후기); //컨텐츠 대상 코드 : 수업평가
                arclInfo.setCntntsTargtNo(lectSer); //수업일련번호
                arclInfo.setSust("");
                arclInfo.setTitle("");
                arclInfo.setRegMbrNo(lectInfo.getRegMbrNo());

                //게시판 테이블 등록
                comunityService.registArcl(arclInfo, null);
            }
        }

        return saveCnt;
    }

    /**
     * <pre>
     *     수업일시정보 목록조회
     * </pre>
     *
     * @param lectInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<LectSchdInfo> listLectureScheduleInfomation(LectInfo lectInfo) throws Exception {
        return lectureInfomationMapper.listLectureScheduleInfomation(lectInfo);
    }

    /**
     * <pre>
     *     수업일시정보 추가
     *     개인멘토일 경우에는 관리자의 승인과정이 필요하기 때문에 등록할때 수업상태코드를 승인대기로 입력하고 기업멘토, 소속멘토일 경우에는 모집중 상태로 입력한다.
     * </pre>
     *
     * @param lectInfo
     * @return
     * @throws Exception
     */
    @Override
    public int insertLectureScheduleInfomation(LectInfo lectInfo) throws NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException {
        int returnValue = 0;
        int isCreateTomms = 0;

        if (lectInfo != null) {
            LectTimsInfo lectTimsInfo = lectInfo.getLectTimsInfo();

            LectureSearch lectureSearch = new LectureSearch();
            lectureSearch.setLectSer(lectTimsInfo.getLectSer());
            LectInfo orgLectInfo = lectureInfomationMapper.retrieveLectInfo(lectureSearch);

            /*멘토정보 조회*/
            String lectrMbrNo = lectTimsInfo.getRegMbrNo(); //멘토회원번호

            MentorDTO mentorInfo = mentorMapper.getMentorInfoBy(lectrMbrNo);

            String mbrCualfCd = mentorInfo.getMbrCualfCd(); //회원자격코드(개인멘토 구분하기 위함)

//            if(CodeConstants.CD100204_101503_개인멘토.equals(mbrCualfCd)){
//                //개인멘토일 경우 승인과정이 필요하기 때문에 수업상태코드를 "승인대기"로 등록한다. : 101542
//                lectTimsInfo.setLectStatCd(CodeConstants.CD101541_101542_수업요청);
//            } else {
            //개인멘토가 아닐 경우 수업상태코드는 "모집중"으로 등록 : 101543
            lectTimsInfo.setLectStatCd(CodeConstants.CD101541_101543_수강모집);
//            }

            int insertCnt = lectureInfomationMapper.insertLectTimsInfo(lectTimsInfo);

            int i = 0;

            while (insertCnt > 0 && lectTimsInfo.getLectSchdInfo().size() > i) {
                LectSchdInfo lectSchdInfo = lectTimsInfo.getLectSchdInfo().get(i);
                lectSchdInfo.setLectSer(lectTimsInfo.getLectSer());
                lectSchdInfo.setLectTims(lectTimsInfo.getLectTims());
                lectSchdInfo.setLectTitle(orgLectInfo.getLectTitle());
                lectSchdInfo.setLectStatCd(lectTimsInfo.getLectStatCd());
                lectSchdInfo.setRegMbrNo(lectTimsInfo.getRegMbrNo());

                //이미 등록된 수업중에 수업시간이 겹치는 수업이 존재하는지 체크
                LectureInfomationDTO overlapLecture = lectureInfomationMapper.retrieveLectureTimeOverlap(lectSchdInfo);
                if (overlapLecture != null) {
                    throw CodeMessage.MSG_800013_수업일시가_겹치는_수업이_이미_등록되어_있기_때문에_수업을_추가_할_수_없습니다_.toException();
                }

                //스케줄 등록은 승인된 수업에만 가능하므로 권한체크는 하지 않음.
                //if(CodeConstants.CD100204_101502_소속멘토.equals(mbrCualfCd) || CodeConstants.CD100204_101501_업체담당자.equals(mbrCualfCd))
                {
                    //TOMMS에 수업정보 개설
                    JSONObject json = HttpRequestUtils.createSession(mentorInfo.getMbrNo(), lectSchdInfo.getLectTitle(), lectSchdInfo.getLectDay(), lectSchdInfo.getLectStartTime(), lectSchdInfo.getLectEndTime());
                    if (!json.get("status").toString().equals("I")) {
                        //log.error("TOMMS setSessionCreate ERROR : {}",json.toString());
                        //lectSchdInfo.setLectSessId("-1");
                        //isCreateTomms = 0;
                        throw CodeMessage.MSG_900006_화상회의_개설에_실패_하였습니다_.toException();
                    } else {
                        String sessionId = json.get("sessionID").toString();
                        lectSchdInfo.setLectSessId(sessionId);
                        isCreateTomms = Constants.TOMMS_CREATE_SUCCESS;

                        json = HttpRequestUtils.addAttendance(sessionId, lectrMbrNo, "M", "I", "1");
                        log.info("addAttendance json :: > " + json);
                        if (StringUtils.isNotEmpty(lectSchdInfo.getMcNo())) {
                            HttpRequestUtils.addAttendance(sessionId, "MC:" + lectSchdInfo.getMcNo(), "M", "I", "1");
                        }
                    }
                }
                insertCnt = lectureInfomationMapper.insertLectSchdInfo(lectSchdInfo);
                i++;
            }
            if (i > 0)
                returnValue = 1;
        }


        return returnValue | isCreateTomms;
    }

    /**
     * <pre>
     *     수업일시정보 수정
     *     수업일시정보에서 스튜디오와 MC만 수정한다.
     *     변경하려는 스튜디오와 MC의 스케줄이 다른 수업일시정보와 겹치지 않는지 확인한다.
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     * @throws Exception
     */
    @Override
    public boolean saveLectureScheduleInfomation(LectSchdInfo lectSchdInfo) throws Exception {
        boolean returnValue = false;
        int duplicationCnt = 0;

        if (StringUtils.isNotEmpty(lectSchdInfo.getStdoNo())) {
            //변경하려는 수업일시정보의 수업시작시간 종료시간에 겹치는 스튜디오 스케줄 다른 수업일시정보에 존재하는지 확인한다.
            duplicationCnt = studioMapper.retrieveStudioScheduleDuplicationCnt(lectSchdInfo);
        }

        if (duplicationCnt == 0) {
            if (StringUtils.isNotEmpty(lectSchdInfo.getMcNo())) {
                //변경하려는 수업일시정보의 수업시작시간 종료시간에 겹치는 MC 스케줄 다른 수업일시정보에 존재하는지 확인한다.
                duplicationCnt = mcMapper.retrieveMcScheduleDuplicationCnt(lectSchdInfo);
            }

            if (duplicationCnt == 0) {
                int updateCnt = lectureInfomationMapper.updateLectureScheduleInfomation(lectSchdInfo);

                if (updateCnt > 0) {
                    returnValue = true;
                }
            }
        }

        return returnValue;
    }

    /**
     * <pre>
     *   수업신청 전에 현 신청인원 숫자확인
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    public int cntLectApplInfo(LectApplInfo lectApplInfo) throws Exception {
        return lectureInfomationMapper.cntLectApplInfo(lectApplInfo);
    }

    /**
     * <pre>
     *   강의 수업신청 수강신청인원 체크후 입력
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    @Override
    @Transactional
    public int applLectApplInfo(LectApplInfo lectApplInfo) {
        int resultCnt = 0;

        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        LectApplCnt lectApplCnt = new LectApplCnt();
        LectTimsInfo lectTimsInfo = new LectTimsInfo();

        lectSchdInfo.setLectSer(lectApplInfo.getLectSer());
        lectSchdInfo.setLectTims(lectApplInfo.getLectTims());

        List<LectSchdInfo> lectSchdInfoResult = lectureInfomationMapper.listLectSchdInfo(lectSchdInfo);

        //수강신청시 중복 체크
        for (int i = 0; i < lectSchdInfoResult.size(); i++) {
            LectSchdInfo dupLectSchdInfo = lectSchdInfoResult.get(i);
            dupLectSchdInfo.setClasRoomSer(lectApplInfo.getClasRoomSer());

            int dupLectSchdInfoCnt = lectureInfomationMapper.dupLectSchdInfo(dupLectSchdInfo);

            if (dupLectSchdInfoCnt > 0) {
                throw CodeMessage.MSG_100012_중복된_수업시간이_존재합니다_.toException();
            }
        }

        lectTimsInfo.setLectSer(lectApplInfo.getLectSer());
        lectTimsInfo.setLectTims(lectApplInfo.getLectTims());


        int applInfoCnt = lectureInfomationMapper.cntLectApplInfo(lectApplInfo);
        //int maxApplCnt  = lectureInfomationMapper.retrieveClasSetHist().getMaxApplCnt();

        LectInfo lectInfo = lectureInfomationMapper.retireveLectSchdInfo(lectSchdInfo);

        int maxApplCnt = lectInfo.getMaxApplCnt();
        char lectTestYn = lectInfo.getLectTestYn();
        String lectTargtCd = lectInfo.getLectTargtCd();

        int incLectVar = 0;
        if (lectTestYn == 'N')
            //차감할 횟수 조회
            incLectVar = retireveLectureCnt(lectTimsInfo, lectTargtCd);


        /**
         * 메일 발송을 위한 정보 세팅 (수업신청 or 수업신청대기)
         */
        MessageReciever reciever = MessageReciever.of(lectApplInfo.getApplMbrNo(), true);
        reciever.setMailAddress(SessionUtils.getUser().getEmailAddr());

        Message message = new Message();
        message.setSendType(MessageSendType.EMS.getValue());
        message.addReciever(reciever);

        LecturePayLoad payLoad = LecturePayLoad.of(message, lectApplInfo.getLectSer(), lectApplInfo.getLectTims(), false);
        message.setPayload(payLoad);


        if (applInfoCnt < maxApplCnt) { //최대수강인원보다 현재신청인원이 적을경우 정상신청(승인)
            lectApplInfo.setApplStatCd(CodeConstants.CD101574_101576_신청);  //승인

            LectApplInfo existLectApplInfo = lectureInfomationMapper.retrieveLectApplInfo(lectApplInfo);
            if (existLectApplInfo == null) {
                lectureInfomationMapper.insertLectApplInfo(lectApplInfo);
            } else {
                lectureInfomationMapper.updateLectApplInfo(lectApplInfo);
            }

            message.setContentType(MessageType.LECTURE_APPLY);
        } else {
            throw CodeMessage.MSG_100014_수강정원_초과입니다_.toException();
            /*
            if(applInfoCnt < (maxApplCnt+5)){ //TODO 확인필요,최대수강인원이 다찼을경우 5명까진 대기상태로 신청, 추후 승인안될경우 횟수 환급(신청)
                LectSchdInfo dupLectSchdInfo = new LectSchdInfo();
                dupLectSchdInfo.setClasRoomSer(lectApplInfo.getClasRoomSer());
                int dupLectApplInfoCnt = lectureInfomationMapper.dupLectApplInfo(dupLectSchdInfo);  //신청대기 중인 다른 수업이 있다면 또 신청대기 신청불가

                if(dupLectApplInfoCnt > 0){
                    throw CodeMessage.MSG_100013_대기상태의_다른수업이_존재합니다_.toException();
                }

                lectApplInfo.setApplStatCd(CodeConstants.CD101574_101575_대기); //대기

                LectApplInfo existLectApplInfo = lectureInfomationMapper.retrieveLectApplInfo(lectApplInfo);
                if(existLectApplInfo == null){
                    resultCnt += lectureInfomationMapper.insertLectApplInfo(lectApplInfo);
                }else{
                    resultCnt += lectureInfomationMapper.updateLectApplInfo(lectApplInfo);
                }

                message.setContentType(MessageType.LECTURE_STANDBY);
            }else{
                //대기인원도 꽉찬 경우 여기서 처리
                throw CodeMessage.MSG_100014_수강정원_초과입니다_.toException();
            }
            */
        }

        //수업신청이력 등록
        lectureInfomationMapper.insertLectApplHist(lectApplInfo);

        lectApplCnt.setSchNo(lectApplInfo.getSchNo());
        lectApplCnt.setSetSer(lectApplInfo.getSetSer());
        //수업신청횟수 업데이트
        resultCnt += updateLectApplCnt(lectApplCnt, incLectVar);

        /**
         * 메일발송 요청
         */
        //try {
        messageTransferManager.invokeTransfer(message);
        //}catch (Exception e){
        //    log.error("message sending error :: {}", e.getMessage());
        //}

        return resultCnt;
    }

    /**
     * <pre>
     *   수업신청횟수 업데이트
     * </pre>
     *
     * @param lectApplCnt
     * @param incLectVar
     * @return
     * @throws Exception
     */
    public int updateLectApplCnt(LectApplCnt lectApplCnt, int incLectVar) {
        int resultCnt = 0;

        //강의신청횟수 정보조회
        LectApplCnt lectApplCntReuslt = lectureInfomationMapper.retireveLectApplCntReuslt(lectApplCnt);

        if (lectApplCntReuslt != null) {
            lectApplCnt.setClasPermCnt(lectApplCntReuslt.getClasPermCnt() - incLectVar);  //수업신청할수있는횟수(차감)
            lectApplCnt.setClasApplCnt(lectApplCntReuslt.getClasApplCnt() + incLectVar);  //수업신청한 총횟수(증가)

            resultCnt += lectureInfomationMapper.updateLectApplCnt(lectApplCnt);  //수업신청에따른 횟수차감
        } else {
            BizSetInfo bizSetInfo = new BizSetInfo();
            bizSetInfo.setSetSer(lectApplCnt.getSetSer() + "");
            int clasCnt = lectureInfomationMapper.retrieveClasCnt(bizSetInfo);

            lectApplCntReuslt = new LectApplCnt();
            lectApplCntReuslt.setSchNo(lectApplCnt.getSchNo());
            lectApplCntReuslt.setSetSer(lectApplCnt.getSetSer());
            lectApplCntReuslt.setClasPermCnt(clasCnt - incLectVar);
            lectApplCntReuslt.setClasApplCnt(incLectVar);

            resultCnt += lectureInfomationMapper.insertLectApplCnt(lectApplCntReuslt);
        }

        return resultCnt;
    }

    /**
     * <pre>
     *     나의수업 정보조회
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    @Override
    public Map myLectureList(LectApplInfo lectApplInfo) throws Exception {
        Map resultMap = new HashMap();
        List<LectureApplInfoDTO> myLecutureList = null;
        List<LectureApplInfoDTO> myLecutureReqTimeList = null;
        LectureApplInfoDTO myLecutureCnt = null;
        lectApplInfo.setPageable(false);

        //나의수업정보 갯수
        myLecutureCnt = lectureInfomationMapper.myLectureTotalStatCnt(lectApplInfo);

        //나의 요청수업정보 갯수
        int myLectReqCnt = lectureInfomationMapper.myLectureReqCnt(lectApplInfo);
        myLecutureCnt.setLectCnt(String.valueOf(myLectReqCnt));

        resultMap.put("myLectCnt", myLecutureCnt);  //수업 현황 카운트

        lectApplInfo.setPageable(true);
        if (lectApplInfo.getLectTypeCd().equals("0")) {     //전체
            myLecutureList = lectureInfomationMapper.myLectureInfoAllList(lectApplInfo);

        } else if (lectApplInfo.getLectTypeCd().equals("5")) {  //수업요청일 경우
            //나의요청수업 리스트
            myLecutureList = lectureInfomationMapper.myLectureReqInfoList(lectApplInfo);
        } else {
            //나의수업정보 리스트
            myLecutureList = lectureInfomationMapper.myLectureInfoList(lectApplInfo);
        }

        if (lectApplInfo.getLectTypeCd().equals("0") || lectApplInfo.getLectTypeCd().equals("5")) {
            lectApplInfo.setPageable(false);

            //요청수업중 수업별로 시간따로 조회
            for (int i = 0; i < myLecutureList.size(); i++) {
                if (myLecutureList.get(i).getApplMbrNo() == null || myLecutureList.get(i).getApplMbrNo().equals("")) {
                    lectApplInfo.setReqSer(myLecutureList.get(i).getReqSer());
                    myLecutureReqTimeList = lectureInfomationMapper.myLectureReqTimeList(lectApplInfo);
                    myLecutureList.get(i).setMyLecutureReqTimeList(myLecutureReqTimeList);
                }
            }
        }

        resultMap.put("myLectList", myLecutureList);

        return resultMap;
    }

    /**
     * <pre>
     *     MC정보 목록조회
     * </pre>
     *
     * @param mcInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<McInfo> listMc(McInfo mcInfo) throws Exception {
        List<McInfo> mcInfoList = null;

        mcInfoList = mcMapper.listMc(mcInfo);

        return mcInfoList;
    }

    /**
     * <pre>
     *     MC정보 목록조회(페이징)
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<McInfo> listMcPaging(LectureSearch lectureSearch) throws Exception {
        List<McInfo> mcInfoList = null;

        mcInfoList = mcMapper.listMcPaging(lectureSearch);

        return mcInfoList;
    }

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
    @Override
    public List<StdoInfo> listStudio(StdoInfo stdoInfo) throws Exception {
        List<StdoInfo> stdoInfoList = null;

        stdoInfoList = studioMapper.listStudio(stdoInfo);

        return stdoInfoList;
    }

    /**
     * <pre>
     *     스튜디오정보 목록조회(페이징)
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<StdoInfo> listStudioPaging(StdoInfo stdoInfo) throws Exception {
        List<StdoInfo> stdoInfoList = null;

        stdoInfoList = studioMapper.listStudioPaging(stdoInfo);

        return stdoInfoList;
    }

    /**
     * <pre>
     *     수업요청 등록
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    @Override
    public boolean insertLectureRequest(LectReqInfo lectReqInfo) throws Exception {
        boolean returnValue = false;

        //수업요청정보 등록
        lectReqInfo.setReqTypeCd("101726");
        int insertCnt = lectureInfomationMapper.insertLectureRequest(lectReqInfo);

        if (insertCnt > 0) {
            List<LectReqTimeInfo> rectReqTimeInfo = lectReqInfo.getLectReqTimeInfoDomain();

            int i = 0;
            while (insertCnt > 0 && rectReqTimeInfo.size() > i) {
                LectReqTimeInfo lectReqTimeInfo = rectReqTimeInfo.get(i);
                lectReqTimeInfo.setReqSer(lectReqInfo.getReqSer());
                //수업요청시간정보 등록
                insertCnt = lectureInfomationMapper.insertLectureRequestTimeInfo(lectReqTimeInfo);
                i++;
            }

            if (insertCnt > 0) {
                returnValue = true;
            }
        }

        return returnValue;
    }

    /**
     * <pre>
     *     수업요청 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectReqInfo> listLectureRequest(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.listLectureRequest(lectureSearch);
    }

    /**
     * <pre>
     *     멘토에 의한 수업취소
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    @Override
    @SneakyThrows
    public int cnclLectSchdInfo(LectSchdInfo lectSchdInfo) {
        int resultCnt = 0;

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd"); //강의 시작날짜
        Date today = new Date();   //오늘날짜
        LectTimsInfo lectTimsInfo = new LectTimsInfo();
        LectApplCnt lectApplCnt = new LectApplCnt();
        LectApplInfo lectApplInfo = new LectApplInfo();

        Date lectDate = formatter.parse(lectSchdInfo.getLectDay());
        formatter.format(today);

        Calendar startCal = Calendar.getInstance();
        Calendar endCal = Calendar.getInstance();

        startCal.setTime(today);
        endCal.setTime(lectDate);

        long diffMillis = endCal.getTimeInMillis() - startCal.getTimeInMillis();
        int diff = (int) (diffMillis / (24 * 60 * 60 * 1000));

        lectTimsInfo.setLectSer(lectSchdInfo.getLectSer());
        lectTimsInfo.setLectTims(lectSchdInfo.getLectTims());

        LectInfo lectInfo = lectureInfomationMapper.retireveLectSchdInfo(lectSchdInfo);

        //환급할 수업횟수 조회
        int incLectVar = retireveLectureCnt(lectTimsInfo, lectInfo.getLectTargtCd());

        //수강인원 체크
        List<LectApplInfo> cntLectListenMem = lectureInfomationMapper.cntLectListenMem(lectSchdInfo);

        lectSchdInfo.setLectStatCd(lectSchdInfo.getLectStatCd());  //수업취소
        resultCnt += lectureInfomationMapper.cnclLectSchdInfo(lectSchdInfo);

        if (lectSchdInfo.getMbrClassCd().equals(CodeConstants.CD100857_100860_관리자)) { //관리자일경우
            if (cntLectListenMem.size() > 0) {
                for (int i = 0; i < cntLectListenMem.size(); i++) {
                    //수업취소에의한 수업횟수환급
                    lectApplCnt.setSchNo(cntLectListenMem.get(i).getSchNo());
                    lectApplCnt.setSetSer(cntLectListenMem.get(i).getSetSer());
                    updateLectApplCnt(lectApplCnt, -incLectVar);

                    //신청수업 취소처리
                    lectApplInfo.setLectSer(cntLectListenMem.get(i).getLectSer());
                    lectApplInfo.setLectTims(cntLectListenMem.get(i).getLectTims());
                    lectApplInfo.setClasRoomSer(cntLectListenMem.get(i).getClasRoomSer());
                    lectApplInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);
                    lectApplInfo.setChgMbrNo(lectSchdInfo.getChgMbrNo());
                    lectureInfomationMapper.updateLectureApplyStatus(lectApplInfo);

                }
            }

            if (lectSchdInfo.getLectStatCd().equals(CodeConstants.CD101541_101547_모집취소)) {

                try {
                    Message message = new Message();
                    message.setSendType(MessageSendType.EMS.getValue());

                    LecturePayLoad lecuturePayLoad = LecturePayLoad.of(message, lectSchdInfo.getLectSer(), lectSchdInfo.getLectTims(), false);


                    message.setPayload(lecuturePayLoad);
                    message.setContentType(MessageType.LECTURE_CLOSE);

                    messageTransferManager.invokeTransfer(message);
                } catch (Exception e) {
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }
            }

        } else {  //그외 멘토일경우(수업시작 7일이전에만 취소가능)
            if (diff < Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY"))) {
                throw CodeMessage.MSG_100010_수업시작_4일이전에만_취소가능합니다_.toException();
            } else {
                if (cntLectListenMem.size() > 0) {
                    for (int i = 0; i < cntLectListenMem.size(); i++) {
                        //수업취소에의한 수업횟수환급
                        lectApplCnt.setSchNo(cntLectListenMem.get(i).getSchNo());
                        lectApplCnt.setSetSer(cntLectListenMem.get(i).getSetSer());
                        updateLectApplCnt(lectApplCnt, -incLectVar);

                        //신청수업 취소처리
                        lectApplInfo.setLectSer(cntLectListenMem.get(i).getLectSer());
                        lectApplInfo.setLectTims(cntLectListenMem.get(i).getLectTims());
                        lectApplInfo.setClasRoomSer(cntLectListenMem.get(i).getClasRoomSer());
                        lectApplInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);
                        lectApplInfo.setChgMbrNo(lectSchdInfo.getChgMbrNo());
                        lectureInfomationMapper.updateLectureApplyStatus(lectApplInfo);

                    }

                }

                if (lectSchdInfo.getLectStatCd().equals(CodeConstants.CD101541_101547_모집취소)) {
                    try {
                        Message message = new Message();
                        message.setSendType(MessageSendType.EMS.getValue());

                        LecturePayLoad lecuturePayLoad = LecturePayLoad.of(message, lectSchdInfo.getLectSer(), lectSchdInfo.getLectTims(), false);


                        message.setPayload(lecuturePayLoad);
                        message.setContentType(MessageType.LECTURE_CANCEL_LECTURE);

                        messageTransferManager.invokeTransfer(message);
                    } catch (Exception e) {
                        log.error(e.getMessage());
                    }
                }
            }
        }

        return resultCnt;
    }

    /**
     * <pre>
     *     학교에의한 수업신청 취소
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    @Override
    public int cnclLectApplInfo(LectApplInfo lectApplInfo) throws Exception {

        // 화면에서 받아온 값
        String applStatCd = lectApplInfo.getApplStatCd();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd"); //강의 시작날짜
        Date today = new Date();   //오늘날짜
        LectTimsInfo lectTimsInfo = new LectTimsInfo();
        LectApplCnt lectApplCnt = new LectApplCnt();
        LectSchdInfo lectSchdInfo = new LectSchdInfo();

        lectSchdInfo.setLectTims(lectApplInfo.getLectTims());
        lectSchdInfo.setLectSer(lectApplInfo.getLectSer());
        lectSchdInfo.setSchdSeq(lectApplInfo.getSchdSeq());

        LectSchdInfo schdLectDay = lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);
        Date lectDate = formatter.parse(schdLectDay.getLectDay());
        formatter.format(today);

        Calendar startCal = Calendar.getInstance();
        Calendar endCal = Calendar.getInstance();

        startCal.setTime(today);
        endCal.setTime(lectDate);

        long diffMillis = endCal.getTimeInMillis() - startCal.getTimeInMillis();
        int diff = (int) (diffMillis / (24 * 60 * 60 * 1000));

        lectTimsInfo.setLectSer(lectApplInfo.getLectSer());
        lectTimsInfo.setLectTims(lectApplInfo.getLectTims());

        LectInfo lectInfo = lectureInfomationMapper.retireveLectSchdInfo(lectSchdInfo);

        //환급할 수업횟수 조회
        int incLectVar = this.retireveLectureCnt(lectTimsInfo, lectInfo.getLectTargtCd());

        int resultValue = 0;
        if (lectApplInfo.getMbrClassCd().equals(CodeConstants.CD100857_100860_관리자)) { //관리자일경우
            //수업취소에의한 수업횟수환급
            lectApplCnt.setSchNo(lectApplInfo.getSchNo());
            lectApplCnt.setSetSer(lectApplInfo.getSetSer());
            this.updateLectApplCnt(lectApplCnt, -incLectVar);

            //수업신청취소
            lectApplInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);
            resultValue = lectureInfomationMapper.updateLectureApplyStatus(lectApplInfo);
        } else {  //그외 학교일경우
            if (diff < Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY"))) {
                throw CodeMessage.MSG_100010_수업시작_4일이전에만_취소가능합니다_.toException();
            } else {
                //수업취소에의한 수업횟수환급
                lectApplCnt.setSchNo(lectApplInfo.getSchNo());
                lectApplCnt.setSetSer(lectApplInfo.getSetSer());
                this.updateLectApplCnt(lectApplCnt, -incLectVar);

                //수업신청취소
                lectApplInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);
                resultValue = lectureInfomationMapper.updateLectureApplyStatus(lectApplInfo);
            }
        }

        // 신청대기 기기 수동 취소 일 경우는 아래 로직 수행하지 않음. 신청기기 수동 취소 일 경우만 수행
        if (!CodeConstants.CD101574_101575_대기.equals(applStatCd)) {

            //대기자 1순위 조회하여 수업신청상태를 자동으로 신청(상태값:101577)으로 변경한다.
            lectApplInfo.setApplStatCd(CodeConstants.CD101574_101575_대기);
            List<LectApplInfo> waitingList = lectureInfomationMapper.listLectApplInfo(lectApplInfo);

            if (waitingList.size() > 0) {
                waitingList.get(0).setApplStatCd(CodeConstants.CD101574_101577_신청);
                waitingList.get(0).setChgMbrNo(waitingList.get(0).getRegMbrNo());
                resultValue = lectureInfomationMapper.updateLectApplInfo(waitingList.get(0));
            }
        }

        return resultValue;
    }

    /**
     * <pre>
     *     MC정보 저장
     * </pre>
     *
     * @param mcInfo
     * @return
     * @throws Exception
     */
    @Override
    public boolean saveMcInfo(McInfo mcInfo) throws Exception {
        boolean returnValue = false;

        String mcNo = mcInfo.getMcNo(); //MC번호

        int cnt = 0;
        if (StringUtils.isEmpty(mcNo)) {
            //등록
            cnt = mcMapper.insertMcInfo(mcInfo);
        } else {
            //수정
            cnt = mcMapper.updateMcInfo(mcInfo);
        }

        if (cnt > 0) {
            returnValue = true;
        }

        return returnValue;
    }

    /**
     * <pre>
     *     MC정보 상세조회
     * </pre>
     *
     * @param mcInfo
     * @return
     * @throws Exception
     */
    @Override
    public McInfo retrieveMcInfo(McInfo mcInfo) throws Exception {
        return mcMapper.retrieveMcInfo(mcInfo);
    }

    /**
     * <pre>
     *     스튜디오정보 저장
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    @Override
    public boolean saveStudioInfo(StdoInfo stdoInfo) throws Exception {
        boolean returnValue = false;

        String stdoNo = stdoInfo.getStdoNo(); //스튜디오번호

        int cnt = 0;
        if (StringUtils.isEmpty(stdoNo)) {
            //등록
            cnt = studioMapper.insertStudioInfo(stdoInfo);
        } else {
            //수정
            cnt = studioMapper.updateStudioInfo(stdoInfo);
        }

        if (cnt > 0) {
            returnValue = true;
        }

        return returnValue;
    }

    /**
     * <pre>
     *     스튜디오정보 상세조회
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    @Override
    public StdoInfo retrieveStudioInfo(StdoInfo stdoInfo) throws Exception {
        return studioMapper.retrieveStudioInfo(stdoInfo);
    }

    /**
     * <pre>
     *     수업예정 안내메일 발송
     *     수업일 기준 D-2,D-1일 수업예정 안내메일을 발송한다.
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @Override
    public int sendPrearrangedLectureInfomationMail() throws Exception {
        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setPageable(false);
        lectureSearch.setLectStatCd(CodeConstants.CD101541_101548_수업예정); //수업상태코드 : 수업예정

        //수업예정 상태이면서 D-2,D-1일 남은 수업차수정보(수업일정정보 포함)을 조회
        List<LectTimsInfo> lectTimsInfoList = lectureInfomationMapper.listLectureStatus(lectureSearch);

        int sendCnt = 0;
        int i = 0;
        while (lectTimsInfoList.size() > i) {
            LectTimsInfo lectTimsInfo = lectTimsInfoList.get(i);

            //수업을 신청한 교사목록 조회(안내메일 발송 대상자)
            List<LectureInfomationDTO> lectApplInfoList = lectureInfomationMapper.listLectureApplicationTeacher(lectTimsInfo);

            int j = 0;
            while (lectApplInfoList.size() > j) {
                List<LectSchdInfo> lectSchdInfoList = lectTimsInfo.getLectSchdInfo();
                LectureInfomationDTO lectApplInfo = lectApplInfoList.get(j); //수업신청정보

                int k = 0;
                while (lectSchdInfoList.size() > k) { //수업일정정보 개수만큼 반복(연강의 경우 개수가 하나 이상인 경우가 발생할 수 있기 때문)
                    LectSchdInfo lectSchdInfo = lectSchdInfoList.get(k);

                    //수업신청정보에 수업일정정보를 맵핑(메일에 보여줘야되는 정보가 있기 때문)
                    lectApplInfo.setLectrNm(lectTimsInfo.getLectInfo().getLectrNm()); //멘토명
                    lectApplInfo.setLectTitle(lectTimsInfo.getLectInfo().getLectTitle()); //수업명
                    lectApplInfo.setLectDay(lectSchdInfo.getLectDay()); //수업일
                    lectApplInfo.setLectStartTime(lectSchdInfo.getLectStartTime()); //수업시작시간
                    lectApplInfo.setLectEndTime(lectSchdInfo.getLectEndTime()); //수업종료시간

                    //메일발송
                    if (StringUtils.isNotEmpty(lectApplInfo.getTchrEmailAddr())) {
                        sendCnt++;
                    }

                    k++;
                }

                j++;
            }

            i++;
        }

        return sendCnt;
    }

    /**
     * <pre>
     * 기기설정정보 조회
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @Override
    public ClasSetHist retrieveClasSetHist() throws Exception {
        return lectureInfomationMapper.retrieveClasSetHist();
    }

    /**
     * <pre>
     * 기기설정정보 입력
     * </pre>
     *
     * @param clasSetHist
     * @return
     * @throws Exception
     */
    @Override
    public int insertClasSetHist(ClasSetHist clasSetHist) throws Exception {
        return lectureInfomationMapper.insertClasSetHist(clasSetHist);
    }

    /**
     * <pre>
     * 수업신청대상 조회(기기조회시 사용)
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    @Override
    public LectSchdInfo listLectApplDvc(LectSchdInfo lectSchdInfo) throws Exception {
        return lectureInfomationMapper.listLectApplDvc(lectSchdInfo);
    }

    /**
     * <pre>
     * 수업신청기기(교실) 조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listLectApplClas(LectSchdInfo lectSchdInfo) throws Exception {
        return lectureInfomationMapper.listLectApplClas(lectSchdInfo);
    }

    @Override
    public int lectureStatusChangeRecruitmentClose(HashMap param) {

        int result = 0;

        lectureInfomationMapper.updateLectureSchdStatusSchedule(param);

        lectureInfomationMapper.updateLectureTimsStatusSchedule(param);


        List<LectTimsInfo> lectTimsInfoList = lectureInfomationMapper.listtRecruitmentCloseLectTimsInfo(param);

        List<LectApplInfo> transitionApplyPhases = Lists.newArrayList();
        List<LectTimsInfo> transitionLecturePhases = Lists.newArrayList();
        List<LectApplInfo> recoverApplyCounts = Lists.newArrayList();

        List<Message<LecturePayLoad>> messages = Lists.newArrayList();

        for (LectTimsInfo lectTimsInfo : lectTimsInfoList) {
            //final int maxApplyCnt = lectTimsInfo.getLectInfo().getMaxApplCnt();

            List<LectApplInfo> applInfos = lectTimsInfo.getLectApplInfos();

            /**
             * left join 에 의해 공백으로 매핑되는 값을 제거한다.
             */
            if (applInfos.size() == 1 && applInfos.get(0).getClasRoomSer() == null)
                applInfos.remove(0);

            //if (applInfos.size() >= ) {   // TODO 상수처리 or Property처리
            if(lectTimsInfo.getAppliedCnt() >= (Integer) param.get("cutLine")){
                // 수업상태변경 목록에 등록한다.
                lectTimsInfo.setLectStatCd(CodeConstants.CD101541_101548_수업예정);
                transitionLecturePhases.add(lectTimsInfo);

                // 멘토에게 메시지 전송
                messages.add(buildMessage(lectTimsInfo, MessageType.LECTURE_CONFIRM, lectTimsInfo.getLectInfo().getReciever(), "수업예정"));   // TODO 사유확인,메시지 프러퍼티 변경

                /*int i = 0;
                for (LectApplInfo applInfo : applInfos) {
                    // maxApplyCnt 와 같아질 때까지 '신청' 상태이면 '확정'으로 변경목록에 등록한다.(Message 발송 리스트에 추가)
                    if (i < maxApplyCnt) {
                        if (CodeConstants.CD101574_101575_대기.equals(applInfo.getApplStatCd())) {
                            applInfo.setApplStatCd(CodeConstants.CD101574_101577_신청);
                            transitionApplyPhases.add(applInfo);

                            // 신청교사에게 메시지 발송
                            messages.add(buildMessage(lectTimsInfo, MessageType.LECTURE_STANDBY_CONFIRM, applInfo.getReciever(), null));
                        }
                    }
                    // maxApplyCnt 보다 큰 경우는 '신청' 상태이면 '취소'로 변경목록 등록한다.(Message 발송 리스트에 추가)
                    // 신청횟수 복원 목록에 등록한다.
                    else {
                        if (CodeConstants.CD101574_101575_대기.equals(applInfo.getApplStatCd())) {
                            applInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);
                            transitionApplyPhases.add(applInfo);
                            recoverApplyCounts.add(applInfo);

                            // 신청교사에게 메시지 발송
                            messages.add(buildMessage(lectTimsInfo, MessageType.LECTURE_STANDBY_CANCEL, applInfo.getReciever(), "정원초과")); // TODO 사유확인,메시지 프러퍼티 변경
                        }
                    }
                    i++;
                }*/
            } else {

                // 수업상태변경 목록에 등록한다. (Message 발송 리스트에 추가 : 해당 일시수업을 신청한 모든 신청교사,일시수업 멘토)
                lectTimsInfo.setLectStatCd(CodeConstants.CD101541_101547_모집취소);
                transitionLecturePhases.add(lectTimsInfo);

                // 신청횟수 복원 목록에 등록한다. (해당 일시수업을 신청한 모든 신청교사)
                for (LectApplInfo applInfo : applInfos) {
                    applInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);
                    transitionApplyPhases.add(applInfo);
                    if(applInfo.getApplClassCd().equals(CodeConstants.CD101714_101716_참관신청)) {
                        double classApplCnt = applInfo.getClasApplCnt() * 0.5;
                        applInfo.setClasApplCnt(classApplCnt);
                    }

                    recoverApplyCounts.add(applInfo);


                    // 신청교사에게 메시지 발송
                    messages.add(buildMessage(lectTimsInfo, MessageType.LECTURE_CANCEL_LECTURE, applInfo.getReciever(), "최소정원미달")); // TODO 사유확인,메시지 프러퍼티 변경
                }

                // 멘토에게 메시지 전송
                messages.add(buildMessage(lectTimsInfo, MessageType.LECTURE_CLOSE, lectTimsInfo.getLectInfo().getReciever(), "모집실패"));   // TODO 사유확인,메시지 프러퍼티 변경
            }
        }


        DefaultSqlSessionFactory sqlSessionFactoryBean = (DefaultSqlSessionFactory) ApplicationContextUtils.getBean("sqlSessionFactory");

        SqlSession sqlSession = sqlSessionFactoryBean.openSession(ExecutorType.BATCH);


        try {


            //final LectureInfomationMapper mapper = sqlSession.getMapper(LectureInfomationMapper.class);
            // 상태변경 목록을 DB에 변경요청한다.(신청정보)
            if (CollectionUtils.isNotEmpty(transitionApplyPhases)) {
                for (final LectApplInfo lectApplInfo : transitionApplyPhases) {
                    //mapper.updateLectureApplyStatus(lectApplInfo);
                    sqlSession.update("updateLectureApplyStatus", lectApplInfo);
                }
            }

            sqlSession.flushStatements();

            //수업상태변경목록을 DB에 변경요청한다.(일시수업정보,수업일정정보)
            if (CollectionUtils.isNotEmpty(transitionLecturePhases)) {
                for (LectTimsInfo lectTimsInfo : transitionLecturePhases) {
                    sqlSession.update("updateLectureTimeStatus", lectTimsInfo);
                }

                sqlSession.flushStatements();

                for (LectTimsInfo lectTimsInfo : transitionLecturePhases) {
                    sqlSession.update("updateLectureSchdStatusBulk", lectTimsInfo);

                }

                sqlSession.flushStatements();


            }

            // 신청횟수 복원 목록을 DB에 변경요청한다.(관련 테이블)
            if (CollectionUtils.isNotEmpty(recoverApplyCounts)) {
                for (LectApplInfo lectApplInfo : recoverApplyCounts) {
                    sqlSession.update("updateLecutApplyCnt", lectApplInfo);
                }
                sqlSession.flushStatements();
            }


            if (CollectionUtils.isNotEmpty(transitionLecturePhases)) {
                for (LectTimsInfo lectTimsInfo : transitionLecturePhases) {
                    if (lectTimsInfo.getLectStatCd().equals(CodeConstants.CD101541_101548_수업예정)) {
                        Integer lectSer = lectTimsInfo.getLectSer();
                        Integer lectTims = lectTimsInfo.getLectTims();
                        String lectTitle = lectTimsInfo.getLectInfo().getLectTitle();
                        String lectStartDtm = StringUtils.replacePattern(lectTimsInfo.getLectInfo().getLectStartDtm(), "[-:\\s]", "");
                        String lectEndDtm = StringUtils.replacePattern(lectTimsInfo.getLectInfo().getLectEndDtm(), "[-:\\s]", "");

                        List<LectApplInfo> applInfos = lectTimsInfo.getLectApplInfos();
                        for (LectApplInfo applInfo : applInfos) {

                            //교사일시도 Planner로 수업정보를 보낸다.
                            JSONObject postData = new JSONObject();
                            postData.put("USER_ID", applInfo.getApplId());
                            postData.put("CLAS_SEQ", lectSer + "" + lectTims);
                            postData.put("SCHD_TITLE", lectTitle);
                            postData.put("SCHD_START_TIME", lectStartDtm + "00");
                            postData.put("SCHD_END_TIME", lectEndDtm + "00");
                            postData.put("SCHD_YN", "Y");

                            HttpRequestUtils.sendSchedule(EgovProperties.getLocalProperty("Planner.url"), postData);

                            List<ClasRoomRegReqHist> clasRoomList = applInfo.getClasRoomList();
                            for (ClasRoomRegReqHist clasRoomRegReqHist : clasRoomList) {

                                String clasReqId = clasRoomRegReqHist.getClasRegId();
                                // clasReqId가 없는 경우는 무시한다.(반에 아무 학생이 없는경우)
                                if (StringUtils.isNotEmpty(clasReqId)) {

                                    postData = new JSONObject();
                                    postData.put("USER_ID", clasReqId);
                                    postData.put("CLAS_SEQ", lectSer + "" + lectTims);
                                    postData.put("SCHD_TITLE", lectTitle);
                                    postData.put("SCHD_START_TIME", lectStartDtm + "00");
                                    postData.put("SCHD_END_TIME", lectEndDtm + "00");
                                    postData.put("SCHD_YN", "Y");

                                    HttpRequestUtils.sendSchedule(EgovProperties.getLocalProperty("Planner.url"), postData);
                                }


                            }
                        }
                    }
                }
            }


            sqlSession.commit();
        } catch (DataAccessException e) {
            log.error(e.getMessage());
            sqlSession.rollback();
        } finally {
            sqlSession.close();
        }


        // 메시지 발송 리스트에서 각 메시지를 발송한다.(?)
        if (CollectionUtils.isNotEmpty(messages)) {
            for (Message message : messages) {
                try {
                    messageTransferManager.invokeTransfer(message);
                } catch (Exception e) {
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }
            }
        }

        return result;
    }

    private Message buildMessage(LectTimsInfo lectTimsInfo, MessageType messageType, MessageReciever reciever, String cause) {
        Message message = new Message();
        message.setSendType(MessageSendType.EMS.getValue()); // TODO 메시지발송유형 확인
        message.setContentType(messageType);

        if (reciever != null)
            message.addReciever(reciever);

        LecturePayLoad payLoad = LecturePayLoad.of(message, lectTimsInfo.getLectSer(), lectTimsInfo.getLectTims(), true);
        payLoad.setCause(cause);
        LectInfo lectInfo = lectTimsInfo.getLectInfo();
        if (lectInfo != null) {
            payLoad.setName(lectInfo.getLectTitle());
            payLoad.setStartDate(lectInfo.getLectStartDtm());
            payLoad.setEndTime(lectInfo.getLectEndDtm());
        } else {
            payLoad.setCompleted(false);
        }
        message.setPayload(payLoad);

        return message;
    }

    /**
     * <pre>
     * 수업상세조회(단건)
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     * @throws Exception
     */
    @Override
    public Map retireveLectSchdInfo(LectSchdInfo lectSchdInfo) {

        HashMap mapResult = new HashMap();

        //수업기본정보
        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setLectSer(lectSchdInfo.getLectSer());
        List<LectInfo> lectInfoList = lectureInfomationMapper.listLectInfo(lectureSearch);
        LectInfo resultLectInfo = lectInfoList.get(0);

        //수업이미지정보조회
        List<LectPicInfo> lectPicInfoList = lectureInfomationMapper.listLectPicInfo(lectSchdInfo.getLectSer());

        //멘토정보
        String mbrNo = lectInfoList.get(0).getLectrMbrNo();
        MentorDTO mentorInfo = mentorMapper.getMentorInfoBy(mbrNo);

        LectureInfomationDTO mentorRelMapp = null;
        if (CodeConstants.CD100204_101502_소속멘토.equals(mentorInfo.getMbrCualfCd())) { //수업의 멘토가 소속멘토인가?
            //소속멘토의 기업멘토정보(소속업체명)와 그 기업멘토의 그룹관리자(교육청담당자)의 기관정보(교육청) 정보를 조회
            mentorRelMapp = lectureInfomationMapper.listMentorRelMapp(mbrNo);
        }

        mapResult.put("resultLectInfo", lectInfoList.get(0)); //수업기본정보
        mapResult.put("lectPicInfoList", lectPicInfoList);    //수업이미지정보
        mapResult.put("mentorInfo", mentorInfo);              //멘토정보
        mapResult.put("mentorRelMapp", mentorRelMapp);        //소속멘토일 경우 업체명과 교육청 정보

        if (lectSchdInfo.getLectTims() == null) {


            mapResult.put("resultLectSchdInfo", new LectSchdInfo());
            mapResult.put("resultLectSchdInfoList", new ArrayList<LectSchdInfo>());
            mapResult.put("isLectureDday", true);

        } else {

            //수업일시정보 단건 조회
            LectSchdInfo resultLectSchdInfo = lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);

            //수업일시정보조회
            List<LectSchdInfo> resultLectSchdInfoList = lectureInfomationMapper.listLectSchdInfo(lectSchdInfo);

            //수업이 D-4일 이내인지 이후인지 계산
            GregorianCalendar gc = new GregorianCalendar();
            gc.add(Calendar.DATE, Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY")));
            Date date = gc.getTime();

            SimpleDateFormat sd = new SimpleDateFormat("yyyyMMdd");
            String lectDay = sd.format(date);

            boolean isLectureDday = false; //수업 D-4일 지났는지 안지났는지 화면에서 확인할 변수
            if (lectDay.compareTo(resultLectSchdInfo.getLectDay()) > 0) {
                //수업은 이미 D-4일 지났음
                isLectureDday = true;
            }

            //현재 수업 신청 신청기기 조회
            LectureInfomationDTO lectureApplCntDto = lectureInfomationMapper.applDvcCnt(lectSchdInfo);

            int applDvcCnt = lectureApplCntDto.getAuthorityCnt() + lectureApplCntDto.getConfirmationCnt();


            mapResult.put("resultLectSchdInfo", resultLectSchdInfo);         //수업일시정보
            mapResult.put("resultLectSchdInfoList", resultLectSchdInfoList); //수업일시정보 리스트
            mapResult.put("lectureApplCnt", lectureApplCntDto);              //수업신청상태별 건수
            mapResult.put("isLectureDday", isLectureDday);                   //수업 D-7일 여부
        }

        return mapResult;
    }

    /**
     * <pre>
     *     수업차감회수 조회
     *     수업차수정보를 이용하여 수업차감회수를 조회한다.
     *     단강과 특강은 1회차감, 연강은 몇회차 수업인지에 따라 다르고 블럭인 경우에는
     *     2블럭(70분~110분)은 1회 차감, 3블럭(120분~150분)과 4블럭(160분~240분)은 2회를 차감한다.
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     * @throws Exception
     */
    @Override
    public int retireveLectureCnt(LectTimsInfo lectTimsInfo, String lectTargtCd) {
        int iLectSer = lectTimsInfo.getLectSer(); //수업일련번호
        int iLectTims = lectTimsInfo.getLectTims(); //수업차수

        LectSchdInfo searchLectSchdInfo = new LectSchdInfo();

        searchLectSchdInfo.setLectSer(iLectSer); //수업일련번호
        searchLectSchdInfo.setLectTims(iLectTims); //수업차수

        //수업정보 조회
        String lectTypeCd = lectureInfomationMapper.retireveLectSchdInfo(searchLectSchdInfo).getLectTypeCd(); //수업유형코드

        //수업일시정보 조회
        LectTimsInfo searchLectTimsInfo = new LectTimsInfo();
        searchLectTimsInfo.setLectSer(iLectSer); //수업일련번호
        searchLectTimsInfo.setLectTims(iLectTims); //수업차수
        List<LectSchdInfo> resultLectSchdInfo = lectureInfomationMapper.listLectTimsSchdInfo(searchLectTimsInfo);

        return retireveLectureCnt(lectTypeCd, lectTargtCd, resultLectSchdInfo);
    }

    /**
     * <pre>
     *     수업차감횟수 조회
     * </pre>
     *
     * @param lectTypeCd
     * @param resultLectSchdInfo
     * @return
     * @throws Exception
     */
    @SneakyThrows
    private int retireveLectureCnt(String lectTypeCd, String lectTargtCd, List<LectSchdInfo> resultLectSchdInfo) {
        int returnCnt = 0;

        if (CodeConstants.CD101528_101529_단강.equals(lectTypeCd) || CodeConstants.CD101528_101531_특강.equals(lectTypeCd)) { //수업유형이 단강, 특강일 경우
            returnCnt = 1;
        } else if (CodeConstants.CD101528_101530_연강.equals(lectTypeCd)) { //수업유형이 연강일 경우
            returnCnt = resultLectSchdInfo.size(); //수업일시정보 개수
        } else if (CodeConstants.CD101528_101532_블록.equals(lectTypeCd)) { //수업유형이 블럭일 경우
            if (resultLectSchdInfo.size() > 0) {
                String sStartTime = resultLectSchdInfo.get(0).getLectStartTime();
                String sEndTime = resultLectSchdInfo.get(0).getLectEndTime();

                SimpleDateFormat formatter = new SimpleDateFormat("HHmm");

                Date dStartTime = formatter.parse(sStartTime);
                Date dEndTime = formatter.parse(sEndTime);

                long diff = dEndTime.getTime() - dStartTime.getTime();
                int diffTime = (int) diff / (60 * 1000);

                int validateTime = 60;
                if (CodeConstants.CD101533_101535_중학교.equals(lectTargtCd)) {
                    validateTime = 70;
                } else if (CodeConstants.CD101533_101538_중_고등학교.equals(lectTargtCd)) {
                    validateTime = 70;
                } else if (CodeConstants.CD101533_101536_고등학교.equals(lectTargtCd)) {
                    validateTime = 70;
                }

                //TODO 2블록 수업기준시간에 따라 수업차감횟수를 세팅
                if (diffTime >= validateTime) {
                    returnCnt = 2;
                } else {
                    returnCnt = 1;
                }

                /*if(diffTime >= 120 && diffTime <= 150){ //3블럭
                    returnCnt = 2;
                }else if(diffTime >= 160 && diffTime <= 240){ //4블럭
                    returnCnt = 2;
                }else{ //그 외 나머지 블럭
                    returnCnt = 1;
                }*/
            }
        }

        return returnCnt;
    }

    /**
     * <pre>
     *     수업정보 조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    @Override
    public LectInfo retireveLectureInfo(LectSchdInfo lectSchdInfo) throws Exception {

        //수업정보조회
        LectInfo resultLectInfo = lectureInfomationMapper.retireveLectSchdInfo(lectSchdInfo);

        return resultLectInfo;
    }

    /**
     * <pre>
     *     수업에 대한 평점 조회
     * </pre>
     *
     * @param arclInfo
     * @return
     * @throws Exception
     */
    @Override
    public LectureInfomationDTO retireveLectureRating(ArclInfo arclInfo) throws Exception {
        LectureInfomationDTO lectureInfomationDTO = lectureInfomationMapper.retireveLectureRating(arclInfo);

//		lectureInfomationDTO.setTeacherRating(5.0);
//		lectureInfomationDTO.setStudentRating(1.4);

        Double tearchRating = lectureInfomationDTO.getTeacherRating();
        Double studentRating = lectureInfomationDTO.getStudentRating();

        String sTearchRating = ratingImage(tearchRating);
        String sStudentRating = ratingImage(studentRating);

        lectureInfomationDTO.setImgTeacherRating(sTearchRating);
        lectureInfomationDTO.setImgStudentRating(sStudentRating);

        return lectureInfomationDTO;
    }

    /**
     * <pre>
     *     수업상세화면에서 평점을 표시할때 평점을 이용하여 별 이미지 파일의 파일명을 패턴형식으로 구하기
     * </pre>
     *
     * @param dSource
     * @return
     */
    public String ratingImage(Double dSource) {
        String resultValue = "";

        int iValue = dSource.intValue();
        Double dValue = dSource - iValue;

        if (dValue > 0.0) {
            dValue = 0.5;
        }

        String pattern = "0.#";
        DecimalFormat df = new DecimalFormat(pattern);

        resultValue = df.format(iValue + dValue).replace(".", "_");

        return resultValue;
    }

    /**
     * <pre>
     *     관련수업 목록조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureInfomationDTO> listRelationLecture(LectSchdInfo lectSchdInfo) throws Exception {
        lectSchdInfo.setPageable(false);
        LectSchdInfo resultLectSchdInfo = lectureInfomationMapper.retireveLectureSchdInfo(lectSchdInfo);

        String mbrNo = resultLectSchdInfo.getLectTimsInfo().getLectInfo().getLectrMbrNo(); //멘토회원번호
        String jobNo = resultLectSchdInfo.getLectTimsInfo().getLectInfo().getLectrJobNo(); //직업번호

        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setLectSer(lectSchdInfo.getLectSer());
        lectureSearch.setLectTims(lectSchdInfo.getLectTims());
        lectureSearch.setSchdSeq(lectSchdInfo.getSchdSeq());
        lectureSearch.setMbrNo(mbrNo);
        lectureSearch.setJobNo(jobNo);
        lectureSearch.setCntntsTargtCd(CodeConstants.CD100979_101654_수업다시보기); //컨텐츠 대상 코드 : 수업다시보기
        lectureSearch.setPageable(true);
        lectureSearch.setRecordCountPerPage(lectSchdInfo.getRecordCountPerPage());
        lectureSearch.setCurrentPageNo(lectSchdInfo.getCurrentPageNo());

        List<LectureInfomationDTO> resultLectSchdInfoList = lectureInfomationMapper.listRelationLecture(lectureSearch);

        return resultLectSchdInfoList;
    }

    /**
     * <pre>
     *     수업일시정보 목록조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<LectSchdInfo> listLectSchdInfo(LectSchdInfo lectSchdInfo) throws Exception {
        return lectureInfomationMapper.listLectSchdInfo(lectSchdInfo);
    }

    /**
     * <pre>
     *     교사가 담당하는 학교정보 목록 조회(selectbox)
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<SchInfo> listSchInfo(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.listSchInfo(lectureSearch);
    }

    /**
     * <pre>
     *     학교에 속한 교실목록 조회
     * </pre>
     *
     * @param schInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<ClasRoomInfo> listClasRoomInfo(SchInfo schInfo) throws Exception {
        return lectureInfomationMapper.listClasRoomInfo(schInfo);
    }

    /**
     * 학교에서 신청한 수업 목록 조회
     *
     * @param bizSetInfo
     * @return
     * @see kr.or.career.mentor.service.LectureManagementService#listSchoolLect(kr.or.career.mentor.domain.BizSetInfo)
     */
    @Override
    public List<LectureApplInfoDTO> listSchoolLect(BizSetInfo bizSetInfo) throws Exception {
        List<LectureApplInfoDTO> rst = lectureInfomationMapper.listSchoolLect(bizSetInfo);
        //수업 차감횟수 계산
        for (LectureApplInfoDTO data : rst) {
            List<LectSchdInfo> resultLectSchdInfo = new ArrayList<LectSchdInfo>();
            LectSchdInfo lsi = new LectSchdInfo();
            lsi.setLectStartTime(data.getLectStartTime());
            lsi.setLectEndTime(data.getLectEndTime());
            resultLectSchdInfo.add(lsi);

            if (data.getApplStatCd().equals(CodeConstants.CD101574_101578_취소)) {  //신청상태가 취소시 차감횟수는 0
                data.setApplCnt(0);
            } else {
                data.setApplCnt(retireveLectureCnt(data.getLectTypeCd(), data.getLectTargtCd(), resultLectSchdInfo));
            }
        }
        return rst;
    }


    /**
     * 내가 신청한 수업 목록
     * <p>
     * //@see kr.or.career.mentor.service.LectureManagementService#listLectureApply()
     *
     * @return
     */
    @Override
    public List<LectureApplInfoDTO> listAppliedLecture(LectureApplInfoDTO lectureApplInfoDTO) {
        return lectureInfomationMapper.listAppliedLecture(lectureApplInfoDTO);
    }

    /**
     * <pre>
     * 내가 속한 교실에서 신청한 수업목록
     * </pre>
     *
     * @param lectureApplInfoDTO
     * @return
     */
    @Override
    public List<LectureApplInfoDTO> listAppliedLectureByMyClassroom(LectureApplInfoDTO lectureApplInfoDTO) {
        return lectureInfomationMapper.listAppliedLectureByMyClassroom(lectureApplInfoDTO);
    }


    /**
     * <pre>
     *     멘토및 직업검색
     * </pre>
     *
     * @param jobSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<JobMentorInfoDTO> mentorjobSearch(JobSearch jobSearch) throws Exception {
        return lectureInfomationMapper.mentorjobSearch(jobSearch);
    }

    /**
     * <pre>
     *     멘토포탈 정산관리 수업목록 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public LectureInfomationDTO listCalculateLectureByMentor(LectureSearch lectureSearch) throws Exception {
        LectureInfomationDTO lectureInfomationDTO = new LectureInfomationDTO();
        lectureSearch.setLectStatCd(CodeConstants.CD101541_101551_수업완료); //수업상태코드 : 수업종료
        lectureSearch.setPageable(true);

        //멘토포탈 정산관리 수업목록 조회
        List<LectureInfomationDTO> lectSchdInfoList = lectureInfomationMapper.listCalculateLectureByMentor(lectureSearch);

        lectureInfomationDTO.setLectureInfomationDTOList(lectSchdInfoList);

        int totalLectDay = 0;
        int totalLectCnt = 0;
        if (lectSchdInfoList.size() > 0) {
            lectureSearch.setPageable(false);

            //멘토포탈 정산관리(개인멘토 대상) 총참여일수 조회
            totalLectDay = lectureInfomationMapper.retireveTotalLectDayCalculateLectureByMentor(lectureSearch);

            //멘토포탈 정산관리(개인멘토 대상) 총수업횟수 조회
            totalLectCnt = lectureInfomationMapper.retireveTotallectCntCalculateLectureByMentor(lectureSearch);
        }

        lectureInfomationDTO.setTotalLectDay(totalLectDay);
        lectureInfomationDTO.setTotalLectCnt(totalLectCnt);

        return lectureInfomationDTO;
    }

    /**
     * <pre>
     *     직업검색팝업
     * </pre>
     *
     * @param jobSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<JobMentorInfoDTO> jobDetailSearch(JobSearch jobSearch) throws Exception {
        return lectureInfomationMapper.jobDetailSearch(jobSearch);
    }

    /**
     * <pre>
     *     listLectInfo
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    @Override
    public List<LectInfo> listLectInfo(LectureSearch lectureSearch) {
        return lectureInfomationMapper.listLectInfo(lectureSearch);
    }

    /**
     * <pre>
     *     listRecentRecommandLecture
     * </pre>
     *
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listRecentRecommandLecture() {
        return lectureInfomationMapper.listRecentRecommandLecture();
    }

    @Override
    public List<LectureInfomationDTO> listSoonCloseLecture() {
        return lectureInfomationMapper.listSoonCloseLecture();
    }

    /**
     * <pre>
     *     listBestLecture
     * </pre>
     *
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listBestLecture() {
        return lectureInfomationMapper.listBestLecture();
    }

    /**
     * <pre>
     *     listNewLecture
     * </pre>
     *
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listNewLecture() {
        return lectureInfomationMapper.listNewLecture();
    }

    /**
     * <pre>
     *     cancelReqLectInfo
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    @Override
    public int cancelReqLectInfo(LectReqInfo lectReqInfo) throws Exception {
        return lectureInfomationMapper.cancelReqLectInfo(lectReqInfo);
    }

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
    @Override
    public List<CoInfo> listCoInfoByLectAppl(LectureSearch lectureSearch) throws Exception {
        List<CoInfo> coInfoList = null;
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(lectureSearch.getLectSer());
        lectSchdInfo.setLectTims(lectureSearch.getLectTims());
        lectSchdInfo.setSchdSeq(1);
        LectSchdInfo resultLectSchdInfo = lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);

        if (resultLectSchdInfo != null) {
            lectureSearch.setLectDay(resultLectSchdInfo.getLectDay());
            coInfoList = lectureInfomationMapper.listCoInfoByLectAppl(lectureSearch);
        }

        return coInfoList;
    }

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
    @Override
    public List<BizSetInfo> listBizSetGrpByCoInfo(LectureSearch lectureSearch) throws Exception {
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        if (lectureSearch.getLectSer() != null && lectureSearch.getLectTims() != null) {
            lectSchdInfo.setLectSer(lectureSearch.getLectSer());
            lectSchdInfo.setLectTims(lectureSearch.getLectTims());
            lectSchdInfo.setSchdSeq(1);
            LectSchdInfo resultLectSchdInfo = lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);
            lectureSearch.setLectDay(resultLectSchdInfo.getLectDay());
        }

        return lectureInfomationMapper.listBizSetGrpByCoInfo(lectureSearch);
    }

    /**
     * <pre>
     *     학교 자체 배정된 배정횟수, 잔여횟수 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public BizSetInfo listBizSetInfoBySchool(LectureSearch lectureSearch) throws Exception {
        //수업 정보가 있을 경우에는 수업일 기준의 학교 배정 정보를 조회, 수업 정보가 없을 경우에는 현재일 기준으로 조회
        if (lectureSearch.getLectSer() != null && lectureSearch.getLectTims() != null) {
            LectSchdInfo lectSchdInfo = new LectSchdInfo();
            lectSchdInfo.setLectSer(lectureSearch.getLectSer());
            lectSchdInfo.setLectTims(lectureSearch.getLectTims());
            lectSchdInfo.setSchdSeq(1);
            LectSchdInfo resultLectSchdInfo = lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);
            lectureSearch.setLectDay(resultLectSchdInfo.getLectDay());
        }
        return lectureInfomationMapper.listBizSetInfoBySchool(lectureSearch);
    }

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
    @Override
    public List<BizSetInfo> listAllBizSetInfoBySchool(LectureSearch lectureSearch) throws Exception {
        List<BizSetInfo> listRtn = lectureInfomationMapper.listBizSetGrpByCoInfo(lectureSearch);
        BizSetInfo bizInfo = listBizSetInfoBySchool(lectureSearch);
        if (bizInfo != null) {
            if (listRtn != null) {
                listRtn.add(bizInfo);
            } else {
                listRtn = new ArrayList<BizSetInfo>();
                listRtn.add(bizInfo);
            }
        }
        return listRtn;
    }

    /**
     * <pre>
     *     mentorLectureList
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    @Override
    public List<LectureApplInfoDTO> mentorLectureList(LectureSearch lectureSearch) {

        if (lectureSearch.getMbrCualfCd().equals(CodeConstants.CD100204_101501_업체담당자)) {
            MentorSearch search = new MentorSearch();
            search.setRegMbrNo(lectureSearch.getMbrNo());
            search.setPosCoNo(lectureSearch.getCoNo());
            List<MentorDTO> mentorList = mentorManagementService.listBelongMentor(search);

            lectureSearch.setMbrNo("");

            if (mentorList.size() > 0) {
                String[] belongMentorList = new String[mentorList.size()];
                for (int i = 0; i < mentorList.size(); i++) {
                    belongMentorList[i] = mentorList.get(i).getMbrNo();
                }
                lectureSearch.setBelongMentorMbrNoList(belongMentorList);
            }
        }

        List<LectureApplInfoDTO> mentorLectureList = lectureInfomationMapper.mentorLectureList(lectureSearch);

        for (LectureApplInfoDTO applInfo : mentorLectureList) {
            String lectStatCd = applInfo.getLectStatCd();
            int obsvCnt = 0;
            if (CodeConstants.CD101541_101550_수업중.equals(lectStatCd)) {
                try {
                    obsvCnt = HttpRequestUtils.getParticipantCnt(applInfo.getLectSessId());
                } catch (Exception e) {
                    //ignore Exception
                }
            }
            applInfo.setObsvCnt(obsvCnt);
        }

        return mentorLectureList;
    }

    /**
     * (수업완료 상태가 아닌 수업중에)현재 시간까지의 수업들을 조회하여 적절한 상태로 변경한다.
     * 현재 시간 기준으로 다음으로 상태 변경이 일어날 시간을 조회한다.
     * 조회한 시간에 스케줄을 등록한다.
     * 조회되는 내용이 없을 경우 1시간 후로 스케줄을 등록한다.
     *
     * @return
     * @see kr.or.career.mentor.service.LectureManagementService#updateLectureStatus()
     */
    @Override
    public Date updateLectureStatus() {
        HashMap<String, Integer> param = new HashMap<>();
        param.put("assign", Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY")));    //수업예정 상태로 바뀌는 기준 '일'
        param.put("ready", Integer.parseInt(EgovProperties.getProperty("READY_MINUTE")));    //수업대기 상태로 바뀌는 기준 '분'
        param.put("cutLine", Integer.parseInt(EgovProperties.getProperty("READY_APPLY_CNT"))); // 수업이 모집실패되는 기준 '신청수'

        //updateLectureStatus(param);
        lectureStatusChangeRecruitmentClose(param);

        Date nextTime = lectureInfomationMapper.retrieveNextStatusChangeTime(param);

        //다음 예정 시간이 없다면 1시간 후를 반환
        if (nextTime == null) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.HOUR, 1);
            nextTime = cal.getTime();
        }
        return nextTime;
    }

    /**
     * <pre>
     *     updateLectureStatus
     * </pre>
     *
     * @param param
     */
    private void updateLectureStatus(HashMap<String, Integer> param) {
        //연강의 강의 일정 정보(CNET_LECT_SCHD_INFO)의 상태를 변경해 준다. (모집실패인지, 수업예정인지만 판별)
        lectureInfomationMapper.updateLinkedLectureSchdStatus(param);

        //강의 일정 정보(CNET_LECT_SCHD_INFO)의 상태를 변경해 준다.
        lectureInfomationMapper.updateLectureSchdStatus(param);

        //강의 차수 정보를 갱신해 준다.CNET_LECT_TIMS_INFO
        lectureInfomationMapper.updateLectureTimsStatus(param);
    }


    /**
     *
     */

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
    @Override
    @Transactional
    public int updateLectureStatCd(ApprovalDTO approvalDTO) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
        //변경하려는 상태가 수강모집이면
        if (CodeConstants.CD101541_101543_수강모집.equals(approvalDTO.getLectStatCd())) {
            //수업 정보 조회
            List<LectSchdInfo> listLect = lectureInfomationMapper.listLectureScheInfo(approvalDTO);
            for (LectSchdInfo info : listLect) {
                //TOMMS에 수업정보 개설
                //User lectrUser = userMapper.getUserByNo(info.getLectTimsInfo().getLectInfo().getLectrMbrNo());
                //JSONObject json = HttpRequestUtils.createSession(lectrUser.getId(), info.getLectTitle(),info.getLectDay(),info.getLectStartTime(),info.getLectEndTime());
                JSONObject json = HttpRequestUtils.createSession(info.getLectTimsInfo().getLectInfo().getLectrMbrNo(), info.getLectTitle(), info.getLectDay(), info.getLectStartTime(), info.getLectEndTime());
                if (!json.get("status").toString().equals("I")) {
                    log.error("TOMMS setSessionCreate ERROR : {}", json.toString());
                    approvalDTO.setLectSessId("-1");
                } else {
                    approvalDTO.setLectSessId(json.get("sessionID").toString());
                }
                lectureInfomationMapper.updateLectureSchdStatCd(approvalDTO);
            }
        } else {
            //강의 스케쥴의 상태를 변경해준다.
            lectureInfomationMapper.updateLectureSchdStatCd(approvalDTO);
        }

        //강의 차수 정보의  상태를 변경해 준다.
        return lectureInfomationMapper.updateLectureTimsStatCd(approvalDTO);
    }

    @Override
    @Transactional
    public int updateLectureInfoStatCd(ApprovalDTO approvalDTO) {
        return lectureInfomationMapper.updateLectureInfoStatCd(approvalDTO);
    }

    /**
     * <pre>
     *     cancelEnrolling
     * </pre>
     *
     * @param approvalDTO
     * @return
     * @throws Exception
     */
    @Override
    public int cancelEnrolling(ApprovalDTO approvalDTO) throws Exception {
        if (CodeConstants.CD101541_101547_모집취소.equals(approvalDTO.getLectStatCd())) {
            cancelLectureApplying(approvalDTO);

        } else {
            //수업 상태를 현재 시간 기준으로  UPDATE, 다시 활성화 시켜줌
            HashMap<String, Integer> param = new HashMap<>();
            param.put("assign", Integer.parseInt(EgovProperties.getProperty("ASSIGN_DAY")));    //수업예정 상태로 바뀌는 기준 '일'
            param.put("ready", Integer.parseInt(EgovProperties.getProperty("READY_MINUTE")));    //수업대기 상태로 바뀌는 기준 '분'
            param.put("cutLine", Integer.parseInt(EgovProperties.getProperty("READY_APPLY_CNT"))); // 수업이 모집실패되는 기준 '신청수'
            param.put("lectSer", approvalDTO.getLectSer());
            param.put("lectTims", approvalDTO.getLectTims());

            updateLectureStatus(param);
        }
        return 0;
    }

    /**
     * <pre>
     *     cancelLectureApplying
     * </pre>
     *
     * @param approvalDTO
     * @throws Exception
     */
    @Override
    public void cancelLectureApplying(ApprovalDTO approvalDTO) throws Exception {
        //수업 모집 취소가 되면
        //1.수업의 상태를 모집 취소로 만듬.
        updateLectureStatCd(approvalDTO);
        //2.신청이력 조회
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(approvalDTO.getLectSer());
        lectSchdInfo.setLectTims(approvalDTO.getLectTims());

        LectTimsInfo lectTimsInfo = new LectTimsInfo();
        lectTimsInfo.setLectSer(approvalDTO.getLectSer());
        lectTimsInfo.setLectTims(approvalDTO.getLectTims());

        //환급할 수업횟수 조회
        int incLectVar = retireveLectureCnt(lectTimsInfo, approvalDTO.getLectTargtCd());

        List<LectApplInfo> listLectApplInfo = lectureInfomationMapper.cntLectListenMem(lectSchdInfo);
        //3.수업에 신청했던 이력을 모집취소로 변경, 차감했던 신청 횟수를 원복
        for (LectApplInfo info : listLectApplInfo) {

            LectApplCnt lectApplCnt = new LectApplCnt();
            //수업취소에의한 수업횟수환급
            lectApplCnt.setSchNo(info.getSchNo());
            lectApplCnt.setSetSer(info.getSetSer());
            updateLectApplCnt(lectApplCnt, -incLectVar);

            //신청수업 취소처리
            LectApplInfo lectApplInfo = new LectApplInfo();
            lectApplInfo.setLectSer(info.getLectSer());
            lectApplInfo.setLectTims(info.getLectTims());
            lectApplInfo.setClasRoomSer(info.getClasRoomSer());
            lectApplInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);
            lectApplInfo.setChgMbrNo("");
            lectureInfomationMapper.updateLectureApplyStatus(lectApplInfo);

//            cnclLectSchdInfo(lectSchdInfo);
        }
    }

    /**
     * <pre>
     *     copySaveOpenLect
     * </pre>
     *
     * @param lectInfo
     * @return
     */
    @Override
    public int copySaveOpenLect(LectInfo lectInfo) {

        int saveCnt = lectureInfomationMapper.copySaveOpenLect(lectInfo);

        if (saveCnt > 0) {
            //게시판 테이블에 수업평점 및 후기에 대한 더미글 등록
            int lectSer = lectInfo.getLectSer(); //수업일련번호

            ArclInfo arclInfo = new ArclInfo();
            arclInfo.setBoardId(Constants.BOARD_ID_LEC_APPR); //수업평가에 대한 게시판ID
            arclInfo.setCntntsTargtCd(CodeConstants.CD100979_101511_강의후기); //컨텐츠 대상 코드 : 수업평가
            arclInfo.setCntntsTargtNo(lectSer); //수업일련번호
            arclInfo.setSust("");
            arclInfo.setTitle("");
            arclInfo.setRegMbrNo(lectInfo.getRegMbrNo());

            //게시판 테이블 등록
            comunityService.registArcl(arclInfo, null);
        }
        return saveCnt;
    }

    /**
     * <pre>
     * 각 상태별 수업 개수
     * </pre>
     *
     * @param user
     * @return
     */
    @Override
    public StateCnt retrieveLectStatusCnt(User user) {
        return lectureInfomationMapper.retrieveLectStatusCnt(user);
    }

    /**
     * <pre>
     *     수업스케줄 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listLectureSchedule(LectureSearch lectureSearch) {

        List<LectureInfomationDTO> lectureInfomationDTOList = lectureInfomationMapper.listLectureSchedule(lectureSearch);

        return lectureInfomationDTOList;
    }

    /**
     * <pre>
     *     수업요청 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectReqInfo> listRequestLecture(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.listRequestLecture(lectureSearch);
    }

    /**
     * <pre>
     *     수업기본정보 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public LectInfo retrieveLectInfo(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.retrieveLectInfo(lectureSearch);
    }

    /**
     * <pre>
     *     기업멘토 관련수업 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureInfomationDTO> listCompanyMentorRelationLecture(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.listCompanyMentorRelationLecture(lectureSearch);
    }

    /**
     * <pre>
     *     기업멘토 관련수업 수업상태별 건수 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public LectureInfomationDTO retrieveCompanyMentorRelationLectureCnt(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.retrieveCompanyMentorRelationLectureCnt(lectureSearch);
    }

    /**
     * <pre>
     *     수업을 신청한 교사목록 조회(안내메일 발송 대상자)
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listLectureApplicationTeacher(LectTimsInfo lectTimsInfo) {
        return lectureInfomationMapper.listLectureApplicationTeacher(lectTimsInfo);
    }

    /**
     * <pre>
     *     관리자 수업현황
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureInfomationDTO> lectureTotalList(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.lectureTotalList(lectureSearch);
    }

    /**
     * <pre>
     *     관리자포탈 수업일시정보 목록조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listLectTimsInfoByAdmin(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.listLectTimsInfoByAdmin(lectureSearch);
    }

    /**
     * <pre>
     *     관리자 수업현황 엑셀다운로드
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public LectureInfomationDTO excelDownListLectureStatus(LectureSearch lectureSearch) throws Exception {

        LectureInfomationDTO lectureInfomationDTO = new LectureInfomationDTO();

        List<LectureInfomationDTO> lectSchdInfoList = lectureInfomationMapper.excelDownListLectureStatus(lectureSearch);

        lectureInfomationDTO.setApplCnt(0);
        for (LectureInfomationDTO dto : lectSchdInfoList) {
            if (lectureInfomationDTO.getApplCnt() < dto.getApplCnt()) {
                lectureInfomationDTO.setApplCnt(dto.getApplCnt());
            }
        }

        lectureInfomationDTO.setLectureInfomationDTOList(lectSchdInfoList);

        return lectureInfomationDTO;
    }

    /**
     * <pre>
     *     관리자 수업현황 엑셀학교목록
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureApplInfoDTO> excelDownSchoolList(LectApplInfo lectApplInfo) throws Exception {

        List<LectureApplInfoDTO> list = lectureInfomationMapper.excelDownSchoolList(lectApplInfo);
        for (LectureApplInfoDTO dto : list) {

            SchInfo schInfo = new SchInfo();
            schInfo.setSchNo(dto.getSchNo());

            // 관리자 수업현황 수업 신청 최초 여부
            String firstTxt = lectureInfomationMapper.excelLectureFirstSchoolText(schInfo);
            if (firstTxt == null) {
                firstTxt = "";
            }
            dto.setSchNm(firstTxt + dto.getSchNm());
        }

        return list;
    }

    /**
     * <pre>
     *     관리자 수업현황 엑셀대기학교목록
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureApplInfoDTO> excelDownStandBySchoolList(LectApplInfo lectApplInfo) throws Exception {

        List<LectureApplInfoDTO> list = lectureInfomationMapper.excelDownStandBySchoolList(lectApplInfo);
        for (LectureApplInfoDTO dto : list) {

            SchInfo schInfo = new SchInfo();
            schInfo.setSchNo(dto.getSchNo());

            // 관리자 수업현황 수업 신청 최초 여부
            String firstTxt = lectureInfomationMapper.excelLectureFirstSchoolText(schInfo);
            if (firstTxt == null) {
                firstTxt = "";
            }
            dto.setSchNm(firstTxt + dto.getSchNm());
        }

        return list;
    }

    /**
     * <pre>
     *     관리자 수업일시상세
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     */
    @Override
    public List<LectSchdInfo> listLectTimsSchdInfo(LectTimsInfo lectTimsInfo) {
        return lectureInfomationMapper.listLectTimsSchdInfo(lectTimsInfo);
    }


    /**
     * <pre>
     *     관리자 수업대기 기기
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listLectApplWaitClas(LectSchdInfo lectSchdInfo) {
        return lectureInfomationMapper.listLectApplWaitClas(lectSchdInfo);
    }

    /**
     * <pre>
     *     수업신청기기 상태변경
     * </pre>
     *
     * @param approvalDTO
     * @return
     */
    @Override
    public int updateLectureTimsStatCd(ApprovalDTO approvalDTO) {
        return lectureInfomationMapper.updateLectureTimsStatCd(approvalDTO);
    }


    /**
     * <pre>
     *     수업신청목록 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    @Override
    public List<LectureInfomationDTO> selectApplSchoolList(LectureSearch lectureSearch) {
        return lectureInfomationMapper.selectApplSchoolList(lectureSearch);
    }

    /**
     * <pre>
     *     수업상태 현황 카운트
     * </pre>
     *
     * @param
     * @return
     */
    @Override
    public List<LectureInfomationDTO> lectureStatusCnt(LectureSearch lectureSearch) {
        return lectureInfomationMapper.lectureStatusCnt(lectureSearch);
    }

    @Override
    public User setUser(String mbrNo) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
        User user = userMapper.getUserByNo(mbrNo);
        JSONObject json = HttpRequestUtils.setUser("I", user.getMbrNo(), user.getUsername(), user.getMbrNo(), user.getEmailAddr());
        log.info("setUser {}", json.toString());

        String resultStr = (String) json.get("message");
        log.info("rtn ::::> " + resultStr);

        if ("Duplicated user id".equals(resultStr)) {
            json = HttpRequestUtils.setUser("U", user.getMbrNo(), user.getUsername(), user.getMbrNo(), user.getEmailAddr());

            resultStr = (String) json.get("message");
            if ("Successfully Saved".equals(resultStr))
                log.info("success ::::> " + resultStr);
            else
                log.info("failed ::::> " + resultStr + "[]");
        }

        //계정 생성에 성공했으면
        if ("Successfully Saved".equals(resultStr)) {
            userMapper.updateCnslStartDay(user.getMbrNo());
        } else {
            log.error("TOMMS SETUSER FAIL : ", user.getMbrNo());
        }
        return user;
    }

    @Override
    public ApprovalDTO createSession(ApprovalDTO approvalDTO) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
        LectSchdInfo info = lectureInfomationMapper.listLectureScheInfo(approvalDTO).get(0);
        JSONObject json = HttpRequestUtils.createSession(info.getLectTimsInfo().getLectInfo().getLectrMbrNo(), info.getLectTitle(), info.getLectDay(), info.getLectStartTime(), info.getLectEndTime());
        if (json.get("status").toString().equals("I")) {
            String sessionID = json.get("sessionID").toString();
            approvalDTO.setLectSessId(sessionID);
            lectureInfomationMapper.updateLectureSchdStatCd(approvalDTO);
        }
        return approvalDTO;

    }

    /**
     * <pre>
     *     멘토탈퇴 전 개설된 수업이 존재하는지 체크
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public Integer secessionCheck(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.secessionCheck(lectureSearch);
    }

    /**
     * <pre>
     *     직업현황 통계
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureInfomationDTO> listJobStatistics(LectureSearch lectureSearch) {
        return lectureInfomationMapper.listJobStatistics(lectureSearch);
    }

    /**
     * <pre>
     *     직업현황 통계
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureInfomationDTO> listJobStatisticsByLv1(LectureSearch lectureSearch) {
        return lectureInfomationMapper.listJobStatisticsByLv1(lectureSearch);
    }

    @Override
    public List<LectureInfomationDTO> listJobStatisticsByLv2(LectureSearch lectureSearch) {
        return lectureInfomationMapper.listJobStatisticsByLv2(lectureSearch);
    }

    /**
     * <pre>
     *     수업현황 통계
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectureInfomationDTO> listLectStatistics(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.listLectStatistics(lectureSearch);
    }

    @Override
    public String selectLectTarget(String lectSer) {
        return lectureInfomationMapper.selectLectTarget(lectSer);
    }

    @Override
    public String selectSchoolClass(String schNo) {
        return lectureInfomationMapper.selectSchoolClass(schNo);
    }

    @Override
    public Date retrieveNextStatusChangeTime(HashMap<String, Integer> param) {
        return lectureInfomationMapper.retrieveNextStatusChangeTime(param);
    }

    @Override
    public List<PeopleInLecture> getCurrentPeopleInLecture() {
        return lectureInfomationMapper.getCurrentPeopleInLecture();
    }

    @Override
    public void changeLectSchdInfo(LectTimsInfo lectTimsInfo) {
        lectureInfomationMapper.updateLectureSchdStatusBulk(lectTimsInfo);
        lectureInfomationMapper.updateLectureTimeStatus(lectTimsInfo);

        //TODO 신청자를 모두 승인처리한다.취소는 없음.
    }

    /**
     * <pre>
     *     수업 차수 노출/비노출 수정
     * </pre>
     *
     * @param lectTimsInfo
     * @return
     */
    @Override
    public int updateExpsLectureInfo(LectTimsInfo lectTimsInfo) {
        return lectureInfomationMapper.updateExpsLectureInfo(lectTimsInfo);
    }

    /**
     * <pre>
     *     캘린더 데이터 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<LectCalendarInfo> selectLectureSchCalendarInfo(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.selectLectureSchCalendarInfo(lectureSearch);
    }

    @Override
    public List<LectureStatusExcelDTO> excelDownLoadLectureList(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.excelDownLoadLectureList(lectureSearch);
    }

    @Override
    public List<LectureStatusExcelDTO> excelDownLoadLectureClassList(LectureSearch lectureSearch) throws Exception {
        return lectureInfomationMapper.excelDownLoadLectureClassList(lectureSearch);
    }


    /**
     * <pre>
     *     관리자 수업현황
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception author jhseo
     *                   since 2016. 7. 01.
     */
    @Override
    public List<LectureInfomationDTO> lectureTimsList(LectureSearch lectureSearch) throws Exception {
        setDtSchoolGrdExList(lectureSearch);
        return lectureInfomationMapper.lectureTimsList(lectureSearch);
    }


    /**
     * <pre>
     *     관리자 수업 차수 상태 현황 카운트
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 01.
     */
    @Override
    public List<LectureInfomationDTO> lectureTimsStatusCnt(LectureSearch lectureSearch) throws Exception {
        setDtSchoolGrdExList(lectureSearch);

        List<LectureInfomationDTO> lectTimsStatusCnt = lectureInfomationMapper.lectureTimsStatusCnt(lectureSearch);

        //회차기준 총 카운트
        if (lectTimsStatusCnt != null && lectTimsStatusCnt.size() > 0) {
            lectTimsStatusCnt.get(0).setTotalLectCnt(lectureInfomationMapper.lectureTimsListCnt(lectureSearch));
        }

        return lectTimsStatusCnt;
    }

    /**
     * <pre>
     *     관리자 수업현황 조회시 학교급 조건 제외 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception author jhseo
     *                   since 2016. 7. 01.
     */
    @Override
    public void setDtSchoolGrdExList(LectureSearch lectureSearch) throws Exception {

        List<String> getSchoolGrdExList = new ArrayList<>();

        // 학교급 검색 조건 제외 목록 처리
        if ("101534".equals(lectureSearch.getSchoolGrd())) {
            getSchoolGrdExList.add("101535");
            getSchoolGrdExList.add("101536");
            getSchoolGrdExList.add("101538");
        } else if ("101535".equals(lectureSearch.getSchoolGrd())) {
            getSchoolGrdExList.add("101534");
            getSchoolGrdExList.add("101536");
            getSchoolGrdExList.add("101539");
        } else if ("101536".equals(lectureSearch.getSchoolGrd())) {
            getSchoolGrdExList.add("101534");
            getSchoolGrdExList.add("101535");
            getSchoolGrdExList.add("101537");
        } else if ("101537".equals(lectureSearch.getSchoolGrd())) {
            getSchoolGrdExList.add("101536");
        } else if ("101538".equals(lectureSearch.getSchoolGrd())) {
            getSchoolGrdExList.add("101534");
        } else if ("101539".equals(lectureSearch.getSchoolGrd())) {
            getSchoolGrdExList.add("101535");
        }

        if (StringUtils.isNotEmpty(lectureSearch.getSchoolGrd()) && StringUtils.isEmpty(lectureSearch.getSchoolEtcGrd())) {
            getSchoolGrdExList.add("101713");
        } else if (StringUtils.isNotEmpty(lectureSearch.getSchoolGrd()) && StringUtils.isNotEmpty(lectureSearch.getSchoolEtcGrd())) {
            lectureSearch.setSchoolEtcGrd(null);
        }
        lectureSearch.setSchoolGrdExList(getSchoolGrdExList);
    }

    /**
     * <pre>
     *     관리자 수업정보 상세조회
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 01.
     */
    @Override
    public LectInfo lectureInfo(LectureSearch lectureSearch) throws Exception {

        //수업정보조회
        LectInfo resultLectInfo = lectureInfomationMapper.lectureInfo(lectureSearch);

        return resultLectInfo;
    }

    /**
     * <pre>
     *     관리자 수업정보 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 01.
     */
    @Override
    public List<LectInfo> lectureInfoList(LectureSearch lectureSearch) throws Exception {
        setDtSchoolGrdExList(lectureSearch);
        //수업정보조회
        List<LectInfo> resultLectInfoList = lectureInfomationMapper.lectureInfoList(lectureSearch);

        return resultLectInfoList;
    }

    /**
     * <pre>
     *     관리자 수업 차수 및 회차 정보 상세조회
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 04.
     */
    @Override
    public LectTimsInfo lectureTimsSchdInfo(LectureSearch lectureSearch) throws Exception {

        //수업정보조회
        LectTimsInfo resultLectTimsInfo = lectureInfomationMapper.lectureTimsSchdInfo(lectureSearch);

        return resultLectTimsInfo;
    }

    /**
     * <pre>
     *     관리자 수업 신청/참관 정보 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 06.
     */
    @Override
    public List<LectureInfomationDTO> lectureApplList(LectureSearch lectureSearch) throws Exception {

        //수업 신청/참관 정보 리스트
        List<LectureInfomationDTO> lectApplList = lectureInfomationMapper.lectureApplList(lectureSearch);

        return lectApplList;
    }

    /**
     * <pre>
     *     관리자 수업 다른 차수 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 06.
     */
    @Override
    public List<LectTimsInfo> lectureOtherTimsList(LectureSearch lectureSearch) throws Exception {

        //수업 신청/참관 정보 리스트
        List<LectTimsInfo> lectTimsList = lectureInfomationMapper.lectureOtherTimsList(lectureSearch);

        return lectTimsList;
    }

    /**
     * <pre>
     *     관리자 수업 수동 취소처리
     * </pre>
     *
     * @param lectTimsInfo
     * @return author jhseo
     * since 2016. 7. 11.
     */
    @Override
    public int cnclLect(LectTimsInfo lectTimsInfo) throws Exception {

        int isCreateTomms = 0;
        //수업 차수 취소 업데이트
        int resultTimsCnt = lectureInfomationMapper.updateLectStatTimsInfo(lectTimsInfo);

        //수업 회차 취소 업데이트
        int resultSchdCnt = lectureInfomationMapper.updateLectStatSchdList(lectTimsInfo);

        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(lectTimsInfo.getLectSer());
        lectSchdInfo.setLectTims(lectTimsInfo.getLectTims());

        List<LectApplInfo> listLectApplInfo = lectureInfomationMapper.cntLectListenMem(lectSchdInfo);

        for (LectApplInfo info : listLectApplInfo) {
            if (info.getApplClassCd().equals("101715")) {
                info.setClasApplCnt(lectTimsInfo.getLectureCnt());
            } else {
                double obsvCnt = lectTimsInfo.getLectureCnt();
                info.setClasApplCnt(obsvCnt / 2);
            }

            lectureInfomationMapper.updateLectStatApplCntList(info);
        }

        //수업 차수 신청 정보 취소 업데이트
        int resultAppl = lectureInfomationMapper.updateLectStatApplList(lectTimsInfo);

        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setLectSer(lectTimsInfo.getLectSer());
        lectureSearch.setLectTims(lectTimsInfo.getLectTims());
        //수업 차수 신청 정보 취소 업데이트

        List<LectSchdInfo> lectSchdList = lectureInfomationMapper.lectureSchdList(lectureSearch);

        for (LectSchdInfo temp : lectSchdList) {
            //TOMMS에 수업정보 개설
            JSONObject json = HttpRequestUtils.deleteSession(temp.getLectrMbrNo(), temp.getLectSessId());
            if (!json.get("status").toString().equals("D")) {
                log.info("회의실 삭제가 실패하였습니다. " + json);
            }

        }


        return resultTimsCnt;
    }


    /**
     * <pre>
     *     관리자 수업 취소 사유 수정
     * </pre>
     *
     * @param lectTimsInfo
     * @return author jhseo
     * since 2016. 7. 11.
     */
    @Override
    public int cnclRsnUpdate(LectTimsInfo lectTimsInfo) throws Exception {

        //수업 취소사유 수정
        int resultTimsCnt = lectureInfomationMapper.updateLectStatTimsInfo(lectTimsInfo);

        return resultTimsCnt;
    }

    /**
     * <pre>
     *  수업 참여 가능 MC 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 12.
     */
    @Override
    public List<McInfo> listMcInfo(LectureSearch lectureSearch) throws Exception {

        //수업 참여 가능 MC 리스트
        List<McInfo> listMc = lectureInfomationMapper.lectureMcList(lectureSearch);

        return listMc;
    }


    /**
     * <pre>
     *  수업 스튜디오 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 12.
     */
    @Override
    public List<StdoInfo> listStdoInfo(LectureSearch lectureSearch) throws Exception {

        //수업 참여 가능 MC 리스트
        List<StdoInfo> listStdo = lectureInfomationMapper.lectureStdoList(lectureSearch);

        return listStdo;
    }


    /**
     * <pre>
     *     관리자 수업 MC/ 스튜디오 수정
     * </pre>
     *
     * @param lectTimsInfo, mbrNo
     * @return author jhseo
     * since 2016. 7. 11.
     */
    @Override
    public int lectUpdateMcStdo(LectTimsInfo lectTimsInfo, String mbrNo) throws Exception {

        //수업 스튜디오/MC 업데이트
        List<LectSchdInfo> lectSchdInfo = lectTimsInfo.getLectSchdInfo();

        if (lectTimsInfo.getMaxApplCnt() != null && lectTimsInfo.getMaxObsvCnt() != null) {
            lectTimsInfo.setLectSer(lectSchdInfo.get(0).getLectSer());
            lectTimsInfo.setLectTims(lectSchdInfo.get(0).getLectTims());
            lectureInfomationMapper.updateLectTimsBizCnt(lectTimsInfo);
        }

        int resultSchdCnt = 0;
        for (LectSchdInfo schdInfo : lectSchdInfo) {
            schdInfo.setChgMbrNo(mbrNo);
            resultSchdCnt += lectureInfomationMapper.updateLectMcStdoInfo(schdInfo);
        }

        return resultSchdCnt;
    }


    /**
     * <pre>
     *  수업 수동 신청 Class 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return author jhseo
     * since 2016. 7. 12.
     */
    @Override
    public List<ClasRoomInfo> listLectClass(LectureSearch lectureSearch) throws Exception {

        List<ClasRoomInfo> listClass = lectureInfomationMapper.lectureApplClasList(lectureSearch);

        return listClass;
    }


    /**
     * <pre>
     *     관리자 수업 수동 신청
     * </pre>
     *
     * @param lectureInfomationDTO
     * @return author jhseo
     * since 2016. 7. 11.
     */
    @Override
    public int lectInsertClass(LectureInfomationDTO lectureInfomationDTO, String callPath) throws Exception {

        int resultCnt = 0;

        if (!callPath.equals("sch") && !lectureInfomationDTO.getSchClassCd().equals("101736")) {
            List<String> chkTarget = lectureInfomationMapper.selectChkLectTarget(lectureInfomationDTO);

            boolean isApplable = org.apache.commons.lang.StringUtils.contains(chkTarget.get(1), chkTarget.get(0));

            if (!isApplable) {
                throw CodeMessage.MSG_800015_수업_신청을_할_수_없는_학교등급입니다.toException();
            }
        }

        LectureSearch lectureSearch = new LectureSearch();

        lectureSearch.setLectSer(lectureInfomationDTO.getLectSer());
        lectureSearch.setLectTims(lectureInfomationDTO.getLectTims());


        List<LectSchdInfo> lectSchdList = lectureInfomationMapper.lectureSchdList(lectureSearch);

        lectureInfomationDTO.setLectSchdInfoList(lectSchdList);

        for (LectSchdInfo lectSchdInfo : lectSchdList) {
            lectSchdInfo.setClasRoomSer(lectureInfomationDTO.getClasRoomSer());
            lectSchdInfo.setLectDay(lectSchdInfo.getLectDay().replaceAll("[.]", ""));
            lectSchdInfo.setLectStartTime(lectSchdInfo.getLectStartTime().replaceAll(":", ""));
            lectSchdInfo.setLectEndTime(lectSchdInfo.getLectEndTime().replaceAll(":", ""));

            int dupLectCnt = lectureInfomationMapper.dupLectSchdInfo(lectSchdInfo);

            if (dupLectCnt > 0) throw CodeMessage.MSG_100012_중복된_수업시간이_존재합니다_.toException();
        }
        //관리자 수업 수동 신청 등록 처리
        resultCnt = lectInsertClassProc(lectureInfomationDTO);

        return resultCnt;
    }

    /**
     * <pre>
     *     관리자 수업 수동 신청 등록 처리
     * </pre>
     *
     * @param lectureInfomationDTO
     * @return author jhseo
     * since 2016. 7. 11.
     */
    public int lectInsertClassProc(LectureInfomationDTO lectureInfomationDTO) throws Exception {

        //수업 수강 신청 등록
        LectApplInfo lectAppInfo = new LectApplInfo();
        lectAppInfo.setLectSer(lectureInfomationDTO.getLectSer());
        lectAppInfo.setLectTims(lectureInfomationDTO.getLectTims());
        lectAppInfo.setClasRoomSer(lectureInfomationDTO.getClasRoomSer());
        lectAppInfo.setApplMbrNo(lectureInfomationDTO.getTchrMbrNo());
        lectAppInfo.setSetSer(lectureInfomationDTO.getSetSer());
        lectAppInfo.setRegMbrNo(lectureInfomationDTO.getLectrMbrNo());
        lectAppInfo.setApplStatCd("101577");
        lectAppInfo.setApplClassCd(lectureInfomationDTO.getApplClassCd());

        //수업 참여 차감 횟수 처리
        if (lectureInfomationDTO.getApplClassCd().equals("101715")) {
            lectAppInfo.setClasApplCnt(lectureInfomationDTO.getLectureCnt());
        } else {
            double obsvCnt = lectureInfomationDTO.getLectureCnt();
            lectAppInfo.setClasApplCnt(obsvCnt / 2);
        }


        lectAppInfo.setSchNo(lectureInfomationDTO.getSchNo());

        //수업 신청정보 수정 및 등록
        int resultCnt = lectureInfomationMapper.insertLectApplInfo(lectAppInfo);

        //수업 신청정보 이력 등록
        lectureInfomationMapper.insertLectApplHist(lectAppInfo);


        //수업 횟수 차감
        lectureInfomationMapper.updateUseLectAppl(lectAppInfo);

        return resultCnt;
    }


    /**
     * <pre>
     *     관리자 수업 Class 수업 신청취소
     * </pre>
     *
     * @param lectureInfomationDTO
     * @return author jhseo
     * since 2016. 7. 114
     */
    @Override
    public int cnclLectClass(LectureInfomationDTO lectureInfomationDTO) throws Exception {

        LectTimsInfo lectTimsInfo = new LectTimsInfo();

        lectTimsInfo.setLectSer(lectureInfomationDTO.getLectSer());
        lectTimsInfo.setLectTims(lectureInfomationDTO.getLectTims());
        lectTimsInfo.setClasRoomSer(lectureInfomationDTO.getClasRoomSer());
        lectTimsInfo.setCnclMbrNo(lectureInfomationDTO.getLectrMbrNo());
        lectTimsInfo.setApplStatCd(CodeConstants.CD101574_101578_취소);


        //수업 신청 취소 업데이트
        int resultTimsCnt = lectureInfomationMapper.updateLectStatApplList(lectTimsInfo);


        LectApplInfo lectAppInfo = new LectApplInfo();
        lectAppInfo.setSetSer(lectureInfomationDTO.getSetSer());
        lectAppInfo.setSchNo(lectureInfomationDTO.getSchNo());

        //수업 참여 차감 횟수 처리
        if (lectureInfomationDTO.getApplClassCd().equals("101715")) {
            lectAppInfo.setClasApplCnt(-lectureInfomationDTO.getLectureCnt());
        } else {
            double obsvCnt = lectureInfomationDTO.getLectureCnt();
            lectAppInfo.setClasApplCnt(-obsvCnt / 2);
        }

        //수업 차감 정보 복구 업데이트
        int resultSchdCnt = lectureInfomationMapper.updateUseLectAppl(lectAppInfo);


        return resultTimsCnt;
    }


    /**
     * <pre>
     *     수업 일시추가 차수/회차 등록
     * </pre>
     *
     * @param lectTimsInfo
     * @return author jhseo
     * since 2016. 7. 114
     */
    @Override
    public int IectureSchdInfoInsert(LectTimsInfo lectTimsInfo) throws NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException {
        int returnValue = 0;
        int isCreateTomms = 0;

        if (lectTimsInfo == null) {
            throw CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toException();
        }


        lectTimsInfo.setLectStatCd(CodeConstants.CD101541_101543_수강모집);
        lectTimsInfo.setExpsYn("Y");

        int insertCnt = lectureInfomationMapper.insertLectTimsInfo(lectTimsInfo);

        int i = 0;

        while (insertCnt > 0 && lectTimsInfo.getLectSchdInfo().size() > i) {
            LectSchdInfo lectSchdInfo = lectTimsInfo.getLectSchdInfo().get(i);
            lectSchdInfo.setLectSer(lectTimsInfo.getLectSer());
            lectSchdInfo.setLectTims(lectTimsInfo.getLectTims());
            lectSchdInfo.setLectTitle(lectTimsInfo.getLectTitle());
            lectSchdInfo.setLectStatCd(lectTimsInfo.getLectStatCd());
            lectSchdInfo.setRegMbrNo(lectTimsInfo.getRegMbrNo());
            lectSchdInfo.setLectrMbrNo(lectTimsInfo.getLectrMbrNo());

            //이미 등록된 수업중에 수업시간이 겹치는 수업이 존재하는지 체크
            int overlapLecture = lectureInfomationMapper.dupMentorSchdInfo(lectSchdInfo);
            if (overlapLecture > 0) {
                throw CodeMessage.MSG_800013_수업일시가_겹치는_수업이_이미_등록되어_있기_때문에_수업을_추가_할_수_없습니다_.toException();
            }

            //TOMMS에 수업정보 개설
            JSONObject json = HttpRequestUtils.createSession(lectTimsInfo.getLectrMbrNo(), lectSchdInfo.getLectTitle(), lectSchdInfo.getLectDay(), lectSchdInfo.getLectStartTime(), lectSchdInfo.getLectEndTime());
            if (!json.get("status").toString().equals("I")) {
                throw CodeMessage.MSG_900006_화상회의_개설에_실패_하였습니다_.toException();
            } else {
                String sessionId = json.get("sessionID").toString();
                lectSchdInfo.setLectSessId(sessionId);
                isCreateTomms = Constants.TOMMS_CREATE_SUCCESS;

                json = HttpRequestUtils.addAttendance(sessionId, lectTimsInfo.getLectrMbrNo(), "M", "I", "1");
                log.info("addAttendance json :: > " + json);
                if (StringUtils.isNotEmpty(lectSchdInfo.getMcNo())) {
                    HttpRequestUtils.addAttendance(sessionId, "MC:" + lectSchdInfo.getMcNo(), "M", "I", "1");
                }
            }

            insertCnt = lectureInfomationMapper.insertLectSchdInfo(lectSchdInfo);
            i++;
        }
        if (i > 0)
            returnValue = 1;

        return returnValue | isCreateTomms;
    }


    /**
     * <pre>
     *  수업수정
     * </pre>
     *
     * @param lectInfo
     * @return
     * @throws Exception
     */
    @Override
    public int updateLectInfo(LectInfo lectInfo, String potalType) throws Exception {

        int saveCnt = 0;

        List<String> delFileList = new ArrayList<String>();

        //수업 이미지 삭제 파일정보 적용
        for (String delFileSer : lectInfo.getDelFileSer().split(",")) {
            if (delFileSer != null && !delFileSer.equals("")) {
                delFileList.add(delFileSer);
            }
        }
        if (delFileList.size() > 0) {
            lectInfo.setFileSerList(delFileList);
            lectureInfomationMapper.delLectPicInfo(lectInfo);
            lectureInfomationMapper.delLectPicFile(lectInfo);
        }

        if (potalType.equals("mng")) { //관리자 수업 수정
            for (String fileSer : lectInfo.getFileSer().split(",")) {
                if (fileSer != null && !fileSer.equals("")) {
                    LectPicInfo lectPicInfo = new LectPicInfo();
                    lectPicInfo.setFileSer(Integer.parseInt(fileSer));
                    lectPicInfo.setLectSer(lectInfo.getLectSer());
                    lectPicInfo.setRegMbrNo(lectInfo.getChgMbrNo());
                    fileMapper.insertLectPicInfo(lectPicInfo);
                }
            }
        } else if (potalType.equals("men") && lectInfo.getListLectPicInfo() != null) { //멘토 수업 수정
            //수업이미지 등록

            for (int i = 0; i < lectInfo.getListLectPicInfo().size(); i++) {
                LectPicInfo lectPicInfo = new LectPicInfo();
                FileInfo fileInfo = fileManagementService.fileProcess(lectInfo.getListLectPicInfo().get(i).getComFileInfo().getFile(), "TEST");
                lectPicInfo.setFileSer(fileInfo.getFileSer());
                lectPicInfo.setLectSer(lectInfo.getLectSer());
                fileMapper.insertLectPicInfo(lectPicInfo);
            }
        }

        saveCnt = lectureInfomationMapper.updateLectInformation(lectInfo);

        return saveCnt;
    }

    /**
     * <pre>
     *     멘토 회차 기준 리스트 (멘토 수업현황)
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    @Override
    public List<LectureApplInfoDTO> mentorLectureSchdList(LectureSearch lectureSearch) {


        List<LectureApplInfoDTO> mentorLectureList = lectureInfomationMapper.mentorLectSchdList(lectureSearch);


        return mentorLectureList;
    }

    /**
     * <pre>
     *     멘토 스튜디오정보 목록조회
     * </pre>
     *
     * @param stdoInfo
     * @return
     * @throws Exception
     */
    @Override
    public List<StdoInfo> stdoList(StdoInfo stdoInfo) throws Exception {
        List<StdoInfo> stdoInfoList = null;

        stdoInfoList = studioMapper.stdoList(stdoInfo);

        return stdoInfoList;
    }

    @Override
    public LectureStatusCountInfo mentorMainLectStatusCount(LectureStatusCountInfo lectureStatusCountInfo) {
        return lectureInfomationMapper.mentorMainLectStatusCount(lectureStatusCountInfo);
    }

    @Override
    public List<LectReqInfo> selectLectReqInfoList(LectReqInfo lectReqInfo) {
        return lectureInfomationMapper.selectLectReqInfoList(lectReqInfo);
    }

    @Override
    public LectReqInfo selectLectReqInfoCount(LectReqInfo lectReqInfo) {
        return lectureInfomationMapper.selectLectReqInfoCount(lectReqInfo);
    }


    /**
     * <pre>
     * 수업참관기기(교실) 조회
     * </pre>
     *
     * @param lectSchdInfo
     * @return
     */
    @Override
    public List<LectureInfomationDTO> listLectObsvClas(LectSchdInfo lectSchdInfo) throws Exception {
        return lectureInfomationMapper.listLectObsvClas(lectSchdInfo);
    }


    /**
     * <pre>
     *  멘토 수업개설신청 등록
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    @Override
    public int insertLectOpenReqInfo(LectReqInfo lectReqInfo) throws Exception {

        int saveCnt = 0;

        saveCnt = lectureInfomationMapper.insertLectOpenReq(lectReqInfo);

        return saveCnt;
    }

    @Override
    public LectReqInfo selectLectReqInfo(LectReqInfo lectReqInfo) {

        return lectureInfomationMapper.selectLectReqInfo(lectReqInfo);
    }

    /**
     * <pre>
     *  멘토 수업개설신청 수정
     * </pre>
     *
     * @param lectReqInfo
     * @return
     * @throws Exception
     */
    @Override
    public int updateLectOpenReqInfo(LectReqInfo lectReqInfo) throws Exception {

        int saveCnt = 0;

        saveCnt = lectureInfomationMapper.updateLectOpenReq(lectReqInfo);

        return saveCnt;
    }

    /**
     * <pre>
     *  수업참관시 참관이력 저장
     * </pre>
     *
     * @param lectApplInfo
     * @return
     * @throws Exception
     */
    @Override
    public int regObsvHist(LectApplInfo lectApplInfo) throws Exception {

        int saveCnt = 0;

        saveCnt = lectureInfomationMapper.regObsvHist(lectApplInfo);

        return saveCnt;
    }


    @Override
    public int withdrawApplyCount() {

        int withdrawApplyCount = 0;

        try {

            List<WithdrawInfo> obsvHists = lectureInfomationMapper.selectObsvHist();

            if (obsvHists.size() > 0) {

                List<WithdrawInfo> successedObservations = tommsMapper.retrieveSuccessedObservation(obsvHists);

                if (successedObservations.size() > 0) {

                    lectureInfomationMapper.updateObsvHist(successedObservations);

                    List<WithdrawInfo> withdrawApplyCounts = lectureInfomationMapper.selectWithdrawApplyCount();

                    withdrawApplyCount = lectureInfomationMapper.withdrawApplyCount(withdrawApplyCounts);
                }

                lectureInfomationMapper.updateObsvHistBatchSuccess(obsvHists);
            }

            return withdrawApplyCount;
        } catch (Exception e) {
            throw e;
        }

    }

    /**
     * <pre>
     *   대표학생여부 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     */
    @Override
    public int getRpsClasStdt(LectureSearch lectureSearch) throws Exception {
        int rpsClasStdt = 0;

        return rpsClasStdt = lectureInfomationMapper.getRpsClasStdt(lectureSearch);
    }


    /**
     * <pre>
     *     관리자 수업현황 엑셀 다운로드 리스트
     * </pre>
     *
     * @param listLecture
     * @return
     * @throws Exception author jhseo
     *                   since 2016. 7. 01.
     */
    @Override
    public ExcelInfoDTO lectInfoExcelList(List<LectureInfomationDTO> listLecture) throws Exception {


        List<LectureStatusExcelDTO> targetList = new ArrayList<>();
        int iTotalCnt = listLecture.size();

        for(LectureInfomationDTO originSource : listLecture){
            LectureStatusExcelDTO targetSource = new LectureStatusExcelDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            StringBuffer sb1 = new StringBuffer(originSource.getLectStartTime());
            StringBuffer sb2 = new StringBuffer(originSource.getLectEndTime());
            StringBuffer sb3 = new StringBuffer(originSource.getLectDay());
            sb1.insert(2,":");
            sb2.insert(2,":");
            sb3.insert(4,"-");
            sb3.insert(7,"-");

            targetSource.setLectTime(sb1.toString() + " ~ " + sb2.toString());
            targetSource.setLectDay(sb3.toString());
            targetSource.setApplDvc(originSource.getApplCnt() + "/" + originSource.getMaxApplCnt());
            targetSource.setObsvDvc(originSource.getObsvCnt() + "/" + originSource.getMaxObsvCnt());
            targetList.add(targetSource);
        }

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "no"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "grpNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectStatCdNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectDay"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectTime"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectJobClsfNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "jobNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectrNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectTitle"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "applDvc"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "obsvDvc"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectTypeCdNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectureCnt"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "coNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "stdoNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "mcNm"));

        ExcelInfoDTO excelSheetInfo = new ExcelInfoDTO();

        excelSheetInfo.setFieldList(listHeaderField);
        excelSheetInfo.setListObject((List)targetList);
        excelSheetInfo.setSheetNm("A1.수업목록@");

        return excelSheetInfo;

    }



    /**
     * <pre>
     *     관리자 수업현황 엑셀 다운로드 리스트
     * </pre>
     *
     * @param listApplClas
     * @return
     * @throws Exception author jhseo
     *                   since 2016. 8. 29.
     */
    @Override
    public ExcelInfoDTO lectApplClasExcelList(List<LectureInfomationDTO> listApplClas, String excelType) throws Exception {


        List<LectureStatusExcelDTO> targetList = new ArrayList<>();
        int iTotalCnt = listApplClas.size();

        for(LectureInfomationDTO originSource : listApplClas){
            LectureStatusExcelDTO targetSource = new LectureStatusExcelDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            StringBuffer sb1 = new StringBuffer(originSource.getLectStartTime());
            StringBuffer sb2 = new StringBuffer(originSource.getLectEndTime());
            StringBuffer sb3 = new StringBuffer(originSource.getLectDay());
            sb1.insert(2,":");
            sb2.insert(2,":");
            sb3.insert(4,"-");
            sb3.insert(7,"-");

            targetSource.setLectTime(sb1.toString() + " ~ " + sb2.toString()  + " (" + targetSource.getLectRunTime() + "분)");
            targetSource.setLectDay(sb3.toString());

            targetSource.setApplDvc(originSource.getApplCnt() + "/" + originSource.getMaxApplCnt());
            targetSource.setObsvDvc(originSource.getObsvCnt() + "/" + originSource.getMaxObsvCnt());
            targetSource.setJoinClassNm(originSource.getJoinClassNm() + "(" + originSource.getDeviceTypeNm() + ")");
            targetList.add(targetSource);
        }

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "no"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "applRegDtm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "applClassCdNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "schClassCdNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "sidoNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "sgguNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "schoolNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "clasRoomNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "clasPersonCnt"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "clasRoomCualfCdNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "tchrNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "grpNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectDay"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectTime"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectTitle"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "jobNm"));
        listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectrNm"));

        if(excelType.equals("lectAppl")){
            listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectTypeCdNm"));
        }else{
            listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "lectStatCdNm"));
            listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "applDvc"));
            listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "obsvDvc"));
            listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "schNo"));
            listHeaderField.add(MultiSheetExcelView.getField(LectureStatusExcelDTO.class, "joinClassNm"));
        }

        ExcelInfoDTO excelSheetInfo = new ExcelInfoDTO();

        excelSheetInfo.setFieldList(listHeaderField);
        excelSheetInfo.setListObject((List)targetList);

        if(excelType.equals("lectAppl")){
            excelSheetInfo.setSheetNm("A1.수업신청취소현황@");
        }else{
            excelSheetInfo.setSheetNm("A2.수업별클래스목록@");
        }


        return excelSheetInfo;

    }


    /**
     * <pre>
     *     관리자 수업 클래스별 신청 현황 리스트
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception author jhseo
     *                   since 2016. 8. 29.
     */
    @Override
    public List<LectureInfomationDTO> lectApplClasList(LectureSearch lectureSearch) throws Exception {

        return lectureInfomationMapper.lectApplClasList(lectureSearch);
    }

    /**
     * <pre>
     *  진행 배정사업그룹 조회
     * </pre>
     *
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @Override
    public List<BizGrpInfo> listBizGrpList(LectureSearch lectureSearch) throws Exception {

        return lectureInfomationMapper.listBizGrpList(lectureSearch);

    }
}