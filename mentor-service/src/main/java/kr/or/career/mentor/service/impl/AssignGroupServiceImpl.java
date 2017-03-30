/* license */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.AssignGroupMapper;
import kr.or.career.mentor.dao.LectureInfomationMapper;
import kr.or.career.mentor.dao.CoInfoMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.AssignGroupService;
import kr.or.career.mentor.util.ApplicationContextUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;


/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    AssignGroupServiceImpl.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 21. 오후 11:15:25
 * @author  technear
 * @see
 */
@Service
@Slf4j
public class AssignGroupServiceImpl implements AssignGroupService {
    @Autowired
    private AssignGroupMapper assignGroupMapper;

    @Autowired
    private CoInfoMapper coInfoMapper;

    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;



    @Override
    public List<BizSetInfo> listAssignGroup(BizGrpSearch bizGrpSearch){
        return assignGroupMapper.listAssignGroup(bizGrpSearch);
    }

    @Override
    public List<BizSetInfo> listSchAssignGroup(BizGrpSearch bizGrpSearch){
        return assignGroupMapper.listSchAssignGroup(bizGrpSearch);
    }

    @Override
    public List<SchInfo> listAssignSchool(BizGrpInfo bizGrpInfo){
        return assignGroupMapper.listAssignSchool(bizGrpInfo);
    }

    @Override
    public BizSetInfo retrieveAssignGroup(BizSetInfo bizSetInfo){
        return assignGroupMapper.retrieveAssignGroup(bizSetInfo);
    }

    /**
     * 학교 배정 정보 추가
     *
     * @see kr.or.career.mentor.service.AssignGroupService#insertAssignSchool(kr.or.career.mentor.domain.BizGrpInfo, kr.or.career.mentor.domain.User)
     * @param bizGrpInfo
     * @param user
     * @return
     */
    @Override
    public List<SchInfo> insertAssignSchool(BizGrpInfo bizGrpInfo, User user) {
        //이미 배정한 학교 배정 그룹 - 중복 제거후 저장

        /*List<SchInfo> dupSchInfo = assignGroupMapper.listAssignSchool(bizGrpInfo);
        List<SchInfo> tmpSchInfo = new ArrayList<>();
        tmpSchInfo.addAll(dupSchInfo);
        bizGrpInfo.setRegMbrNo(user.getMbrNo());
        List<SchInfo> targetSchInfo = bizGrpInfo.getListSchInfo();
        for(int i=targetSchInfo.size()-1 ; i >= 0 ; i--){
            for(int j=0; j < tmpSchInfo.size() ; j++){
                if(targetSchInfo.get(i).getSchNo().equals(tmpSchInfo.get(j).getSchNo())){
                    targetSchInfo.remove(i);
                    tmpSchInfo.remove(j);
                    break;
                }
            }
        }*/



        DefaultSqlSessionFactory sqlSessionFactoryBean = (DefaultSqlSessionFactory) ApplicationContextUtils.getBean("sqlSessionFactory");

        SqlSession sqlSession = sqlSessionFactoryBean.openSession(ExecutorType.BATCH);

        try {
            for (final SchInfo schInfo : bizGrpInfo.getListSchInfo()) {
                bizGrpInfo.setRegMbrNo(user.getMbrNo());
                bizGrpInfo.setSchNo(schInfo.getSchNo());
                sqlSession.insert("insertAssignSchool", bizGrpInfo);
            }

            sqlSession.flushStatements();

            Integer setChgSeq = assignGroupMapper.getMaxSetChgSeq();
            bizGrpInfo.setSetChgSeq(setChgSeq);
                for (SchInfo schInfo : bizGrpInfo.getListSchInfo()) {
                    bizGrpInfo.setRegMbrNo(user.getMbrNo());
                    bizGrpInfo.setSchNo(schInfo.getSchNo());
                    bizGrpInfo.setClasPermCnt(bizGrpInfo.getClasPermCnt());
                    sqlSession.insert("insertAssignSchoolHist", bizGrpInfo);
                }
            sqlSession.flushStatements();

            sqlSession.commit();
        }catch (DataAccessException e){
            log.error(e.getMessage());
            sqlSession.rollback();
        }finally {
            sqlSession.close();
        }

        return bizGrpInfo.getListSchInfo();
    }

    @Override
    @Transactional
    public List<SchInfo> saveBizGrpInfo(BizSetInfo bizSetInfo, User user) {
        int rtn = 0;
        List<SchInfo> listDuplSch = null;
        BizGrpInfo bizGrpInfo = bizSetInfo.getBizGrpInfo();

        bizGrpInfo.setRegMbrNo(user.getMbrNo());
        bizSetInfo.setRegMbrNo(user.getMbrNo());
        if(StringUtils.isEmpty(bizSetInfo.getSetTargtCd())){
            bizSetInfo.setSetTargtCd(CodeConstants.CD101599_101601_사업그룹);
        }

        String instMbrNo = "";
        CoInfo coInfo = new CoInfo();
        coInfo.setCoNo(bizGrpInfo.getCoNo());
        if(coInfo != null){
            instMbrNo = coInfoMapper.getInstMbrNo(coInfo);
            if(StringUtils.isNotEmpty(instMbrNo))
                bizGrpInfo.setInstMbrNo(instMbrNo);
            else
                bizGrpInfo.setInstMbrNo(user.getMbrNo());
        }else {
            bizGrpInfo.setInstMbrNo(user.getMbrNo());
        }


        //학교 자체 배정인 경우 날짜가 겹치지 않는지 확인
        /*
        if(bizGrpInfo.getListSchInfo() != null && bizGrpInfo.getListSchInfo().size() > 0
                && bizSetInfo.getSetTargtCd().equals(CodeConstants.CD101599_101600_학교)){
            listDuplSch = assignGroupMapper.listSchoolAssign(bizSetInfo);

            if(listDuplSch  != null && listDuplSch.size() > 0){
                //학교 자체 배정 정보 중에서 기간중복건이 있으면
                return listDuplSch;
            }
        }  */

        if(StringUtils.isEmpty(bizGrpInfo.getGrpNo())){//신규
            //사업그룹정보
            assignGroupMapper.insertBizGrpInfo(bizGrpInfo);
            bizSetInfo.setSetSer(bizGrpInfo.getGrpNo());
            bizSetInfo.setSetTargtNo(bizGrpInfo.getGrpNo());
            //사업설정정보
            rtn = assignGroupMapper.insertBizSetInfo(bizSetInfo);
        }else{//수정
            assignGroupMapper.updateBizGrpInfo(bizGrpInfo);
            rtn = assignGroupMapper.updateBizSetInfo(bizSetInfo);
        }


        bizGrpInfo.setSetSer(Integer.valueOf(bizGrpInfo.getGrpNo()));
        if( bizGrpInfo.getListSchInfo() != null && bizGrpInfo.getListSchInfo().size() > 0){
            bizGrpInfo.setSchChgClassCd("101711");
            bizGrpInfo.setClasPermCnt(Integer.valueOf(bizSetInfo.getClasCnt()));
            insertAssignSchool(bizGrpInfo, user);
        }
        return listDuplSch;
    }

    /**
     * <pre>
     *     배정그룹 엑셀다운로드
     * </pre>
     * @param bizGrpSearch
     * @return
     */
    @Override
    public List<AssignGroupExcelDTO> excelDownListAssignGroup(BizGrpSearch bizGrpSearch) {
        return assignGroupMapper.excelDownListAssignGroup(bizGrpSearch);
    }

    /**
     * <pre>
     *     배정관리 그룹 수정
     * </pre>
     * @param bizSetInfo
     */
    @Override
    @Transactional
    public void modifyAssignGroupPoc(BizSetInfo bizSetInfo, User user) {

        BizGrpInfo bizGrpInfo = bizSetInfo.getBizGrpInfo();
        bizGrpInfo.setRegMbrNo(user.getMbrNo());

        // BIZ_GRP_INFO : GRP_NM(배정그룹명) 수정
        assignGroupMapper.updateBizGrpInfo(bizSetInfo.getBizGrpInfo());

        // 배정학교 All Insert
        if( bizGrpInfo.getListSchInfo() != null && bizGrpInfo.getListSchInfo().size() > 0){
            insertAssignSchool(bizGrpInfo, user);
        }

    }

    /**
     * <pre>
     *     배정그룹 배정학교삭제
     * </pre>
     * @param bizSetInfo
     */
    @Override
    @Transactional
    public String deleteAssignSchool(BizSetInfo bizSetInfo, User user) {

        String rtnStr = "FAIL";
        int delChk = 0;

        BizGrpInfo bizGrpInfo = bizSetInfo.getBizGrpInfo();
        List<SchInfo> targetSchInfo = bizGrpInfo.getListSchInfo();

        if(targetSchInfo != null){
            for(SchInfo schInfo : targetSchInfo){
                SchInfo schoolInfo = new SchInfo();

                // 배정학교 Checked 삭제
                schoolInfo.setGrpNo(bizGrpInfo.getGrpNo());
                schoolInfo.setSchNo(schInfo.getSchNo());

                delChk = delChk + assignGroupMapper.deleteTargetSchGrpMapp(schoolInfo);
            }

            if(delChk == targetSchInfo.size()) {
                rtnStr = "SUCC";
            }
        }


        DefaultSqlSessionFactory sqlSessionFactoryBean = (DefaultSqlSessionFactory) ApplicationContextUtils.getBean("sqlSessionFactory");

        SqlSession sqlSession = sqlSessionFactoryBean.openSession(ExecutorType.BATCH);

        try {
            sqlSession.flushStatements();

            Integer setChgSeq = assignGroupMapper.getMaxSetChgSeq();
            bizGrpInfo.setSetChgSeq(setChgSeq);
            for(int j=0;j<=3;j++) {
                for (SchInfo schInfo : bizGrpInfo.getListSchInfo()) {
                    bizGrpInfo.setRegMbrNo(user.getMbrNo());
                    bizGrpInfo.setSchNo(schInfo.getSchNo());
                    bizGrpInfo.setClasPermCnt(bizGrpInfo.getClasPermCnt());
                    sqlSession.insert("insertAssignSchoolHist", bizGrpInfo);
                }
            }
            sqlSession.flushStatements();

            sqlSession.commit();
        }catch (DataAccessException e){
            log.error(e.getMessage());
            sqlSession.rollback();
        }finally {
            sqlSession.close();
        }

        return rtnStr;
    }

    /**
     * <pre>
     *     배정그룹 삭제
     * </pre>
     * @param bizGrpInfo
     */
    @Override
    @Transactional
    public String deleteAssignGroupPoc(BizGrpInfo bizGrpInfo) {

        String rtnStr = "";
        int delChk = 0;

        // 배정학교 Delete
        delChk = delChk + assignGroupMapper.deleteSchGrpMapp(bizGrpInfo);

        // 배정그룹설정 Delete
        delChk = delChk + assignGroupMapper.deleteBizSetInfo(bizGrpInfo);

        // 배정그룹 Delete
        delChk = delChk + assignGroupMapper.deleteBizGrpInfo(bizGrpInfo);

        if(delChk >= 2) {
            rtnStr = "SUCC";
        }

        return rtnStr;
    }

    /**
     * <pre>
     *     배정학교 추가시 중복 체크
     * </pre>
     * @param bizGrpInfo
     */
    @Override
    public List<SchInfo> dupListAssignSchool(BizGrpInfo bizGrpInfo) {
        List<SchInfo> rtnList = new ArrayList<>();

        List<SchInfo> listSchInfo = new ArrayList<>();

        String[] arrSchNo = bizGrpInfo.getSchNo().split("\\|");
        for(String schNo : arrSchNo){
            SchInfo schInfo = new SchInfo();
            schInfo.setSchNo(schNo);

            listSchInfo.add(schInfo);
        }

        bizGrpInfo.setListSchInfo(listSchInfo);
        if(bizGrpInfo.getListSchInfo() != null && bizGrpInfo.getListSchInfo().size() > 0){
            rtnList = assignGroupMapper.dupListAssignSchool(bizGrpInfo);
        }

        return rtnList;
    }


    @Override
    public List<SchInfo> listSidoInfo(SchInfo schInfo) {
        return assignGroupMapper.listSidoInfo(schInfo);
    }

    @Override
    public List<SchInfo> listSgguInfo(SchInfo schInfo) {
        return assignGroupMapper.selectSgguInfo(schInfo);
    }


    @Override
    public List<SchInfo> schoolTcherInfo(SchInfo schInfo) {
        return assignGroupMapper.schoolTcherInfo(schInfo);
    }

    @Override
    public List<SchInfo> schoolClassRoomInfo(SchInfo schInfo) {
        return assignGroupMapper.schoolClassRoomInfo(schInfo);
    }

    @Override
    public List<SchInfo> schoolClassRoomHistory(SchInfo schInfo) {
        return assignGroupMapper.schoolClassRoomHistory(schInfo);
    }


    @Override
    public List<SchInfo> schoolAssignGroupState(BizGrpSearch bizGrpSearch) {
        return assignGroupMapper.schoolAssignGroupState(bizGrpSearch);
    }

    @Override
    public List<SchInfo> schoolClassRoomRepresent(SchInfo schInfo) {
        return assignGroupMapper.schoolClassRoomRepresent(schInfo);
    }


    @Override
    public List<SchInfo> schoolClassTcherRepresent(SchInfo schInfo) {
        return assignGroupMapper.schoolClassTcherRepresent(schInfo);
    }



    /**
     * <pre>
     *     교사/학생 현황 삭제
     * </pre>
     * @param schInfo
     */
    @Override
    @Transactional
    public String deleteSchoolTcher(SchInfo schInfo) {

        String rtnStr = "";
        int delChk = 0;

        // 배정학교 Delete

        String delTch[] = schInfo.getClasRoomSers().split(",");
        if(delTch != null) {
            for(int i=0;i<delTch.length;i++) {
                schInfo.setClasRoomSer(delTch[i]);
                delChk = delChk + assignGroupMapper.deleteSchoolTcher(schInfo);
            }
        }

        if(delTch.length == delChk){
            rtnStr = "SUCC";
        }


        return rtnStr;
    }


    /**
     * <pre>
     *     교실 정보 삭제
     * </pre>
     * @param schInfo
     */
    @Override
    @Transactional
    public String deleteSchoolRoom(SchInfo schInfo) {
        String rtnStr = "";
        int delChk = 0;

        delChk = delChk + assignGroupMapper.deleteSchoolTcher(schInfo);
        delChk = delChk + assignGroupMapper.deleteSchoolRoom(schInfo);

        if(delChk == 2){
            rtnStr = "SUCC";
        }

        return rtnStr;
    }

    /**
     * <pre>
     *     강의 신청 횟수 등록/수정
     * </pre>
     * @param bizGrpInfo
     */
    @Override
    @Transactional
    public String saveAssignLectAppl(BizGrpInfo bizGrpInfo, User user) {

        String rtnStr = "";
        int delChk = 0;
        try {
            assignGroupMapper.updateBizGrpInfo(bizGrpInfo);
            lectureInfomationMapper.updateLectureAppl(bizGrpInfo);

            List<SchInfo> listSchInfo = new ArrayList<>();
            LectureSearch lectureSearch = null;
            listSchInfo = bizGrpInfo.getListSchInfo();
            int ordCnt = 0;
            if (listSchInfo != null) {
                for (int i = 0; i < listSchInfo.size(); i++) {
                    bizGrpInfo.setSchNo(listSchInfo.get(i).getSchNo());
                    bizGrpInfo.setClasPermCnt(listSchInfo.get(i).getClasPermCnt());

                /*LectApplCnt lectApplCnt = new LectApplCnt();
                lectApplCnt.setSchNo(listSchInfo.get(i).getSchNo());
                lectApplCnt.setSetSer(bizGrpInfo.getSetSer());
                LectApplCnt lectApplCntReuslt = lectureInfomationMapper.retireveLectApplCntReuslt(lectApplCnt);
                bizGrpInfo.getListSchInfo().get(i).setOrdSchNo("N");
                if(lectApplCntReuslt != null) {
                    if (lectApplCntReuslt.getClasPermCnt() == listSchInfo.get(i).getClasPermCnt()) {
                        bizGrpInfo.getListSchInfo().get(i).setOrdSchNo("Y");
                        ordCnt++;
                    }
                }*/
                    delChk = delChk + assignGroupMapper.saveAssignLectAppl(bizGrpInfo);
                }
                if (listSchInfo.size() > ordCnt) {
                    DefaultSqlSessionFactory sqlSessionFactoryBean = (DefaultSqlSessionFactory) ApplicationContextUtils.getBean("sqlSessionFactory");

                    SqlSession sqlSession = sqlSessionFactoryBean.openSession(ExecutorType.BATCH);

                    try {

                        sqlSession.flushStatements();

                        Integer setChgSeq = assignGroupMapper.getMaxSetChgSeq();
                        bizGrpInfo.setSetChgSeq(setChgSeq);
                        for (SchInfo schInfo : bizGrpInfo.getListSchInfo()) {
                            bizGrpInfo.setRegMbrNo(user.getMbrNo());
                            bizGrpInfo.setSchNo(schInfo.getSchNo());
                            bizGrpInfo.setClasPermCnt(bizGrpInfo.getClasPermCnt());
                            sqlSession.insert("insertAssignSchoolHist", bizGrpInfo);
                        }
                        sqlSession.flushStatements();

                        sqlSession.commit();
                    } catch (DataAccessException e) {
                        log.error(e.getMessage());
                        sqlSession.rollback();
                    } finally {
                        sqlSession.close();
                    }

                }
            }


            if (delChk == listSchInfo.size()) {
                rtnStr = "SUCC";
            }
        }catch (Exception e){
            rtnStr = "ERROR";
        }

        return rtnStr;
    }


    @Override
    public List<BizSetInfo> listAssignGroupHist(BizGrpSearch bizGrpSearch){
        return assignGroupMapper.listAssignGroupHist(bizGrpSearch);
    }



    @Override
    @Transactional
    public String assignGroupName(BizGrpInfo bizGrpInfo) {
        String rtnStr = "";
        int cnt = 0;

        cnt = assignGroupMapper.assignGroupName(bizGrpInfo);
        if(cnt == 0) {
            rtnStr = "SUCC";
        }

        return rtnStr;
    }


    @Override
    public List<BizGrpInfo> listAssignGroupByDistinct() {
        return assignGroupMapper.listAssignGroupByDistinct();
    }
}

