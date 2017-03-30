/* license */
package kr.or.career.mentor.service;

import java.util.List;

import kr.or.career.mentor.domain.*;
import org.springframework.security.core.Authentication;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    SchInfoService.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 22. 오후 5:42:01
 * @author  technear
 * @see
 */
public interface SchInfoService {
    public List<SchInfo> listSchInfo(SchInfo schInfo);

    public List<SchInfoDTO> listSchInfoWithGroup(BizGrpSearch bizGrpSearch);

    public SchInfoDTO retrieveSchInfoDetail(SchInfo schInfo);

    public SchInfo retrieveSchInfo(SchInfo schInfo);

    public void saveSchInfo(SchInfo schInfo);

    public List<AssignGroupDTO> listAssignGroupListBySchool(SchInfo schInfo);

    public List<SchInfoExcelDTO> excelDownListSchInfoWithGroup(BizGrpSearch bizGrpSearch);

    public Integer deleteSchCualf(SchInfo schInfo);

    public Integer insertSchCualf(List<SchInfo> schInfos, Authentication authentication);

    public List<SchJobGroup> listSchJobGroupInfo(SchJobGroup schJobGroup);
}
