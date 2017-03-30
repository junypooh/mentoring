package kr.or.career.mentor.util;

import java.io.Closeable;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *  Class Name : EgovProperties.java
 *  Description : properties값들을 파일로부터 읽어와   Globals클래스의 정적변수로 로드시켜주는 클래스로
 *   문자열 정보 기준으로 사용할 전역변수를 시스템 재시작으로 반영할 수 있도록 한다.
 *  Modification Information
 *
 *     수정일         수정자                   수정내용
 *   -------    --------    ---------------------------
 *   2009.01.19    박지욱          최초 생성
 *	 2011.07.20    서준식 	      Globals파일의 상대경로를 읽은 메서드 추가
 *	 2014.10.13    이기하 	      Globals.properties 값이 null일 경우 오류처리
 *  @author 공통 서비스 개발팀 박지욱
 *  @since 2009. 01. 19
 *  @version 1.0
 *  @see
 *
 */

public class EgovProperties {

    private static final Logger LOGGER = LoggerFactory.getLogger(EgovProperties.class);

    //파일구분자
    final static  String FILE_SEPARATOR = System.getProperty("file.separator");

    private static Properties loadProperties(String filename) {
        InputStream is = null;
        try {
            is = Thread.currentThread().getContextClassLoader().getResourceAsStream(filename);
            //Thread.currentThread().getContextClassLoader().getResource(filename);
            if(is != null){
                Properties properties = new Properties();
                properties.load(is);

                return properties;
            }else{
                return null;
            }
        }
        catch (IOException e) {
            throw new RuntimeException("Properties file not found", e);
        }
        finally {
            close(is);
        }
    }

    private static Properties properties = loadProperties("properties/globals.properties");
    private static Properties localProperties = loadProperties("properties/local.properties");

    /**
     * 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다(Globals.java 전용)
     * @param keyName String
     * @return String
     */
    public static String getProperty(String keyName) {
        return properties.getProperty(keyName);
    }

    public static String getLocalProperty(String keyName) {
        return localProperties.getProperty(keyName);
    }

    /**
     * Resource close 처리.
     * @param resources
     */
    private static void close(Closeable  ... resources) {
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
}
