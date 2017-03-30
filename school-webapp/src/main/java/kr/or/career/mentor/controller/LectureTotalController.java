/* license */
package kr.or.career.mentor.controller;

import com.google.common.collect.Lists;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.*;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureTotalController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 18. 오전 11:43:57
 * @author  technear
 * @see
 */
@Controller
@RequestMapping("lecture/lectureTotal")
public class LectureTotalController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    ClassroomService classroomService;

    @Autowired
    private ComunityService comunityService;

    @Autowired
    JobService jobService;

    @RequestMapping("lectureList.do")
    public String onLoadlectureList(Model model, LectureSearch lectureSearch) throws Exception {
        Code codeParam = new Code();
        codeParam.setSupCd("101533");
        List<Code> schoolGrd = codeManagementService.listCode(codeParam); //강의대상

        codeParam.setSupCd("101528");
        List<Code> lectType = codeManagementService.listCode(codeParam);  //강의유형

        codeParam.setSupCd("101564");
        List<Code> jobList = codeManagementService.listCode(codeParam);  //직업특징분류

        List<JobClsfDTO> jobDetailList = jobService.jobListCode();  //1차직업분류

        List<BizGrpInfo> bizGrpList = lectureManagementService.listBizGrpList(lectureSearch);

        model.addAttribute("lectureSearch",lectureSearch);

        model.addAttribute("bizGrpList",bizGrpList);
        model.addAttribute("schoolGrd",schoolGrd);
        model.addAttribute("lectType",lectType);
        model.addAttribute("jobList",jobList);
        model.addAttribute("jobDetailList", jobDetailList);

        return "lecture/lectureTotal/lectureList";
    }

    @RequestMapping("ajax.lectureList.do")
    @ResponseBody
    public List<LectSchdInfo> lectureList(@Pageable LectureSearch lectureSearch) throws Exception {

        Integer listType = lectureSearch.getListType();

        List<String> exceptLectStatCdList = new ArrayList<String>();
        exceptLectStatCdList.add(CodeConstants.CD101541_101542_수업요청); //수업요청상태인 것들은 목록에서 제외(개인멘토가 만들어서 관리자의 승인이 아직 안된 수업)

        if(listType != 0){
            exceptLectStatCdList.add("101545"); //모집실패상태인 것들은 목록에서 제외
            exceptLectStatCdList.add(CodeConstants.CD101541_101547_모집취소); //모집취소상태인 것들은 목록에서 제외
        }
        lectureSearch.setExceptLectStatCdList(exceptLectStatCdList);
        // 수업 목록에서 연강인 경우는 첫번째 수업만을 보여주도록 한다.

        if(listType == 1)
            lectureSearch.setSchdSeq(1);
        lectureSearch.setExpsYn("Y");

        lectureManagementService.setDtSchoolGrdExList(lectureSearch);

        lectureSearch.setSchoolGrd("");

        List<LectSchdInfo> listLecture = lectureManagementService.listLect(lectureSearch);
        return listLecture;
    }

    @RequestMapping("mentorLectureList.do")
    @ResponseBody
    public List<LectSchdInfo> mentorLectureList(@Pageable LectureSearch lectureSearch) throws Exception {
        List<String> exceptLectStatCdList = new ArrayList<String>();
        exceptLectStatCdList.add(CodeConstants.CD101541_101542_수업요청); //수업요청상태인 것들은 목록에서 제외(개인멘토가 만들어서 관리자의 승인이 아직 안된 수업)
        lectureSearch.setExceptLectStatCdList(exceptLectStatCdList);
        // 수업 목록에서 연강인 경우는 첫번째 수업만을 보여주도록 한다.
        lectureSearch.setSchdSeq(1);
        lectureSearch.setExpsYn("Y");
        List<LectSchdInfo> jobInfoList = lectureManagementService.listLect(lectureSearch);
        return jobInfoList;
    }

    @RequestMapping("ajax.mobileMentorsLectureList.do")
    @ResponseBody
    public List<LectSchdInfo> mobileMentorsLectureList(@Pageable LectureSearch lectureSearch) throws Exception {
        //lectureSearch.setExceptLectStatCd(CodeConstants.CD101541_101542_수업요청); //수업요청상태인 것들은 목록에서 제외(개인멘토가 만들어서 관리자의 승인이 아직 안된 수업)
        List<String> acceptableStatus = Lists.newArrayList();
        acceptableStatus.add(CodeConstants.CD101541_101548_수업예정);
        acceptableStatus.add(CodeConstants.CD101541_101549_수업대기);
        acceptableStatus.add(CodeConstants.CD101541_101550_수업중);

        lectureSearch.setLectStatusCds(acceptableStatus);
        lectureSearch.setExpsYn("Y");

        List<LectSchdInfo> lectureInfoList = lectureManagementService.listLect(lectureSearch);
        return lectureInfoList;
    }

    @RequestMapping("tabLectureGradeMark.do")
    public void tabLectureGradeMark(LectSchdInfo lectSchdInfo, Model model){
        ArclInfo<T> arclInfo = new ArclInfo<T>();
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_APPR);
        arclInfo.setCntntsTargtNo(lectSchdInfo.getLectSer());
        model.addAttribute("arclInfo", comunityService.getLectureArticleInfo(arclInfo));

    }

}


