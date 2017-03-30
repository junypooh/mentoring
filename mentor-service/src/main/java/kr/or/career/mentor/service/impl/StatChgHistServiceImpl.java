package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.dao.MentorMapper;
import kr.or.career.mentor.dao.StatChgHistMapper;
import kr.or.career.mentor.dao.UserMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.StatChgHistService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.HttpRequestUtils;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *      StatChgHistServiceImpl
 *
 * 상태 변경 이력 Service
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-11 오후 2:01
 */
@Service
@Slf4j
public class StatChgHistServiceImpl implements StatChgHistService {

    @Autowired
    private StatChgHistMapper statChgHistMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private MentorMapper mentorMapper;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @Override
    public void insertStatChgHistInfo(StatChgHistInfo statChgHistInfo) {
        statChgHistMapper.insertStatChgHistInfo(statChgHistInfo);
    }
    @Override
    public List<StatChgHistInfo> getStatChgHistByMbrNo(UserSearch userSearch) {
        return statChgHistMapper.getStatChgHistByMbrNo(userSearch);
    }

    @Override
    public void insertStatChgHistSubmit(StatChgHistInfo statChgHistInfo) throws Exception {

        String statChgClassCd = statChgHistInfo.getStatChgClassCd();
        if(
                CodeConstants.CD101718_101719_회원가입요청상태.equals(statChgClassCd) ||
                        CodeConstants.CD101718_101751_회원탈퇴요청상태.equals(statChgClassCd)
                ) {
            statChgHistInfo.setStatChgClassCd(null);
            statChgHistInfo.setStatChgClassCds(Arrays.asList(CodeConstants.CD101718_101719_회원가입요청상태, CodeConstants.CD101718_101751_회원탈퇴요청상태));
        }

        statChgHistMapper.updateStatChgHistLastStat(statChgHistInfo);
        statChgHistMapper.insertStatChgHistSubmit(statChgHistInfo);

        Message message = new Message();
        message.setSendType(MessageSendType.EMS.getValue());

        // 상태변경구분 코드에 따라 각각의 비지니스 로직 수행.
        User user = new User();
        switch (statChgClassCd) {
            case CodeConstants.CD101718_101719_회원가입요청상태 :
                if(CodeConstants.CD100861_100862_정상이용.equals(statChgHistInfo.getStatChgRsltCd())) {
                    // 승인
                    user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
                    user.setLoginPermYn("Y");
                    user.setChgMbrNo(SessionUtils.getUser().getMbrNo());
                    user.setMbrNo(statChgHistInfo.getStatChgTargtMbrNo());
                    userMapper.updateStat(user);

                    //TOMMS에 사용자 추가
                    user.setUsername(statChgHistInfo.getUsername());
                    user.setEmailAddr(statChgHistInfo.getEmailAddr());
                    JSONObject json = HttpRequestUtils.setUser("I",user.getMbrNo(), user.getUsername(), user.getMbrNo(), user.getEmailAddr());
                    log.info("TOMMS ACCOUNT ADD : {}",json.toString());

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
                    if ("Successfully Saved".equals(resultStr)){
                        userMapper.updateCnslStartDay(user.getMbrNo());
                    }else{
                        log.error("TOMMS SETUSER FAIL : ",user.getMbrNo());
                    }

                    message.setContentType(MessageType.MENTOR_APPROVE);
                } else {
                    // 반려
                    user.setLoginPermYn("N");
                    user.setMbrStatCd(CodeConstants.CD100861_100863_이용중지);
                    user.setChgMbrNo(SessionUtils.getUser().getMbrNo());
                    user.setMbrNo(statChgHistInfo.getStatChgTargtMbrNo());
                    userMapper.updateStat(user);

                    message.setContentType(MessageType.MENTOR_RETURN);
                }

                try {
                    message.setPayload(MemberPayLoad.of(user.getMbrNo(), message, false));

                    messageTransferManager.invokeTransfer(message);
                }catch (Exception e){
                    //Nothing
                }

                break;
            case CodeConstants.CD101718_101751_회원탈퇴요청상태 :
                if(CodeConstants.CD100861_100864_탈퇴.equals(statChgHistInfo.getStatChgRsltCd())) {

                    //회원이 개설하여 아직 진행하지 않은 수업은 취소 처리 함.
                    //1.회원이 개설하여 아직 진행하지 않은 수업 조회
                    List<ApprovalDTO> listApprovalDTO = mentorMapper.listALiveLecture(statChgHistInfo.getStatChgTargtMbrNo());

                    for (ApprovalDTO info : listApprovalDTO) {
                        info.setLectStatCd(CodeConstants.CD101541_101547_모집취소);
                        lectureManagementService.cancelLectureApplying(info);
                    }

                    // 승인
                    user.setMbrStatCd(CodeConstants.CD100861_100864_탈퇴);
                    user.setLoginPermYn("N");
                    user.setChgMbrNo(SessionUtils.getUser().getMbrNo());
                    user.setMbrNo(statChgHistInfo.getStatChgTargtMbrNo());
                    user.setAuthProcSust("회원탈퇴신청");
                    user.setMbrWithdrawnType(CodeConstants.CD101512_101753_회원_탈퇴_신청);
                    userMapper.withDrawalUser(user); // 회원 정보 삭제
                } else {
                    // 반려
                    user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
                    user.setLoginPermYn("Y");
                    user.setChgMbrNo(SessionUtils.getUser().getMbrNo());
                    user.setMbrNo(statChgHistInfo.getStatChgTargtMbrNo());

                    message.setContentType(MessageType.SECEDE_RETURN_MENTOR);

                    try {
                        message.setPayload(MemberPayLoad.of(user.getMbrNo(), message, false));

                        messageTransferManager.invokeTransfer(message);
                    }catch (Exception e){
                        //Nothing
                    }
                }
                userMapper.updateStat(user);
                break;
            case CodeConstants.CD101718_101720_교실등록상태 :
                break;
            case CodeConstants.CD101718_101721_수업상태 :
                break;
            case CodeConstants.CD101718_101722_대표교사상태 :
                break;
            case CodeConstants.CD101718_101723_수업요청상태 :
                break;
        }
    }
}
