package com.example.harassment.repository;

import com.example.harassment.model.ChatMessage;
import com.example.harassment.model.Consultation;
import com.example.harassment.model.FollowUpRecord;

import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JdbcConsultationRepository implements ConsultationRepository {

    private static final String KEY_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789";
    private static final int KEY_LEN = 16;
    private final SecureRandom random = new SecureRandom();

    @Override
    public Consultation save(Consultation c) {
        if (c == null) return null;

        if (isBlank(c.getAccessKey())) {
            c.setAccessKey(generateKey());
        }
        if (isBlank(c.getStatus())) {
            c.setStatus("UNCONFIRMED");
        } else {
            c.setStatus(normStatus(c.getStatus()));
        }

        String sql = "INSERT INTO consultations (" +
                "access_key, sheet_date, consultant_name, summary, reported_exists, reported_person, reported_at, follow_up, " +
                "mental_scale, mental_detail, future_request, future_request_other_detail, share_permission, share_limited_targets, " +
                "admin_checked, follow_up_draft, follow_up_action, status, reporter_rating, reporter_feedback, reporter_rated_at, " +
                "satisfaction_score, satisfaction_comment, satisfaction_at, latest_chat_message, latest_chat_sender_role, latest_chat_at, " +
                "last_reporter_read_at, last_admin_read_at" +
                ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            int i = 1;
            ps.setString(i++, c.getAccessKey());
            setDate(ps, i++, c.getSheetDate());
            ps.setString(i++, emptyToNull(c.getConsultantName()));
            ps.setString(i++, safe(c.getSummary()));
            ps.setString(i++, emptyToNull(c.getReportedExists()));
            ps.setString(i++, emptyToNull(c.getReportedPerson()));
            setDateTime(ps, i++, c.getReportedAt());
            ps.setString(i++, emptyToNull(c.getFollowUp()));
            setInt(ps, i++, c.getMentalScale());
            ps.setString(i++, emptyToNull(c.getMentalDetail()));
            ps.setString(i++, emptyToNull(c.getFutureRequest()));
            ps.setString(i++, emptyToNull(c.getFutureRequestOtherDetail()));
            ps.setString(i++, emptyToNull(c.getSharePermission()));
            ps.setString(i++, emptyToNull(c.getShareLimitedTargets()));
            ps.setInt(i++, c.isAdminChecked() ? 1 : 0);
            ps.setString(i++, emptyToNull(c.getFollowUpDraft()));
            ps.setString(i++, emptyToNull(c.getFollowUpAction()));
            ps.setString(i++, normStatus(c.getStatus()));
            setIntNullable(ps, i++, c.getReporterRating());
            ps.setString(i++, emptyToNull(c.getReporterFeedback()));
            setTimestamp(ps, i++, c.getReporterRatedAt());
            setIntNullable(ps, i++, c.getSatisfactionScore());
            ps.setString(i++, emptyToNull(c.getSatisfactionComment()));
            setTimestamp(ps, i++, c.getSatisfactionAt());
            ps.setString(i++, emptyToNull(c.getLatestChatMessage()));
            ps.setString(i++, emptyToNull(c.getLatestChatSenderRole()));
            setTimestamp(ps, i++, c.getLatestChatAt());
            setTimestamp(ps, i++, c.getLastReporterReadAt());
            setTimestamp(ps, i++, c.getLastAdminReadAt());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    c.setId(rs.getInt(1));
                }
            }
            return c;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void update(Consultation c) {
        if (c == null || c.getId() <= 0) return;

        String sql = "UPDATE consultations SET " +
                "access_key=?, sheet_date=?, consultant_name=?, summary=?, reported_exists=?, reported_person=?, reported_at=?, follow_up=?, " +
                "mental_scale=?, mental_detail=?, future_request=?, future_request_other_detail=?, share_permission=?, share_limited_targets=?, " +
                "admin_checked=?, follow_up_draft=?, follow_up_action=?, status=?, reporter_rating=?, reporter_feedback=?, reporter_rated_at=?, " +
                "satisfaction_score=?, satisfaction_comment=?, satisfaction_at=?, latest_chat_message=?, latest_chat_sender_role=?, latest_chat_at=?, " +
                "last_reporter_read_at=?, last_admin_read_at=? " +
                "WHERE id=?";

        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;
            ps.setString(i++, emptyToNull(c.getAccessKey()));
            setDate(ps, i++, c.getSheetDate());
            ps.setString(i++, emptyToNull(c.getConsultantName()));
            ps.setString(i++, safe(c.getSummary()));
            ps.setString(i++, emptyToNull(c.getReportedExists()));
            ps.setString(i++, emptyToNull(c.getReportedPerson()));
            setDateTime(ps, i++, c.getReportedAt());
            ps.setString(i++, emptyToNull(c.getFollowUp()));
            setInt(ps, i++, c.getMentalScale());
            ps.setString(i++, emptyToNull(c.getMentalDetail()));
            ps.setString(i++, emptyToNull(c.getFutureRequest()));
            ps.setString(i++, emptyToNull(c.getFutureRequestOtherDetail()));
            ps.setString(i++, emptyToNull(c.getSharePermission()));
            ps.setString(i++, emptyToNull(c.getShareLimitedTargets()));
            ps.setInt(i++, c.isAdminChecked() ? 1 : 0);
            ps.setString(i++, emptyToNull(c.getFollowUpDraft()));
            ps.setString(i++, emptyToNull(c.getFollowUpAction()));
            ps.setString(i++, normStatus(c.getStatus()));
            setIntNullable(ps, i++, c.getReporterRating());
            ps.setString(i++, emptyToNull(c.getReporterFeedback()));
            setTimestamp(ps, i++, c.getReporterRatedAt());
            setIntNullable(ps, i++, c.getSatisfactionScore());
            ps.setString(i++, emptyToNull(c.getSatisfactionComment()));
            setTimestamp(ps, i++, c.getSatisfactionAt());
            ps.setString(i++, emptyToNull(c.getLatestChatMessage()));
            ps.setString(i++, emptyToNull(c.getLatestChatSenderRole()));
            setTimestamp(ps, i++, c.getLatestChatAt());
            setTimestamp(ps, i++, c.getLastReporterReadAt());
            setTimestamp(ps, i++, c.getLastAdminReadAt());
            ps.setInt(i, c.getId());

            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Consultation findById(int id) {
        String sql = "SELECT * FROM consultations WHERE id = ?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Consultation c = mapConsultation(rs);
                    loadChatMessages(con, c);
                    loadFollowUpHistory(con, c);
                    loadUnreadCounts(con, c);
                    return c;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public Consultation findByAccessKey(String accessKey) {
        String sql = "SELECT * FROM consultations WHERE access_key = ?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accessKey);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Consultation c = mapConsultation(rs);
                    loadChatMessages(con, c);
                    loadFollowUpHistory(con, c);
                    loadUnreadCounts(con, c);
                    return c;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public List<Consultation> findAll() {
        String sql = "SELECT c.*, " +
                "(SELECT COUNT(*) FROM consultation_chat_messages m " +
                " WHERE m.consultation_id=c.id AND m.sender_role='REPORTER' AND m.read_by_admin_at IS NULL) AS unread_for_admin, " +
                "(SELECT COUNT(*) FROM consultation_chat_messages m " +
                " WHERE m.consultation_id=c.id AND m.sender_role IN ('ADMIN','MASTER') AND m.read_by_reporter_at IS NULL) AS unread_for_reporter " +
                "FROM consultations c ORDER BY c.id";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Consultation> list = new ArrayList<>();
            while (rs.next()) {
                Consultation c = mapConsultation(rs);
                c.setUnreadForAdmin(rs.getInt("unread_for_admin"));
                c.setUnreadForReporter(rs.getInt("unread_for_reporter"));
                list.add(c);
            }
            return list;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Consultation> search(String nameLike, String from, String to, String sort) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT c.*, ");
        sb.append("(SELECT COUNT(*) FROM consultation_chat_messages m ");
        sb.append(" WHERE m.consultation_id=c.id AND m.sender_role='REPORTER' AND m.read_by_admin_at IS NULL) AS unread_for_admin, ");
        sb.append("(SELECT COUNT(*) FROM consultation_chat_messages m ");
        sb.append(" WHERE m.consultation_id=c.id AND m.sender_role IN ('ADMIN','MASTER') AND m.read_by_reporter_at IS NULL) AS unread_for_reporter ");
        sb.append("FROM consultations c WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        if (!isBlank(nameLike)) {
            sb.append("AND c.consultant_name LIKE ? ");
            params.add("%" + nameLike.trim() + "%");
        }
        if (!isBlank(from)) {
            sb.append("AND c.sheet_date >= ? ");
            params.add(Date.valueOf(from.trim()));
        }
        if (!isBlank(to)) {
            sb.append("AND c.sheet_date <= ? ");
            params.add(Date.valueOf(to.trim()));
        }

        if ("mental_desc".equalsIgnoreCase(sort)) {
            sb.append("ORDER BY c.mental_scale DESC ");
        } else if ("unconfirmed_first".equalsIgnoreCase(sort)) {
            sb.append("ORDER BY CASE c.status ")
              .append("WHEN 'UNCONFIRMED' THEN 0 ")
              .append("WHEN 'CONFIRMED' THEN 1 ")
              .append("WHEN 'REVIEWING' THEN 2 ")
              .append("WHEN 'IN_PROGRESS' THEN 3 ")
              .append("WHEN 'DONE' THEN 4 ")
              .append("ELSE 5 END, c.id DESC ");
        } else if ("id_desc".equalsIgnoreCase(sort)) {
            sb.append("ORDER BY c.id DESC ");
        } else {
            sb.append("ORDER BY c.id ASC ");
        }

        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                List<Consultation> list = new ArrayList<>();
                while (rs.next()) {
                    Consultation c = mapConsultation(rs);
                    c.setUnreadForAdmin(rs.getInt("unread_for_admin"));
                    c.setUnreadForReporter(rs.getInt("unread_for_reporter"));
                    list.add(c);
                }
                return list;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void setAdminChecked(int id, boolean checked) {
        String sql = "UPDATE consultations SET admin_checked=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, checked ? 1 : 0);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void setStatus(int id, String status) {
        String sql = "UPDATE consultations SET status=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normStatus(status));
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void updateStatus(int id, String status) {
        setStatus(id, status);
    }

    @Override
    public void saveFollowup(int id, String mode, String text) {
        String t = safe(text);
        String sql;
        if ("final".equalsIgnoreCase(mode)) {
            sql = "UPDATE consultations SET follow_up_action=?, " +
                    "status=CASE WHEN status='DONE' THEN status ELSE 'IN_PROGRESS' END " +
                    "WHERE id=?";
        } else {
            sql = "UPDATE consultations SET follow_up_draft=? WHERE id=?";
        }
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if ("final".equalsIgnoreCase(mode)) {
                ps.setString(1, t);
                ps.setInt(2, id);
            } else {
                ps.setString(1, t);
                ps.setInt(2, id);
            }
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void addFollowUp(int id, String actorRole, String category, String text, LocalDateTime at) {
        String t = safe(text);
        if (t.isEmpty()) return;

        String insert = "INSERT INTO consultation_followups (consultation_id, actor_role, category, body, created_at) " +
                "VALUES (?,?,?,?,?)";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(insert)) {
            ps.setInt(1, id);
            ps.setString(2, normRole(actorRole));
            ps.setString(3, emptyToNull(category));
            ps.setString(4, t);
            LocalDateTime dt = (at != null) ? at : LocalDateTime.now();
            ps.setTimestamp(5, Timestamp.valueOf(dt));
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void appendChat(int id, String senderRole, String message) {
        String msg = safe(message);
        if (msg.isEmpty()) return;

        LocalDateTime now = LocalDateTime.now();
        String insert = "INSERT INTO consultation_chat_messages " +
                "(consultation_id, sender_role, message, sent_at, read_by_reporter_at, read_by_admin_at) " +
                "VALUES (?,?,?,?,?,?)";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(insert)) {

            ps.setInt(1, id);
            String role = normRole(senderRole);
            ps.setString(2, role);
            ps.setString(3, msg);
            ps.setTimestamp(4, Timestamp.valueOf(now));
            if ("REPORTER".equals(role)) {
                ps.setTimestamp(5, Timestamp.valueOf(now));
                ps.setTimestamp(6, null);
            } else {
                ps.setTimestamp(5, null);
                ps.setTimestamp(6, Timestamp.valueOf(now));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        String update = "UPDATE consultations SET latest_chat_message=?, latest_chat_sender_role=?, latest_chat_at=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(update)) {
            ps.setString(1, msg);
            ps.setString(2, normRole(senderRole));
            ps.setTimestamp(3, Timestamp.valueOf(now));
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void addChat(int id, String senderRole, String message) {
        appendChat(id, senderRole, message);
    }

    @Override
    public void markChatRead(int id, String role) {
        String r = normRole(role);
        LocalDateTime now = LocalDateTime.now();
        if ("REPORTER".equals(r)) {
            String sql = "UPDATE consultation_chat_messages SET read_by_reporter_at=? " +
                    "WHERE consultation_id=? AND read_by_reporter_at IS NULL AND sender_role IN ('ADMIN','MASTER')";
            try (Connection con = DbUtil.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setTimestamp(1, Timestamp.valueOf(now));
                ps.setInt(2, id);
                ps.executeUpdate();
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            updateReadAt(id, "last_reporter_read_at", now);
        } else {
            String sql = "UPDATE consultation_chat_messages SET read_by_admin_at=? " +
                    "WHERE consultation_id=? AND read_by_admin_at IS NULL AND sender_role='REPORTER'";
            try (Connection con = DbUtil.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setTimestamp(1, Timestamp.valueOf(now));
                ps.setInt(2, id);
                ps.executeUpdate();
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            updateReadAt(id, "last_admin_read_at", now);
        }
    }

    @Override
    public void saveEvaluation(int id, int rating, String feedback) {
        int r = rating;
        if (r < 1) r = 1;
        if (r > 5) r = 5;
        String sql = "UPDATE consultations SET reporter_rating=?, reporter_feedback=?, reporter_rated_at=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, r);
            ps.setString(2, emptyToNull(feedback));
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void updateEvaluation(int id, int rating, String feedback) {
        saveEvaluation(id, rating, feedback);
    }

    @Override
    public void saveSatisfaction(int id, String accessKey, int score, String comment) {
        String sql = "UPDATE consultations SET satisfaction_score=?, satisfaction_comment=?, satisfaction_at=? " +
                "WHERE id=? AND access_key=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, score);
            ps.setString(2, emptyToNull(comment));
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(4, id);
            ps.setString(5, accessKey);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void updateReadAt(int id, String col, LocalDateTime at) {
        String sql = "UPDATE consultations SET " + col + "=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(at));
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private Consultation mapConsultation(ResultSet rs) throws Exception {
        Consultation c = new Consultation();
        c.setId(rs.getInt("id"));
        Date sheetDate = rs.getDate("sheet_date");
        c.setSheetDate(sheetDate != null ? sheetDate.toString() : null);
        c.setConsultantName(rs.getString("consultant_name"));
        c.setSummary(rs.getString("summary"));
        c.setReportedExists(rs.getString("reported_exists"));
        c.setReportedPerson(rs.getString("reported_person"));

        Timestamp reportedAt = rs.getTimestamp("reported_at");
        c.setReportedAt(reportedAt != null ? reportedAt.toLocalDateTime().toString().replace('T', ' ') : null);
        c.setFollowUp(rs.getString("follow_up"));
        c.setMentalScale(rs.getInt("mental_scale"));
        c.setMentalDetail(rs.getString("mental_detail"));
        c.setFutureRequest(rs.getString("future_request"));
        c.setFutureRequestOtherDetail(rs.getString("future_request_other_detail"));
        c.setSharePermission(rs.getString("share_permission"));
        c.setShareLimitedTargets(rs.getString("share_limited_targets"));
        c.setAdminChecked(rs.getInt("admin_checked") == 1);
        c.setFollowUpDraft(rs.getString("follow_up_draft"));
        c.setFollowUpAction(rs.getString("follow_up_action"));
        c.setStatus(rs.getString("status"));
        c.setAccessKey(rs.getString("access_key"));
        c.setReporterRating(rs.getInt("reporter_rating"));
        c.setReporterFeedback(rs.getString("reporter_feedback"));

        Timestamp ratedAt = rs.getTimestamp("reporter_rated_at");
        if (ratedAt != null) {
            c.setReporterRatedAt(ratedAt.toLocalDateTime());
        }
        c.setSatisfactionScore(rs.getInt("satisfaction_score"));
        c.setSatisfactionComment(rs.getString("satisfaction_comment"));
        Timestamp satAt = rs.getTimestamp("satisfaction_at");
        if (satAt != null) {
            c.setSatisfactionAt(satAt.toLocalDateTime());
        }
        c.setLatestChatMessage(rs.getString("latest_chat_message"));
        c.setLatestChatSenderRole(rs.getString("latest_chat_sender_role"));
        Timestamp latestAt = rs.getTimestamp("latest_chat_at");
        if (latestAt != null) {
            c.setLatestChatAt(latestAt.toLocalDateTime());
        }
        Timestamp lastReporterReadAt = rs.getTimestamp("last_reporter_read_at");
        if (lastReporterReadAt != null) {
            c.setLastReporterReadAt(lastReporterReadAt.toLocalDateTime());
        }
        Timestamp lastAdminReadAt = rs.getTimestamp("last_admin_read_at");
        if (lastAdminReadAt != null) {
            c.setLastAdminReadAt(lastAdminReadAt.toLocalDateTime());
        }
        return c;
    }

    private void loadChatMessages(Connection con, Consultation c) throws Exception {
        if (c == null) return;
        String sql = "SELECT sender_role, message, sent_at FROM consultation_chat_messages " +
                "WHERE consultation_id=? ORDER BY sent_at ASC, id ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, c.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<ChatMessage> list = new ArrayList<>();
                while (rs.next()) {
                    ChatMessage m = new ChatMessage();
                    m.setSenderRole(rs.getString("sender_role"));
                    m.setMessage(rs.getString("message"));
                    Timestamp ts = rs.getTimestamp("sent_at");
                    if (ts != null) {
                        m.setSentAt(ts.toLocalDateTime());
                    }
                    list.add(m);
                }
                c.setChatMessages(list);
            }
        }
    }

    private void loadFollowUpHistory(Connection con, Consultation c) throws Exception {
        if (c == null) return;
        String sql = "SELECT actor_role, category, body, created_at FROM consultation_followups " +
                "WHERE consultation_id=? ORDER BY created_at ASC, id ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, c.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<FollowUpRecord> list = new ArrayList<>();
                while (rs.next()) {
                    Timestamp at = rs.getTimestamp("created_at");
                    LocalDateTime dt = at != null ? at.toLocalDateTime() : null;
                    FollowUpRecord r = new FollowUpRecord(
                            dt,
                            rs.getString("actor_role"),
                            rs.getString("category"),
                            rs.getString("body")
                    );
                    list.add(r);
                }
                c.setFollowUpHistory(list);
            }
        }
    }

    private void loadUnreadCounts(Connection con, Consultation c) throws Exception {
        if (c == null) return;
        String sql = "SELECT " +
                "(SELECT COUNT(*) FROM consultation_chat_messages m " +
                " WHERE m.consultation_id=? AND m.sender_role='REPORTER' AND m.read_by_admin_at IS NULL) AS unread_for_admin, " +
                "(SELECT COUNT(*) FROM consultation_chat_messages m " +
                " WHERE m.consultation_id=? AND m.sender_role IN ('ADMIN','MASTER') AND m.read_by_reporter_at IS NULL) AS unread_for_reporter";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, c.getId());
            ps.setInt(2, c.getId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c.setUnreadForAdmin(rs.getInt("unread_for_admin"));
                    c.setUnreadForReporter(rs.getInt("unread_for_reporter"));
                }
            }
        }
    }

    private String normStatus(String status) {
        String st = safe(status).toUpperCase();
        switch (st) {
            case "UNCONFIRMED":
            case "CONFIRMED":
            case "REVIEWING":
            case "IN_PROGRESS":
            case "DONE":
                return st;
            case "NEW":
                return "UNCONFIRMED";
            case "CHECKING":
                return "CONFIRMED";
            default:
                return st.isEmpty() ? "UNCONFIRMED" : st;
        }
    }

    private String normRole(String role) {
        String r = safe(role).toUpperCase();
        if (r.equals("ADMIN") || r.equals("MASTER") || r.equals("REPORTER")) return r;
        return "REPORTER";
    }

    private String safe(String s) {
        return (s == null) ? "" : s.trim();
    }

    private boolean isBlank(String s) {
        return safe(s).isEmpty();
    }

    private String emptyToNull(String s) {
        String v = safe(s);
        return v.isEmpty() ? null : v;
    }

    private void setDate(PreparedStatement ps, int index, String dateStr) throws Exception {
        if (isBlank(dateStr)) {
            ps.setDate(index, null);
        } else {
            ps.setDate(index, Date.valueOf(dateStr.trim()));
        }
    }

    private void setDateTime(PreparedStatement ps, int index, String dtStr) throws Exception {
        if (isBlank(dtStr)) {
            ps.setTimestamp(index, null);
            return;
        }
        String v = dtStr.trim().replace('T', ' ');
        if (v.length() == 16) {
            v = v + ":00";
        }
        ps.setTimestamp(index, Timestamp.valueOf(v));
    }

    private void setTimestamp(PreparedStatement ps, int index, LocalDateTime dt) throws Exception {
        if (dt == null) {
            ps.setTimestamp(index, null);
        } else {
            ps.setTimestamp(index, Timestamp.valueOf(dt));
        }
    }

    private void setInt(PreparedStatement ps, int index, int value) throws Exception {
        if (value == 0) {
            ps.setNull(index, java.sql.Types.INTEGER);
        } else {
            ps.setInt(index, value);
        }
    }

    private void setIntNullable(PreparedStatement ps, int index, int value) throws Exception {
        if (value <= 0) {
            ps.setNull(index, java.sql.Types.INTEGER);
        } else {
            ps.setInt(index, value);
        }
    }

    private String generateKey() {
        StringBuilder sb = new StringBuilder(KEY_LEN);
        for (int i = 0; i < KEY_LEN; i++) {
            sb.append(KEY_CHARS.charAt(random.nextInt(KEY_CHARS.length())));
        }
        return sb.toString();
    }
}
