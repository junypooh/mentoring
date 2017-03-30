/* license */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.StudioMapper;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.domain.StdoInfo;
import kr.or.career.mentor.service.StudioService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    StudioServiceImpl.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 26. 오후 6:56:14
 * @author  technear
 * @see
 */
@Service("studioService")
public class StudioServiceImpl implements StudioService{

    @Autowired
    StudioMapper studioMapper;

    @Override
    public List<StdoInfo> listStudio(StdoInfo stdoInfo) {
        return studioMapper.listStudio(stdoInfo);
    }

    @Override
    public List<StdoInfo> listStudioPaging(StdoInfo stdoInfo) {
        return studioMapper.listStudioPaging(stdoInfo);
    }

    @Override
    public int retrieveStudioScheduleDuplicationCnt(LectSchdInfo lectSchdInfo) {
        return studioMapper.retrieveStudioScheduleDuplicationCnt(lectSchdInfo);
    }

    @Override
    public int insertStudioInfo(StdoInfo stdoInfo) {
        return studioMapper.insertStudioInfo(stdoInfo);
    }

    @Override
    public int updateStudioInfo(StdoInfo stdoInfo) {
        return studioMapper.updateStudioInfo(stdoInfo);
    }

    @Override
    public StdoInfo retrieveStudioInfo(StdoInfo stdoInfo) {
        return studioMapper.retrieveStudioInfo(stdoInfo);
    }

    @Override
    public int saveStudioInfo(StdoInfo stdoInfo) {
        int rtn = 0;
        if(StringUtils.isEmpty(stdoInfo.getStdoNo())){
            rtn = studioMapper.insertStudioInfo(stdoInfo);
        }else{
            rtn = studioMapper.updateStudioInfo(stdoInfo);
        }
        return rtn;
    }

    @Override
    public int deleteStudioInfo(StdoInfo stdoInfo){

        return studioMapper.deleteStudioInfo(stdoInfo);
    }

    @Override
    public int retrieveRelatedLecSched(StdoInfo stdoInfo){
        return studioMapper.retrieveRelatedLecture(stdoInfo);
    }

    @Override
    public List<StdoInfo> getStudioInfo(StdoInfo stdoInfo) {
        return studioMapper.getStudioInfo(stdoInfo);
    }

    @Override
    public List<StdoInfo> getStudioSido() {
        return studioMapper.getStudioSido();
    }

    @Override
    public List<StdoInfo> getStudioSggu(StdoInfo stdoInfo) {
        return studioMapper.getStudioSggu(stdoInfo);
    }

}
