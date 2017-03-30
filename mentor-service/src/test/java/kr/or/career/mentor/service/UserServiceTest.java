package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.ClasRoomInfo;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.HttpRequestUtils;
import net.sf.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.owasp.esapi.ESAPI;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.testng.collections.Lists;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.*;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.HashMap;
import java.util.List;


@ContextConfiguration(locations = {"classpath:spring/application-context.xml","classpath:spring/application-datasource.xml","classpath:spring/application-transaction.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
//@ActiveProfiles("jpa")
public class UserServiceTest {

    public static final Logger log = LoggerFactory.getLogger(UserServiceTest.class);

    @Autowired
    protected UserService userService;

    @Autowired
    private LectureManagementService lectureManagerService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @Test
    @Transactional
    public void findUserByUserId() {
    	HashMap<String,String> param = new HashMap<>();
        param.put("username", "TEST");
        userService.retrieveUser(param);
    }

    @Test
    public void findUsersBySearchOption(){
        /*SearchOption<KeywordSearch> option = mock(SearchOption.class);


        when(option.getValue()).thenReturn((new KeywordSearch("aaa","bbb")));

        option.getValue().setKeyword("AAAA");

        log.info("keyword is {}", option.getValue().getKeyword());

        //verify(option.getValue()).setKeyword("AAAA");

        Assert.assertEquals("AAAA",option.getValue().getKeyword());*/

        //Assert.fail();

        try {
            Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());

            byte[] input = "abcdefg hijklmn".getBytes();
            Cipher cipher = Cipher.getInstance("RSA/None/NoPadding", "BC");
            /*
            SecureRandom random = new SecureRandom();
            KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA", "BC");

            generator.initialize(128, random); // 여기에서는 128 bit 키를 생성하였음
            KeyPair pair = generator.generateKeyPair();

            dumpKeyPair(pair);

            saveKeyPair("/Users/chaos",pair);

            */

            KeyPair pair = loadKeyPair("/Users/chaos","RSA");
            Key pubKey = pair.getPublic();
            Key privKey = pair.getPrivate();

            /*

            // 공개키를 전달하여 암호화
            cipher.init(Cipher.ENCRYPT_MODE, pubKey);
            byte[] cipherText = cipher.doFinal(input);
            System.out.println("cipher: (" + cipherText.length + ")" + new String(cipherText));
            */


            byte[] cipherText = "(16)�/κ�`W�E����<1z".getBytes();

            /*
            byte[] encodedPrivateKey = "3079020100300d06092a864886f70d010101050004653063020100021100dad353c0456498b31f9fae660e652a5b0203010001021100915775b42a2313cc031229db9eab7089020900ef45fc9998e56107020900ea1f68310f009b0d02083c21a4879d4b1805020848964a38839d3d75020900ed2b1405625fffbe".getBytes();

            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(
                    encodedPrivateKey);
            PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);

            */
            // 개인키를 가지고있는쪽에서 복호화
            cipher.init(Cipher.DECRYPT_MODE, privKey);
            byte[] plainText = cipher.doFinal(cipherText);
            System.out.println("plain : " + new String(plainText));

        }catch (Exception e){
            e.printStackTrace();
        }
    }

    private void dumpKeyPair(KeyPair keyPair) {
        PublicKey pub = keyPair.getPublic();
        System.out.println("Public Key: " + getHexString(pub.getEncoded()));

        PrivateKey priv = keyPair.getPrivate();
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(
                priv.getEncoded());
        //System.out.println("Private Key: " + getHexString(priv.getEncoded()));
        System.out.println("Private Key: " + pkcs8EncodedKeySpec.getEncoded());
    }

    private String getHexString(byte[] b) {
        String result = "";
        for (int i = 0; i < b.length; i++) {
            result += Integer.toString((b[i] & 0xff) + 0x100, 16).substring(1);
        }
        return result;
    }

    private void saveKeyPair(String path, KeyPair keyPair) throws IOException {
        PrivateKey privateKey = keyPair.getPrivate();
        PublicKey publicKey = keyPair.getPublic();

        // Store Public Key.
        X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(
                publicKey.getEncoded());
        FileOutputStream fos = new FileOutputStream(path + "/public.key");
        fos.write(x509EncodedKeySpec.getEncoded());
        fos.close();

        // Store Private Key.
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(
                privateKey.getEncoded());
        fos = new FileOutputStream(path + "/private.key");
        fos.write(pkcs8EncodedKeySpec.getEncoded());
        fos.close();
    }

    private KeyPair loadKeyPair(String path, String algorithm)
            throws IOException, NoSuchAlgorithmException,
            InvalidKeySpecException {
        // Read Public Key.
        File filePublicKey = new File(path + "/public.key");
        FileInputStream fis = new FileInputStream(path + "/public.key");
        byte[] encodedPublicKey = new byte[(int) filePublicKey.length()];
        fis.read(encodedPublicKey);
        fis.close();

        // Read Private Key.
        File filePrivateKey = new File(path + "/private.key");
        fis = new FileInputStream(path + "/private.key");
        byte[] encodedPrivateKey = new byte[(int) filePrivateKey.length()];
        fis.read(encodedPrivateKey);
        fis.close();

        // Generate KeyPair.
        KeyFactory keyFactory = KeyFactory.getInstance(algorithm);
        X509EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(
                encodedPublicKey);
        PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);

        PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(
                encodedPrivateKey);
        PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);

        return new KeyPair(publicKey, privateKey);
    }



    @Test
    public void test(){
        String value = "<a href='http://www.google.com/' onclick='personal()' >link</a>";

        value = ESAPI.encoder().canonicalize(value);

        log.info("canonicalize String : {}", value);

        value.replaceAll("\0", "");

        value = Jsoup.clean(value, Whitelist.basic());


        log.info("endcoded String : {}", value);
    }

    @Test
    public void testMockito(){
/*        //mock creation
        List mockedList = mock(List.class);

        //using mock object
        mockedList.add("one");
        mockedList.clear();

        //verification
        verify(mockedList).add("one");
        verify(mockedList).clear();
        */


        /*LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(10000293);
        lectSchdInfo.setLectTims(1);
        lectSchdInfo.setSchdSeq(1);
        LectSchdInfo lectureSchdInfo= lectureInfomationMapper.retrieveLectSchdInfo(lectSchdInfo);*/

        /*MessageReciever reciever = new MessageReciever();
        reciever.setMemberNo("1234");
        reciever.setMailAddress("test@yopmail.com");
        reciever.setTelNo("01012341234");*/



        /*Message message = new Message();
        message.setContentType(MessageType.LECTURE_APPLY);
        message.setSendType(MessageSendType.EMS, MessageSendType.SMS);

        LecturePayLoad payLoad = LecturePayLoad.of(message,10000293,1,false);


        message.setPayload(payLoad);

        messageTransferManager.transfer(message);

        boolean isSuspend = true;

        while(isSuspend){
            log.debug("suspened...");
            try {
                Thread.currentThread().sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }*/

        /*int result = 0;

        try {
            result = lectureManagerService.lectureStatusChangeRecruitmentClose();
        } catch (Exception e) {
            e.printStackTrace();
        }



        log.info(result+"");*/




       /* MulticastResult result = null;

                Sender sender = new Sender("AIzaSyAZ1lqDdG5-7icBx6kfsLJOXWygyWpndy0");


        List<String> list = Lists.newArrayList();
        list.add("APA91bH4XN2Nzq_3wq_v0VL2ZYeEONmNvlnKg9WdrpGk2WMvWYipN9B9xWO-KE-P68MXYS0Yd471BRrXc_R8MCooyoHxzd1PQ0KDi5CzIA9ln1hhRpfFVTMFHvhCdDZTiyCxNYGK75RZ");
        //list.add("APA91bHNe4z-D_8hUXlC9_2PRWmNKM1VO9Hdd3o6cv19oaqmURfYDDMF94A9x-PrucXJ1HJWuhEznVHxgAceccw3vLb6XABxlli2ci6dVsdGBT3Lf-Srd43IqyOT-uEK-AFUnLXA49Ry");
        //list.add("APA91bFFaUJw6WjKUwoVeGU7UDGXZRCI4scx8mKegjkeeX2V_C4D1xOUWjo4Roj5zYpqEL9PXozqDFLTexjlRuKSa2kgQ2g8h1DIW4P_fFL7ug1N9HD1_Sdw-2VU7ZyKL9hGjVFjTneh");


        try {
            result = sender.send(
                    new Message.Builder()
                            .delayWhileIdle(true)
                            .addData("msg", "9번째 테스트입니다.")
                            .build()
                    , list, 1 );
        } catch (IOException e) {
            e.printStackTrace();
        }

        log.info(result.toString());*/


        /*String sql = "SELECT A.tchr_mbr_no,A.clas_room_ser, A.sch_no, A.clas_room_nm,  A.clas_room_type_cd\n" +
                "            ,B.NM as tchr_mbr_nm\n" +
                "            ,C.sch_nm as si_sch_nm\n" +
                "          FROM CNET_CLAS_ROOM_INFO A\n" +
                "    INNER JOIN  CNET_MBR_INFO B\n" +
                "            ON A.tchr_mbr_no = B.mbr_no\n" +
                "    INNER JOIN  CNET_SCH_INFO C\n" +
                "            ON A.sch_no = C.sch_no\n" +
                "    INNER JOIN CNET_CLAS_ROOM_REG_REQ_HIST E\n" +
                "            ON A.clas_room_ser   = E.clas_room_ser\n" +
                "               and b.mbr_no = e.req_mbr_no\n" +
                "    INNER JOIN CNET_CODE F\n" +
                "            ON E.reg_stat_cd  = F.cd\n" +
                "           AND F.sup_cd = '101524'\n";


        RowMapper<ClasRoomInfo> userRowMapper = new RowMapper<ClasRoomInfo>() {
            @Override
            public ClasRoomInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
                ClasRoomInfo emp = new ClasRoomInfo();
                emp.setTchrMbrNo(rs.getString("tchr_mbr_no"));
                emp.setClasRoomSer(rs.getInt("clas_room_ser"));
                emp.setSchNo(rs.getString("sch_no"));
                emp.setClasRoomNm(rs.getString("clas_room_nm"));
                emp.setSchNm(rs.getString("si_sch_nm"));


                return emp;
            }
        };
        List<ClasRoomInfo> users = jdbcTemplate.query(sql, userRowMapper);


        log.info("rtn ::::> " + users);*/


        List<ClasRoomInfo> users = Lists.newArrayList();
        try {
            for(ClasRoomInfo user: users) {
                String id = user.getTchrMbrNo()+ "" + user.getClasRoomSer();
                String name = user.getSchNm()+"[" + user.getClasRoomNm()+"]";
                JSONObject rtn = HttpRequestUtils.setUser("I", id, name, user.getTchrMbrNo(), "");

                String resultStr = (String) rtn.get("message");
                log.info("rtn ::::> " + resultStr);

                if ("Duplicated user id".equals(resultStr)) {
                    rtn = HttpRequestUtils.setUser("U", id, name, user.getTchrMbrNo(), "");

                    resultStr = (String) rtn.get("message");
                    if ("Successfully Saved".equals(resultStr))
                        log.info("success ::::> " + resultStr);
                    else
                        log.info("failed ::::> " + resultStr + "[]");
                }
            }
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        } catch (InvalidAlgorithmParameterException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }


        /*
        log.info("result ::" + StringUtils.replacePattern("2011-11-11 21:00", "[-:\\s]", ""));


        JSONObject postData = new JSONObject();
        postData.put("USER_ID","segnat");
        postData.put("CLAS_SEQ","100005131");
        postData.put("SCHD_TITLE","배치테스트 수업2");
        postData.put("SCHD_START_TIME","20151230090000");
        postData.put("SCHD_END_TIME","20151230095000");
        postData.put("SCHD_YN","Y");

        HttpRequestUtils.sendSchedule("http://stg-planner.career.go.kr:8080/mentoringSchd.ajax", postData);
        */
        /*try {

            final HttpClient client = new HttpClient();
            client.getParams().setParameter("http.useragent", "SEEDS Client");

            PostMethod method = new PostMethod("http://www.sms17.com/minisms/sms_sgl/minisms_sendp.php");
            NameValuePair[] parameters = new NameValuePair[6];
            parameters[0] = new NameValuePair("uid", "ntels"); // 고객님의 SMS17 아이디
            parameters[1] = new NameValuePair("pass", "piu7f4c4e5bb9Iqz"); //웹연동 전용 패스워드(http://www.sms17.com 로그인 후 회원정보 수정에 가면 있음)
            parameters[2] = new NameValuePair("rphone", "01086328595");    //발신번호(숫자만)  01038161099
            parameters[3] = new NameValuePair("sphone", "01038161099");    //회신번호(숫자만)
            parameters[4] = new NameValuePair("sd", "");      // 공백인 경우 즉시 발송, 년월일시분(ex: 200812092358) 예약 발송
            parameters[5] = new NameValuePair("msg", URLEncoder.encode("TEST", "EUC-KR"));       // 영문 90자, 한글 45자



            method.setRequestBody(parameters);

            method.getParams().setContentCharset("EUC-KR");
            //method.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");

            int statusCode = 0;
            String resultString = "";

            log.debug("called......{}", statusCode);
            statusCode = client.executeMethod(method);

            resultString = method.getResponseBodyAsString();
            log.debug("result......{}", resultString);


        } catch (Exception e) {
            //e.printStackTrace();

            log.debug("{}", e.getMessage());
        }*/


    }

}