package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.MbrNotiInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.NotifInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      NotifInfoController
 *
 * 활동이력 > 알림내역 Controller
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-27 오후 5:41
 */
@Controller
@RequestMapping("notifInfo")
public class NotifInfoController {

    @Autowired
    private NotifInfoService notifInfoService;

    /**
     * <pre>
     *     알림내역 리스트
     * </pre>
     * @param mbrNotiInfo
     * @return
     */
    @RequestMapping("/ajax.mbrNotifInfoList.do")
    @ResponseBody
    public List<MbrNotiInfo> selectMbrNotifInfo(@Pageable MbrNotiInfo mbrNotiInfo, Authentication authentication) throws Exception{
        User user = (User) authentication.getPrincipal();
        mbrNotiInfo.setMbrNo(user.getMbrNo());
        return notifInfoService.selectMbrNotifInfo(mbrNotiInfo);
    }

    /**
     * <pre>
     *     알림내역 확인 UPDATE
     * </pre>
     * @param mbrNotiInfo
     * @return
     */
    @RequestMapping("/ajax.notifVerf.do")
    @ResponseBody
    public String updateNotifVerf(MbrNotiInfo mbrNotiInfo){
        return  notifInfoService.updateNotifVerf(mbrNotiInfo);
    }

    /**
     * <pre>
     *     알림내역 삭제
     * </pre>
     * @param mbrNotiInfo
     * @return
     */
    @RequestMapping("/ajax.deleteNotifInfo.do")
    @ResponseBody
    public String deleteMbrNotifInfo(MbrNotiInfo mbrNotiInfo){
        String rtnStr = "FAIL";
        if(mbrNotiInfo.getNotifSers() != null){
            try{
                for(String notifSer : mbrNotiInfo.getNotifSers()) {
                    mbrNotiInfo.setNotifSer(Integer.parseInt(notifSer));
                    notifInfoService.deleteMbrNotifInfo(mbrNotiInfo);
                }
                rtnStr = "SUCCESS";
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        return rtnStr;
    }

}
