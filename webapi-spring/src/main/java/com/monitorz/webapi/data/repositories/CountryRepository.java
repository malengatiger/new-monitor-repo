package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Country;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;

@Repository

public interface CountryRepository extends ReactiveMongoRepository<Country, String> {

}
