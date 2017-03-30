package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.ClassStatisticsExcelDto;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.StatisticsMentor;
import kr.or.career.mentor.service.StatisticsService;
import kr.or.career.mentor.view.GenericListExcelView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      StatisticsMentorController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-29 오후 1:06
 */
@Controller
@RequestMapping("statistics/class")
public class StatisticsClassController {

    @Autowired
    private StatisticsService statisticsService;

    /**
     * <pre>
     *     학교 목록 조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.schoolList.do")
    @ResponseBody
    public List<ClassStatisticsExcelDto> schoolList(LectureSearch lectureSearch) throws Exception{
        return statisticsService.excelSchoolList(lectureSearch);
    }

    /**
     * <pre>
     *     학교 목록 엑셀 다운로드
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping(value="excelSchoolList.do", method = RequestMethod.POST)
    public ModelAndView excelSchoolList(LectureSearch lectureSearch, Model model) throws Exception{

        List<ClassStatisticsExcelDto> statisticsExcelDtos = statisticsService.excelSchoolList(lectureSearch);

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "no"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "schNo"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "sidoNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "sgguNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "schClassNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "schNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "nm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "mobile"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "joinClassCdNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "clsCnt"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectCnt"));

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_adminSchoolList.xls");
        model.addAttribute("domains", statisticsExcelDtos);
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("excelListView","data",model);
    }

    /**
     * <pre>
     *     클래스별 수업목록 조회
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.classLectureList.do")
    @ResponseBody
    public List<ClassStatisticsExcelDto> classLectureList(LectureSearch lectureSearch) throws Exception{
        return statisticsService.excelClassLectureList(lectureSearch);
    }

    /**
     * <pre>
     *     클래스별 수업목록 엑셀 다운로드
     * </pre>
     * @param lectureSearch
     * @return
     * @throws Exception
     */
    @RequestMapping(value="excelClassLectureList.do", method = RequestMethod.POST)
    public ModelAndView excelClassLectureList(LectureSearch lectureSearch, Model model) throws Exception{

        List<ClassStatisticsExcelDto> statisticsExcelDtos = statisticsService.excelClassLectureList(lectureSearch);

        ArrayList<Field> listHeaderField = new ArrayList<>();
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "clasRoomSer"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "clasRoomNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "sidoNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "sgguNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "schClassNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "schNo"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "schNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "nm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "mobile"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "joinClassCdNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectTims"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "schdSeq"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectId"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectStatCdNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectDay"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectTime"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectJobClsfNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "jobNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectrNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectTypeCdNm"));
        listHeaderField.add(GenericListExcelView.getField(ClassStatisticsExcelDto.class, "lectTitle"));

        //파일명
        GregorianCalendar gc = new GregorianCalendar();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmm"); // 기본 데이타베이스 저장 타입
        Date d = gc.getTime(); // Date -> util 패키지
        String str = sf.format(d);

        model.addAttribute("fileName", str + "_adminClassLectureList.xls");
        model.addAttribute("domains", statisticsExcelDtos);
        model.addAttribute("listHeaderField",listHeaderField);

        return new ModelAndView("excelListView","data",model);
    }



}
