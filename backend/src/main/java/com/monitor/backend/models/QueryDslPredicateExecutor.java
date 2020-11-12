package com.monitor.backend.models;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.List;
import java.util.function.Predicate;

public interface QueryDslPredicateExecutor<T> {

    T findOne(Predicate predicate);

    List<T> findAll(Predicate predicate);

    List<T> findAll(Predicate predicate, Sort... orders);

    Page<T> findAll(Predicate predicate, Pageable pageable);

    Long count(Predicate predicate);
}
