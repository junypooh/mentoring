/* ntels */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.*;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.GenericExcelView;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;


/**
    * <pre>
    * kr.go.career.mentor.controller
    *      LectureStatusManageController
    *
    * WEB > 기기제한설정 controller
    *
    * </pre>
    *
    * @author DaDa
    * @see
    * @since 2016-07-05 오후 07:05
*/
@Controller
@RequestMapping("lecture/status")
public class LectureStatusManageController {

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private McService mcService;

    @Autowired
    private ComunityService comunityService;

    @Autowired
    private StudioService studioService;


    @RequestMapping("ajax.listMc.do")
    @ResponseBody
    @Historic(workId = "1000000114")
    public List<McInfo> main(@Pageable LectureSearch lectureSearch) {
        return mcService.listMcPaging(lectureSearch);
    }


    @RequestMapping(value={"mc/view.do","mc/edit","mc/saveMcInfo"} , method= RequestMethod.GET)
    public void mcInfo(McInfo mcInfo, Model model) {
        if(StringUtils.isEmpty(mcInfo.getMcNo())){
            mcInfo.setUseYn("Y");
            model.addAttribute("mcInfo",mcInfo);
        }else{
            model.addAttribute("mcInfo",mcService.retrieveMcInfo(mcInfo));
        }
    }

    @RequestMapping(value={"mc/saveMcInfo"})
    @Historic(workId = "1000000115")
    public String saveMcInfo(@ModelAttribute McInfo mcInfo, BindingResult result, Model model, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        mcInfo.setRegMbrNo(user.getMbrNo());

        if(StringUtils.isEmpty(mcInfo.getMcNm())){
            result.rejectValue("stdoNm", "", "MC 이름을 입력해주세요");
        }

        // Validation 오류 발생시 게시글 정보 등록화면으로 이동
        if (result.hasErrors()) {
            // 에러 출력
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError e : list) {
                //log.error(" ObjectError : " + e);
            }

            return "lecture/status/mc/edit";
        }

        mcService.saveMcInfo(mcInfo);
        return "redirect:list.do";
    }

    /**
     * <pre>
     *     수업정보관리 > 평점조회 수업별 목록
     * </pre>
     * @param ratingDTO
     * @return
     */
    @RequestMapping("/rating/ajax.ratingByLecture.do")
    @ResponseBody
    @Historic(workId = "1000000110")
    public List<RatingDTO> ratingByLecture(@Pageable RatingDTO ratingDTO) throws Exception{
        return comunityService.getRatingByLecture(ratingDTO);
    }

    /**
     * <pre>
     *     수업정보관리 > 평점조회 수업별 목록 엑셀다운로드
     * </pre>
     * @param ratingDTO
     * @return
     */
    @RequestMapping(value = "/rating/excel.ratingByLecture.do", method = RequestMethod.POST)
    public ModelAndView excelRatingByLecture(RatingDTO ratingDTO, Model model) throws Exception {
        List<RatingDTO> originList = comunityService.getRatingByLecture(ratingDTO);

        List<RatingDTO> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(RatingDTO originSource : originList){
            RatingDTO targetSource = new RatingDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            //수업대상 setting
            if("101534".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초");
            }else if("101535".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("중");
            }else if("101536".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("고");
            }else if("101537".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초중");
            }else if("101538".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("중고");
            }else if("101539".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초고");
            }else if("101540".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초중고");
            }else if("101713".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("기타");
            }

            targetList.add(targetSource);
        }

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "no"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "lectTypeNm"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "lectTargtNm"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "lectTitle"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "lectrNm"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "jobNm"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "grpNm"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "teacherCnt"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "techerPoint"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "stuCnt"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "stuPoint"));

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_평점조회_수업별.xls");
        model.addAttribute("domains", targetList);
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("excelView", "data", model);
    }

    /**
     * <pre>
     *     수업정보관리 > 평점조회 멘토별 목록
     * </pre>
     * @param ratingDTO
     * @return
     */
    @RequestMapping("/rating/ajax.ratingByMentor.do")
    @ResponseBody
    @Historic(workId = "1000000111")
    public List<RatingDTO> ratingByMentor(@Pageable RatingDTO ratingDTO) {
        return comunityService.getRatingByMentor(ratingDTO);
    }

    /**
     * <pre>
     *     수업정보관리 > 평점조회 멘토별 목록 엑셀다운로드
     * </pre>
     * @param ratingDTO
     * @return
     */
    @RequestMapping(value = "/rating/excel.ratingByMentor.do", method = RequestMethod.POST)
    public ModelAndView excelRatingByMentor(RatingDTO ratingDTO, Model model) throws NoSuchFieldException {
        List<RatingDTO> originList = comunityService.getRatingByMentor(ratingDTO);

        List<RatingDTO> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(RatingDTO originSource : originList){
            RatingDTO targetSource = new RatingDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);
            targetList.add(targetSource);
        }

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "no"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "lectrNm"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "jobNm"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "lectCnt"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "teacherCnt"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "techerPoint"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "stuCnt"));
        listHeaderField.add(GenericExcelView.getField(RatingDTO.class, "stuPoint"));

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_평점조회_멘토별.xls");
        model.addAttribute("domains", targetList);
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("excelView", "data", model);
    }

    /**
     * <pre>
     *     수업정보관리 > 수업후기 목록
     * </pre>
     * @param ratingCmtDTO
     * @return
     */
    @RequestMapping("/epilogue/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000108")
    public List<RatingCmtDTO> epilogueList(@Pageable RatingCmtDTO ratingCmtDTO) throws Exception{
        return comunityService.getLectureReview(ratingCmtDTO);
    }

    /**
     * <pre>
     *     수업정보관리 > 수업후기 목록 엑셀다운로드
     * </pre>
     * @param ratingCmtDTO
     * @return
     */
    @RequestMapping(value = "/epilogue/excel.list.do", method = RequestMethod.POST)
    public ModelAndView excelEpilogueList(RatingCmtDTO ratingCmtDTO, Model model) throws Exception {
        List<RatingCmtDTO> originList = comunityService.getLectureReview(ratingCmtDTO);

        List<RatingCmtDTO> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(RatingCmtDTO originSource : originList){
            RatingCmtDTO targetSource = new RatingCmtDTO();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            //수업대상 setting
            if("101534".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초");
            }else if("101535".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("중");
            }else if("101536".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("고");
            }else if("101537".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초중");
            }else if("101538".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("중고");
            }else if("101539".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초고");
            }else if("101540".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("초중고");
            }else if("101713".equals(originSource.getLectTargtCd())){
                targetSource.setLectTargtNm("기타");
            }

            //작성자 setting
            String mbrCualf = "";
            if("100205".equals(originSource.getMbrCualfCd()) || "100206".equals(originSource.getMbrCualfCd()) || "100207".equals(originSource.getMbrCualfCd()) || "100208".equals(originSource.getMbrCualfCd())){
                originSource.setMbrCualfNm("학생");
            }else if("100214".equals(originSource.getMbrCualfCd()) || "100215".equals(originSource.getMbrCualfCd())){
                originSource.setMbrCualfNm("교사");
            }

            targetSource.setRegMbrNm(originSource.getRegMbrNm() + "(" + originSource.getMbrCualfNm() + ")");

            targetList.add(targetSource);
        }

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "no"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "lectTypeNm"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "lectTitle"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "lectrNm"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "jobNm"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "cmtSust"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "asmPnt"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "lectTargtNm"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "schNm"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "clasRoomNm"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "regMbrNm"));
        listHeaderField.add(GenericExcelView.getField(RatingCmtDTO.class, "regDtm"));

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_수업후기.xls");
        model.addAttribute("domains", targetList);
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("excelView", "data", model);
    }

    /**
     * <pre>
     *     수업후기 삭제
     * </pre>
     * @param ratingCmtDTO
     * @return
     */
    @RequestMapping(value = "/epilogue/ajax.delete.do", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    @Historic(workId = "1000000109")
    public JSONResponse deleteArcl(RatingCmtDTO ratingCmtDTO, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        ratingCmtDTO.setDelMbrNo(user.getMbrNo());

        if(ratingCmtDTO.getCmtSer() != null){
            try{

                comunityService.deleteLectureReview(ratingCmtDTO);

            }catch (Exception e){
                CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
                if (e instanceof CnetException) {
                    codeMessage = ((CnetException) e).getCode();
                }
                return JSONResponse.failure(codeMessage, e);
            }
        }

        return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
    }

    /**
     * <pre>
     *     수업정보관리 > 스튜디오 목록
     * </pre>
     * @param stdoInfo
     * @return
     */
    @RequestMapping("/studio/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000112")
    public List<StdoInfo> studioList(@Pageable StdoInfo stdoInfo) {
        return studioService.getStudioInfo(stdoInfo);
    }

    /**
     * <pre>
     *     수업정보관리 > 스튜디오 목록 > 지역시관련 시군구 조회
     * </pre>
     * @param stdoInfo
     * @return
     */
    @RequestMapping("/studio/ajax.studioSggu.do")
    @ResponseBody
    public List<StdoInfo> studioSggu( StdoInfo stdoInfo) {
        return studioService.getStudioSggu(stdoInfo);
    }

    /**
     * <pre>
     *     수업정보관리 > 스튜디오 edit > 수정 및 등록
     * </pre>
     * @param stdoInfo
     * @return
     */
    @RequestMapping("/studio/ajax.saveStudioInfo.do")
    @ResponseBody
    @Historic(workId = "1000000113")
    public String saveStudioInfo( StdoInfo stdoInfo, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        stdoInfo.setRegMbrNo(user.getMbrNo());

        String rtnStr = "FAIL";
        int chk = studioService.saveStudioInfo(stdoInfo);
        if(chk > 0){
            rtnStr = "SUCCESS";
        }
        return rtnStr;
    }









}
