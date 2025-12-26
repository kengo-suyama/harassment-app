package com.example.harassment.repository;

import com.example.harassment.model.Consultation;

import java.time.LocalDateTime;
import java.util.List;

public interface ConsultationRepository {
    Consultation save(Consultation c);
    void update(Consultation c);
    Consultation findById(int id);
    Consultation findByAccessKey(String accessKey);
    List<Consultation> findAll();
    List<Consultation> search(String nameLike, String from, String to, String sort);
    void setAdminChecked(int id, boolean checked);
    void setStatus(int id, String status);
    void updateStatus(int id, String status);
    void saveFollowup(int id, String mode, String text);
    void addFollowUp(int id, String actorRole, String category, String text, LocalDateTime at);
    default void addFollowUp(int id, String actorRole, String category, String text) {
        addFollowUp(id, actorRole, category, text, null);
    }
    void appendChat(int id, String senderRole, String message);
    void addChat(int id, String senderRole, String message);
    void markChatRead(int id, String role);
    void saveEvaluation(int id, int rating, String feedback);
    void updateEvaluation(int id, int rating, String feedback);
    void saveSatisfaction(int id, String accessKey, int score, String comment);
}
