package kr.or.career.mentor.service;

import java.util.List;

import kr.or.career.mentor.domain.ClasSetHist;
import kr.or.career.mentor.domain.CoInfo;
import kr.or.career.mentor.domain.Code;

public interface CodeManagementService {

    Code retireveCode(String cd);
    List<Code> listCode(Code code);

    List<Code> listCodeBySupCd(String supCd);

    List<Code> listUseCodeBySupCd(String supCd);

    List<Code> listCodeWithPaging(Code code);

    int saveCode(List<Code> listCode);

    ClasSetHist retrieveClasSetHist();

    Integer insertClasSetHist(ClasSetHist clasSetHist);

    List<CoInfo> listCoInfo(CoInfo coInfo);

    void insertCoInfo(CoInfo coInfo);

    void updateCoInfo(CoInfo coInfo);

    List<Code> listSchSgguNm();

    Integer deleteCode(Code code);

}
