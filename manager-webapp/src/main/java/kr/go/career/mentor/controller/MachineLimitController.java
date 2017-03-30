/* license */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.domain.ClasSetHist;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.CodeManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    MachineLimit.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 26. 오후 6:01:20
 * @author  technear
 * @see
 */
@Controller
@RequestMapping("lecture/limit")
public class MachineLimitController {
    @Autowired
    CodeManagementService codeManagementService;

    @RequestMapping(value={"list","edit"})
    @Historic(workId = "1000000116")
    public void main(Model model, Authentication authentication) {
        ClasSetHist retrieveClasSetHistList =  codeManagementService.retrieveClasSetHist();
        if(retrieveClasSetHistList == null){
            retrieveClasSetHistList.setMaxApplCnt(0);
            retrieveClasSetHistList.setMaxObsvCnt(0);
        }
        model.addAttribute("clasSetHist", retrieveClasSetHistList);
    }

    @RequestMapping(value={"saveMachineLimit"})
    @Historic(workId = "1000000117")
    public String save(ClasSetHist clasSetHist, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        clasSetHist.setRegMbrNo(user.getMbrNo());
        codeManagementService.insertClasSetHist(clasSetHist);
        return "redirect:list.do";
    }
}
