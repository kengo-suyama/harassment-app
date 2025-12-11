package com.example.harassment.repository;

import com.example.harassment.model.Consultation;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class MemoryConsultationRepository {

    private static final List<Consultation> STORE =
            Collections.synchronizedList(new ArrayList<>());

    private static int SEQUENCE = 1;

    public MemoryConsultationRepository() {
    }

    public void save(Consultation c) {
        synchronized (STORE) {
            if (c.getId() == 0) {
                // 新規登録
                c.setId(SEQUENCE++);
                STORE.add(c);
            } else {
                // 更新
                for (int i = 0; i < STORE.size(); i++) {
                    if (STORE.get(i).getId() == c.getId()) {
                        STORE.set(i, c);
                        return;
                    }
                }
                // 見つからなければ追加
                STORE.add(c);
            }
        }
    }

    public List<Consultation> findAll() {
        synchronized (STORE) {
            return new ArrayList<>(STORE);
        }
    }

    public Consultation findById(int id) {
        synchronized (STORE) {
            Iterator<Consultation> it = STORE.iterator();
            while (it.hasNext()) {
                Consultation c = it.next();
                if (c.getId() == id) {
                    return c;
                }
            }
            return null;
        }
    }
}
