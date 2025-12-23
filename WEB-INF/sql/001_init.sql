-- Harassment Consultation App schema (MySQL)
-- Assumes database harassment_db already exists.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS consultations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  access_key VARCHAR(64) NOT NULL,
  sheet_date DATE NULL,
  consultant_name VARCHAR(255) NULL,
  summary TEXT NOT NULL,
  reported_exists VARCHAR(32) NULL,
  reported_person VARCHAR(255) NULL,
  reported_at DATETIME NULL,
  follow_up TEXT NULL,
  mental_scale INT NULL,
  mental_detail TEXT NULL,
  future_request VARCHAR(255) NULL,
  future_request_other_detail TEXT NULL,
  share_permission VARCHAR(32) NULL,
  share_limited_targets TEXT NULL,
  admin_checked TINYINT(1) NOT NULL DEFAULT 0,
  follow_up_draft TEXT NULL,
  follow_up_action TEXT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'UNCONFIRMED',
  reporter_rating TINYINT NULL,
  reporter_feedback TEXT NULL,
  reporter_rated_at DATETIME NULL,
  satisfaction_score TINYINT NULL,
  satisfaction_comment TEXT NULL,
  satisfaction_at DATETIME NULL,
  latest_chat_message TEXT NULL,
  latest_chat_sender_role VARCHAR(16) NULL,
  latest_chat_at DATETIME NULL,
  last_reporter_read_at DATETIME NULL,
  last_admin_read_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_consultations_access_key (access_key),
  KEY idx_consultations_status (status),
  KEY idx_consultations_sheet_date (sheet_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS consultation_followups (
  id INT AUTO_INCREMENT PRIMARY KEY,
  consultation_id INT NOT NULL,
  actor_role VARCHAR(16) NOT NULL,
  category VARCHAR(64) NULL,
  body TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_followups_consultation (consultation_id),
  CONSTRAINT fk_followups_consultation
    FOREIGN KEY (consultation_id) REFERENCES consultations(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS consultation_chat_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  consultation_id INT NOT NULL,
  sender_role VARCHAR(16) NOT NULL,
  message TEXT NOT NULL,
  sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_by_reporter_at DATETIME NULL,
  read_by_admin_at DATETIME NULL,
  KEY idx_chat_consultation (consultation_id),
  KEY idx_chat_sent_at (sent_at),
  CONSTRAINT fk_chat_consultation
    FOREIGN KEY (consultation_id) REFERENCES consultations(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  role VARCHAR(16) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  password_algo VARCHAR(32) NOT NULL DEFAULT 'SHA256',
  reset_token VARCHAR(255) NULL,
  reset_expires_at DATETIME NULL,
  last_login_at DATETIME NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_users_email (email),
  KEY idx_users_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS audit_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  actor_role VARCHAR(16) NOT NULL,
  actor_user_id INT NULL,
  action VARCHAR(64) NOT NULL,
  target_type VARCHAR(64) NULL,
  target_id INT NULL,
  detail TEXT NULL,
  ip_addr VARCHAR(64) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_audit_actor (actor_role, actor_user_id),
  KEY idx_audit_target (target_type, target_id),
  KEY idx_audit_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed users (password_hash uses SHA2 for initial setup)
INSERT INTO users (role, email, password_hash, password_algo)
VALUES
  ('ADMIN', 'admin@local.test', SHA2('AdminStart_123!', 256), 'SHA256'),
  ('MASTER', 'master@local.test', SHA2('MasterStart_123!', 256), 'SHA256')
ON DUPLICATE KEY UPDATE
  role = VALUES(role),
  password_hash = VALUES(password_hash),
  password_algo = VALUES(password_algo);
