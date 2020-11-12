package com.monitor.backend.models;

import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface QuestionnaireRepository extends PagingAndSortingRepository<Questionnaire, String> {

    List<Questionnaire> findByProjectId(String projectId);
    List<Questionnaire> findByOrganizationId(String organizationId);
}
