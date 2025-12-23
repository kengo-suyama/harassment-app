package com.example.harassment.repository;

public class RepositoryProvider {
    private static final ConsultationRepository INSTANCE = new JdbcConsultationRepository();

    private RepositoryProvider() {}

    public static ConsultationRepository get() {
        return INSTANCE;
    }
}
