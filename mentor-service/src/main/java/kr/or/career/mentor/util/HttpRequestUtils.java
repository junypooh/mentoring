package kr.or.career.mentor.util;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.cookie.CookiePolicy;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.lang3.StringUtils;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

@Slf4j
public class HttpRequestUtils {


    static private String accessToken = "";

    public static final String TOMMS_DOMAIN;
    public static final String TOMMS_APP_DOMAIN;
    static {
        TOMMS_DOMAIN = EgovProperties.getProperty("TOMMS.DOMAIN");
        TOMMS_APP_DOMAIN = EgovProperties.getProperty("TOMMS.APP.DOMAIN");
    }

    public static JSONObject httpPost(String serviceName, NameValuePair[] params) {
        PostMethod method = new PostMethod(TOMMS_DOMAIN+serviceName);
        int statusCode = 0;
        String strResponse = "";
        JSONObject json = new JSONObject();
        try {
            method.getParams().setContentCharset("utf-8");
            method.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
            if(params != null){
                method.setRequestBody(params);
            }
            statusCode = httpRequest(method);
            strResponse = method.getResponseBodyAsString();
            if(statusCode == HttpStatus.SC_OK) {
                String decriptStr = null;
                try {
                    decriptStr = AESCipherUtils.decript(strResponse).replaceAll("##MSG##", "\"\"");
                    json = JSONObject.fromObject(decriptStr);
                } catch (IllegalBlockSizeException e) {
                    decriptStr = AESCipherUtils.decriptHex(strResponse).replaceAll("##MSG##", "\"\"");
                    json = JSONObject.fromObject(decriptStr);
                }
            }else{
                json.put("STATUS_CODE",statusCode);
                json.put("RESPONSE",strResponse);
            }
        }catch (IOException ioe){
            log.error("TOMMS Connection is not Normal cause {}. Please contact Tomms engineer.",ioe.getMessage());
            json.put("STATUS_CODE",statusCode);
            json.put("RESPONSE", strResponse);
        }catch (InvalidKeyException| InvalidAlgorithmParameterException | BadPaddingException
                | NoSuchAlgorithmException | NoSuchPaddingException | DecoderException | IllegalBlockSizeException ace){
            log.error("Return Value is not Normal cause {}. Please contact Tomms engineer.",ace.getMessage());
            json.put("STATUS_CODE",statusCode);
            json.put("RESPONSE",strResponse);
        }finally {
            method.releaseConnection();
        }
        return json;
    }

    public static JSONObject sendSchedule(String serviceUrl, JSONObject params) {
        PostMethod method = new PostMethod(serviceUrl);
        int statusCode = 0;
        String strResponse = "";
        JSONObject json = new JSONObject();
        try {
            method.getParams().setContentCharset("utf-8");
            method.setRequestHeader("Content-Type", "application/json; charset=utf-8");
            if(params != null){
                log.info("requestBody ::: {}" ,params.toString());
                method.setRequestEntity(new StringRequestEntity(params.toString(), "application/json", "UTF-8"));
            }
            statusCode = httpRequest(method);
            strResponse = method.getResponseBodyAsString();
            if(statusCode == HttpStatus.SC_OK) {
                json = JSONObject.fromObject(strResponse);
            }
        }catch (IOException ioe){
            log.error("Planner Send Schedule Exception : {}",ioe.getMessage());
            json.put("STATUS_CODE",statusCode);
            json.put("RESPONSE", strResponse);
        }finally {
            method.releaseConnection();
        }
        return json;
    }

    static private int httpRequest(HttpMethod method) throws IllegalArgumentException,IOException {

        int statusCode = 0;
        //String rtn = "";
        method.getParams().setCookiePolicy(CookiePolicy.IGNORE_COOKIES);
        method.setRequestHeader("Cookie", "accessToken="+accessToken);


        HttpClient client = new HttpClient();
        client.getParams().setParameter("http.useragent", "SEEDS Client");

        //파레메터 암호화
//        if((method instanceof PostMethod) && (!StringUtil.isEmpty(method.getQueryString()))){
//            RequestEntity entiry = new StringRequestEntity(new String(EncryptCustomerInfo.encrypt(method.getQueryString().getBytes(), Global.CMP_KEY, Global.CMP_IV)), "text/html", "utf-8");
//            ((PostMethod)method).setRequestEntity(entiry);
//            method.setQueryString(new String(EncryptCustomerInfo.encrypt(method.getQueryString().getBytes(), Global.CMP_KEY, Global.CMP_IV)));
//        }
        statusCode = client.executeMethod(method);

        return statusCode;
    }

    public static JSONObject setUser(String flag, String userId, String userNm, String pwd, String email) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        return setUser(flag, userId, userNm, pwd, userNm, email, "0", "P", "1");
    }

    public static JSONObject setUser(String flag, String userId, String userNm, String pwd, String aliasname, String email, String deptcode, String permission, String payment) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        userId = EgovProperties.getProperty("TOMMS_PREFIX") + userId;
        ArrayList<String> parameters = new ArrayList<String>();
        parameters.add(flag);//			flag	String	I : Insert, U : Update, D : Delete, AD : All User Delete
        parameters.add(userId);//			userid	String	user id
        parameters.add(userNm);//			username	String	user name
        parameters.add(pwd);//			pwd	String	user password
        parameters.add(aliasname);//			aliasname	String	(Optional)alias name (showing on the session)
        if(email == null) email = EgovProperties.getProperty("MAIL.SENDER");
        parameters.add(email);//			email	String	(Optional)user email
        parameters.add(deptcode);//			deptcode	String	department code 0 : fixed value
        parameters.add(permission);//			permission	String	S : Super Admin, A : Admin, C : Creator, P : Participant
        parameters.add(payment);//			payment	String	1 : active, 0 : deactivate
        return httpPost("/rest/User/setUser" + makeParam(parameters), null);
    }

    private static String makeParam(ArrayList<String> parameters) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        StringBuffer sb = new StringBuffer();
        for(String p:parameters){
            sb.append("/").append(AESCipherUtils.encriptHex(p));
        }
        return sb.toString();
    }

    public static JSONObject deleteSession(String userId,String sId) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        return setSession(userId, "D", "", sId, "", "");
    }

    public static JSONObject updateSession(String userId,String sId, String title,String startTime,String endTime) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        return setSession(userId, "U", title,sId, startTime,endTime);
    }

    public static JSONObject createSession(String userId, String title, String lectDay,String startTime,String endTime) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        String _startTime = PooqUtils.datePattern(lectDay+startTime);
        String _endTime = PooqUtils.datePattern(lectDay+endTime);
        return setSession(userId, "I", title,"", _startTime,_endTime);
    }

    public static JSONObject createSession(String userId, String title,String startTime,String endTime) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        return setSession(userId, "I", title,"", startTime,endTime);
    }

    public static JSONObject setSession(String userId, String flag, String title, String sId,String startTime,String endTime) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        ArrayList<String> parameters = new ArrayList<String>();

        if(StringUtils.isNotEmpty(userId))
            userId = EgovProperties.getProperty("TOMMS_PREFIX") + userId;

        parameters.add(flag);//flag	String	I : Insert, U : Update, D : Delete
        parameters.add(sId);//sessionid	String	session registered id (only using update and delete)
        parameters.add(title);//title	String	session title
        parameters.add(userId);//userid	String	session registered id
        parameters.add("1");//isPublic	String	회의보안(1:공개, 0:비공개)
        parameters.add(startTime);//startTime	String	회의 시작 시간(yyyy-MM-ddhh:mm:ss)
        parameters.add(endTime);//endTime	String	회의 종료 시간(yyyy-MM-ddhh:mm:ss)
        parameters.add("");//pwd	String	(Encrypt)회의입장 비밀번호
        parameters.add("0");//controlType	String	제어권 자동이양(1 : true, 0 : false)
        parameters.add("0");//allowVideo	String	내 영상 켜기(1 : true, 0 : false)
        parameters.add("0");//autoVideo	String	영상 자동 켜기(1 : true, 0 : false)
        parameters.add("1");//allowChat	String	채팅 허용(1 : true, 0 : false)
        parameters.add("1");//conferenceId	String	회의 설정 옵션
        parameters.add("");//usemsession	String	회의 반복 개설(사용안함. 공백처리)
        parameters.add("");//selectdatetype	String	회의 반복 종류 선택(사용안함. 공백처리)
        parameters.add("");//incustomdate	String	회의 반복 지정일(사용안함. 공백처리)
        parameters.add("");//weekdate	String	회의 반복 주(사용안함. 공백처리)
        return HttpRequestUtils.httpPost("/rest/Session/setSessionCreate"+makeParam(parameters),null);

    }

    public static JSONObject addAttendance(String sessionId, String userId, String userType, String flag, String fixedowner) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        ArrayList<String> parameters = new ArrayList<String>();

        //[{"userid":"admin","usertype":"P","fixedowner":0,"priority":0}]
        //userid : 참석대상자 ID
        //userType : M (master - 제어권 획득 가능)  or P (normal)
        //fixedowner :  1 (고정발언권 설정) or 0 (고정발언권 미설정)
        //priority : 0 (fixed)

        userId = EgovProperties.getProperty("TOMMS_PREFIX") + userId;

        parameters.add(userId);//requestId	String	참석자 추가한 userID
        parameters.add("[{\"userid\":\""+userId+"\",\"usertype\":\""+ userType+"\",\"fixedowner\":\""+ fixedowner +"\",\"priority\":0}]");//participantJSON	String	참석자 정보 JSON type
        parameters.add(sessionId);//회의 ID
        parameters.add(flag);//flag	String	I: 참석자 추가, M : 참석자 수정, D : 참석자 삭제
        return HttpRequestUtils.httpPost("/rest/Participant/setParticipant"+makeParam(parameters),null);
        //return HttpRequestUtils.httpPost("/rest/Session/setParticipant"+makeParam(parameters),null);
    }

    public static JSONObject addAttendance(String sessionId, String requestId, String userId, String userType, String flag, String fixedowner) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        ArrayList<String> parameters = new ArrayList<String>();

        //[{"userid":"admin","usertype":"P","fixedowner":0,"priority":0}]
        //userid : 참석대상자 ID
        //userType : M (master - 제어권 획득 가능)  or P (normal)
        //fixedowner :  1 (고정발언권 설정) or 0 (고정발언권 미설정)
        //priority : 0 (fixed)

        requestId = EgovProperties.getProperty("TOMMS_PREFIX") + requestId;
        userId = EgovProperties.getProperty("TOMMS_PREFIX") + userId;

        parameters.add(requestId);//requestId	String	참석자 추가한 userID
        parameters.add("[{\"userid\":\""+userId+"\",\"usertype\":\""+ userType+"\",\"fixedowner\":\""+ fixedowner +"\",\"priority\":0}]");//participantJSON	String	참석자 정보 JSON type
        parameters.add(sessionId);//회의 ID
        parameters.add(flag);//flag	String	I: 참석자 추가, M : 참석자 수정, D : 참석자 삭제
        return HttpRequestUtils.httpPost("/rest/Participant/setParticipant"+makeParam(parameters),null);
        //return HttpRequestUtils.httpPost("/rest/Session/setParticipant"+makeParam(parameters),null);
    }

    public static JSONObject getParticipantList(String sessionId) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        ArrayList<String> parameters = new ArrayList<String>();
        parameters.add(sessionId);//회의 ID
        //return HttpRequestUtils.httpPost("/rest/Participant/getParticipantList"+makeParam(parameters),null);
        return HttpRequestUtils.httpPost("/rest/Participant/getConnectedUsers"+makeParam(parameters),null);
        //return HttpRequestUtils.httpPost("/rest/Session/getParticipantList"+makeParam(parameters),null);
    }

    public static int getParticipantCnt(String sessionId) throws Exception{
        JSONObject participantList = HttpRequestUtils.getParticipantList(sessionId);

        JSONArray dataSet = participantList.getJSONArray("dataSet");

        String userType = null;

        int observerCnt = 0;
        for(int i=0; i < dataSet.size() ; i++){
            JSONObject jsonObject = dataSet.getJSONObject(i);
            userType = (String)jsonObject.get("usertype_");
            if("G".equals(userType))
                observerCnt++;
        }

        return observerCnt;
    }
}
