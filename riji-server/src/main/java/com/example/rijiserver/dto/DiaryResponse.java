package com.example.rijiserver.dto;

import com.example.rijiserver.document.Diary;

import java.time.Instant;

public class DiaryResponse {

    private String clientId;
    private String serverId;
    private String title;
    private String content;
    private String mood;
    private Instant createdAt;
    private Instant updatedAt;
    private boolean deleted;

    public DiaryResponse() {
    }

    public DiaryResponse(Diary diary) {
        this.clientId = diary.getClientId();
        this.serverId = diary.getId();
        this.title = diary.getTitle();
        this.content = diary.getContent();
        this.mood = diary.getMood();
        this.createdAt = diary.getCreatedAt();
        this.updatedAt = diary.getUpdatedAt();
        this.deleted = diary.isDeleted();
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
