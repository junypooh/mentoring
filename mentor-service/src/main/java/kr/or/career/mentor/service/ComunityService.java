/* ntels */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.*;
import org.apache.poi.ss.formula.functions.T;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    ComunityService
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 20. 오후 11:42
 */
public interface ComunityService {

  public ArclInfo<T> getLectureArticleInfo(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getArticleList(ArclInfo<T> arclInfo);
  List<ArclInfo<T>> getArticleListWithNotiable(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getArticleListWithoutFile(ArclInfo<T> arclInfo);
  public int registArcl(ArclInfo<T> arclInfo, String fileSers);
  public int updateArcl(ArclInfo<T> arclInfo, String fileSers);
  public int deleteArcl(ArclInfo<T> arclInfo);
    int deleteArclReply(ArclInfo<T> arclInfo);
  public List<ArclCmtInfo>getCmtInfoList(ArclCmtInfo arclCmtInfo);
  public int registCmt(ArclCmtInfo arclCmtInfo);
  public int deleteCmt(ArclCmtInfo arclCmtInfo);
  public List<BoardPrefInfo> getBoardPrefInfoList(BoardPrefInfo boardPrefInfo);
  public List<ArclCmtInfoRS> listRecentPostscript();
  public List<Map<String, String>> getLastLectList(String mbrNo);
  public int insertArclFileInfo(ArclFileInfo arclFileInfo);
  public int deleteArclFileInfoByArclSer(ArclFileInfo arclFileInfo);
  public int insertAnswer(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getMentorDataArclList(ArclInfo<T> arclInfo);
  public int getNotiCount(ArclInfo<T> arclInfo);
  public int isGradeYn(ArclCmtInfo arclCmtInfo);

  public int registLectureDataArcl(ArclInfo<T> arclInfo) throws Exception;
  public List<ArclInfo<T>> lectureFiledResult(ArclInfo<T> arclInfo);

  public List<CompLectInfoDTO> selectCompLectList(CompLectInfoDTO compLectInfo);
  public CompLectInfoDTO selectCompLectInfo(CompLectInfoDTO dto);

  public List<ArclInfoDTO> getReplayInfoList(ArclInfoDTO dto);
  public ArclInfoDTO getReplayInfoDetail(ArclInfoDTO dto);

  public List<ArclInfo<T>> getSimpleArclList(ArclInfo<T> arclInfo);
  public ArclInfo<T> getSimpleArclInfo(ArclInfo<T> arclInfo);
  public int addVcnt(ArclInfo<T> arclInfo);

  public List<ArclFileInfo> getFileInfoList(ArclInfo<T> arclInfo);

  public List<ArclCmtInfo> getSimpleCmtInfoList(ArclCmtInfo arclCmtInfo);

  public int updateCmt(ArclCmtInfo arclCmtInfo);

  public List<RatingDTO> listRating(RatingDTO ratingDTO);
  public List<RatingDTO> ratingListByLecture(RatingDTO ratingDTO);
  public List<RatingCmtDTO> listRatingCmt(RatingCmtDTO ratingCmtDTO);
  public RatingCmtDTO retrieveRatingCmt(RatingCmtDTO ratingCmtDTO);

  public List<LectArclDTO> lectList(LectArclDTO dto);

  /** 게시판 머리말 정보 조회 */
  public List<BoardPrefInfo> getBoardPrefInfo(String boardId);

  /** 수업과제 목록 조회 */
  public List<ArclInfo<T>> getClassTaskList(ArclInfo<T> arclInfo);

  /** 공지사항 목록 조회 */
  public Map<String, Object> getNoticeList(ArclInfo<T> arclInfo);

  /** 평점조회 후기 > 수업별 목록 조회 */
  public List<RatingDTO> getRatingByLecture(RatingDTO ratingDTO) throws Exception;

  /** 평점조회 > 멘토별 목록 조회 */
  public List<RatingDTO> getRatingByMentor(RatingDTO ratingDTO);

  /** 수업후기 목록 조회 */
  public List<RatingCmtDTO> getLectureReview(RatingCmtDTO ratingCmtDTO) throws Exception;

  /** 수업후기 상세 삭제 */
  public int deleteLectureReview(RatingCmtDTO ratingCmtDTO);

  /** 멘토포탈 > 질문과답변, 수업과제 리스트 조회 */
  public List<ArclInfo<T>> getMentorArclInfoList(ArclInfo<T> arclInfo);


}