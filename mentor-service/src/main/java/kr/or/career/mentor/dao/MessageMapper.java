/* ntels */
package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dao
 *    MessageMapper
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 1. 오후 6:44
 */
public interface MessageMapper {
    int insertSendMessage(SendAndResult sendAndResult);

    int updateSendMessage(SendAndResult sendAndResult);

    int insertSendMessageTarget(SendAndResult sendAndResult);

    int updateSendMessageTarget(SendAndResult sendAndResult);

    List<MessageReciever> selectLectureMessageReciever(LecturePayLoad payLoad);

    List<MessageReciever> selectMentorMessageReciever(LecturePayLoad payLoad);

    List<MessageReciever> selectMentorMessageRecieverForApprove(LecturePayLoad payLoad);

    List<MessageReciever> selectMemberMessageReciever(MemberPayLoad payLoad);

    //List<MessageReciever> selectClassMessageReciever(ClassPayLoad payLoad);

    LecturePayLoad selectLecturePayLoad(LecturePayLoad payLoad);
    LecturePayLoad selectLectureInfoPayLoad(LecturePayLoad payLoad);

    MemberPayLoad selectMemberPayLoad(MemberPayLoad payLoad);

    List<MessageReciever> selectMessageTarget(SearchOption searchOption);

    List<SendResultDTO> selectSmsSendResult(SendResultDTO sendResultDTO);


    List<SendResultDTO> selectSmsSendHistory(SendResultDTO sendResultDTO);

    SendResultDTO sendEmailView(SendResultDTO sendResultDTO);

    int deleteEmail(SendResultDTO sendResultDTO);

    List<MessageReciever> selectPushReciever(Message message);
    List<SendResultDTO> selectSmsSendResultTest(SendResultDTO sendResultDTO);

}
