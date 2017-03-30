package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.DataFileInfo;
import kr.or.career.mentor.domain.LectDataInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.LectureDataService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      LectureDataController
 *
 * 수업관리 > 자료등록 Controller
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-20 오후 6:21
 */
@Controller
@RequestMapping("lecture/lectureData")
@Slf4j
public class LectureDataController {

    @Autowired
    private LectureDataService lectureDataService;

    /**
     * <pre>
     *     자료등록 리스트
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.lectureDataList.do")
    @ResponseBody
    public List<LectDataInfo> ajaxLectureDataList(@Pageable LectDataInfo lectDataInfo, Authentication authentication, Model model) throws Exception{
        User user = (User) authentication.getPrincipal();

        //교육수행기관일경우
        if("101501".equals(user.getMbrCualfCd())){
            lectDataInfo.setPosCoNo(user.getPosCoNo());
            lectDataInfo.setMbrCualfCd(user.getMbrCualfCd());
        }else{
        //멘토일경우
            lectDataInfo.setOwnerMbrNo(user.getMbrNo());
        }

        return lectureDataService.selectMbrDataInfo(lectDataInfo);
    }

    /**
     * <pre>
     *     수업 자료 등록 가능 리스트
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.mentorDataList.do")
    @ResponseBody
    public List<LectDataInfo> ajaxMentorDataList(LectDataInfo lectDataInfo, Authentication authentication, Model model) throws Exception{
        User user = (User) authentication.getPrincipal();

        lectDataInfo.setRegMbrNo(user.getMbrNo());

        return lectureDataService.selectMbrDataInfo(lectDataInfo);
    }

    /**
     * <pre>
     *     수업 자료 리스트
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.lectDataList.do")
    @ResponseBody
    public List<LectDataInfo> lectDataList(@Pageable LectDataInfo lectDataInfo, Authentication authentication, Model model) throws Exception{
        User user = (User) authentication.getPrincipal();

        lectDataInfo.setRegMbrNo(user.getMbrNo());

        return lectureDataService.selectLectDataList(lectDataInfo);
    }

    /**
     * <pre>
     *     멘토 자료를 수업자료로 맵핑
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.insertMappingLectData.do")
    @ResponseBody
    public JSONResponse insertMappingLectData(LectDataInfo lectDataInfo, Authentication authentication){
        CodeMessage codeMessage = null;
        int chkCnt= 0;

        User user = (User) authentication.getPrincipal();
        lectDataInfo.setRegMbrNo(user.getMbrNo());

        try{
            chkCnt = lectureDataService.insertLectDataInfo(lectDataInfo);

            if(chkCnt > 0){
                codeMessage = CodeMessage.MSG_900001_등록_되었습니다_;
            }else{
                codeMessage = CodeMessage.MSG_900002_등록_실패_하였습니다_;
            }

        }catch (Exception e){
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
     *     멘토 자료와 수업자료맵핑 해제
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.delMappingLectData.do")
    @ResponseBody
    public JSONResponse delMappingLectData(LectDataInfo lectDataInfo, Authentication authentication){
        CodeMessage codeMessage = null;
        int chkCnt= 0;

        User user = (User) authentication.getPrincipal();
        lectDataInfo.setRegMbrNo(user.getMbrNo());

        try{
            chkCnt = lectureDataService.deleteLectDataFile(lectDataInfo);

            if(chkCnt > 0){
                codeMessage = CodeMessage.MSG_900004_삭제_되었습니다_;
            }else{
                codeMessage = CodeMessage.MSG_900009_삭제_실패_하였습니다_;
            }

        }catch (Exception e){
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
     *     자료등록
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.insertLectureData.do")
    @ResponseBody
    public String insertLectureData(LectDataInfo lectDataInfo, Authentication authentication){
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
     *     자료정보 연결수업 조회
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.connectLectList.do")
    @ResponseBody
    public List<LectDataInfo> ajaxConnectLectList(LectDataInfo lectDataInfo){
        return lectureDataService.selectConnectLectList(lectDataInfo);
    }

    /**
     * <pre>
     *     자료정보 상세 첨부파일 조회
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
     *     자료삭제
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.deleteLectureData.do")
    @ResponseBody
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
}
