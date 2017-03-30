package kr.or.career.mentor.util;

import org.apache.commons.lang3.StringUtils;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * <pre>
 * kr.or.career.mentor.util
 *      FileThumbnailUtils
 *
 * 파일 썸네일 관련 Class
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-05-31 오후 3:17
 */
public class FileThumbnailUtils {

    /**
     * 썸네일 생성
     *
     * @param loadFilePath  기존파일경로 + 파일명
     * @param maxDim        새로저장될 사이즈 지정 (Width기준)
     * @return Map
     *         saveFilePath : 저장경로
     *         saveFileExt  : 확장자
     *         saveFileNm   : 저장된 파일명
     *         saveFileSize : 저장된 파일사이즈 (byte)
     *
     * @throws Exception
     */
    public static Map<String, Object> createThumbnail(String loadFilePath, int maxDim) throws IOException{
        return createThumbnail(loadFilePath, maxDim, null);
    }

    /**
     * 썸네일 생성
     *
     * @param loadFilePath  기존파일경로 + 파일명
     * @param maxDim        새로저장될 사이즈 지정 (Width기준)
     * @param saveFilePath  새로저장될 파일경로
     * @return Map
     *         saveFilePath : 저장경로
     *         saveFileExt  : 확장자
     *         saveFileNm   : 저장된 파일명
     *         saveFileSize : 저장된 파일사이즈 (byte)
     * @throws Exception
     */
    public static Map<String, Object> createThumbnail(String loadFilePath, int maxDim, String saveFilePath) throws IOException{

        Map<String, Object> resultMap = new HashMap<String, Object>();

        String savePathString = "";

        if (StringUtils.isEmpty(saveFilePath)) {
            savePathString = EgovProperties.getProperty("Globals.fileStorePath") + "thumbnail/";

        } else {
            savePathString = EgovProperties.getProperty(saveFilePath);
        }

        File saveFolder = new File(filePathBlackList(savePathString));

        // 폴더생성
        if (!saveFolder.exists() || saveFolder.isFile()) {
            saveFolder.mkdirs();
        }

        loadFilePath = loadFilePath.replaceAll("/", "\\" + File.separator);

        // 확장자명
        int index = loadFilePath.lastIndexOf(".");
        String fileExt = StringUtils.upperCase(loadFilePath.substring(index + 1));

        // 기존파일명
        int idx = loadFilePath.lastIndexOf(File.separator);
        String fileName = loadFilePath.substring(idx+1, index);

        // 새로저장될 파일명
        String newFileName=System.currentTimeMillis()+"_"+ UUID.randomUUID().toString().replace("-", "");

        // 이미지 확장자가 아닐경우
        if(!("JPG".equals(fileExt) || "PNG".equals(fileExt))){
            //throw new CnetException(CodeMessage.ERROR_000007_허용되지_않는_확장자_입니다_);
        }

        File save = new File(savePathString + newFileName + "." + fileExt);
        FileInputStream fis = new FileInputStream(loadFilePath);

        BufferedImage im = ImageIO.read(fis);
        Image inImage = new ImageIcon(loadFilePath).getImage();
        double scale = (double) maxDim / (double) inImage.getHeight(null);
        if (inImage.getWidth(null) > inImage.getHeight(null)) {
            scale = (double) maxDim / (double) inImage.getWidth(null);
        }
        int scaledW = (int) (scale * inImage.getWidth(null));
        int scaledH = (int) (scale * inImage.getHeight(null));
        BufferedImage thumb = new BufferedImage(scaledW, scaledH,BufferedImage.TYPE_INT_RGB);
        Graphics2D g2 = thumb.createGraphics();
        g2.drawImage(im, 0, 0, scaledW, scaledH, null);

        ImageIO.write(thumb, fileExt, save);
        System.out.println("썸네일 생성완료");

        long saveFileSize = save.length();

        resultMap.put("saveFilePath", save.getAbsoluteFile());  // 저장경로
        resultMap.put("saveFileExt", fileExt);                  // 확장자
        resultMap.put("saveFileNm", newFileName);               // 저장된 파일명
        resultMap.put("saveFileSize",saveFileSize);             // 저장된 파일사이즈

        return resultMap;

    }

    public static String filePathBlackList(String value) {
        String returnValue = value;
        if (returnValue == null || returnValue.trim().equals("")) {
            return "";
        }

        returnValue = returnValue.replaceAll("\\.\\./", ""); // ../
        returnValue = returnValue.replaceAll("\\.\\.\\\\", ""); // ..\

        return returnValue;
    }
}
