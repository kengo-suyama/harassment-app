package com.example.harassment.repository;

import com.example.harassment.model.Consultation;

import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicLong;

public class MemoryConsultationRepository {

    // メモリ上の保存場所（全件）
    private static final List<Consultation> STORE = new CopyOnWriteArrayList<>();

    // ID 採番用
    private static final AtomicLong SEQUENCE = new AtomicLong(1);

    // 1件保存（新規）
    public Consultation save(Consultation c) {
        if (c.getId() == 0) {
            c.setId(SEQUENCE.getAndIncrement());
            STORE.add(c);
        }
        return c;
    }

    // 全件取得（管理者画面などで使える）
    public List<Consultation> findAll() {
        return new ArrayList<>(STORE);
    }

    // IDで1件取得（詳細画面用）
    public Consultation findById(long id) {
        for (Consultation c : STORE) {
            if (c.getId() == id) {
                return c;
            }
        }
        return null;
    }
}
