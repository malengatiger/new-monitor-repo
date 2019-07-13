package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Country;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository

public interface CountryRepository extends MongoRepository<Country, String> {

}
