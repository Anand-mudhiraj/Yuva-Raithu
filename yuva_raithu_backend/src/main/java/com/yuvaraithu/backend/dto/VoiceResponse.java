package com.yuvaraithu.backend.dto;

public class VoiceResponse {
    private String intent;
    private String category;
    private String reply;

    public VoiceResponse(String intent, String category, String reply) {
        this.intent = intent;
        this.category = category;
        this.reply = reply;
    }

    public String getIntent() {
        return intent;
    }

    public void setIntent(String intent) {
        this.intent = intent;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }
}
