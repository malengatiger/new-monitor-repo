package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Questionnaire;
import org.springframework.data.mongodb.repository.MongoRepository;

import org.springframework.stereotype.Repository;

@Repository
public interface QuestionnaireRepository extends MongoRepository<Questionnaire, String> {

}
