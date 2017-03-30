package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.FileMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.FileManagementService;
import kr.or.career.mentor.util.*;
import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.WebUtils;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Arrays;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    |_ FileManagementServiceImpl.java
 *
 * </pre>
 * @since	2015. 9. 21. 오전 9:43:00
 * @version
 * @author	technear
 */
@Service
@Slf4j
public class FileManagementServiceImpl implements FileManagementService{

    @Autowired
    private FileMapper fileMapper;

    private static final String[] allowedFileExts =
            new String[]{ "PDF", "HWP", "TXT", "PPTX", "PPT", "XLSX",
                            "XLS", "DOCX", "DOC", "JPG", "PNG", "GIF", "MP4", "MOV", "JPEG"
                            , "AVI", "MP3", "WAV", "WMA", "ZIP", "RAR"
                        };

    private static final String[] convertThumnailExts =
            new String[]{ "JPG", "PNG", "GIF", "JPEG"
            };

    private static final long DEFAULT_EXPIRE_TIME = 604800000L;

    private static final int thumbnailWidth = Integer.parseInt(EgovProperties.getProperty("Globals.thumbnailWidth"));

    @Override
    public void downloadFile(int fileSer,boolean origin, HttpServletRequest request, HttpServletResponse response) throws Exception{

        FileInfo fileInfo = new FileInfo();
        fileInfo.setFileSer(fileSer);
        FileInfo fvo = fileMapper.retrieveFile(fileInfo);

        if(fvo == null)return;

        String fileExt = StringUtils.upperCase(fvo.getFileExt());

        File uFile = new File(fvo.getFilePath() + fvo.getFileNm());

        String fileThumbPath = fvo.getFileThumbPath();

        if(!origin && ArrayUtils.contains(convertThumnailExts,fileExt) && fileThumbPath == null){
            if(uFile.exists()) {
                String savePathString = EgovProperties.getProperty("Globals.fileStorePath") + "thumbnail/";
                File thumbnail = new File(EgovWebUtil.filePathBlackList(savePathString + fvo.getFileNm()));
                thumbnail.getParentFile().mkdirs();
                BufferedImage bufferedImage = ImageIO.read(uFile);
                if (bufferedImage.getWidth() > thumbnailWidth) {
                    Thumbnails.of(uFile).width(thumbnailWidth).outputFormat("png").toFile(thumbnail);

                    fileThumbPath = thumbnail.getName();

                    fvo.setFileThumbPath(fileThumbPath);

                    fileMapper.updateFile(fvo);

                    uFile = new File(fvo.getFilePath() + "thumbnail", fileThumbPath + ".png");
                }
            }
        }

        if(!origin && fileThumbPath != null)
            uFile = new File(fvo.getFilePath() + "thumbnail", fileThumbPath + ".png");

        int fSize = (int) uFile.length();


        long expires = System.currentTimeMillis() + DEFAULT_EXPIRE_TIME;

        long length = uFile.length();
        long lastModified = uFile.lastModified();
        String eTag = fvo.getFileNm() + "_" + length + "_" + lastModified;


        String ifNoneMatch = request.getHeader("If-None-Match");
        if (ifNoneMatch != null && matches(ifNoneMatch, eTag)) {
            response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
            response.setHeader("ETag", eTag); // Required in 304.
            response.setDateHeader("Expires", expires); // Postpone cache with 1 week.
            return;
        }

        // If-Modified-Since header should be greater than LastModified. If so, then return 304.
        // This header is ignored if any If-None-Match header is specified.
        long ifModifiedSince = request.getDateHeader("If-Modified-Since");
        if (ifNoneMatch == null && ifModifiedSince != -1 && ifModifiedSince + 1000 > lastModified) {
            response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
            response.setHeader("ETag", eTag); // Required in 304.
            response.setDateHeader("Expires", expires); // Postpone cache with 1 week.
            return;
        }

        if (fSize > 0) {
            String mimeType = "application/unknown";
            if(fileExt.equals("PDF")){
                mimeType = "application/pdf";
            }else if(fileExt.equals("HWP")){
                mimeType = "application/x-hwp";
            }else if(fileExt.equals("TXT")){
                mimeType = "text/plain";
            }else if(fileExt.equals("PPTX") || fileExt.equals("PPT")){
                mimeType = "application/vnd.ms-powerpoint";
            }else if(fileExt.equals("XLSX") || fileExt.equals("XLS")){
                mimeType = "application/vnd.ms-excel";
            }else if(fileExt.equals("DOCX") || fileExt.equals("DOC")){
                mimeType = "application/msword";
            }else if(fileExt.equals("JPG")){
                mimeType = "image/jpeg";
            }else if(fileExt.equals("PNG")){
                mimeType = "image/png";
            }else if(fileExt.equals("GIF")){
                mimeType = "image/gif";
            }else if(fileExt.equals("MP4")){
                mimeType = "video/mp4";
            }else if(fileExt.equals("MOV")){
                mimeType = "application/pdf";
            }else if(fileExt.equals("AVI")){
                mimeType = "video/msvideo";
            }else if(fileExt.equals("MP3")){
                mimeType = "audio/mpeg";
            }else if(fileExt.equals("WAV")){
                mimeType = "audio/wav";
            }else if(fileExt.equals("WMA")){
                mimeType = "audio/x-ms-wma";
            }else if(fileExt.equals("ZIP")){
                mimeType = "application/zip";
            }else if(fileExt.equals("RAR")){
                mimeType = "application/x-rar-compressed";
            }
            //String mimetype = "application/x-msdownload";

            //response.setBufferSize(fSize);	// OutOfMemeory 발생
            response.setBufferSize(10240);
            response.setContentType(mimeType);

            response.setHeader("Cache-Control","public,max-age=86400");
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("ETag", eTag);
            response.setDateHeader("Last-Modified", lastModified);
            response.setDateHeader("Expires", expires);
            //response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fvo.getOrignlFileNm(), "utf-8") + "\"");
            setDisposition(fvo.getOriFileNm(), request, response);
            response.setContentLength(fSize);

            /*
             * FileCopyUtils.copy(in, response.getOutputStream());
             * in.close();
             * response.getOutputStream().flush();
             * response.getOutputStream().close();
             */
            BufferedInputStream in = null;
            BufferedOutputStream out = null;

            try {
                in = new BufferedInputStream(new FileInputStream(uFile));
                out = new BufferedOutputStream(response.getOutputStream());

                FileCopyUtils.copy(in, out);
                out.flush();
            } catch (IOException ex) {
                // 다음 Exception 무시 처리
                // Connection reset by peer: socket write error
                //EgovBasicLogger.ignore("IO Exception", ex);
            } finally {
                close(in, out);
            }

        } else {
            response.setContentType("application/octet-stream");

            PrintWriter printwriter = response.getWriter();

            printwriter.println("<html>");
            printwriter.println("<br><br><br><h2>Could not get file name:<br>" + fvo.getOriFileNm() + "</h2>");
            printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
            printwriter.println("<br><br><br>&copy; webAccess");
            printwriter.println("</html>");

            printwriter.flush();
            printwriter.close();
        }
    }

    @Override
    @Transactional
    public void downloadFile(int arclSer, String boardId, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ArclFileInfo arclFileInfo = new ArclFileInfo();
        arclFileInfo.setArclSer(arclSer);
        arclFileInfo.setBoardId(boardId);
        List<ArclFileInfo> arclFileInfos = fileMapper.listArclFileInfo(arclFileInfo);

        if (!arclFileInfos.isEmpty() && validationFiles(arclFileInfos)) {
            response.setContentType("application/zip");
            setDisposition(String.format("%s-%d.%s", "mPs", System.currentTimeMillis(), "zip"), request, response);

            List<CompressionFile> compressionFiles = new ArrayList<CompressionFile>();
            for (ArclFileInfo afi: arclFileInfos) {
                FileInfo fi = afi.getFileInfo();
                log.debug("[response] fileInfo: {}", fi);
                compressionFiles.add(CompressionFile.of(fi.getFilePath(), fi.getFileNm(), fi.getOriFileNm()));
                // 다운로드 카운트 증가
                fileMapper.incrementFileDwCnt(fi.getFileSer());
            }

            try (ByteArrayOutputStream bos = new ByteArrayOutputStream()) {
                CompressionUtils.zip(compressionFiles, bos);
                response.setContentLength(bos.size());

                bos.writeTo(response.getOutputStream());
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
        else {
            response.setContentType("application/x-msdownload");

            PrintWriter printwriter = response.getWriter();

            printwriter.println("<html>");
            printwriter.println("<br><br><br><h2>Could not get files<br></h2>");
            printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
            printwriter.println("<br><br><br>&copy; webAccess");
            printwriter.println("</html>");

            printwriter.flush();
            printwriter.close();
        }
    }

    /**
     * 존재하는 파일인지 검사
     *
     * @param fileInfoList
     * @return
     */
    private boolean validationFiles(List<ArclFileInfo> fileInfoList) {
        for (ArclFileInfo afi: fileInfoList) {
            FileInfo fi = afi.getFileInfo();

            if (!new File(fi.getFilePath(), fi.getFileNm()).exists()) {
                return false;
            }
        }
        return true;
    }

    /**
     * Disposition 지정하기.
     *
     * @param filename
     * @param request
     * @param response
     * @throws Exception
     */
    private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String browser = getBrowser(request);

        String dispositionPrefix = "attachment; filename=";
        String encodedFilename = null;

        if (browser.equals("MSIE")) {
            encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("TRIDENT")) { // IE11 문자열 깨짐 방지
            encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("FIREFOX")) {
            encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("OPERA")) {
            encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("ANDROID")) {
            encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("CHROME")) {
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < filename.length(); i++) {
                char c = filename.charAt(i);
                if (c > '~') {
                    sb.append(URLEncoder.encode("" + c, "UTF-8"));
                } else {
                    sb.append(c);
                }
            }
            encodedFilename = sb.toString();
        } else {
            throw new IOException("Not supported browser");
        }

        response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

        if ("OPERA".equals(browser)) {
            response.setContentType("application/octet-stream;charset=UTF-8");
        }
    }

    /**
     * 브라우저 구분 얻기.
     *
     * @param request
     * @return
     */
    private String getBrowser(HttpServletRequest request) {
        String header = StringUtils.upperCase(request.getHeader("User-Agent"));
        if (header.indexOf("MSIE") > -1) {
            return "MSIE";
        } else if (header.indexOf("TRIDENT") > -1) { // IE11 문자열 깨짐 방지
            return "TRIDENT";
        } else if (header.indexOf("CHROME") > -1) {
            return "CHROME";
        } else if (header.indexOf("OPERA") > -1) {
            return "OPERA";
        } else if (header.indexOf("ANDROID") > -1){
            return "ANDROID";
        }
        return "FIREFOX";
    }

    /**
     * Resource close 처리.
     * @param resources
     */
    private void close(Closeable  ... resources) {
        for (Closeable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception ignore) {
                    //EgovBasicLogger.ignore("Occurred Exception to close resource is ingored!!");
                }
            }
        }
    }

    @Override
    public FileInfo fileProcess(MultipartFile mFile, String KeyStr) throws Exception{
        List<MultipartFile> files = new ArrayList<>();
        files.add(mFile);
        return parseFileInf(files, KeyStr, 0, "", "").get(0);
    }

    /**
     * 첨부파일에 대한 목록 정보를 취득한다.
     *
     * @param files
     * @return
     * @throws Exception
     */
    private List<FileInfo> parseFileInf(List<MultipartFile> files, String KeyStr, int fileKeyParam, String atchFileId, String storePath) throws Exception {
        int fileKey = fileKeyParam;

        String storePathString = "";

        if (StringUtils.isEmpty(storePath)) {
            storePathString = EgovProperties.getProperty("Globals.fileStorePath");
        } else {
            storePathString = EgovProperties.getProperty(storePath);
        }

        File saveFolder = new File(EgovWebUtil.filePathBlackList(storePathString));

        if (!saveFolder.exists() || saveFolder.isFile()) {
            saveFolder.mkdirs();
        }

        String filePath = "";
        List<FileInfo> result = new ArrayList<FileInfo>();
        FileInfo fvo;

        for(MultipartFile file :files){
            if(file != null){
                String orginFileName = file.getOriginalFilename();

                //--------------------------------------
                // 원 파일명이 없는 경우 처리
                // (첨부가 되지 않은 input file type)
                //--------------------------------------
                if ("".equals(orginFileName)) {
                    continue;
                }
                ////------------------------------------


                int index = orginFileName.lastIndexOf(".");
                //String fileName = orginFileName.substring(0, index);
                String fileExt = StringUtils.upperCase(orginFileName.substring(index + 1));
                String newName = KeyStr + getTimeStamp() + fileKey;
                long size = file.getSize();

                if(!ArrayUtils.contains(allowedFileExts,fileExt))
                    throw new CnetException(CodeMessage.ERROR_000007_허용되지_않는_확장자_입니다_);

                String fileThumbPath = null;
                if(ArrayUtils.contains(convertThumnailExts,fileExt)){
                    BufferedImage bufferedImage = ImageIO.read(file.getInputStream());
                    if(bufferedImage.getWidth() > thumbnailWidth) {
                        String savePathString = EgovProperties.getProperty("Globals.fileStorePath") + "thumbnail/";
                        File thumbnail = new File(EgovWebUtil.filePathBlackList(savePathString+newName));
                        thumbnail.getParentFile().mkdirs();
                        Thumbnails.of(file.getInputStream()).width(thumbnailWidth).outputFormat("png").toFile(thumbnail);
                    }
                }

                if (!"".equals(orginFileName)) {
                    filePath = storePathString + File.separator + newName;
                    file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
                }

                fvo = new FileInfo();
                fvo.setFileExt(fileExt);
                fvo.setFilePath(storePathString);
                fvo.setFileSize(Long.toString(size));
                fvo.setOriFileNm(orginFileName);
                fvo.setFileNm(newName);
                fvo.setFileThumbPath(fileThumbPath);
                Tika tika = new Tika();
                fvo.setFileMime(tika.detect(file.getInputStream()));

                fileMapper.insertFileInfo(fvo);

                result.add(fvo);
            }else{
                result.add(null);
            }


            fileKey++;
        }

        return result;
    }

    /**
     * 공통 컴포넌트 utl.fcc 패키지와 Dependency제거를 위해 내부 메서드로 추가 정의함
     * 응용어플리케이션에서 고유값을 사용하기 위해 시스템에서17자리의TIMESTAMP값을 구하는 기능
     *
     * @param
     * @return Timestamp 값
     * @see
     */
    private String getTimeStamp() {

        String rtnStr = null;

        // 문자열로 변환하기 위한 패턴 설정(년도-월-일 시:분:초:초(자정이후 초))
        String pattern = "yyyyMMddhhmmssSSS";

        SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
        Timestamp ts = new Timestamp(System.currentTimeMillis());

        rtnStr = sdfCurrent.format(ts.getTime());

        return rtnStr;
    }

    /**
     *
     *
     * @see kr.or.career.mentor.service.FileManagementService#retrieveFile(kr.or.career.mentor.domain.FileInfo)
     * @param fileInfo
     * @return
     * @throws Exception
     */
    @Override
    public FileInfo retrieveFile(FileInfo fileInfo) throws Exception{
        return fileMapper.retrieveFile(fileInfo);
    }
    @Override
    public List<ArclFileInfo> listArclFileInfo(ArclFileInfo arclFileInfo) {
        return fileMapper.listArclFileInfo(arclFileInfo);
    }

    /**
     * 게시판에서 신규 글 작성시 첨부파일 정보 처리
     *
     * @see kr.or.career.mentor.service.FileManagementService#insertArclFileInfo(kr.or.career.mentor.domain.ArclFileInfo, java.util.List)
     * @param arclFileInfo
     * @param files
     * @return
     * @throws Exception
     */
    @Override
    public List<ArclFileInfo> insertArclFileInfo(ArclFileInfo arclFileInfo,
            List<MultipartFile> files) throws Exception {
        List<FileInfo> listFileInfo = parseFileInf(files, "ACL", 0, "", "");
        for(FileInfo fileInfo : listFileInfo){
            arclFileInfo.setFileSer(fileInfo.getFileSer());
            fileMapper.insertArclFileInfo(arclFileInfo);
        }
        return null;
    }

    /**
     * 게시판에서 글쓰기 저장시 첨부파일 정보 처리
     *
     * @param arclInfo
     * @param files
     * @return
     * @throws Exception
     */
    @Override
    public List<ArclFileInfo> saveArclFileInfo(ArclInfo arclInfo,
            List<MultipartFile> files) throws Exception {
        //기존 파일정보 삭제
        fileMapper.deleteArclFileInfoExclude(arclInfo);
        List<FileInfo> listFileInfo = parseFileInf(files, "ACL", 0, "", "");

        int idx = 0;
        for(FileInfo fileInfo : listFileInfo){
            ArclFileInfo arclFileInfo = (ArclFileInfo) arclInfo.getListArclFileInfo().get(idx);
            if(fileInfo != null){
                arclFileInfo.setFileSer(fileInfo.getFileSer());
                fileMapper.insertArclFileInfo(arclFileInfo);
            }
            idx++;
        }
        return arclInfo.getListArclFileInfo();
    }
    @Override
    public List<LectPicInfo> listLectPicInfo(LectPicInfo lectPicInfo) {
        return fileMapper.listLectPicInfo(lectPicInfo);
    }
    @Override
    public List<LectPicInfo> saveLectPicInfo(LectInfo lectInfo, List<MultipartFile> files) throws Exception {
        //기존 파일정보 삭제
        fileMapper.deleteLectPicInfoExclude(lectInfo);
        List<FileInfo> listFileInfo = parseFileInf(files, "LECT", 0, "", "");

        int idx = 0;
        for(FileInfo fileInfo : listFileInfo){
            LectPicInfo arclFileInfo = lectInfo.getListLectPicInfo().get(idx);
            if(fileInfo != null){
                arclFileInfo.setFileSer(fileInfo.getFileSer());
                fileMapper.insertLectPicInfo(arclFileInfo);
            }
            idx++;
        }
        return lectInfo.getListLectPicInfo();
    }

    @Override
    public int insertArclFileInfo(ArclFileInfo arclFileInfo) throws Exception {
        return fileMapper.insertArclFileInfo(arclFileInfo);
    }

    @Override
    public int updateFileInfo(FileInfo fileInfo) {
        return fileMapper.updateFile(fileInfo);
    }

    private static boolean matches(String matchHeader, String toMatch) {
        String[] matchValues = matchHeader.split("\\s*,\\s*");
        Arrays.sort(matchValues);
        return Arrays.binarySearch(matchValues, toMatch) > -1
                || Arrays.binarySearch(matchValues, "*") > -1;
    }
}
