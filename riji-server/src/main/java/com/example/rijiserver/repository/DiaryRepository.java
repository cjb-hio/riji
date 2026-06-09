package com.example.rijiserver.repository;

import com.example.rijiserver.document.Diary;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Repository
public interface DiaryRepository extends MongoRepository<Diary, String> {

    Optional<Diary> findByIdAndUserId(String id, String userId);

    Optional<Diary> findByClientIdAndUserId(String clientId, String userId);

    List<Diary> findByUserIdOrderByCreatedAtDesc(String userId);

    Page<Diary> findByUserIdAndDeletedFalse(String userId, Pageable pageable);

    List<Diary> findByUserIdAndUpdatedAtAfterAndDeletedFalse(String userId, Instant updatedAt);

    List<Diary> findByUserIdAndUpdatedAtBetweenAndDeletedFalse(String userId, Instant start, Instant end);

    Page<Diary> findByUserIdAndUpdatedAtBetweenAndDeletedFalse(String userId, Instant start, Instant end, Pageable pageable);
}
