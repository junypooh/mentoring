/* license */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.AssignGroupMapper;
import kr.or.career.mentor.dao.SchInfoMapper;
import kr.or.career.mentor.dao.UserMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.security.EgovFileScrty;
import kr.or.career.mentor.service.SchInfoService;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    SchInfoServiceImpl.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 22. 오후 5:41:34
 * @author  technear
 * @see
 */
@Service
@Slf4j
public class SchInfoServiceImpl implements SchInfoService{

    @Autowired
    private SchInfoMapper schInfoMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private AssignGroupMapper assignGroupMapper;

    @Override
    public List<SchInfo> listSchInfo(SchInfo schInfo) {
        return schInfoMapper.listSchInfo(schInfo);
    }

    @Override
    public List<SchInfoDTO> listSchInfoWithGroup(BizGrpSearch bizGrpSearch) {
        return schInfoMapper.listSchInfoWithGroup(bizGrpSearch);
    }

    @Override
    public SchInfoDTO retrieveSchInfoDetail(SchInfo schInfo) {
        return schInfoMapper.retrieveSchInfoDetail(schInfo);
    }

    @Override
    public SchInfo retrieveSchInfo(SchInfo schInfo) {
        return schInfoMapper.retrieveSchInfo(schInfo);
    }

    public List<AssignGroupDTO> listAssignGroupListBySchool(SchInfo schInfo){
        return assignGroupMapper.listAssignGroupListBySchool(schInfo);
    }

    @Override
    public void saveSchInfo(SchInfo schInfo) {
        User sessionUser = SessionUtils.getUser();
        if(StringUtils.isEmpty(schInfo.getSchNo())){
            schInfoMapper.insertSchInfo(schInfo);

        }else{
            schInfoMapper.updateSchInfo(schInfo);
        }

        if(StringUtils.isEmpty(schInfo.getMbrNo())) {
            User user = new User();
            user.setId(schInfo.getUserId());
            user.setUsername(schInfo.getUsername());
            user.setTel(schInfo.getTel());
            user.setEmailAddr(schInfo.getEmailAddr());
            user.setMbrClassCd("101707");
            user.setMbrCualfCd("101708");
            user.setMbrGradeCd("4");
            user.setPassword(EgovFileScrty.encryptPassword(schInfo.getPassword(), user.getId()));
            user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
            user.setRegMbrNo(sessionUser.getMbrNo());
            userMapper.insertUser(user);
            schInfo.setRegMbrNo(sessionUser.getMbrNo());
            schInfo.setMbrNo(user.getMbrNo());
            schInfo.setSchMbrCualfCd("101699");
            schInfo.setCualfRegStatCd("101702");
            schInfoMapper.insertSchCualf(schInfo);
        }else{
            User user = new User();
            if(!schInfo.getPassword().equals("") && schInfo.getPassword() != null) {
                user.setPassword(EgovFileScrty.encryptPassword(schInfo.getPassword(), schInfo.getUserId()));
                user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
            }
            user.setMbrNo(schInfo.getMbrNo());
            user.setUsername(schInfo.getUsername());
            user.setTel(schInfo.getTel());
            user.setEmailAddr(schInfo.getEmailAddr());
            user.setChgMbrNo(sessionUser.getMbrNo());
            userMapper.updateUser(user);
        }

        schInfoMapper.deleteSchDevice(schInfo);
        if(schInfo.getDeviceTypeHold() != null) {
            String getDeviceTypeHold [] = schInfo.getDeviceTypeHold().split(",");
            for(String str : getDeviceTypeHold){
                schInfo.setDeviceTypeHold(str);
                schInfo.setMbrNo(schInfo.getMbrNo());
                schInfoMapper.insertSchDevice(schInfo);
            }

        }
        schInfoMapper.deleteSchJobGroup(schInfo);
        if(schInfo.getSchJobGroup() != null) {
            for(int j=0;j<schInfo.getSchJobGroup().size();j++){
                SchJobGroup schJobGroup = schInfo.getSchJobGroup().get(j);
                schJobGroup.setRegMbrNo(schInfo.getMbrNo());
                schJobGroup.setSchNo(schInfo.getSchNo());
                schInfoMapper.insertSchJobGroup(schJobGroup);
            }
        }
    }

    @Override
    public List<SchInfoExcelDTO> excelDownListSchInfoWithGroup(BizGrpSearch bizGrpSearch) {
        List<SchInfoExcelDTO> schInfoExcelDTOList = schInfoMapper.excelDownListSchInfoWithGroup(bizGrpSearch);

        for(SchInfoExcelDTO schInfoExcelDTO: schInfoExcelDTOList){

            if(!(schInfoExcelDTO.getAppliedSchLectInfos().size() == 1 && schInfoExcelDTO.getAppliedSchLectInfos().get(0).getLectSer() == null)){
                for(AppliedSchLectInfo appliedSchLectInfo : schInfoExcelDTO.getAppliedSchLectInfos()) {
                    schInfoExcelDTO.getLectDateTime().add(appliedSchLectInfo.getLectDateTime());
                    schInfoExcelDTO.getLectTitle().add(appliedSchLectInfo.getLectTitle());
                }
            }
        }

        return schInfoExcelDTOList;
    }

    @Override
    public Integer deleteSchCualf(SchInfo schInfo) {
        return schInfoMapper.deleteSchCualf(schInfo);
    }

    @Override
    public Integer insertSchCualf(List<SchInfo> schInfos, Authentication authentication) {

        int rtnVal = 0;
        User user = (User)authentication.getPrincipal();
        for(SchInfo schInfo : schInfos) {
            schInfo.setRegMbrNo(user.getMbrNo());
            rtnVal += schInfoMapper.insertSchCualf(schInfo);
        }

        return rtnVal;
    }

    @Override
    public List<SchJobGroup> listSchJobGroupInfo(SchJobGroup schJobGroup) {
        return schInfoMapper.listSchJobGroupInfo(schJobGroup);
    }


}
