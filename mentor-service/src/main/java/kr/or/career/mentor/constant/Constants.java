package kr.or.career.mentor.constant;


public class Constants {
    //메뉴 코드 : 학교
    public final static String MNU_CODE_SCHOOL = "MNU00002";

    //메뉴 코드 : 멘토
    public final static String MNU_CODE_MENTOR = "MNU00027";
    public final static String MNU_CODE_MENTOR2 = "MNU00156";

    //메뉴 코드 : 관리자
    public final static String MNU_CODE_MANAGER = "MNU00050";
    public final static String MNU_CODE_MANAGER2 = "MNU00093";

    public final static String SCHOOL = "SCHOOL";
    public final static String MENTOR = "MENTOR";
    public final static String MANAGER = "MANAGER";

    //CNET_BOARD_INFO 테이블에 등록되어 있는 게시판 ID : 강의평가
//    public final static String BOARD_ID_LECTURE_RATING = "lecAppr";
    public static final String BOARD_ID_NOTICE = "mtNotice"; // 공지사항
    public static final String BOARD_ID_LEC_FILE = "lecFile"; // 수업자료(구)
    public static final String BOARD_ID_LEC_QNA = "lecQnA"; // 수업문의하기
    public static final String BOARD_ID_LEC_DATA = "lecData"; // 수업자료(신) - 자료등록
    public static final String BOARD_ID_LEC_REPLAY = "lecReplay"; // 다시보기
    public static final String BOARD_ID_FAQ = "mtFAQ"; // FAQ
    public static final String BOARD_ID_LEC_APPR = "lecAppr"; // 강의평가
    public static final String BOARD_ID_LEC_FREE_BOARD = "lecFreeBoard"; // 자유게시판
    public static final String BOARD_ID_LEC_WORK = "lecWork"; // 수업과제
    public static final String BOARD_ID_ETC_DATA = "etcData"; // 기타자료

    //유망멘토의 SEQUENCE를 만들때 시작값
    public final static int START_HOOFULT_MENTOR_SEQ = 3000000;

    public final static int START_RECOMMAND_LECTURE_SEQ = 2000000;

    public final static int LECTURE_CREATE_SUCCESS = 0x01;
    public final static int TOMMS_CREATE_SUCCESS = 0x10;

    public final static String IOS = "ios";

}
