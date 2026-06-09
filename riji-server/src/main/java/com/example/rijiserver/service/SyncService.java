package com.example.rijiserver.service;

import com.example.rijiserver.document.Diary;
import com.example.rijiserver.dto.DiaryResponse;
import com.example.rijiserver.dto.SyncRequest;
import com.example.rijiserver.dto.SyncResponse;
import com.example.rijiserver.repository.DiaryRepository;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class SyncService {

    private final DiaryRepository diaryRepository;
    private final DiaryService diaryService;

    public SyncService(DiaryRepository diaryRepository, DiaryService diaryService) {
        this.diaryRepository = diaryRepository;
        this.diaryService = diaryService;
    }

    public SyncResponse sync(String userId, SyncRequest request) {
        Instant syncTime = Instant.now();
        List<DiaryResponse> result = new ArrayList<>();

        if (request.getDiaries() != null) {
            for (SyncRequest.DiarySyncItem item : request.getDiaries()) {
                mergeDiary(userId, item, syncTime);
            }
        }

        Instant since = request.getLastSyncAt() != null ? request.getLastSyncAt() : Instant.EPOCH;
        List<Diary> changed = diaryService.getChangedSince(userId, since);

        for (Diary diary : changed) {
            result.add(new DiaryResponse(diary));
        }

        return new SyncResponse(syncTime, result);
    }

    private void mergeDiary(String userId, SyncRequest.DiarySyncItem item, Instant syncTime) {
        Optional<Diary> existingOpt;

        if (item.getServerId() != null) {
            existingOpt = diaryRepository.findByIdAndUserId(item.getServerId(), userId);
        } else if (item.getClientId() != null) {
            existingOpt = diaryRepository.findByClientIdAndUserId(item.getClientId(), userId);
        } else {
            return;
        }

        if (existingOpt.isPresent()) {
            Diary existing = existingOpt.get();
            if (item.getUpdatedAt() != null && existing.getUpdatedAt() != null
                    && item.getUpdatedAt().isAfter(existing.getUpdatedAt())) {
                existing.setTitle(item.getTitle());
                existing.setContent(item.getContent());
                existing.setMood(item.getMood());
                existing.setDeleted(item.isDeleted());
                existing.setUpdatedAt(syncTime);
                diaryRepository.save(existing);
            }
        } else {
            Diary newDiary = new Diary();
            newDiary.setClientId(item.getClientId());
            newDiary.setTitle(item.getTitle());
            newDiary.setContent(item.getContent());
            newDiary.setMood(item.getMood());
            newDiary.setCreatedAt(item.getCreatedAt() != null ? item.getCreatedAt() : syncTime);
            newDiary.setUpdatedAt(item.getUpdatedAt() != null ? item.getUpdatedAt() : syncTime);
            newDiary.setDeleted(item.isDeleted());
            newDiary.setUserId(userId);
            diaryRepository.save(newDiary);
        }
    }
}
