/* license */
package kr.or.career.mentor.service;

import com.beust.jcommander.internal.Lists;
import kr.or.career.mentor.util.AESCipherUtils;
import kr.or.career.mentor.util.HttpRequestUtils;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.codec.DecoderException;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    TommsTest.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 29. 오후 3:21:09
 * @author  technear
 * @see
 */
@Log4j2
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class TommsTest {

    @Test
    public void getParticipantList() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{

        List<String> participantLists = Lists.newArrayList();

        JSONObject json = HttpRequestUtils.getParticipantList("2762");
        JSONArray array = json.getJSONArray("dataSet");
        for(int i =0; i < array.size(); i++){
            JSONObject obj = array.getJSONObject(i);
            participantLists.add(obj.getString("userid_"));
            log.info("RETURN userId : {}",obj.getString("userid_"));

        }

        //98d222ab8b6aefbf5ccf553c9e4a7d08d6b19b01ce4f42344470ac926d5f4634a0529fd6132e0d5728ad9ca17af8599d6fca709b05fe625e5b8d958ff0b92085
    }

    @Test
    public void addAttendance() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{

        //JSONObject json = HttpRequestUtils.addAttendance("1493","SCH0001");
        //log.info("RETURN JSON : {}",json.toString());
    }

    @Test
    public void decript() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException, DecoderException{
        log.info("rtn : {}",AESCipherUtils.decriptHex("98d222ab8b6aefbf5ccf553c9e4a7d08d6b19b01ce4f42344470ac926d5f4634a0529fd6132e0d5728ad9ca17af8599d6fca709b05fe625e5b8d958ff0b92085"));
    }

    @Test
    public void setUser() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{

        JSONObject json = HttpRequestUtils.setUser("I","maxIdTest01234567890","maxIdTest01234567890","1q2w3e4r5t!@%^","mentoring@yopmail.com");
        log.info("RETURN JSON : {}",json.toString());
    }

    @Test
    public void encript() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        String str = "2283";
        log.info("encriptHex : "+AESCipherUtils.encriptHex(str));
        log.info("encriptBase64 : "+AESCipherUtils.encriptBase64(str));
    }


}
