package kr.or.career.mentor.util;

import kr.or.career.mentor.exception.CnetException;
import org.slf4j.LoggerFactory;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

//@formatter:off
public enum CodeMessage {

    // 에러 메시지
    ERROR_000001_시스템_오류_입니다_,
    ERROR_000002_저장중_오류가_발생하였습니다_,
    ERROR_000003_등록된_사용자_정보를_찾을_수_없습니다_,
    ERROR_000004_ID가_없거나_비밀번호가_잘못_입력되었습니다_,
    ERROR_000005_이메일_전송중_오류가_발생하셨습니다_,
    ERROR_000006_관리자의_승인을_기다리고_있습니다_,
    ERROR_000007_허용되지_않는_확장자_입니다_,

    SECURITY_200001_관리자의_승인을_기다리고_있습니다_,
    SECURITY_200002_사용자_계정을_사용할_수_없습니다_,
    SECURITY_200003_expired_,
    SECURITY_200004_credentialsExpired_,
    SECURITY_200005_만_14세_미만의_어린이_회원은_보호자_동의가_필요합니다_,

    // 일반적임 메세지
    MSG_100001_로그인이_필요한_서비스_입니다_,
    MSG_100002_X0_님_관심멘토가_등록되었습니다_,
    MSG_100003_X0_님_관심직업_등록되었습니다_,
    MSG_100004_X0_님_관심수업_등록되었습니다_,
    MSG_100005_이미_등록된_관심_멘토입니다_,
    MSG_100006_이미_등록된_관심_직업입니다_,
    MSG_100007_이미_등록된_관심_수업입니다_,
    MSG_100008_X0_님_수업요청_등록되었습니다_,
    MSG_100009_X0_님_수업취소_되었습니다_,
    MSG_100010_수업시작_4일이전에만_취소가능합니다_,
    MSG_100011_X0_님_요청수업_취소되었습니다_,
    MSG_100012_중복된_수업시간이_존재합니다_,
    MSG_100013_대기상태의_다른수업이_존재합니다_,
    MSG_100014_수강정원_초과입니다_,
    MSG_100015_X0_님_수업신청_등록되었습니다_,
    MSG_100016_X0_님_수업대기신청_등록되었습니다_,
    MSG_100017_소속멘토가_등록되었습니다_,
    MSG_100018_이미_배정정보가_있습니다_,
    MSG_100019_저장하시겠습니까_,
    MSG_100020_수업취소_되었습니다_,


    // 유효성 관련 메시지들
    MSG_800000_이미_등록된_아이디_입니다_,
    MSG_800001_이용약관에_동의해_주세요_,
    MSG_800002_개인정보_수집이용에_동의해_주세요_,
    MSG_800003_이름을_입력_해_주세요_,
    MSG_800004_ID를_입력_해_주세요_,
    MSG_800005_ID가_형식에_맞지_않습니다_,
    MSG_800006_이메일을_입력_해_주세요_,
    MSG_800007_이메일이_형식에_맞지_않습니다_,
    MSG_800008_보호자_이메일을_입력_해_주세요_,
    MSG_800009_보호자_이메일이_형식에_맞지_않습니다_,
    MSG_800010_비밀번호를_입력_해_주세요_,
    MSG_800011_비밀번호가_형식에_맞지_않습니다__,
    MSG_800012_비밀번호가_맞지_않습니다_,
    MSG_800013_수업일시가_겹치는_수업이_이미_등록되어_있기_때문에_수업을_추가_할_수_없습니다_,
    MSG_800014_수업_개설중인_상태에서는_회원_탈퇴가_불가능합니다,
    MSG_800015_수업_신청을_할_수_없는_학교등급입니다,
    MSG_800016_기_등록된_직업이_존재합니다,
    MSG_800017_해당_직업명을_사용중인_멘토가_있습니다_멘토의_직업명을_변경_후_삭제해주세요_,
    MSG_800018_보호자_이메일과_회원의_이메일이_같을_수_없습니다_,
    MSG_800019_이미_등록된_이메일_입니다_,

    MSG_810001_ID가_형식에_맞지_않습니다__5자리___12자리_영문__숫자_및_기호__________만_가능합니다_,
    MSG_810002_비밀번호가가_형식에_맞지_않습니다__영문__숫자_또는_특수문자를_포함한_10_20자리가_가능합니다_,
    MSG_810003_테스트_수업은_최소_60분_전부터_가능합니다_,

    // 등록 실패 메시지
    MSG_900001_등록_되었습니다_,
    MSG_900002_등록_실패_하였습니다_,
    MSG_900003_수정_되었습니다_,
    MSG_900004_삭제_되었습니다_,
    MSG_900005_취소_실패_하였습니다_,
    MSG_900006_화상회의_개설에_실패_하였습니다_,
    MSG_900007_이메일이_발송되었습니다_,
    MSG_900008_수정_실패_하였습니다_,
    MSG_900009_삭제_실패_하였습니다_,
    MSG_900010_SMS가_발송되었습니다_,
    MSG_900011_메시지가_발송되었습니다_,
    // END
    ;

    private static final String MESSAGE_PATTERN = "^(ERROR|MSG|CODE|SECURITY)_(\\d+)_(.+)$";

    private String code;
    private String type;
    private String hint;

    CodeMessage() {
        LoggerFactory.getLogger(CodeMessage.class).debug("[Initialize] MessageCode.{}", name());

        if (!name().matches(MESSAGE_PATTERN)) {
            throw new RuntimeException("Not pattern: " + name());
        }

        Pattern pattern = Pattern.compile(MESSAGE_PATTERN);
        Matcher matcher = pattern.matcher(name());

        matcher.find();

        type = matcher.group(1);
        code = matcher.group(2);
        hint = matcher.group(3);
    }

    public String getCode() {
        return code;
    }

    public String getType() {
        return type;
    }

    public String getHint() {
        return  hint;
    }

    public String toMessage() {
        return MessageUtils.getMessage(code);
    }

    public String toMessage(Object... params) {
        return MessageUtils.getMessage(code, params);
    }

    public CnetException toException() {
        throw new CnetException(this);
    }

    public RuntimeException toException(Object... params) {
        return new CnetException(this, params);
    }

    public RuntimeException toExceptio(Throwable cause, Object... params) {
        return new CnetException(this, params, cause);
    }

}
//@formatter:on