/* ntels */
package kr.or.career.mentor.constant;

/**
 * <pre>
 * kr.or.career.mentor.constant
 *    LectureMessageType
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 29. 오후 3:52
 */
public enum MessageType {

    LECTURE_APPLY,                   /* TO : 신청당사자(교사) -> Session정보 */
    LECTURE_SCHEDULED,               /* TO : 수업 신청상태가 신청,확정인 수업 신청 교사들 -> 대상 수업 신청 교사들 */
    LECTURE_STANDBY,                 /* TO : 교사가 신청시 대기상태로 신청된 신청당사자(교사) -> Session정보 */
    LECTURE_STANDBY_CONFIRM,         /* TO : 관리자,배치프로세스 의해 수업신청상태가 신청 -> 확정 변경된 신청 (교사) */
    LECTURE_STANDBY_CANCEL,          /* TO : 모집마감시 배치프로세스 의해 수업신청상태가 신청 -> 취소 변경된 신청 교사들 */
    LECTURE_CANCEL_LECTURE,          /* TO : 관리자에 의해 수업취소 승인 완료시 해당 수업의 수업신청상태가 신청, 승인, 확정 상태인 신청 교사들 */
    LECTURE_CANCEL_SELF,             /* TO : 교사가 본인이 신청한 수업에 대하여 취소한 경우 */
    LECTURE_OPEN,                    /* TO : 관리자가 수업개설 요청에 대해 승인처리를 한 경우에 수업개설 멘토에게 메시지 발송 */
    LECTURE_CONFIRM,                 /* TO : 배치프로세스에서 수업의 수강모집이 완료되었을때 수업개설 멘토에게 메시지 발송 */
    LECTURE_CLOSE,                   /* TO : 관리자, 배치프로세스에서 수업이 폐지될 시 멘토,교사에게 메시지 발송  */
    ADMIN_APPROVE,                 /*  관리자 승인 */
    ADMIN_RETURN,                  /*  관리자 반려 */

    JOIN_SCHOOL,                    /* 학교회원가입 */
    JOIN_AGREE,                     /* 14세 미만 가입 동의 */
    SEARCH_INFO,                    /* 회원 정보 찾기 */
    SECEDE_SCHOOL,                  /* 학교포탈 탈퇴완료 */
    JOIN_MENTOR,                    /* 멘토포탈 가입완료 */
    JOIN_APPLY,                     /* 멘토포탈 가입신청 */
    SECEDE_MENTOR_APPLY,            /* 멘토포탈 탈퇴신청 */
    SECEDE_MENTOR,                  /* 멘토포탈 탈퇴완료 */
    JOIN_CONFIRM,                   /* 멘토포탈 가입신청 승인 */
    JOIN_REJECT,                    /* 멘토포탈 가입신청 반려 */
    JOIN_CONFIRM_ADMIN,             /* 관리자 회원가입 완료  */
    RESET_PASSWD_BYADMIN,             /* 관리자에 의한 패스워드 reset */
    JOIN_CONFIRM_MENTOR_ADMIN,      /* 멘토포탈 어드민 가입완료 */


    SIMPLE_MESSAGE,                 /* 일반 메시지 */
    SCH_PWD_RESET,             /* 학교관리자 비밀번호 초기화  */

    MENTOR_APPROVE,             /* 개인 멘토 가입 신청 승인 */
    MENTOR_RETURN,              /* 개인 멘토 가입 신청 반려 */
    SECEDE_RETURN_MENTOR,       /* 멘토 서비스 회원 탈퇴 신청 반려 */

    ;

    private String code;



}
