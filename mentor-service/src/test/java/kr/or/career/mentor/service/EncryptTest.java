package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.security.EgovFileScrty;
import kr.or.career.mentor.util.AESCipherUtils;
import lombok.extern.log4j.Log4j2;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@Log4j2
@ContextConfiguration(locations = {"classpath:spring/application-*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class EncryptTest {

    @Autowired
    protected UserService userService;

    @Test
    public void changePwd(){
        //for(int i=1; i <= 6 ; i++)
        {
            User user = new User();
            user.setMbrNo("1000000259");
            user.setId("teacher01");
            try {
                user.setPassword(EgovFileScrty.encryptPassword("1", user.getId()));
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            userService.updatePwd(user);
        }
    }

    @Test
    public void decript() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
        //String str = "ef9fb981778706038fcab976aec185e6926d6c48f327cedcc5a15f6fe4039661ba4e7bba33ec99b66d1cf90cea07894d57f1fec0321fe2ab3aedcebcd40aa3e12f464997bf9218351a87b9f60614c0eb";
        String str = "4e4864322cfde93f42ca03dfb7384aa70376dfb08ab18b18fbeeecab3e08787ff12757c4f9f19c742ef6e80c87e77c2d48d6d7e8f7747043542c41ad46ebf124";
        String dec = AESCipherUtils.decript(str);
        log.info(dec);
    }

}
