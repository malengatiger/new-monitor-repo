package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Respondent;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RespondentRepository extends MongoRepository<Respondent, String>{

}
