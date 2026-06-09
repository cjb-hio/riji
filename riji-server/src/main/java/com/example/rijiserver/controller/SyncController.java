package com.example.rijiserver.controller;

import com.example.rijiserver.dto.SyncRequest;
import com.example.rijiserver.dto.SyncResponse;
import com.example.rijiserver.security.AuthUser;
import com.example.rijiserver.service.SyncService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
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
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody SyncRequest request
    ) {
        String userId = getUserId(userDetails);
        SyncResponse response = syncService.sync(userId, request);
        return ResponseEntity.ok(response);
    }

    private String getUserId(UserDetails userDetails) {
        if (userDetails instanceof AuthUser authUser) {
            return authUser.getUserId();
        }
        return userDetails.getUsername();
    }
}
