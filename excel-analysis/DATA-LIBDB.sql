CREATE VIEW vw_loan_flat AS
SELECT
    l.loan_id,
    l.copy_id,
    bc.barcode,
    bc.status AS copy_status,
    bc.location,
    b.book_id,
    b.isbn,
    b.title AS book_title,
    g.name AS genre,
    b.publisher,
    b.publish_year,
    b.price,
    GROUP_CONCAT(DISTINCT CONCAT(a.first_name, ' ', a.last_name)
        ORDER BY a.last_name, a.first_name SEPARATOR ', ') AS authors,
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email AS member_email,
    m.phone AS member_phone,
    mst.label AS member_status,
    m.join_date,
    m.expiry_date,
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    s.role AS staff_role,
    l.borrow_date,
    l.due_date,
    l.return_date,
    l.actual_return_date,
    l.status AS loan_status,
    CASE
        WHEN l.status = 'returned' AND l.actual_return_date <= l.due_date THEN 'on_time'
        WHEN l.status = 'returned' AND l.actual_return_date > l.due_date THEN 'late'
        WHEN l.status IN ('active', 'overdue') THEN 'not_returned'
        WHEN l.status = 'lost' THEN 'lost'
        ELSE 'other'
    END AS return_bucket,
    CASE
        WHEN l.actual_return_date IS NOT NULL THEN DATEDIFF(l.actual_return_date, l.borrow_date)
        ELSE DATEDIFF(CURDATE(), l.borrow_date)
    END AS loan_duration_days,
    CASE
        WHEN l.actual_return_date IS NOT NULL THEN DATEDIFF(l.actual_return_date, l.due_date)
        WHEN l.status IN ('active', 'overdue') THEN DATEDIFF(CURDATE(), l.due_date)
        ELSE NULL
    END AS days_from_due,
    COALESCE(SUM(f.amount), 0) AS total_fine_amount,
    COALESCE(SUM(CASE WHEN f.paid_status = 'paid' THEN f.amount ELSE 0 END), 0) AS fine_paid_amount,
    COALESCE(SUM(CASE WHEN f.paid_status IN ('unpaid', 'partial') THEN f.amount ELSE 0 END), 0) AS fine_outstanding_amount,
    MAX(CASE WHEN f.paid_status = 'paid' THEN 1 ELSE 0 END) AS has_paid_fine,
    MAX(CASE WHEN f.paid_status IN ('unpaid', 'partial') THEN 1 ELSE 0 END) AS has_outstanding_fine,
    COUNT(DISTINCT r.reservation_id) AS reservation_count_for_book
FROM loan l
JOIN book_copy bc ON l.copy_id = bc.copy_id
JOIN book b ON bc.book_id = b.book_id
JOIN genre g ON b.genre_id = g.genre_id
JOIN member m ON l.member_id = m.member_id
JOIN member_status_type mst ON m.status_id = mst.status_id
LEFT JOIN staff s ON l.staff_id = s.staff_id
LEFT JOIN book_author ba ON b.book_id = ba.book_id
LEFT JOIN author a ON ba.author_id = a.author_id
LEFT JOIN fine f ON l.loan_id = f.loan_id
LEFT JOIN reservation r ON b.book_id = r.book_id
GROUP BY
    l.loan_id, l.copy_id, bc.barcode, bc.status, bc.location,
    b.book_id, b.isbn, b.title, g.name, b.publisher, b.publish_year, b.price,
    m.member_id, m.first_name, m.last_name, m.email, m.phone, mst.label, m.join_date, m.expiry_date,
    s.staff_id, s.first_name, s.last_name, s.role,
    l.borrow_date, l.due_date, l.return_date, l.actual_return_date, l.status;