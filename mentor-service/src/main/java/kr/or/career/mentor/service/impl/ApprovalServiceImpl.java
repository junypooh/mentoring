/* ntels */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.ApprovalMapper;
import kr.or.career.mentor.domain.ApprovalRequest;
import kr.or.career.mentor.domain.ApprovalSummary;
import kr.or.career.mentor.domain.SearchOption;
import kr.or.career.mentor.service.ApprovalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    ApprovalServiceImpl
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 23. 오후 2:05
 */
@Service
public class ApprovalServiceImpl implements ApprovalService {

    @Autowired
    private ApprovalMapper approvalMapper;

    @Override
    public List<ApprovalRequest> listApprovalRequest(SearchOption searchOption) {
        return approvalMapper.listApprovalRequest(searchOption);
    }

    @Override
    public ApprovalSummary selectSummarizedApprovalRequest() {
        return null;
    }

    @Override
    public int approveRequest(ApprovalRequest approvalRequest) {
        return 0;
    }

    @Override
    public int rejectRequest(ApprovalRequest approvalRequest) {
        return 0;
    }
}
