/* license */
package kr.or.career.mentor.controller;

import java.util.ArrayList;
import java.util.List;

import kr.or.career.mentor.domain.ArclFileInfo;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.FileInfo;
import kr.or.career.mentor.domain.PagingObject;
import kr.or.career.mentor.service.BbsService;

import org.apache.poi.ss.formula.functions.T;
import org.quartz.SchedulerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    CommunityDataController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @since 2015. 9. 18. 오후 4:22:54
 * @author technear
 * @see
 */
@Controller
public class CommunityDataController {

  public static final Logger log = LoggerFactory.getLogger(BbsManagementController.class);

  @Autowired
  private BbsService bbsService;

  public PagingObject<ArclInfo> dataList() throws SchedulerException {

    List<ArclInfo> listArclInfo = new ArrayList<>();
    ArclInfo arclInfo = new ArclInfo();

    for (int i = 0; i < 9; i++) {
      arclInfo.setTitle("수업보조자료 및 사후활동지_8월 26일_최경민 멘토_초등용");
      List<ArclFileInfo> listArclFileInfo = new ArrayList<>();
      ArclFileInfo arclFile = new ArclFileInfo();
      FileInfo fileInfo = new FileInfo();
      fileInfo.setFileNm("test파일이름");
      arclFile.setFileInfo(fileInfo);
      listArclFileInfo.add(arclFile);
      arclInfo.setListArclFileInfo(listArclFileInfo);
      listArclInfo.add(arclInfo);
    }

    PagingObject<ArclInfo> rtn = new PagingObject<>();
    rtn.setData(listArclInfo);
    rtn.setTotalRecordCount(100);
    return rtn;
  }

}
