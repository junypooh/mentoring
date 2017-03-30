package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.FileManagementService;
import kr.or.career.mentor.service.LectureDataService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.GenericExcelView;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      WebCommunityController
 *
 * WEB > 커뮤니티 controller
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-06-14 오후 3:56
 */
@Controller
@RequestMapping("/web/community")
@Slf4j
public class WebCommunityController {

    @Autowired
    private ComunityService comunityService;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private LectureDataService lectureDataService;

    /**
     * <pre>
     *     1:1문의 리스트 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping("/ajax.simpleArclList.do")
    @ResponseBody
    @Historic(workId = "1000000214")
    public List<ArclInfo<T>> simpleArclList(@Pageable ArclInfo<T> arclInfo) {
        return comunityService.getSimpleArclList(arclInfo);
    }

    /**
     * <pre>
     *     수업과제 데이터 삭제
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping(value = "/ajax.deleteArcl.do", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    @Historic(workId = "1000000218")
    public JSONResponse deleteArcl(ArclInfo<T> arclInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
        arclInfo.setChgMbrNo(user.getMbrNo());

        if(arclInfo.getArclSers() != null){
            try{
                for(String arclSer : arclInfo.getArclSers()){
                    arclInfo.setArclSer(Integer.parseInt(arclSer));
                    comunityService.deleteArcl(arclInfo);
                }
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
     *     1:1문의 상세 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping("/ajax.simpleArclView.do")
    @ResponseBody
    @Historic(workId = "1000000215")
    public ArclInfo<T> simpleArclView(ArclInfo<T> arclInfo) {
        return comunityService.getSimpleArclInfo(arclInfo);
    }

    /**
     * <pre>
     *     수업과제 상세 첨부파일 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping("/ajax.getFileInfoList.do")
    @ResponseBody
    public List<ArclFileInfo> getFileInfoList(ArclInfo<T> arclInfo) {
        return comunityService.getFileInfoList(arclInfo);
    }

    /**
     * <pre>
     *     1:1문의 데이터 등록 및 수정
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping(value = "/ajax.registArcl.do", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    @Historic(workId = "1000000216")
    public JSONResponse registArcl(ArclInfo<T> arclInfo, Authentication authentication) {
        log.debug("arclInfo: {}", arclInfo);

        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
        CodeMessage codeMessage = null;

        try {
            if (arclInfo.getArclSer() == null || arclInfo.getArclSer() == 0) {
                arclInfo.setRegMbrNo(user.getMbrNo());
                comunityService.registArcl(arclInfo, arclInfo.getFileSers());
                codeMessage = CodeMessage.MSG_900001_등록_되었습니다_;
            } else {
                arclInfo.setChgMbrNo(user.getMbrNo());

                // 1:1문의하기 답변등록/수정일경우
                if(StringUtils.stripToNull(arclInfo.getCntntsSust()) != null){
                    arclInfo.setAnsRegMbrNo(user.getMbrNo());
                }
                comunityService.updateArcl(arclInfo, arclInfo.getFileSers());
                codeMessage = CodeMessage.MSG_900003_수정_되었습니다_;
            }
        } catch (Exception e) {
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }

    /**
     * <pre>
     *     수업과제 리스트 조회
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping("/ajax.classTaskList.do")
    @ResponseBody
    @Historic(workId = "1000000217")
    public List<ArclInfo<T>> getClassTaskList(@Pageable ArclInfo<T> arclInfo) {
        return comunityService.getClassTaskList(arclInfo);
    }

    /**
     * <pre>
     *     1:1문의 리스트 엑셀다운로드
     * </pre>
     * @param arclInfo
     * @return
     */
    @RequestMapping(value = "/excel.simpleArclList.do", method = RequestMethod.POST)
    public ModelAndView excelSimpleArclList(ArclInfo<T> arclInfo, Model model) throws NoSuchFieldException  {
        List<ArclInfo<T>> originList = comunityService.getSimpleArclList(arclInfo);

        List<ArclInfo<T>> targetList = new ArrayList<>();
        int iTotalCnt = originList.size();

        for(ArclInfo<T> originSource : originList){
            ArclInfo<T> targetSource = new ArclInfo<T>();
            BeanUtils.copyProperties(originSource, targetSource);

            //번호 세팅
            targetSource.setNo(iTotalCnt - originSource.getRn() + 1);

            //답변여부 셋팅
            if("Y".equals(originSource.getAnsYn())){
                targetSource.setAnsYn("답변완료");
            }else{
                targetSource.setAnsYn("미답변");
            }

            // 내용 html Tag 제거
            String sust = originSource.getSust().replaceAll("<[^>]*>", "");
            sust = sust.replaceAll("|\r|\n","");
            sust = sust.replaceAll("&nbsp;","");
            targetSource.setSust(sust);

            targetList.add(targetSource);
        }

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "no"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "ansYn"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "prefNm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "sust"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "mbrCualfNm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "regMbrNm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "sidoNm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "schNm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "regDtm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "ansRegDtm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "ansRegMbrNm"));
        listHeaderField.add(GenericExcelView.getField(ArclInfo.class, "vcnt"));

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm");
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_문의.xls");
        model.addAttribute("domains", targetList);
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("excelView", "data", model);
    }

    /**
     * <pre>
     *     멘토자료 리스트 조회
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.selectDataInfo.do")
    @ResponseBody
    @Historic(workId = "1000000209")
    public List<LectDataInfo> selectMbrDataInfo(@Pageable LectDataInfo lectDataInfo) throws Exception{
        return lectureDataService.selectMbrDataInfo(lectDataInfo);
    }

    /**
     * <pre>
     *     멘토자료 데이터 삭제 (USE_YN - N으로 변경)
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping(value = "/ajax.deleteDataInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    @Historic(workId = "1000000210")
    public JSONResponse deleteDataInfo(LectDataInfo lectDataInfo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();
        lectDataInfo.setChgMbrNo(user.getMbrNo());
        lectDataInfo.setUseYn("N");

        if(lectDataInfo.getDataSers() != null){
            try{
                for(String dataSer : lectDataInfo.getDataSers()){
                    lectDataInfo.setDataSer(Integer.parseInt(dataSer));
                    lectureDataService.updateMbrDataInfoDel(lectDataInfo);
                }
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
     *     멘토자료 상세 첨부파일 조회
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.dataFileInfoList.do")
    @ResponseBody
    public List<DataFileInfo> selectDataFileList(LectDataInfo lectDataInfo) {
        return lectureDataService.selectDataFileList(lectDataInfo);
    }

    /**
     * <pre>
     *     멘토자료삭제
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.deleteLectureData.do")
    @ResponseBody
    @Historic(workId = "1000000211")
    public String deleteLectureData(LectDataInfo lectDataInfo, Authentication authentication){
        String rtnStr = "";
        User user = (User) authentication.getPrincipal();
        List<LectDataInfo> connectLect = lectureDataService.selectConnectLectList(lectDataInfo);
        if(connectLect.size() > 0){
            rtnStr = "ERROR";
        }else{
            lectDataInfo.setChgMbrNo(user.getMbrNo());
            lectDataInfo.setUseYn("N");
            rtnStr = lectureDataService.updateMbrDataInfoDel(lectDataInfo);
        }
        return rtnStr;
    }

    @RequestMapping("/ajax.getVideoDuration.do")
    @ResponseBody
    public String getVideoDuration(@RequestParam(value = "cID") String cID) throws Exception {

        String xmlUrl = "http://movie.career.go.kr/interfaces/transCheck.asp?sType=web&cID="+cID;

        URL url  = new URL(xmlUrl);
        URLConnection connection = url.openConnection();

        Document doc = parseXML(connection.getInputStream());
        NodeList descNodes = doc.getElementsByTagName("encoding");

        String duration = "";

        for(int i=0; i<descNodes.getLength();i++){
            for(Node node = descNodes.item(i).getFirstChild(); node!=null; node=node.getNextSibling()){ //첫번째 자식을 시작으로 마지막까지 다음 형제를 실행
                if(node.getNodeName().equals("duration")){
                    duration = node.getTextContent();
                }
            }
        }
        return duration;
    }

    private Document parseXML(InputStream stream) throws Exception{

        DocumentBuilderFactory objDocumentBuilderFactory = null;
        DocumentBuilder objDocumentBuilder = null;
        Document doc = null;

        try{

            objDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
            objDocumentBuilder = objDocumentBuilderFactory.newDocumentBuilder();

            doc = objDocumentBuilder.parse(stream);

        }catch(Exception ex){
            throw ex;
        }

        return doc;
    }

    /**
     * <pre>
     *     멘토자료등록
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.insertLectureData.do")
    @ResponseBody
    @Historic(workId = "1000000212")
    public String insertLectureDataAjax(LectDataInfo lectDataInfo, Authentication authentication){
        String rtnData = "";
        User user = (User) authentication.getPrincipal();

        // 등록일때
        if(lectDataInfo.getDataSer() == null || lectDataInfo.getDataSer() == 0){
            lectDataInfo.setRegMbrNo(user.getMbrNo());
            rtnData = lectureDataService.insertMbrDataInfo(lectDataInfo);
        }else{
            lectDataInfo.setRegMbrNo(user.getMbrNo()); // 자료파일등록시 넣어주기위해
            lectDataInfo.setChgMbrNo(user.getMbrNo());
            rtnData = lectureDataService.updateMbrDataInfo(lectDataInfo);
        }
        return rtnData;
    }

    /**
     * <pre>
     *     멘토자료등록
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/insertLectureData.do")
    @Historic(workId = "1000000213")
    public String insertLectureData(LectDataInfo lectDataInfo,  @RequestParam(value="redirectUrl", required = false) String redirectUrl, Authentication authentication) throws CnetException {
        User user = (User) authentication.getPrincipal();

        // 등록일때
        if(lectDataInfo.getDataSer() == null || lectDataInfo.getDataSer() == 0){
            System.err.println("등록");
            lectDataInfo.setRegMbrNo(user.getMbrNo());
            lectureDataService.insertMbrDataInfo(lectDataInfo);
        }else{
            System.err.println("수정");
            lectDataInfo.setRegMbrNo(user.getMbrNo()); // 자료파일등록시 넣어주기위해
            lectDataInfo.setChgMbrNo(user.getMbrNo());
            lectureDataService.updateMbrDataInfo(lectDataInfo);
        }
        return "redirect:"+redirectUrl;
    }

}
