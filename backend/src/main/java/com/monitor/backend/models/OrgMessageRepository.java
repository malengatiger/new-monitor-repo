package com.monitor.backend.models;

import com.monitor.backend.data.OrgMessage;
import com.monitor.backend.data.Organization;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface OrgMessageRepository extends PagingAndSortingRepository<OrgMessage, String> {

    List<OrgMessage> findByOrganizationId(String countryId);

}
