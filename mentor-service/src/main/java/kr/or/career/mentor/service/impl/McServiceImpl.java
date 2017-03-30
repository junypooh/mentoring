/* license */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.McMapper;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.LectureSearch;
import kr.or.career.mentor.domain.McInfo;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.McService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.HttpRequestUtils;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    McServiceImpl.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 27. 오후 1:28:58
 * @author  technear
 * @see
 */
@Service
public class McServiceImpl implements McService {

    @Autowired
    McMapper mcMapper;

    @Override
    public List<McInfo> listMc(McInfo mcInfo) {
        return mcMapper.listMc(mcInfo);
    }

    @Override
    public List<McInfo> listMcPaging(LectureSearch lectureSearch) {
        return mcMapper.listMcPaging(lectureSearch);
    }

    @Override
    public int retrieveMcScheduleDuplicationCnt(LectSchdInfo lectSchdInfo) {
        return mcMapper.retrieveMcScheduleDuplicationCnt(lectSchdInfo);
    }

    @Override
    public int insertMcInfo(McInfo mcInfo) {
        return mcMapper.insertMcInfo(mcInfo);
    }

    @Override
    public int updateMcInfo(McInfo mcInfo) {
        return mcMapper.updateMcInfo(mcInfo);
    }

    @Override
    public McInfo retrieveMcInfo(McInfo mcInfo) {
        return mcMapper.retrieveMcInfo(mcInfo);
    }

    @Override
    public int saveMcInfo(McInfo mcInfo) throws Exception{
        if(StringUtils.isEmpty(mcInfo.getMcNo())){

            int resultCnt = mcMapper.insertMcInfo(mcInfo);
            JSONObject json = HttpRequestUtils.setUser("I", "MC:" + mcInfo.getMcNo(), mcInfo.getMcNm(), "MC:" + mcInfo.getMcNo(), mcInfo.getMcNm(),
                    "", "0", "A", "1");
            String resultStr = (String) json.get("message");
            if (!"Successfully Saved".equals(resultStr)){
                throw new CnetException(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_);
            }
            return resultCnt;
        }else{
            return mcMapper.updateMcInfo(mcInfo);
        }
    }

}
