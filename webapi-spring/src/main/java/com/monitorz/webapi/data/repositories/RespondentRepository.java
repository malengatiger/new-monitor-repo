package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Respondent;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RespondentRepository extends ReactiveMongoRepository<Respondent, String> {

}
