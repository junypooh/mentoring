/* ntels */
package kr.or.career.mentor.controller;

import com.google.common.collect.Lists;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.LectureInfomationMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ClassroomService;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.formula.functions.T;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;


/**
 * <pre> kr.or.career.mentor.controller LayerPopupLectureApply
 *
 * 수업신청 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-07 오후 6:07
 */
@Controller
@RequestMapping("layer")
public class LayerPopupLectureApplyController {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    LectureManagementService lectureManagementService;

    @Autowired
    ClassroomService classroomService;

    @Autowired
    CodeManagementService codeManagementService;


    @Autowired
    private ComunityService comunityService;

    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;


    /**
     * <pre> 수업신청(수업신청대기) 팝업화면 onload </pre>
     * 
     * @param model
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("layerPopupLectureApply.do")
    public void onLoadLayerPopupLectureApply(Model model, HttpServletRequest request, LectureSearch lectureSearch) throws Exception {


        //수업정보 조회
        LectInfo lectureInfo = lectureManagementService.lectureInfo(lectureSearch);
        //수업 차수 및 회차 정보 조회
        LectTimsInfo lectTimsInfo = lectureManagementService.lectureTimsSchdInfo(lectureSearch);

        model.addAttribute("lectTimsInfo", lectTimsInfo);    //수업 차수&회차 정보
        model.addAttribute("lectInfo", lectureInfo);         //수업정보
        model.addAttribute("applClassCd", lectureSearch.getApplClassCd());         //수업정보
    }


    /**
     * <pre> 교사가 담당하는 학교정보 목록 조회(selectbox) </pre>
     * 
     * @param authentication
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listSchInfo.do")
    @ResponseBody
    public List<SchInfo> listSchInfo(Authentication authentication) throws Exception {
        SchInfo schInfo = new SchInfo();
        User user = (User) authentication.getPrincipal();

        schInfo.setMbrNo(user.getMbrNo());
        schInfo.setRegStatCd("101526"); //승인된 교실 포함
        List<SchInfo> schInfoList = classroomService.listMySchool(schInfo);

        return schInfoList;
    }


    /**
     * <pre> 학교에 속한 교실목록 조회 </pre>
     * 
     * @param schNo
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listClasRoomInfo.do")
    @ResponseBody
    public List<ClasRoomInfo> listClasRoomInfo(Authentication authentication, @RequestParam String schNo, @RequestParam String lectSer, @RequestParam String setSer) throws Exception {

        List<ClasRoomInfo> clasRoomInfoList;

        User user = (User) authentication.getPrincipal();

        SchInfo schInfo = new SchInfo();
        schInfo.setMbrNo(user.getMbrNo());
        schInfo.setSchNo(schNo);

        if(lectSer != null) {


            String schoolClass = lectureManagementService.selectSchoolClass(schNo);

            if(!schoolClass.equals("T")) {

                String lectTarget = lectureManagementService.selectLectTarget(lectSer);

                boolean isApplable = StringUtils.contains(lectTarget, schoolClass);

                if (!isApplable) {
                    clasRoomInfoList = Lists.newArrayList();
                    ClasRoomInfo clasRoomInfo = new ClasRoomInfo();
                    clasRoomInfo.setApplable(isApplable);

                    clasRoomInfoList.add(clasRoomInfo);

                    return clasRoomInfoList;
                }
            }
        }

        clasRoomInfoList = lectureManagementService.listClasRoomInfo(schInfo);

        if(setSer != null){

            schInfo.setSetSer(setSer);
            ClasRoomInfo clasRoomInfo = lectureInfomationMapper.selectSetSchoolInfo(schInfo);

            if(clasRoomInfo == null){
                clasRoomInfoList.get(0).setApplyCnt(0);
                clasRoomInfoList.get(0).setPermCnt(0);
            }else{
                clasRoomInfoList.get(0).setApplyCnt(clasRoomInfo.getApplyCnt());
                clasRoomInfoList.get(0).setPermCnt(clasRoomInfo.getPermCnt());
            }
        }

        return clasRoomInfoList;
    }


    /**
     * <pre> 기관(교육청) 조회(selectbox) 수업신청 팝업화면에서 선택된 학교가 속해 있는 사업의 교육청을 조회 </pre>
     * 
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listCoInfo.do")
    @ResponseBody
    public List<CoInfo> listCoInfo(LectureSearch lectureSearch) throws Exception {

        List<CoInfo> coInfoList = lectureManagementService.listCoInfoByLectAppl(lectureSearch);

        return coInfoList;
    }


    /**
     * <pre> 교육청의 사업 조회(selectbox) 수업신청 팝업화면에서 교육청을 선택했을 시 교육청이 가지고 있는 사업정보, 배정횟수, 잔여횟수 등 조회 </pre>
     * 
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listBizSetGrp.do")
    @ResponseBody
    public List<BizSetInfo> listBizSetGrp(LectureSearch lectureSearch) throws Exception {

        List<BizSetInfo> bizSetInfoList = lectureManagementService.listBizSetGrpByCoInfo(lectureSearch);

        return bizSetInfoList;
    }


    /**
     * <pre> 학교 자체 배정된 배정횟수, 잔여횟수 조회 </pre>
     * 
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listBizSetInfoBySchool.do")
    @ResponseBody
    public BizSetInfo listBizSetInfoBySchool(LectureSearch lectureSearch) throws Exception {

        BizSetInfo bizSetInfo = lectureManagementService.listBizSetInfoBySchool(lectureSearch);

        return bizSetInfo;
    }


    /**
     * <pre> 학교 자체 배정된 배정횟수, 잔여횟수 조회 </pre>
     * 
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.listAllBizSetInfoBySchool.do")
    @ResponseBody
    public List<BizSetInfo> listAllBizSetInfoBySchool(LectureSearch lectureSearch) throws Exception {

        return lectureManagementService.listAllBizSetInfoBySchool(lectureSearch);
    }


    /**
     * <pre> 수업신청, 수업신청대기 </pre>
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.lectureApply.do")
    @ResponseBody
    public JSONResponse applLectApplInfo(Authentication authentication, LectureInfomationDTO lectureInfomationDTO) throws Exception {


        User user = (User) authentication.getPrincipal();


        try {
            int insetResult = 0;

            //수동 수강신청 등록 관리자 정보
            lectureInfomationDTO.setLectrMbrNo(user.getMbrNo());
            lectureInfomationDTO.setTchrMbrNo(user.getMbrNo());

            insetResult = lectureManagementService.lectInsertClass(lectureInfomationDTO, "sch");


            if (insetResult > 0 ) {
                return JSONResponse.success(CodeMessage.MSG_100015_X0_님_수업신청_등록되었습니다_.toMessage(user.getUsername()));
            }else{
                throw CodeMessage.MSG_900002_등록_실패_하였습니다_.toException();
            }
        }catch (Exception e){
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

    /**
     * <pre>
     *     수업 과제 리스트 (교사/반대표/학교관리자)
     * </pre>
     * @param arclInfo
     * @throws Exception
     */
    @RequestMapping(value = "layerPopupLectureWorkList.do")
    public void layerLectureWorkList(Authentication authentication, Model model, ArclInfo<T> arclInfo) throws Exception{

        User user = (User) authentication.getPrincipal();

        arclInfo.setTeacherYn("Y");
        arclInfo.setDispNotice(false);
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_WORK);
        arclInfo.setSrchMbrNo(user.getMbrNo());


        LectureSearch lectureSearch = new LectureSearch();
        lectureSearch.setLectSer(arclInfo.getCntntsTargtNo());
        lectureSearch.setClasRoomSer(arclInfo.getClasRoomSer());
        lectureSearch.setLectTims(Integer.parseInt(arclInfo.getLectTims()));
        lectureSearch.setSchdSeq(Integer.parseInt(arclInfo.getSchdSeq()));

        LectureInfomationDTO lectSchdInfo = lectureInfomationMapper.lectureSchdInfo(lectureSearch);

        List<ArclInfo<T>> arclList = comunityService.getArticleList(arclInfo);


        for( ArclInfo<T> eachObj : arclList){
            double totalSize = 0;
            for( ArclFileInfo fileObj : eachObj.getListArclFileInfo()){
                totalSize += fileObj.getComFileInfo().getFileSize();

                double fileSize = fileObj.getComFileInfo().getFileSize();
                fileSize = fileSize/1024/1024;
                fileObj.getComFileInfo().setFileSize((int)Math.ceil(fileSize));
            }
            eachObj.setFileTotalSize((int)Math.ceil(totalSize/1024/1024));
        }

        model.addAttribute("arclList", arclList);
        model.addAttribute("lectSchdInfo", lectSchdInfo);

    }
}
