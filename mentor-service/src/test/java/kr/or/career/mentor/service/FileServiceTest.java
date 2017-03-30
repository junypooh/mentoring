package kr.or.career.mentor.service;

import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.*;
import lombok.extern.log4j.Log4j2;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.mock;

@Log4j2
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class FileServiceTest {

    @Autowired
    protected FileManagementService fileManagementService;


    /**
     * 화면에서 사용자가 파일 다운로드를 요청 했을 경우 호출하는 함수
     * @throws Exception
     */
    @Test
    public void fileDownload() throws Exception {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);

        Mockito.when(request.getHeader("User-Agent")).thenReturn("Mozilla/4.0 (MSIE 7.0; Windows NT 5.1");
        final StringBuilder outputBuilder=new StringBuilder();
        ServletOutputStream outputStream=new ServletOutputStream(){
            @Override public void write(    int i) throws IOException {
              outputBuilder.append(new String(new int[]{i},0,1));
            }
          };
        Mockito.when(response.getOutputStream()).thenReturn(outputStream);
        //fileSer, request, response를 파라메터로 받음.
        //fileManagementService.downloadFile(10000033, request, response);
    }

    /**
     * 파일 정보를 DB에 저장, 저장된 파일 정보를  반환한다.
     * @throws Exception
     */
    @Test
    public void insertFileInfs() throws Exception{
        MockMultipartFile mockMultipartFile = new MockMultipartFile(
                "fileData",
                "orgFileName.txt",
                "text/plain",
                "testData".getBytes());

        FileInfo fileInfo = fileManagementService.fileProcess(mockMultipartFile, "TEST");
        log.info(fileInfo.toString());
    }

    /**
     * <pre>
     * 파일 정보를 조회한다.
     * </pre>
     *
     * @throws Exception
     */
    @Test
    public void retrieveFileInfo() throws Exception{
        FileInfo fileInfo = new FileInfo();
        fileInfo.setFileSer(10000006);
        FileInfo fo = fileManagementService.retrieveFile(fileInfo);
        log.info(fo.toString());
    }

    /**
     *
     * <pre>
     * 게시판의 첨부파일 정보를 조회한다.
     * </pre>
     *
     * @throws Exception
     */
    @Test
    public void listArclFileInfo() throws Exception{
        ArclFileInfo arclFileInfo = new ArclFileInfo();
        arclFileInfo.setArclSer(10000020);
        arclFileInfo.setBoardId(Constants.BOARD_ID_LEC_QNA);
        List<ArclFileInfo> list = fileManagementService.listArclFileInfo(arclFileInfo);
        log.info(list.toString());
    }

    /**
     * <pre>
     * 게시판의 첨부파일 정보를 저장한다.
     * </pre>
     *
     * @throws Exception
     */
    @Test
    public void saveArclFileInfo() throws Exception{

        ArclInfo arclInfo = new ArclInfo();

        List<ArclFileInfo> listArclFileInfo = new ArrayList<>();
        //글 정보
        for(int i=0 ; i< 5 ; i++){
            ArclFileInfo arclFileInfo = new ArclFileInfo();
            arclFileInfo.setArclSer(10000020);
            arclFileInfo.setBoardId(Constants.BOARD_ID_LEC_QNA);
            if(i%2==0){
                arclFileInfo.setFileSer(10000012+i);
            }
            listArclFileInfo.add(arclFileInfo);
        }
        arclInfo.setArclSer(10000020);
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_QNA);
        arclInfo.setListArclFileInfo(listArclFileInfo);

        //TEST용 File 생성
        List<MultipartFile> files = new ArrayList<>();
        for(int i=0 ; i< 5 ; i++){
            if(i%2==1){
                MockMultipartFile mockMultipartFile = new MockMultipartFile(
                    "fileData",
                    "orgFileName.txt",
                    "text/plain",
                    ("testData"+i).getBytes());

                files.add(mockMultipartFile);
            }else{
                files.add(null);
            }
        }

        //file 저장 및 DB에 Insert
        List<ArclFileInfo> list = fileManagementService.saveArclFileInfo(arclInfo, files);
        log.info(list.toString());
    }


    @Test
    public void listLectPicInfo() throws Exception{
        LectPicInfo lectPicInfo = new LectPicInfo();
        lectPicInfo.setLectSer(10000003);
        List<LectPicInfo> list = fileManagementService.listLectPicInfo(lectPicInfo);
        log.info(list.toString());
    }

    @Test
    public void saveLectPicInfo() throws Exception{

        LectInfo lectInfo = new LectInfo();

        List<LectPicInfo> listLectPicInfo = new ArrayList<>();
        //글 정보
        for(int i=0 ; i< 5 ; i++){
            LectPicInfo lectPicInfo = new LectPicInfo();
            lectPicInfo.setLectSer(10000003);
            if(i%2==0){
                lectPicInfo.setFileSer(10000012+i);
            }
            listLectPicInfo.add(lectPicInfo);
        }
        lectInfo.setLectSer(10000003);
        lectInfo.setListLectPicInfo(listLectPicInfo);

        //TEST용 File 생성
        List<MultipartFile> files = new ArrayList<>();
        for(int i=0 ; i< 5 ; i++){
            if(i%2==1){
                MockMultipartFile mockMultipartFile = new MockMultipartFile(
                    "fileData",
                    "orgFileName.txt",
                    "text/plain",
                    ("testData"+i).getBytes());

                files.add(mockMultipartFile);
            }else{
                files.add(null);
            }
        }

        //file 저장 및 DB에 Insert
        List<LectPicInfo> list = fileManagementService.saveLectPicInfo(lectInfo, files);
        log.info(list.toString());
    }

}
