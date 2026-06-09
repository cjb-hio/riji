package com.example.rijiserver.controller;

import com.example.rijiserver.document.Diary;
import com.example.rijiserver.dto.DiaryRequest;
import com.example.rijiserver.dto.DiaryResponse;
import com.example.rijiserver.security.AuthUser;
import com.example.rijiserver.service.DiaryService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/diaries")
public class DiaryController {

    private final DiaryService diaryService;

    public DiaryController(DiaryService diaryService) {
        this.diaryService = diaryService;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getDiaries(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String mood
    ) {
        String userId = getUserId(userDetails);
        size = Math.min(size, 100);

        Page<Diary> diaryPage = diaryService.getDiaries(userId, page, size, startDate, endDate, mood);

        Map<String, Object> response = new HashMap<>();
        response.put("content", diaryPage.getContent().stream().map(DiaryResponse::new));
        response.put("page", diaryPage.getNumber());
        response.put("size", diaryPage.getSize());
        response.put("totalElements", diaryPage.getTotalElements());
        response.put("totalPages", diaryPage.getTotalPages());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<DiaryResponse> getDiary(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable String id
    ) {
        String userId = getUserId(userDetails);
        return diaryService.getDiaryById(id, userId)
                .map(diary -> ResponseEntity.ok(new DiaryResponse(diary)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<DiaryResponse> createDiary(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody DiaryRequest request
    ) {
        String userId = getUserId(userDetails);
        Diary diary = diaryService.createDiary(
                userId,
                request.getClientId(),
                request.getTitle(),
                request.getContent(),
                request.getMood(),
                null
        );
        return ResponseEntity.ok(new DiaryResponse(diary));
    }

    @PutMapping("/{id}")
    public ResponseEntity<DiaryResponse> updateDiary(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable String id,
            @Valid @RequestBody DiaryRequest request
    ) {
        String userId = getUserId(userDetails);
        return diaryService.getDiaryById(id, userId)
                .map(diary -> {
                    Diary updated = diaryService.updateDiary(diary, request.getTitle(), request.getContent(), request.getMood());
                    return ResponseEntity.ok(new DiaryResponse(updated));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDiary(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable String id
    ) {
        String userId = getUserId(userDetails);
        return diaryService.getDiaryById(id, userId)
                .map(diary -> {
                    diaryService.softDeleteDiary(diary);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }

    private String getUserId(UserDetails userDetails) {
        if (userDetails instanceof AuthUser authUser) {
            return authUser.getUserId();
        }
        return userDetails.getUsername();
    }
}
