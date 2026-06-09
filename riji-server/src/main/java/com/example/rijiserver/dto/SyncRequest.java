package com.example.rijiserver.dto;

import java.time.Instant;
import java.util.List;

public class SyncRequest {

    private Instant lastSyncAt;
    private List<DiarySyncItem> diaries;

    public SyncRequest() {
    }

    public Instant getLastSyncAt() {
        return lastSyncAt;
    }

    public void setLastSyncAt(Instant lastSyncAt) {
        this.lastSyncAt = lastSyncAt;
    }

    public List<DiarySyncItem> getDiaries() {
        return diaries;
    }

    public void setDiaries(List<DiarySyncItem> diaries) {
        this.diaries = diaries;
    }

    public static class DiarySyncItem {
        private String clientId;
        private String serverId;
        private String title;
        private String content;
        private String mood;
        private Instant createdAt;
        private Instant updatedAt;
        private boolean deleted;

        public DiarySyncItem() {
        }

        public String getClientId() {
            return clientId;
        }

        public void setClientId(String clientId) {
            this.clientId = clientId;
        }

        public String getServerId() {
            return serverId;
        }

        public void setServerId(String serverId) {
            this.serverId = serverId;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getMood() {
            return mood;
        }

        public void setMood(String mood) {
            this.mood = mood;
        }

        public Instant getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Instant createdAt) {
            this.createdAt = createdAt;
        }

        public Instant getUpdatedAt() {
            return updatedAt;
        }

        public void setUpdatedAt(Instant updatedAt) {
            this.updatedAt = updatedAt;
        }

        public boolean isDeleted() {
            return deleted;
        }

        public void setDeleted(boolean deleted) {
            this.deleted = deleted;
        }
    }
}
