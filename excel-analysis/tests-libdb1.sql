-- ============================================================
-- 10. TEST QUERIES
-- ============================================================

-- Checkout copy 5 to member 5 for 14 days
CALL sp_checkout_book(5, 5, 2, 14, @loan_id, @msg);
SELECT @loan_id AS loan_id, @msg AS message;

-- Return copy 3 (overdue — should generate fine)
CALL sp_return_book(3, 2, @fine, @msg);
SELECT @fine AS fine_charged, @msg AS message;

CALL sp_return_book(8,2, @fine, @msg)
SELECT @fine AS fine_charged, @msg as message;

-- Pay fine 1
CALL sp_pay_fine(1, 1.50, @msg);
SELECT @msg AS message;

-- Check all views
SELECT * FROM vw_book_inventory;
SELECT * FROM vw_overdue_loans;
SELECT * FROM vw_member_balance;
SELECT * FROM vw_popular_books;

-- Check audit log
SELECT * FROM audit_log ORDER BY changed_at DESC LIMIT 10;