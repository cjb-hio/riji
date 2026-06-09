package com.example.rijiserver.dto;

import java.time.Instant;
import java.util.List;

public class SyncResponse {

    private Instant syncAt;
    private List<DiaryResponse> diaries;

    public SyncResponse() {
    }

    public SyncResponse(Instant syncAt, List<DiaryResponse> diaries) {
        this.syncAt = syncAt;
        this.diaries = diaries;
    }

    public Instant getSyncAt() {
        return syncAt;
    }

    public void setSyncAt(Instant syncAt) {
        this.syncAt = syncAt;
    }

    public List<DiaryResponse> getDiaries() {
        return diaries;
    }

    public void setDiaries(List<DiaryResponse> diaries) {
        this.diaries = diaries;
    }
}
