package com.example.rijiserver.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.example.rijiserver.dto.SyncRequest;
import com.example.rijiserver.dto.SyncResponse;
import com.example.rijiserver.service.SyncService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sync")
public class SyncController {

    private final SyncService syncService;

    public SyncController(SyncService syncService) {
        this.syncService = syncService;
    }

    @PostMapping
    public ResponseEntity<SyncResponse> sync(
            @RequestBody SyncRequest request
    ) {
        String userId = StpUtil.getLoginIdAsString();
        SyncResponse response = syncService.sync(userId, request);
        return ResponseEntity.ok(response);
    }
}
