/* ntels */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.ApprovalRequest;
import kr.or.career.mentor.domain.ApprovalSummary;
import kr.or.career.mentor.domain.SearchOption;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    ApprovalService
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 23. 오후 2:01
 */
public interface ApprovalService {

    List<ApprovalRequest> listApprovalRequest(SearchOption searchOption);

    ApprovalSummary selectSummarizedApprovalRequest();

    int approveRequest(ApprovalRequest approvalRequest);

    int rejectRequest(ApprovalRequest approvalRequest);
}
