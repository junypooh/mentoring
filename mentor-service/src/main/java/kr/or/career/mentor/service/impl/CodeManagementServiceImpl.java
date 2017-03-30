package kr.or.career.mentor.service.impl;

import java.util.List;

import kr.or.career.mentor.dao.CoInfoMapper;
import kr.or.career.mentor.dao.CodeMapper;
import kr.or.career.mentor.domain.ClasSetHist;
import kr.or.career.mentor.domain.CoInfo;
import kr.or.career.mentor.domain.Code;
import kr.or.career.mentor.service.CodeManagementService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("codeManagementService")
public class CodeManagementServiceImpl implements CodeManagementService {

    @Autowired
    private CodeMapper codeMapper;

    @Autowired
    private CoInfoMapper coInfoMapper;

    @Override
    public Code retireveCode(String cd) {
        return codeMapper.retrieveCode(cd);
    }

    @Override
    public List<Code> listCode(Code code) {
        return codeMapper.listCode(code);
    }

    @Override
    public List<Code> listCodeBySupCd(String supCd) {
        Code code = new Code();
        code.setSupCd(supCd);
        return codeMapper.listCode(code);
    }

    @Override
    public List<Code> listUseCodeBySupCd(String supCd) {
        Code code = new Code();
        code.setSupCd(supCd);
        code.setUseYn("Y");
        return codeMapper.listCode(code);
    }

    @Override
    public List<Code> listCodeWithPaging(Code code) {
        return codeMapper.listCodeWithPaging(code);
    }

    @Override
    public int saveCode(List<Code> listCode) {
        int cnt = 0;
        for (Code code : listCode) {
            codeMapper.saveCode(code);
        }
        return cnt;
    }

    @Override
    public Integer insertClasSetHist(ClasSetHist clasSetHist) {
        return codeMapper.insertClasSetHist(clasSetHist);
    }

    @Override
    public ClasSetHist retrieveClasSetHist() {
        return codeMapper.retrieveClasSetHist();
    }

    @Override
    public List<CoInfo> listCoInfo(CoInfo coInfo) {
        return coInfoMapper.listCoInfo(coInfo);
    }

    @Override
    public void insertCoInfo(CoInfo coInfo) {
        coInfoMapper.insertCoInfo(coInfo);
    }

    @Override
    public void updateCoInfo(CoInfo coInfo) {
        coInfoMapper.updateCoInfo(coInfo);
    }

    @Override
    public List<Code> listSchSgguNm() {
        return codeMapper.listSchSgguNm();
    }

    @Override
    public Integer deleteCode(Code code) {return codeMapper.deleteCode(code); }

}
