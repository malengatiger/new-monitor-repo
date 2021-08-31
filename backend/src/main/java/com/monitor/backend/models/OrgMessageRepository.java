package com.monitor.backend.models;

import com.monitor.backend.data.OrgMessage;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface OrgMessageRepository extends PagingAndSortingRepository<OrgMessage, String> {

    List<OrgMessage> findByOrganizationId(String organizationId);
    List<OrgMessage> findByProjectId(String projectId);
    List<OrgMessage> findByUserId(String userId);

}
