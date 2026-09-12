package com.example.rijiserver.repository;

import com.example.rijiserver.document.Diary;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.Optional;

@Repository
public interface DiaryRepository extends MongoRepository<Diary, String> {

    Optional<Diary> findByIdAndUserId(String id, String userId);

    Page<Diary> findByUserIdAndDeletedFalse(String userId, Pageable pageable);

    Page<Diary> findByUserIdAndMoodAndDeletedFalse(String userId, String mood, Pageable pageable);

    Page<Diary> findByUserIdAndUpdatedAtBetweenAndDeletedFalse(
            String userId, Instant start, Instant end, Pageable pageable);

    Page<Diary> findByUserIdAndMoodAndUpdatedAtBetweenAndDeletedFalse(
            String userId, String mood, Instant start, Instant end, Pageable pageable);
}
