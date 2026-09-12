package com.example.rijiserver.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.example.rijiserver.document.Diary;
import com.example.rijiserver.dto.DiaryRequest;
import com.example.rijiserver.dto.DiaryResponse;
import com.example.rijiserver.dto.PageResponse;
import com.example.rijiserver.service.DiaryService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/diaries")
public class DiaryController {

    private final DiaryService diaryService;

    public DiaryController(DiaryService diaryService) {
        this.diaryService = diaryService;
    }

    @GetMapping
    public ResponseEntity<PageResponse<DiaryResponse>> getDiaries(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String mood
    ) {
        if (page < 0) {
            throw new IllegalArgumentException("page must be greater than or equal to 0");
        }
        if (size < 1 || size > 100) {
            throw new IllegalArgumentException("size must be between 1 and 100");
        }

        String userId = StpUtil.getLoginIdAsString();

        Page<Diary> diaryPage = diaryService.getDiaries(userId, page, size, startDate, endDate, mood);
        return ResponseEntity.ok(PageResponse.from(diaryPage.map(DiaryResponse::new)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<DiaryResponse> getDiary(
            @PathVariable String id
    ) {
        String userId = StpUtil.getLoginIdAsString();
        return diaryService.getDiaryById(id, userId)
                .map(diary -> ResponseEntity.ok(new DiaryResponse(diary)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<DiaryResponse> createDiary(
            @Valid @RequestBody DiaryRequest request
    ) {
        String userId = StpUtil.getLoginIdAsString();
        Diary diary = diaryService.createDiary(
                userId,
                request.getTitle(),
                request.getContent(),
                request.getMood()
        );
        return ResponseEntity.ok(new DiaryResponse(diary));
    }

    @PutMapping("/{id}")
    public ResponseEntity<DiaryResponse> updateDiary(
            @PathVariable String id,
            @Valid @RequestBody DiaryRequest request
    ) {
        String userId = StpUtil.getLoginIdAsString();
        return diaryService.getDiaryById(id, userId)
                .map(diary -> {
                    Diary updated = diaryService.updateDiary(diary, request.getTitle(), request.getContent(), request.getMood());
                    return ResponseEntity.ok(new DiaryResponse(updated));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDiary(
            @PathVariable String id
    ) {
        String userId = StpUtil.getLoginIdAsString();
        return diaryService.getDiaryById(id, userId)
                .map(diary -> {
                    diaryService.softDeleteDiary(diary);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }

}
