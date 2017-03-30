package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.*;
import org.apache.poi.ss.formula.functions.T;

import java.util.List;
import java.util.Map;

public interface ArclInfoMapper {

  public ArclInfo<T> getLectureArclInfo(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getArclList(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getArticleListWithoutFile(ArclInfo<T> arclInfo);
  public int registArcl(ArclInfo<T> arclInfo);
  public int updateArcl(ArclInfo<T> arclInfo);
  public int deleteArcl(ArclInfo<T> arclInfo);
  public List<BoardPrefInfo> getBoardPrefInfoList(BoardPrefInfo boardPrefInfo);
  public List<ArclCmtInfoRS> listRecentPostscript();
  public List<Map<String, String>> getLastLectList(String mbrNo);
  public int insertAnswer(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getMentorDataArclList(ArclInfo<T> arclInfo);
  public int getNotiCount(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> lectureFiledResult(ArclInfo<T> arclInfo);
  public List<CompLectInfoDTO> selectCompLectList(CompLectInfoDTO compLectInfo);
  public List<ArclInfoDTO> getReplayInfoList(ArclInfoDTO dto);
  public ArclInfoDTO getReplayInfoDetail(ArclInfoDTO dto);
  public List<ArclInfo<T>> getSimpleNoticeList(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getSimpleArclList(ArclInfo<T> arclInfo);
  public List<ArclInfo<T>> getClassTaskList(ArclInfo<T> arclInfo);
  public ArclInfo<T> getSimpleArclInfo(ArclInfo<T> arclInfo);
  public int addVcnt(ArclInfo<T> arclInfo);
  public CompLectInfoDTO selectCompLectInfo(CompLectInfoDTO dto);
  public List<RatingDTO> listRating(RatingDTO ratingDTO);
  public List<RatingDTO> ratingListByLecture(RatingDTO ratingDTO);
  public List<RatingCmtDTO> listRatingCmt(RatingCmtDTO ratingCmtDTO);
  public RatingCmtDTO retrieveRatingCmt(RatingCmtDTO ratingCmtDTO);
  public List<LectArclDTO> lectList(LectArclDTO dto);

  public List<RatingDTO> getRatingByLecture(RatingDTO ratingDTO);
  public List<RatingDTO> getRatingByMentor(RatingDTO ratingDTO);
  public List<RatingCmtDTO> getLectureReview(RatingCmtDTO ratingCmtDTO);
  public int deleteLectureReview(RatingCmtDTO ratingCmtDTO);

  List<ArclInfo<T>> getArticleListJustNotiable(ArclInfo<T> arclInfo);

  int deleteArclReply(ArclInfo<T> arclInfo);

  /** 멘토포탈> 질문과답변, 수업과제 리스트 조회 */
  List<ArclInfo<T>> getMentorArclInfoList(ArclInfo<T> arclInfo);

  boolean isValidateArcl(Integer arclSer);
}