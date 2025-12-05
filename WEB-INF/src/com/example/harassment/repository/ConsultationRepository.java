package com.example.harassment.repository;

import com.example.harassment.model.Consultation;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 簡易なインメモリの相談データ保存クラス。
 * 本番では DB などに差し替え可能な設計。
 */
public class ConsultationRepository {

    // 全相談を保持するリスト（サーバー起動中のみ有効）
    private static final List<Consultation> data = new ArrayList<>();
    private static int sequence = 1;

    // 相談を保存し、受付番号を採番
    public synchronized void save(Consultation c) {
        c.setId(sequence++);
        data.add(c);
    }

    // 一覧取得（管理者・マスター用）
    public List<Consultation> findAll() {
        return Collections.unmodifiableList(data);
    }
}

