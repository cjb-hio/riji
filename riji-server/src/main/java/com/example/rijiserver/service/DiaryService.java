package com.example.rijiserver.service;

import com.example.rijiserver.document.Diary;
import com.example.rijiserver.repository.DiaryRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.Optional;

@Service
public class DiaryService {

    private final DiaryRepository diaryRepository;

    public DiaryService(DiaryRepository diaryRepository) {
        this.diaryRepository = diaryRepository;
    }

    public Diary createDiary(String userId, String title, String content, String mood) {
        Diary diary = new Diary();
        diary.setTitle(title);
        diary.setContent(content);
        diary.setMood(mood);
        diary.setUserId(userId);
        diary.setCreatedAt(Instant.now());
        diary.setUpdatedAt(Instant.now());
        diary.setDeleted(false);
        return diaryRepository.save(diary);
    }

    public Optional<Diary> getDiaryById(String id, String userId) {
        return diaryRepository.findByIdAndUserId(id, userId)
                .filter(d -> !d.isDeleted());
    }

    public Page<Diary> getDiaries(String userId, int page, int size, LocalDate startDate, LocalDate endDate, String mood) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));

        if (startDate != null && endDate != null) {
            Instant start = startDate.atStartOfDay().toInstant(ZoneOffset.UTC);
            Instant end = endDate.plusDays(1).atStartOfDay().toInstant(ZoneOffset.UTC);
            if (mood != null && !mood.isBlank()) {
                return diaryRepository.findByUserIdAndMoodAndUpdatedAtBetweenAndDeletedFalse(
                        userId, mood, start, end, pageable);
            }
            return diaryRepository.findByUserIdAndUpdatedAtBetweenAndDeletedFalse(userId, start, end, pageable);
        }

        if (mood != null && !mood.isBlank()) {
            return diaryRepository.findByUserIdAndMoodAndDeletedFalse(userId, mood, pageable);
        }

        return diaryRepository.findByUserIdAndDeletedFalse(userId, pageable);
    }

    public Diary updateDiary(Diary diary, String title, String content, String mood) {
        diary.setTitle(title);
        diary.setContent(content);
        diary.setMood(mood);
        diary.setUpdatedAt(Instant.now());
        return diaryRepository.save(diary);
    }

    public void softDeleteDiary(Diary diary) {
        diary.setDeleted(true);
        diary.setUpdatedAt(Instant.now());
        diaryRepository.save(diary);
    }
}
