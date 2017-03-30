package kr.or.career.mentor.domain;

import com.google.common.collect.Lists;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.apache.commons.lang3.StringUtils;

import java.util.Collections;
import java.util.List;

/**
 * 직업정보 관리를 위한 VO 클래스
 * @author
 * @since
 * @version 1.0
 * @see
 *
 */

@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class JobInfo extends Base {

    private static final long serialVersionUID = -8025184644267347284L;

    /** 직업_번호 */
    private String jobNo;

    /** 직업_분류_코드 */
    private String jobClsfCd;

    /** 1차분류코드 */
    private String jobClsfCdLv1;

    /** 2차분류코드 */
    private String jobClsfCdLv2;

    /** 3차분류코드 */
    private String jobClsfCdLv3;

    /** 직업_이름 */
    private String jobNm;

    /** 직업_정의_이름 */
    private String jobDefNm;

    /** 직업_사진_경로 */
    private String jobPicInfo;

    /** 직업_소개_정보 */
    private String jobIntdcInfo;

    /** 핵심_능력_정보 */
    private String coreAblInfo;

    /** 연관_학과_정보 */
    private String assoSchDeptInfo;

    /** 연관_자격_정보 */
    private String assoCualfInfo;

    /** 유사_직업_이름 */
    private String smlrJobNm;

    /** 등록_일시 */
    private String regDtm;

    /** 등록_회원_번호 */
    private String regMbrNo;

    // transient =======================================================
    private String jobClsfNm;

    /** 1차분류명 */
    private String jobClsfNmLv1;

    /** 2차분류명 */
    private String jobClsfNmLv2;

    /** 3차분류명 */
    private String jobClsfNmLv3;

    /** 직업에 속한 멘토수 */
    private int mentorCnt;

    /** 직업에 속한 멘토의 프로필 이미지 정보 */
    private String mentorProfPicInfo;

    /** 등록자_이름 */
    private String regMbrNm;

    /** 등록자_ID */
    private String regMbrId;

    /** 검색조건 */
    private String searchWord;

    private String orderBy;

    @Data
    @AllArgsConstructor
    public class PicInfo{
        private String fileSer;
        private String picUrl;
    }

    private List<PicInfo> picInfoList;

    public List<PicInfo> getPicInfoList(){
        picInfoList = Lists.newArrayList();
        String[] jobPicInfos = StringUtils.split(this.jobPicInfo,',');

        if(jobPicInfos != null)
        for(String pic : jobPicInfos){
            picInfoList.add(new PicInfo(null,pic));
        }

        String[] mentorPicInfos = StringUtils.split(this.mentorProfPicInfo,',');

        if(mentorPicInfos != null)
        for(String pic : mentorPicInfos){
            picInfoList.add(new PicInfo(pic,null));
        }

        Collections.shuffle(picInfoList);

        return picInfoList;
    }

}
