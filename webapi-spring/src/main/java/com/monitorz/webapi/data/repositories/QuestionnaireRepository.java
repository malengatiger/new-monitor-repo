package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Questionnaire;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QuestionnaireRepository extends ReactiveMongoRepository<Questionnaire, String> {

}
