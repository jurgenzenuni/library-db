-- ============================================================
-- LIBRARY DB - ADVANCED ANALYSIS QUERIES
-- ============================================================
-- VISUALS THIS FILE SUPPORTS:
--   Q1  -> Member Risk Scoring Table
--   Q2  -> Popular Genres Bar Graph
--   Q3  -> Fine Collection Rate Line/Table
--   Q4  -> Dead Inventory Table
--   Q5  -> Staff Performance Table
--   Q6  -> Member Retention Cohort Table
--   Q7  -> Top 10 Most Borrowed Books Table
--   Q8  -> Overdue Loans Collections Dashboard
--   Q9  -> Borrowing Trends Line Graph (Monthly)
--   Q10 -> Member Loyalty Table
--   Q11 -> Return Status by Year Stacked Bar Chart
--   Q12 -> Member Stats 100% Stacked Bar + Avg Loan Duration
-- ============================================================

USE library_db;

SELECT * FROM vw_loan_flat ORDER BY loan_id;

-- ============================================================
-- Q1. MEMBER RISK SCORING
-- ============================================================
-- VISUAL: Table / Conditional Formatting in Excel
-- Purpose: Identify high-risk members for follow-up
SELECT
    CONCAT(m.first_name, ' ', m.last_name)        AS member_name,
    COUNT(DISTINCT CASE WHEN l.status = 'overdue'
        THEN l.loan_id END)                        AS active_overdues,
    COUNT(DISTINCT CASE WHEN l.actual_return_date > l.due_date
        THEN l.loan_id END)                        AS late_returns,
    COALESCE(SUM(CASE WHEN f.paid_status != 'paid'
        THEN f.amount END), 0)                     AS unpaid_fines,
    (COUNT(DISTINCT CASE WHEN l.status = 'overdue'
        THEN l.loan_id END) * 3 +
     COUNT(DISTINCT CASE WHEN l.actual_return_date > l.due_date
        THEN l.loan_id END) +
     COALESCE(SUM(CASE WHEN f.paid_status != 'paid'
        THEN f.amount END), 0))                    AS risk_score
FROM member m
LEFT JOIN loan l ON m.member_id = l.member_id
LEFT JOIN fine f ON m.member_id = f.member_id
GROUP BY m.member_id
ORDER BY risk_score DESC;

-- ============================================================
-- Q2. GENRE POPULARITY
-- ============================================================
-- VISUAL: Clustered Bar Chart (Genre on X-axis, Total Loans on Y-axis)
-- Purpose: Which genres drive circulation
SELECT
    g.name                                    AS genre,
    COUNT(l.loan_id)                          AS total_loans,
    COUNT(DISTINCT c.copy_id)                 AS distinct_copies_borrowed,
    ROUND(COUNT(l.loan_id)
        / COUNT(DISTINCT c.copy_id), 2)       AS avg_loans_per_copy,
    RANK() OVER (ORDER BY COUNT(l.loan_id) DESC) AS popularity_rank
FROM loan l
JOIN book_copy c ON l.copy_id  = c.copy_id
JOIN book      b ON c.book_id  = b.book_id
JOIN genre     g ON b.genre_id = g.genre_id
GROUP BY g.genre_id
ORDER BY total_loans DESC;

-- ============================================================
-- Q3. FINE COLLECTION RATE
-- ============================================================
-- VISUAL: Line Chart (Month on X-axis, Collection Rate % on Y-axis)
-- Purpose: Track payment compliance and revenue over time
SELECT
    DATE_FORMAT(f.created_at, '%Y-%m')         AS month,
    COUNT(*)                                    AS fines_issued,
    ROUND(SUM(f.amount), 2)                     AS total_issued,
    ROUND(SUM(CASE WHEN f.paid_status = 'paid'
        THEN f.amount ELSE 0 END), 2)           AS total_collected,
    ROUND(SUM(CASE WHEN f.paid_status = 'paid'
        THEN f.amount ELSE 0 END)
        / SUM(f.amount) * 100, 1)              AS collection_rate_pct,
    ROUND(AVG(CASE WHEN f.paid_status = 'paid'
        THEN DATEDIFF(f.paid_at, f.created_at)
    END), 1)                                    AS avg_days_to_pay
FROM fine f
GROUP BY DATE_FORMAT(f.created_at, '%Y-%m')
ORDER BY month;

-- ============================================================
-- Q4. BOOKS NEVER BORROWED (DEAD INVENTORY)
-- ============================================================
-- VISUAL: Table / Sorted List in Excel
-- Purpose: Identify books to remove or promote
SELECT
    b.book_id,
    b.title,
    b.publish_year,
    g.name           AS genre,
    COUNT(c.copy_id) AS copies_owned
FROM book b
JOIN genre     g ON b.genre_id = g.genre_id
JOIN book_copy c ON b.book_id  = c.book_id
WHERE NOT EXISTS (
    SELECT 1 FROM loan l WHERE l.copy_id = c.copy_id
)
GROUP BY b.book_id
ORDER BY copies_owned DESC;

-- ============================================================
-- Q5. STAFF PERFORMANCE
-- ============================================================
-- VISUAL: Table with Conditional Formatting in Excel
-- Purpose: Evaluate staff by checkout volume and quality
SELECT
    CONCAT(s.first_name, ' ', s.last_name)   AS staff_name,
    s.role,
    COUNT(l.loan_id)                          AS total_checkouts,
    SUM(l.status = 'overdue')                 AS currently_overdue,
    SUM(l.actual_return_date > l.due_date)    AS late_returns_processed,
    ROUND(SUM(l.actual_return_date > l.due_date)
        / COUNT(l.loan_id) * 100, 1)          AS late_return_pct
FROM staff s
JOIN loan l ON s.staff_id = l.staff_id
GROUP BY s.staff_id
ORDER BY total_checkouts DESC;

-- ============================================================
-- Q6. MEMBER RETENTION COHORT
-- ============================================================
-- VISUAL: Bar Chart (Cohort on X, Retention % on Y)
-- Purpose: Track member engagement by join quarter
SELECT
    CONCAT(YEAR(m.join_date), '-Q',
        QUARTER(m.join_date))                   AS cohort,
    COUNT(DISTINCT m.member_id)                 AS members_joined,
    COUNT(DISTINCT CASE WHEN l.status IN ('active','overdue')
        THEN m.member_id END)                   AS still_active_borrowers,
    ROUND(COUNT(DISTINCT CASE WHEN l.status IN ('active','overdue')
        THEN m.member_id END)
        / COUNT(DISTINCT m.member_id) * 100, 1) AS retention_pct
FROM member m
LEFT JOIN loan l ON m.member_id = l.member_id
GROUP BY cohort
ORDER BY cohort;

-- ============================================================
-- Q7. TOP 10 MOST BORROWED BOOKS
-- ============================================================
-- VISUAL: Horizontal Bar Chart (Title on Y, Total Loans on X)
-- Purpose: Identify bestsellers that may need more copies
SELECT
    b.book_id,
    b.title,
    GROUP_CONCAT(CONCAT(a.first_name,' ',a.last_name)
        SEPARATOR ', ')                        AS author,
    g.name                                     AS genre,
    COUNT(l.loan_id)                           AS total_loans,
    COUNT(DISTINCT c.copy_id)                  AS total_copies,
    ROUND(COUNT(l.loan_id)
        / COUNT(DISTINCT c.copy_id), 2)        AS turnover_rate
FROM book b
JOIN genre       g  ON b.genre_id    = g.genre_id
JOIN book_copy   c  ON b.book_id     = c.book_id
JOIN book_author ba ON b.book_id     = ba.book_id
JOIN author      a  ON ba.author_id  = a.author_id
LEFT JOIN loan   l  ON c.copy_id     = l.copy_id
GROUP BY b.book_id
ORDER BY total_loans DESC
LIMIT 10;

-- ============================================================
-- Q8. OVERDUE LOANS COLLECTIONS DASHBOARD
-- ============================================================
-- VISUAL: Table with Red Conditional Formatting (>30 days)
-- Purpose: Collections follow-up list
SELECT
    CONCAT(m.first_name, ' ', m.last_name)     AS member_name,
    m.email,
    m.phone,
    b.title                                     AS book_title,
    DATEDIFF(CURDATE(), l.due_date)             AS days_overdue,
    ROUND(DATEDIFF(CURDATE(), l.due_date)
        * 0.25, 2)                              AS expected_fine
FROM loan l
JOIN book_copy c ON l.copy_id   = c.copy_id
JOIN book      b ON c.book_id   = b.book_id
JOIN member    m ON l.member_id = m.member_id
WHERE l.status IN ('active','overdue')
  AND l.due_date < CURDATE()
ORDER BY days_overdue DESC;

-- ============================================================
-- Q9. MONTHLY CIRCULATION TREND
-- ============================================================
-- VISUAL: Line Graph (Month on X-axis, Checkouts on Y-axis)
-- Purpose: Track overall checkout volume over time
SELECT
    DATE_FORMAT(l.borrow_date, '%Y-%m')         AS month,
    COUNT(l.loan_id)                             AS checkouts,
    SUM(l.status = 'returned')                   AS returns,
    SUM(l.status IN ('active','overdue'))        AS active_loans,
    ROUND(AVG(DATEDIFF(l.actual_return_date,
        l.borrow_date)), 1)                      AS avg_loan_duration_days
FROM loan l
GROUP BY DATE_FORMAT(l.borrow_date, '%Y-%m')
ORDER BY month;

-- ============================================================
-- Q10. MEMBER LOYALTY (TOP BORROWERS)
-- ============================================================
-- VISUAL: Leaderboard Table in Excel
-- Purpose: VIP engagement analysis
SELECT
    CONCAT(m.first_name, ' ', m.last_name)  AS member_name,
    mst.label                               AS status,
    COUNT(l.loan_id)                        AS total_loans,
    COUNT(DISTINCT b.book_id)               AS distinct_books,
    ROUND(SUM(CASE WHEN f.paid_status = 'paid'
        THEN f.amount ELSE 0 END), 2)       AS total_fines_paid,
    (COUNT(l.loan_id) * 10
        + COUNT(DISTINCT b.book_id) * 2)    AS loyalty_score
FROM member m
JOIN member_status_type mst ON m.status_id  = mst.status_id
LEFT JOIN loan       l  ON m.member_id      = l.member_id
LEFT JOIN book_copy  c  ON l.copy_id        = c.copy_id
LEFT JOIN book       b  ON c.book_id        = b.book_id
LEFT JOIN fine       f  ON m.member_id      = f.member_id
GROUP BY m.member_id
ORDER BY loyalty_score DESC
LIMIT 20;

-- ============================================================
-- Q11. RETURN STATUS BY YEAR
-- ============================================================
-- VISUAL: 100% Stacked Bar Chart
--   X-axis -> Year
--   Y-axis -> % on_time / late / not_returned
--   Colors -> Green (on time), Yellow (late), Red (not returned)
-- Excel:  Use on_time_pct, late_pct, not_returned_pct columns only
SELECT
    YEAR(l.borrow_date)                         AS year,
    COUNT(l.loan_id)                            AS total_loans,
    SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date <= l.due_date THEN 1 ELSE 0
    END)                                        AS on_time,
    SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date > l.due_date  THEN 1 ELSE 0
    END)                                        AS late,
    SUM(CASE
        WHEN l.status IN ('active','overdue')   THEN 1 ELSE 0
    END)                                        AS not_returned,
    ROUND(SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date <= l.due_date THEN 1 ELSE 0
    END) / COUNT(l.loan_id) * 100, 1)           AS on_time_pct,
    ROUND(SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date > l.due_date THEN 1 ELSE 0
    END) / COUNT(l.loan_id) * 100, 1)           AS late_pct,
    ROUND(SUM(CASE
        WHEN l.status IN ('active','overdue')   THEN 1 ELSE 0
    END) / COUNT(l.loan_id) * 100, 1)           AS not_returned_pct
FROM loan l
GROUP BY YEAR(l.borrow_date)
ORDER BY year;

-- ============================================================
-- Q12. MEMBER STATS - RETURN BEHAVIOUR + AVG LOAN DURATION
-- ============================================================
-- VISUAL: 100% Stacked Bar + Secondary Axis Line
--   X-axis          -> member_name
--   Y-axis primary  -> on_time_pct / late_pct / not_returned_pct stacked
--   Y-axis secondary-> avg_loan_duration_days as line overlay
--   Colors          -> Green (on time), Yellow (late), Red (not returned)
-- Excel: Select member_name + 3 pct columns for stacked bar,
--        then add avg_loan_duration_days as a secondary axis line series
SELECT
    CONCAT(m.first_name, ' ', m.last_name)  AS member_name,
    COUNT(l.loan_id)                         AS total_loans,
    SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date <= l.due_date THEN 1 ELSE 0
    END)                                     AS on_time,
    SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date > l.due_date  THEN 1 ELSE 0
    END)                                     AS late,
    SUM(CASE
        WHEN l.status IN ('active','overdue') THEN 1 ELSE 0
    END)                                     AS not_returned,
    ROUND(SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date <= l.due_date THEN 1 ELSE 0
    END) / COUNT(l.loan_id) * 100, 1)        AS on_time_pct,
    ROUND(SUM(CASE
        WHEN l.status = 'returned'
         AND l.actual_return_date > l.due_date THEN 1 ELSE 0
    END) / COUNT(l.loan_id) * 100, 1)        AS late_pct,
    ROUND(SUM(CASE
        WHEN l.status IN ('active','overdue') THEN 1 ELSE 0
    END) / COUNT(l.loan_id) * 100, 1)        AS not_returned_pct,
    ROUND(AVG(CASE
        WHEN l.actual_return_date IS NOT NULL
        THEN DATEDIFF(l.actual_return_date, l.borrow_date)
    END), 1)                                 AS avg_loan_duration_days
FROM member m
JOIN loan l ON m.member_id = l.member_id
GROUP BY m.member_id
HAVING total_loans > 0
ORDER BY total_loans DESC;