package kr.or.career.mentor.tomms;

import kr.or.career.mentor.domain.WithdrawInfo;

import java.util.List;

/**
 * Created by chaos on 2016. 8. 18..
 */
public interface TommsMapper {

    List<WithdrawInfo> retrieveSuccessedObservation(List<WithdrawInfo> withdrawInfos);
}
