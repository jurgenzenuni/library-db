-- ============================================================
-- LIBRARY MANAGEMENT SYSTEM - PROFESSIONAL MySQL Schema
-- ============================================================

DROP DATABASE IF EXISTS library_db;

CREATE DATABASE library_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE library_db;

-- ============================================================
-- 1. LOOKUP / REFERENCE TABLES
-- ============================================================

CREATE TABLE genre (
  genre_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE member_status_type (
  status_id  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  label      VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE flag_type (
  flag_type_id  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code          VARCHAR(50)  NOT NULL UNIQUE,
  description   VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE fine_type (
  fine_type_id  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code          VARCHAR(50)  NOT NULL UNIQUE,
  daily_rate    DECIMAL(6,2) NOT NULL DEFAULT 0.25
) ENGINE=InnoDB;

-- ============================================================
-- 2. CORE ENTITY TABLES
-- ============================================================

CREATE TABLE author (
  author_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name  VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100) NOT NULL,
  bio         TEXT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FULLTEXT idx_author_name (first_name, last_name)
) ENGINE=InnoDB;

CREATE TABLE book (
  book_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  isbn          VARCHAR(20)  NOT NULL UNIQUE,
  title         VARCHAR(255) NOT NULL,
  genre_id      INT UNSIGNED NOT NULL,
  publisher     VARCHAR(255),
  publish_year  YEAR,
  price         DECIMAL(10,2),
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FULLTEXT idx_book_title (title),
  FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
) ENGINE=InnoDB;

CREATE TABLE book_author (
  book_id    INT UNSIGNED NOT NULL,
  author_id  INT UNSIGNED NOT NULL,
  PRIMARY KEY (book_id, author_id),
  FOREIGN KEY (book_id)   REFERENCES book(book_id)   ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE book_copy (
  copy_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  book_id      INT UNSIGNED NOT NULL,
  barcode      VARCHAR(50)  NOT NULL UNIQUE,
  status       ENUM('available','checked_out','reserved','lost','damaged') NOT NULL DEFAULT 'available',
  acquired_at  DATE,
  location     VARCHAR(100),
  FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE member (
  member_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name  VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  phone       VARCHAR(20),
  address     TEXT,
  status_id   TINYINT UNSIGNED NOT NULL DEFAULT 1,
  join_date   DATE NOT NULL DEFAULT (CURRENT_DATE),
  expiry_date DATE NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (status_id) REFERENCES member_status_type(status_id)
) ENGINE=InnoDB;

CREATE TABLE staff (
  staff_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name  VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  role        ENUM('librarian','admin','supervisor') NOT NULL DEFAULT 'librarian',
  hire_date   DATE NOT NULL,
  is_active   TINYINT(1) NOT NULL DEFAULT 1,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 3. TRANSACTIONAL TABLES
-- ============================================================

CREATE TABLE loan (
  loan_id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  copy_id            INT UNSIGNED NOT NULL,
  member_id          INT UNSIGNED NOT NULL,
  staff_id           INT UNSIGNED,
  borrow_date        DATE NOT NULL DEFAULT (CURRENT_DATE),
  due_date           DATE NOT NULL,
  return_date        DATE,
  actual_return_date DATE,
  status             ENUM('active','returned','overdue','lost') NOT NULL DEFAULT 'active',
  created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (copy_id)   REFERENCES book_copy(copy_id),
  FOREIGN KEY (member_id) REFERENCES member(member_id),
  FOREIGN KEY (staff_id)  REFERENCES staff(staff_id),
  INDEX idx_loan_member (member_id),
  INDEX idx_loan_status  (status)
) ENGINE=InnoDB;

CREATE TABLE fine (
  fine_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  loan_id       INT UNSIGNED NOT NULL,
  member_id     INT UNSIGNED NOT NULL,
  fine_type_id  TINYINT UNSIGNED NOT NULL,
  amount        DECIMAL(10,2) NOT NULL,
  paid_status   ENUM('unpaid','partial','paid') NOT NULL DEFAULT 'unpaid',
  paid_at       TIMESTAMP NULL,
  reason        VARCHAR(255),
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (loan_id)      REFERENCES loan(loan_id),
  FOREIGN KEY (member_id)    REFERENCES member(member_id),
  FOREIGN KEY (fine_type_id) REFERENCES fine_type(fine_type_id),
  INDEX idx_fine_member (member_id),
  INDEX idx_fine_paid   (paid_status)
) ENGINE=InnoDB;

CREATE TABLE reservation (
  reservation_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  book_id         INT UNSIGNED NOT NULL,
  member_id       INT UNSIGNED NOT NULL,
  reserved_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at      TIMESTAMP NOT NULL,
  status          ENUM('pending','fulfilled','cancelled','expired') NOT NULL DEFAULT 'pending',
  FOREIGN KEY (book_id)   REFERENCES book(book_id),
  FOREIGN KEY (member_id) REFERENCES member(member_id),
  INDEX idx_reservation_status (status)
) ENGINE=InnoDB;

CREATE TABLE member_flag (
  flag_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  member_id     INT UNSIGNED NOT NULL,
  flag_type_id  TINYINT UNSIGNED NOT NULL,
  reason        VARCHAR(255),
  flagged_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at   TIMESTAMP NULL,
  is_active     TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (member_id)    REFERENCES member(member_id),
  FOREIGN KEY (flag_type_id) REFERENCES flag_type(flag_type_id),
  INDEX idx_flag_member (member_id)
) ENGINE=InnoDB;

-- ============================================================
-- 4. AUDIT LOG
-- ============================================================

CREATE TABLE audit_log (
  log_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  table_name  VARCHAR(100) NOT NULL,
  record_id   INT UNSIGNED NOT NULL,
  action      ENUM('INSERT','UPDATE','DELETE') NOT NULL,
  changed_by  VARCHAR(100),
  old_data    JSON,
  new_data    JSON,
  changed_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_audit_table (table_name, record_id)
) ENGINE=InnoDB;

-- ============================================================
-- 5. VIEWS
-- ============================================================

CREATE OR REPLACE VIEW vw_book_inventory AS
  SELECT
    b.book_id,
    b.isbn,
    b.title,
    COUNT(c.copy_id)                                AS total_copies,
    SUM(c.status = 'available')                     AS available_copies,
    SUM(c.status = 'checked_out')                   AS checked_out_copies,
    SUM(c.status IN ('lost','damaged'))              AS unavailable_copies
  FROM book b
  LEFT JOIN book_copy c ON b.book_id = c.book_id
  GROUP BY b.book_id;

CREATE OR REPLACE VIEW vw_popular_books AS
  SELECT
    b.book_id,
    b.title,
    COUNT(l.loan_id) AS total_loans
  FROM book b
  JOIN book_copy c ON b.book_id = c.book_id
  JOIN loan      l ON c.copy_id = l.copy_id
  GROUP BY b.book_id
  ORDER BY total_loans DESC;

CREATE OR REPLACE VIEW vw_overdue_loans AS
  SELECT
    l.loan_id,
    m.member_id,
    CONCAT(m.first_name,' ',m.last_name)  AS member_name,
    m.email,
    b.title,
    l.due_date,
    DATEDIFF(CURRENT_DATE, l.due_date)    AS days_overdue
  FROM loan l
  JOIN book_copy c ON l.copy_id   = c.copy_id
  JOIN book      b ON c.book_id   = b.book_id
  JOIN member    m ON l.member_id = m.member_id
  WHERE l.status IN ('active','overdue')
    AND l.due_date < CURRENT_DATE;

CREATE OR REPLACE VIEW vw_member_balance AS
  SELECT
    m.member_id,
    CONCAT(m.first_name,' ',m.last_name) AS member_name,
    COALESCE(SUM(CASE WHEN f.paid_status != 'paid' THEN f.amount END), 0) AS outstanding_fines
  FROM member m
  LEFT JOIN fine f ON m.member_id = f.member_id
  GROUP BY m.member_id;

-- ============================================================
-- 6. STORED PROCEDURES
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_checkout_book (
  IN  p_copy_id    INT UNSIGNED,
  IN  p_member_id  INT UNSIGNED,
  IN  p_staff_id   INT UNSIGNED,
  IN  p_loan_days  INT,
  OUT p_loan_id    INT UNSIGNED,
  OUT p_message    VARCHAR(255)
)
proc_label: BEGIN
  DECLARE v_copy_status   VARCHAR(20);
  DECLARE v_member_status TINYINT UNSIGNED;
  DECLARE v_outstanding   DECIMAL(10,2);

  SELECT status INTO v_copy_status FROM book_copy WHERE copy_id = p_copy_id FOR UPDATE;
  IF v_copy_status IS NULL THEN
    SET p_message = 'ERROR: Copy not found.';
    LEAVE proc_label;
  END IF;
  IF v_copy_status != 'available' THEN
    SET p_message = CONCAT('ERROR: Copy is currently ', v_copy_status);
    LEAVE proc_label;
  END IF;

  SELECT status_id INTO v_member_status FROM member WHERE member_id = p_member_id;
  IF v_member_status != 1 THEN
    SET p_message = 'ERROR: Member account is not active.';
    LEAVE proc_label;
  END IF;

  SELECT COALESCE(SUM(amount), 0) INTO v_outstanding
  FROM fine WHERE member_id = p_member_id AND paid_status != 'paid';
  IF v_outstanding > 10.00 THEN
    SET p_message = CONCAT('ERROR: Member has $', v_outstanding, ' in unpaid fines.');
    LEAVE proc_label;
  END IF;

  START TRANSACTION;
    INSERT INTO loan (copy_id, member_id, staff_id, borrow_date, due_date)
    VALUES (p_copy_id, p_member_id, p_staff_id, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL p_loan_days DAY));
    SET p_loan_id = LAST_INSERT_ID();
    UPDATE book_copy SET status = 'checked_out' WHERE copy_id = p_copy_id;
  COMMIT;

  SET p_message = 'SUCCESS';
END proc_label$$

CREATE PROCEDURE sp_return_book (
  IN  p_copy_id  INT UNSIGNED,
  IN  p_staff_id INT UNSIGNED,
  OUT p_fine_amt DECIMAL(10,2),
  OUT p_message  VARCHAR(255)
)
proc_label: BEGIN
  DECLARE v_loan_id   INT UNSIGNED;
  DECLARE v_due_date  DATE;
  DECLARE v_days_late INT;
  DECLARE v_rate      DECIMAL(6,2);
  DECLARE v_fine_type TINYINT UNSIGNED;

  SELECT loan_id, due_date INTO v_loan_id, v_due_date
  FROM loan
  WHERE copy_id = p_copy_id AND status IN ('active','overdue')
  ORDER BY borrow_date DESC LIMIT 1;

  IF v_loan_id IS NULL THEN
    SET p_message = 'ERROR: No active loan found for this copy.';
    LEAVE proc_label;
  END IF;

  SET v_days_late = DATEDIFF(CURRENT_DATE, v_due_date);

  START TRANSACTION;
    UPDATE loan
    SET status = 'returned', actual_return_date = CURRENT_DATE
    WHERE loan_id = v_loan_id;

    UPDATE book_copy SET status = 'available' WHERE copy_id = p_copy_id;

    IF v_days_late > 0 THEN
      SELECT fine_type_id, daily_rate INTO v_fine_type, v_rate
      FROM fine_type WHERE code = 'OVERDUE';
      SET p_fine_amt = v_days_late * v_rate;
      INSERT INTO fine (loan_id, member_id, fine_type_id, amount, reason)
      SELECT v_loan_id, member_id, v_fine_type, p_fine_amt,
             CONCAT(v_days_late, ' days overdue')
      FROM loan WHERE loan_id = v_loan_id;
    ELSE
      SET p_fine_amt = 0.00;
    END IF;
  COMMIT;

  SET p_message = 'SUCCESS';
END proc_label$$

CREATE PROCEDURE sp_pay_fine (
  IN  p_fine_id  INT UNSIGNED,
  IN  p_amount   DECIMAL(10,2),
  OUT p_message  VARCHAR(255)
)
proc_label: BEGIN
  DECLARE v_owed DECIMAL(10,2);

  SELECT amount INTO v_owed FROM fine
  WHERE fine_id = p_fine_id AND paid_status != 'paid';

  IF v_owed IS NULL THEN
    SET p_message = 'ERROR: Fine not found or already paid.';
    LEAVE proc_label;
  END IF;

  IF p_amount >= v_owed THEN
    UPDATE fine SET paid_status = 'paid', paid_at = NOW() WHERE fine_id = p_fine_id;
    SET p_message = 'SUCCESS: Fine fully paid.';
  ELSE
    UPDATE fine SET amount = amount - p_amount, paid_status = 'partial' WHERE fine_id = p_fine_id;
    SET p_message = CONCAT('SUCCESS: Partial payment. Remaining: $', (v_owed - p_amount));
  END IF;
END proc_label$$

DELIMITER ;

-- ============================================================
-- 7. TRIGGERS
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_loan_mark_overdue
BEFORE UPDATE ON loan
FOR EACH ROW
BEGIN
  IF NEW.status = 'active' AND NEW.due_date < CURRENT_DATE THEN
    SET NEW.status = 'overdue';
  END IF;
END$$

CREATE TRIGGER trg_loan_resolve_flag
AFTER UPDATE ON loan
FOR EACH ROW
BEGIN
  IF NEW.status = 'returned' AND OLD.status IN ('active','overdue') THEN
    IF NOT EXISTS (
      SELECT 1 FROM loan
      WHERE member_id = NEW.member_id
        AND status IN ('active','overdue')
        AND due_date < CURRENT_DATE
        AND loan_id != NEW.loan_id
    ) THEN
      UPDATE member_flag
      SET is_active = 0, resolved_at = NOW()
      WHERE member_id = NEW.member_id
        AND flag_type_id = (SELECT flag_type_id FROM flag_type WHERE code = 'OVERDUE')
        AND is_active = 1;
    END IF;
  END IF;
END$$

CREATE TRIGGER trg_fine_flag_member
AFTER INSERT ON fine
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM member_flag
    WHERE member_id = NEW.member_id
      AND flag_type_id = (SELECT flag_type_id FROM flag_type WHERE code = 'FINES_DUE')
      AND is_active = 1
  ) THEN
    INSERT INTO member_flag (member_id, flag_type_id, reason)
    VALUES (
      NEW.member_id,
      (SELECT flag_type_id FROM flag_type WHERE code = 'FINES_DUE'),
      CONCAT('Fine of $', NEW.amount, ' issued.')
    );
  END IF;
END$$

CREATE TRIGGER trg_fine_clear_flag
AFTER UPDATE ON fine
FOR EACH ROW
BEGIN
  IF NEW.paid_status = 'paid' THEN
    IF NOT EXISTS (
      SELECT 1 FROM fine
      WHERE member_id = NEW.member_id
        AND paid_status != 'paid'
        AND fine_id != NEW.fine_id
    ) THEN
      UPDATE member_flag
      SET is_active = 0, resolved_at = NOW()
      WHERE member_id = NEW.member_id
        AND flag_type_id = (SELECT flag_type_id FROM flag_type WHERE code = 'FINES_DUE')
        AND is_active = 1;
    END IF;
  END IF;
END$$

CREATE TRIGGER trg_audit_book_copy_update
AFTER UPDATE ON book_copy
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, record_id, action, old_data, new_data)
  VALUES (
    'book_copy', NEW.copy_id, 'UPDATE',
    JSON_OBJECT('status', OLD.status),
    JSON_OBJECT('status', NEW.status)
  );
END$$

DELIMITER ;

-- ============================================================
-- 8. SCHEDULED EVENTS
-- ============================================================

# SET GLOBAL event_scheduler = ON;

DELIMITER $$

CREATE EVENT evt_mark_overdue_loans
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_TIMESTAMP + INTERVAL 1 HOUR)
DO
BEGIN
  UPDATE loan
  SET status = 'overdue'
  WHERE status = 'active'
    AND due_date < CURRENT_DATE;
END$$

CREATE EVENT evt_generate_overdue_fines
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_TIMESTAMP + INTERVAL 2 HOUR)
DO
BEGIN
  INSERT INTO fine (loan_id, member_id, fine_type_id, amount, reason)
  SELECT
    l.loan_id,
    l.member_id,
    ft.fine_type_id,
    ft.daily_rate,
    'Daily overdue charge'
  FROM loan l
  JOIN fine_type ft ON ft.code = 'OVERDUE'
  WHERE l.status = 'overdue'
    AND NOT EXISTS (
      SELECT 1 FROM fine f
      WHERE f.loan_id = l.loan_id
        AND DATE(f.created_at) = CURRENT_DATE
    );
END$$

CREATE EVENT evt_flag_high_balance_members
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_TIMESTAMP + INTERVAL 3 HOUR)
DO
BEGIN
  INSERT INTO member_flag (member_id, flag_type_id, reason)
  SELECT
    mb.member_id,
    ft.flag_type_id,
    CONCAT('Outstanding balance: $', mb.outstanding_fines)
  FROM vw_member_balance mb
  JOIN flag_type ft ON ft.code = 'FINES_DUE'
  WHERE mb.outstanding_fines > 5.00
    AND NOT EXISTS (
      SELECT 1 FROM member_flag mf
      WHERE mf.member_id = mb.member_id
        AND mf.flag_type_id = ft.flag_type_id
        AND mf.is_active = 1
    );
END$$

CREATE EVENT evt_expire_reservations
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
  UPDATE reservation
  SET status = 'expired'
  WHERE status = 'pending'
    AND expires_at < NOW();
END$$

DELIMITER ;

-- ============================================================
-- 9. SEED DATA
-- ============================================================

INSERT INTO genre (name) VALUES
  ('Fiction'),('Non-Fiction'),('Science Fiction'),
  ('Mystery'),('History'),('Technology'),('Biography');

INSERT INTO member_status_type (label) VALUES
  ('ACTIVE'),('SUSPENDED'),('EXPIRED'),('BANNED');

INSERT INTO flag_type (code, description) VALUES
  ('OVERDUE',        'Member has overdue loans'),
  ('FINES_DUE',      'Member has unpaid fines'),
  ('DAMAGED_RETURN', 'Member returned damaged item');

INSERT INTO fine_type (code, daily_rate) VALUES
  ('OVERDUE',  0.25),
  ('LOST',    25.00),
  ('DAMAGED', 15.00);

INSERT INTO author (first_name, last_name, bio) VALUES
  ('George',  'Orwell',    'English novelist known for dystopian fiction.'),
  ('Frank',   'Herbert',   'Author of the Dune series.'),
  ('Agatha',  'Christie',  'Queen of Crime fiction.'),
  ('Walter',  'Isaacson',  'Biographer and journalist.'),
  ('Martin',  'Kleppmann', 'Author of Designing Data-Intensive Applications.');

INSERT INTO book (isbn, title, genre_id, publisher, publish_year, price) VALUES
  ('9780451524935', '1984',                            1, 'Signet Classic',   1949,  9.99),
  ('9780441013593', 'Dune',                            3, 'Ace Books',        1965, 14.99),
  ('9780062073501', 'And Then There Were None',        4, 'Harper Collins',   1939,  8.99),
  ('9781451648539', 'Steve Jobs',                      7, 'Simon & Schuster', 2011, 18.99),
  ('9781449373320', 'Designing Data-Intensive Apps',   6, 'O\'Reilly Media',  2017, 49.99);

INSERT INTO book_author (book_id, author_id) VALUES
  (1,1),(2,2),(3,3),(4,4),(5,5);

INSERT INTO book_copy (book_id, barcode, status, acquired_at, location) VALUES
  (1, 'LIB-001-A', 'available',   '2022-01-15', 'Section A, Shelf 1'),
  (1, 'LIB-001-B', 'available',   '2022-01-15', 'Section A, Shelf 1'),
  (2, 'LIB-002-A', 'available',   '2022-03-10', 'Section B, Shelf 3'),
  (2, 'LIB-002-B', 'available',   '2022-03-10', 'Section B, Shelf 3'),
  (3, 'LIB-003-A', 'available',   '2021-11-20', 'Section A, Shelf 4'),
  (4, 'LIB-004-A', 'available',   '2023-05-01', 'Section C, Shelf 2'),
  (4, 'LIB-004-B', 'available',   '2023-05-01', 'Section C, Shelf 2'),
  (5, 'LIB-005-A', 'available',   '2023-08-15', 'Section D, Shelf 1'),
  (5, 'LIB-005-B', 'available',   '2023-08-15', 'Section D, Shelf 1');

INSERT INTO staff (first_name, last_name, email, role, hire_date) VALUES
  ('Sarah',  'Johnson', 'sarah.johnson@library.org', 'admin',      '2019-04-01'),
  ('Marcus', 'Lee',     'marcus.lee@library.org',    'librarian',  '2021-09-15'),
  ('Priya',  'Patel',   'priya.patel@library.org',   'supervisor', '2020-06-01');

INSERT INTO member (first_name, last_name, email, phone, status_id, join_date, expiry_date) VALUES
  ('James',  'Carter', 'james.carter@email.com', '917-555-0101', 1, '2023-01-10', '2025-01-10'),
  ('Linda',  'Torres', 'linda.torres@email.com', '718-555-0202', 1, '2022-06-15', '2024-06-15'),
  ('Kevin',  'Brown',  'kevin.brown@email.com',  '646-555-0303', 1, '2023-03-20', '2025-03-20'),
  ('Amara',  'Diallo', 'amara.diallo@email.com', '212-555-0404', 1, '2021-11-01', '2023-11-01'),
  ('Daniel', 'Wu',     'daniel.wu@email.com',    '347-555-0505', 1, '2024-01-05', '2026-01-05');

INSERT INTO loan (copy_id, member_id, staff_id, borrow_date, due_date, status) VALUES
  (1, 1, 2, DATE_SUB(CURRENT_DATE, INTERVAL 5  DAY), DATE_ADD(CURRENT_DATE, INTERVAL 9  DAY), 'active'),
  (3, 2, 2, DATE_SUB(CURRENT_DATE, INTERVAL 20 DAY), DATE_SUB(CURRENT_DATE, INTERVAL 6  DAY), 'overdue'),
  (6, 3, 1, DATE_SUB(CURRENT_DATE, INTERVAL 2  DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 'active'),
  (8, 4, 2, DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY), DATE_SUB(CURRENT_DATE, INTERVAL 16 DAY), 'overdue');

UPDATE book_copy SET status = 'checked_out' WHERE copy_id IN (1, 3, 6, 8);

INSERT INTO fine (loan_id, member_id, fine_type_id, amount, reason) VALUES
  (2, 2, 1, 1.50, '6 days overdue'),
  (4, 4, 1, 4.00, '16 days overdue');

INSERT INTO reservation (book_id, member_id, reserved_at, expires_at, status) VALUES
  (2, 5, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY), 'pending');