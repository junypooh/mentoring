package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ArclRecomHist {
  private int arclSer;
  private int cmtSer;
  private String recomMbrNo;
  private Date recomDtm;
}
