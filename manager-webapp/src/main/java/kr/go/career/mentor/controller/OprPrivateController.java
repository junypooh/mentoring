package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.WorkInfo;
import kr.or.career.mentor.service.WorkHistoryService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      OprPrivateController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-08-30 오후 1:17
 */
@Controller
@RequestMapping("/opr/private")
@Slf4j
public class OprPrivateController {

    @Autowired
    private WorkHistoryService workHistoryService;

    /**
     * <pre>
     *     운영관리 > 개인정보접속관리 리스트
     * </pre>
     * @param workInfo
     * @return
     * @throws Exception
     */
    @RequestMapping("/ajax.list.do")
    @ResponseBody
    public List<WorkInfo> listPrivateAjax(@Pageable WorkInfo workInfo) {

        return workHistoryService.selectWorkHistList(workInfo);
    }

    /**
     * <pre>
     *     운영관리 > 개인정보접속관리 엑셀 다운로드
     * </pre>
     * @param workInfo
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="excel.do",method= RequestMethod.POST)
    public ModelAndView excelDownlist(WorkInfo workInfo, Model model) throws Exception{
        List<WorkInfo> originList = workHistoryService.selectWorkHistList(workInfo);

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_개인정보접속현황.xls");
        model.addAttribute("domains", originList);

        return new ModelAndView("excelView", "data", model);
    }
}
