package com.monitor.backend.models;

import com.monitor.backend.data.Country;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CountryRepository extends MongoRepository<Country, String> {
}
