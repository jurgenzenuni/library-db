/*
 Navicat Premium Dump SQL
 Date: 11/01/2025 13:19:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for authors
-- ----------------------------
DROP TABLE IF EXISTS `authors`;
CREATE TABLE `authors`  (
  `authorid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`authorid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of authors
-- ----------------------------
INSERT INTO `authors` VALUES (1, 'Stephen King');
INSERT INTO `authors` VALUES (2, 'J.K. Rowling');
INSERT INTO `authors` VALUES (3, 'George Orwell');
INSERT INTO `authors` VALUES (4, 'Harper Lee');
INSERT INTO `authors` VALUES (5, 'J.R.R. Tolkien');
INSERT INTO `authors` VALUES (6, 'Agatha Christie');
INSERT INTO `authors` VALUES (7, 'Isaac Asimov');
INSERT INTO `authors` VALUES (8, 'Mark Twain');
INSERT INTO `authors` VALUES (9, 'F. Scott Fitzgerald');
INSERT INTO `authors` VALUES (10, 'Ernest Hemingway');

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `bookid` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ISBN` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `genre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` enum('available','not available') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'available',
  `authorid` int NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`bookid`) USING BTREE,
  INDEX `authorid`(`authorid` ASC) USING BTREE,
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`authorid`) REFERENCES `authors` (`authorid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (1, 'The Shining', '9780385121680', 'Horror', 'available', 1, 35.00);
INSERT INTO `book` VALUES (2, 'Harry Potter and the Philosophers Stone', '9780747532699', 'Fantasy', 'available', 2, 60.00);
INSERT INTO `book` VALUES (3, '1984', '9780451524935', 'Dystopian', 'not available', 3, 15.00);
INSERT INTO `book` VALUES (4, 'To Kill a Mockingbird', '9780061120084', 'Classic', 'available', 4, 45.00);
INSERT INTO `book` VALUES (5, 'The Hobbit', '9780547928227', 'Fantasy', 'available', 5, 50.00);
INSERT INTO `book` VALUES (6, 'Pet Sematary', '9780743412278', 'Horror', 'available', 1, 17.50);
INSERT INTO `book` VALUES (7, 'Animal Farm', '9780451526342', 'Satire', 'available', 3, 25.00);
INSERT INTO `book` VALUES (8, 'The Catcher in the Rye', '9780316769488', 'Fiction', 'available', 4, 30.00);
INSERT INTO `book` VALUES (9, 'The Lord of the Rings', '9780544003415', 'Fantasy', 'available', 5, 60.00);
INSERT INTO `book` VALUES (10, 'It', '9781501142970', 'Horror', 'available', 1, 40.00);
INSERT INTO `book` VALUES (11, 'Brave New World', '9780060850524', 'Science Fiction', 'available', 3, 35.00);
INSERT INTO `book` VALUES (12, 'The Great Gatsby', '9780743273565', 'Classic', 'available', 4, 30.00);
INSERT INTO `book` VALUES (13, 'Murder on the Orient Express', '9780007119318', 'Mystery', 'available', 6, 25.00);
INSERT INTO `book` VALUES (14, 'Foundation', '9780553293357', 'Science Fiction', 'available', 7, 15.00);
INSERT INTO `book` VALUES (15, 'The Adventures of Tom Sawyer', '9780486400778', 'Fiction', 'not available', 8, 15.00);
INSERT INTO `book` VALUES (16, 'The Great Gatsby', '9780743273565', 'Classic', 'available', 9, 30.00);
INSERT INTO `book` VALUES (17, 'The Old Man and the Sea', '9780684801223', 'Fiction', 'available', 10, 20.00);
INSERT INTO `book` VALUES (18, 'The Murder of Roger Ackroyd', '9780007527491', 'Mystery', 'available', 6, 25.00);
INSERT INTO `book` VALUES (19, 'I, Robot', '9780553382563', 'Science Fiction', 'available', 7, 15.00);
INSERT INTO `book` VALUES (20, 'Adventures of Huckleberry Finn', '9780486280615', 'Fiction', 'available', 8, 20.00);
INSERT INTO `book` VALUES (21, 'Tender Is the Night', '9780684801544', 'Classic', 'available', 9, 30.00);
INSERT INTO `book` VALUES (22, 'For Whom the Bell Tolls', '9780684803357', 'Fiction', 'available', 10, 15.00);

-- ----------------------------
-- Table structure for fine
-- ----------------------------
DROP TABLE IF EXISTS `fine`;
CREATE TABLE `fine`  (
  `FineID` int NOT NULL AUTO_INCREMENT,
  `TransactionID` int NULL DEFAULT NULL,
  `Amount` decimal(10, 2) NULL DEFAULT NULL,
  `Reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `PaidStatus` bit(1) NULL DEFAULT NULL,
  `memberid` int NULL DEFAULT NULL,
  PRIMARY KEY (`FineID`) USING BTREE,
  INDEX `TransactionID`(`TransactionID` ASC) USING BTREE,
  INDEX `fk_fine_transactions`(`memberid` ASC) USING BTREE,
  CONSTRAINT `fine_ibfk_1` FOREIGN KEY (`TransactionID`) REFERENCES `transactions` (`transactionid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_fine_transactions` FOREIGN KEY (`memberid`) REFERENCES `transactions` (`memberid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fine
-- ----------------------------
INSERT INTO `fine` VALUES (1, 11, 2.50, 'Late return of book', b'1', 6);
INSERT INTO `fine` VALUES (2, 14, 5.00, 'Late return of book', b'1', 9);
INSERT INTO `fine` VALUES (6, 25, 5.00, 'Late return of book ID 15', b'1', 7);
INSERT INTO `fine` VALUES (7, 27, 5.00, 'Late return of book ID 9', b'1', 3);
INSERT INTO `fine` VALUES (10, 29, 5.00, 'Late return of book ID 5', b'1', 10);
INSERT INTO `fine` VALUES (13, 26, 5.00, 'Late return of book ID 10', b'1', 5);
INSERT INTO `fine` VALUES (14, 28, 5.00, 'Late return of book ID 4', b'1', 6);
INSERT INTO `fine` VALUES (15, 31, 5.00, 'Late return of book ID 20', b'1', 1);
INSERT INTO `fine` VALUES (17, 39, 5.00, 'Late return of book ID 22', b'1', 5);
INSERT INTO `fine` VALUES (18, 41, 5.00, 'Late return of book ID 21', b'1', 5);
INSERT INTO `fine` VALUES (19, 46, 5.00, 'Late return of book ID 1', b'1', 2);
INSERT INTO `fine` VALUES (20, 47, 5.00, 'Late return of book ID 2', b'1', 2);
INSERT INTO `fine` VALUES (21, 51, 5.00, 'Late return of book ID 4', b'1', 3);
INSERT INTO `fine` VALUES (22, 52, 5.00, 'Late return of book ID 5', b'1', 3);
INSERT INTO `fine` VALUES (23, 53, 5.00, 'Late return of book ID 7', b'1', 7);
INSERT INTO `fine` VALUES (24, 54, 5.00, 'Late return of book ID 8', b'1', 7);
INSERT INTO `fine` VALUES (25, 59, 5.00, 'Late return of book ID 13', b'1', 8);
INSERT INTO `fine` VALUES (26, 57, 5.00, 'Late return of book ID 11', b'1', 8);
INSERT INTO `fine` VALUES (27, 60, 5.00, 'Late return of book ID 11', b'1', 9);
INSERT INTO `fine` VALUES (28, 61, 50.00, 'Lost Book', b'1', 5);
INSERT INTO `fine` VALUES (30, 62, 50.00, 'Lost Book', b'1', 10);
INSERT INTO `fine` VALUES (31, 63, 50.00, 'Lost Book', b'1', 9);
INSERT INTO `fine` VALUES (32, 64, 15.00, 'Lost Book', b'1', 9);
INSERT INTO `fine` VALUES (33, 65, 15.00, 'Lost Book', b'1', 10);

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `BookID` int NOT NULL,
  `Total_Quantity` int NULL DEFAULT NULL,
  `Available_Quantity` int NULL DEFAULT NULL,
  PRIMARY KEY (`BookID`) USING BTREE,
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`bookid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory
-- ----------------------------
INSERT INTO `inventory` VALUES (1, 5, 4);
INSERT INTO `inventory` VALUES (2, 3, 2);
INSERT INTO `inventory` VALUES (3, 1, 0);
INSERT INTO `inventory` VALUES (4, 4, 3);
INSERT INTO `inventory` VALUES (5, 3, 3);
INSERT INTO `inventory` VALUES (6, 2, 2);
INSERT INTO `inventory` VALUES (7, 5, 6);
INSERT INTO `inventory` VALUES (8, 7, 7);
INSERT INTO `inventory` VALUES (9, 3, 3);
INSERT INTO `inventory` VALUES (10, 1, 1);
INSERT INTO `inventory` VALUES (11, 4, 4);
INSERT INTO `inventory` VALUES (12, 5, 5);
INSERT INTO `inventory` VALUES (13, 6, 6);
INSERT INTO `inventory` VALUES (14, 2, 2);
INSERT INTO `inventory` VALUES (15, 1, 0);
INSERT INTO `inventory` VALUES (16, 3, 3);
INSERT INTO `inventory` VALUES (17, 4, 4);
INSERT INTO `inventory` VALUES (18, 6, 6);
INSERT INTO `inventory` VALUES (19, 6, 6);
INSERT INTO `inventory` VALUES (20, 2, 1);
INSERT INTO `inventory` VALUES (21, 5, 4);
INSERT INTO `inventory` VALUES (22, 10, 9);

-- ----------------------------
-- Table structure for member_flags
-- ----------------------------
DROP TABLE IF EXISTS `member_flags`;
CREATE TABLE `member_flags`  (
  `flag_id` int NOT NULL AUTO_INCREMENT,
  `memberid` int NOT NULL,
  `flag_status` tinyint(1) NULL DEFAULT NULL,
  `flag_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `flag_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`flag_id`) USING BTREE,
  INDEX `memberid`(`memberid` ASC) USING BTREE,
  CONSTRAINT `member_flags_ibfk_1` FOREIGN KEY (`memberid`) REFERENCES `members` (`memberid`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member_flags
-- ----------------------------
INSERT INTO `member_flags` VALUES (26, 4, 1, 'Overdue book: 4', '2025-01-11 12:56:07');

-- ----------------------------
-- Table structure for members
-- ----------------------------
DROP TABLE IF EXISTS `members`;
CREATE TABLE `members`  (
  `memberid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`memberid`) USING BTREE,
  UNIQUE INDEX `unique_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of members
-- ----------------------------
INSERT INTO `members` VALUES (1, 'John Doe', '123 Main St, Anytown, USA', 'john.doe@example.com');
INSERT INTO `members` VALUES (2, 'Jane Smith', '456 Elm St, Another Town, USA', 'jane.smith@example.com');
INSERT INTO `members` VALUES (3, 'Michael Johnson', '789 Oak St, Smallville, USA', 'michael.johnson@example.com');
INSERT INTO `members` VALUES (4, 'Emily Brown', '321 Pine St, Villageville, USA', 'emily.brown@example.com');
INSERT INTO `members` VALUES (5, 'David Lee', '555 Cedar St, Citytown, USA', 'david.lee@example.com');
INSERT INTO `members` VALUES (6, 'Alice Walker', '101 Birch Rd, Townsville, USA', 'alice.walker@example.com');
INSERT INTO `members` VALUES (7, 'Bob Martin', '202 Cedar Ave, Citytown, USA', 'bob.martin@example.com');
INSERT INTO `members` VALUES (8, 'Clara Wilson', '303 Spruce Blvd, Metropolis, USA', 'clara.wilson@example.com');
INSERT INTO `members` VALUES (9, 'Derek White', '404 Willow Ln, Hamlet, USA', 'derek.white@example.com');
INSERT INTO `members` VALUES (10, 'Eva Green', '505 Maple Dr, Countryside, USA', 'eva.green@example.com');

-- ----------------------------
-- Table structure for staff
-- ----------------------------
DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff`  (
  `StaffID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`StaffID`) USING BTREE,
  UNIQUE INDEX `Email`(`Email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of staff
-- ----------------------------
INSERT INTO `staff` VALUES (1, 'Sarah Connor', 'sarah.connor@library.com', 'Librarian');
INSERT INTO `staff` VALUES (2, 'John Reese', 'john.reese@library.com', 'Assistant Librarian');
INSERT INTO `staff` VALUES (3, 'Ellen Ripley', 'ellen.ripley@library.com', 'Catalog Manager');
INSERT INTO `staff` VALUES (4, 'Alan Grant', 'alan.grant@library.com', 'Inventory Manager');
INSERT INTO `staff` VALUES (5, 'Dana Scully', 'dana.scully@library.com', 'Administrator');
INSERT INTO `staff` VALUES (6, 'Laura Palmer', 'laura.palmer@library.com', 'Archivist');
INSERT INTO `staff` VALUES (7, 'Gordon Cole', 'gordon.cole@library.com', 'Digital Asset Manager');
INSERT INTO `staff` VALUES (8, 'Harry Truman', 'harry.truman@library.com', 'Operations Manager');

-- ----------------------------
-- Table structure for transactions
-- ----------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions`  (
  `transactionid` int NOT NULL AUTO_INCREMENT,
  `bookid` int NULL DEFAULT NULL,
  `memberid` int NULL DEFAULT NULL,
  `borrow_date` date NULL DEFAULT NULL,
  `return_date` date NULL DEFAULT NULL,
  `actual_return_date` date NULL DEFAULT NULL,
  `fine_status` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`transactionid`) USING BTREE,
  INDEX `bookid`(`bookid` ASC) USING BTREE,
  INDEX `memberid`(`memberid` ASC) USING BTREE,
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`bookid`) REFERENCES `book` (`bookid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`memberid`) REFERENCES `members` (`memberid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of transactions
-- ----------------------------
INSERT INTO `transactions` VALUES (1, 1, 1, '2024-06-01', '2024-07-01', '2024-07-01', b'0');
INSERT INTO `transactions` VALUES (2, 2, 2, '2024-06-05', '2024-07-05', '2024-07-01', b'0');
INSERT INTO `transactions` VALUES (3, 3, 3, '2024-06-10', '2024-07-10', '2024-07-09', b'0');
INSERT INTO `transactions` VALUES (4, 4, 4, '2024-06-15', '2024-07-15', '2024-07-10', b'0');
INSERT INTO `transactions` VALUES (5, 5, 5, '2024-06-20', '2024-07-20', '2024-07-14', b'0');
INSERT INTO `transactions` VALUES (6, 6, 1, '2024-06-25', '2024-07-25', '2024-07-16', b'0');
INSERT INTO `transactions` VALUES (7, 7, 2, '2024-06-02', '2024-07-02', '2024-07-01', b'0');
INSERT INTO `transactions` VALUES (8, 8, 3, '2024-06-07', '2024-07-07', '2024-07-04', b'0');
INSERT INTO `transactions` VALUES (9, 9, 4, '2024-06-12', '2024-07-12', '2024-07-10', b'0');
INSERT INTO `transactions` VALUES (10, 10, 5, '2024-06-17', '2024-07-17', '2024-07-15', b'0');
INSERT INTO `transactions` VALUES (11, 11, 6, '2024-07-01', '2024-08-01', '2024-08-02', b'1');
INSERT INTO `transactions` VALUES (12, 12, 7, '2024-07-05', '2024-08-05', '2024-07-31', b'0');
INSERT INTO `transactions` VALUES (13, 13, 8, '2024-07-10', '2024-08-10', '2024-08-09', b'0');
INSERT INTO `transactions` VALUES (14, 14, 9, '2024-07-15', '2024-08-15', '2024-08-20', b'1');
INSERT INTO `transactions` VALUES (15, 15, 10, '2024-07-20', '2024-08-20', '2024-07-31', b'0');
INSERT INTO `transactions` VALUES (16, 16, 6, '2024-07-25', '2024-08-25', '2024-08-24', b'0');
INSERT INTO `transactions` VALUES (17, 17, 7, '2024-07-30', '2024-08-30', '2024-08-20', b'0');
INSERT INTO `transactions` VALUES (22, 10, 1, '2024-07-01', '2024-08-01', '2024-07-30', b'0');
INSERT INTO `transactions` VALUES (23, 1, 7, '2024-07-01', '2024-08-01', '2024-07-03', b'0');
INSERT INTO `transactions` VALUES (24, 15, 7, '2024-07-01', '2024-08-01', '2024-07-04', b'0');
INSERT INTO `transactions` VALUES (25, 15, 7, '2024-06-01', '2024-07-01', '2024-07-04', b'1');
INSERT INTO `transactions` VALUES (26, 10, 5, '2024-05-01', '2024-06-01', '2024-07-10', b'1');
INSERT INTO `transactions` VALUES (27, 9, 3, '2024-06-01', '2024-07-01', '2024-07-04', b'1');
INSERT INTO `transactions` VALUES (28, 4, 6, '2024-04-03', '2024-05-03', '2024-07-16', b'1');
INSERT INTO `transactions` VALUES (29, 5, 10, '2024-06-01', '2024-07-01', '2024-07-04', b'1');
INSERT INTO `transactions` VALUES (30, 22, 6, '2024-08-29', '2024-09-29', '2024-09-26', b'0');
INSERT INTO `transactions` VALUES (31, 20, 1, '2024-08-29', '2024-09-29', '2025-10-08', b'1');
INSERT INTO `transactions` VALUES (32, 22, 4, '2024-08-29', '2024-09-29', '2024-09-18', b'0');
INSERT INTO `transactions` VALUES (33, 3, 1, '2025-01-10', '2025-02-09', '2025-01-10', b'0');
INSERT INTO `transactions` VALUES (34, 3, 2, '2025-01-10', '2025-02-09', '2025-01-10', b'0');
INSERT INTO `transactions` VALUES (35, 22, 10, '2025-01-10', '2025-02-09', '2025-01-10', b'0');
INSERT INTO `transactions` VALUES (36, 22, 10, '2025-01-10', '2025-02-09', NULL, b'0');
INSERT INTO `transactions` VALUES (37, 21, 10, '2025-01-10', '2025-02-09', NULL, b'0');
INSERT INTO `transactions` VALUES (38, 20, 10, '2025-01-10', '2025-02-09', NULL, b'0');
INSERT INTO `transactions` VALUES (39, 22, 5, '2024-11-13', '2024-12-13', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (40, 22, 5, '2024-11-13', '2024-12-13', '2024-11-14', b'0');
INSERT INTO `transactions` VALUES (41, 21, 5, '2024-10-09', '2024-11-09', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (42, 1, 1, '2025-01-10', '2025-02-09', NULL, b'0');
INSERT INTO `transactions` VALUES (43, 3, 1, '2025-01-10', '2025-02-09', NULL, b'0');
INSERT INTO `transactions` VALUES (44, 2, 1, '2025-01-10', '2025-02-09', NULL, b'0');
INSERT INTO `transactions` VALUES (46, 1, 2, '2024-11-01', '2024-12-01', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (47, 2, 2, '2024-11-01', '2024-12-01', '2025-01-08', b'1');
INSERT INTO `transactions` VALUES (48, 4, 3, '2024-11-01', '2025-12-01', '2024-11-29', b'0');
INSERT INTO `transactions` VALUES (49, 5, 3, '2024-11-01', '2024-12-01', '2024-11-29', b'0');
INSERT INTO `transactions` VALUES (50, 4, 3, '2025-11-01', '2025-12-01', '2024-11-28', b'0');
INSERT INTO `transactions` VALUES (51, 4, 3, '2024-11-05', '2024-12-05', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (52, 5, 3, '2024-11-05', '2024-12-05', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (53, 7, 7, '2024-11-01', '2024-12-01', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (54, 8, 7, '2024-11-01', '2024-12-01', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (55, 7, 7, '2024-11-02', '2024-12-02', '2024-11-05', b'0');
INSERT INTO `transactions` VALUES (56, 15, 7, '2025-01-01', '2025-02-01', NULL, b'0');
INSERT INTO `transactions` VALUES (57, 11, 8, '2024-11-01', '2024-12-01', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (58, 12, 8, '2024-11-01', '2024-12-01', '2024-11-19', b'0');
INSERT INTO `transactions` VALUES (59, 13, 8, '2024-11-01', '2024-12-01', '2025-01-10', b'1');
INSERT INTO `transactions` VALUES (60, 11, 9, '2024-11-01', '2024-12-01', '2024-12-26', b'1');
INSERT INTO `transactions` VALUES (61, 5, 5, '2024-11-01', '2024-12-01', NULL, b'0');
INSERT INTO `transactions` VALUES (62, 5, 10, '2024-11-01', '2024-12-01', NULL, b'0');
INSERT INTO `transactions` VALUES (63, 5, 9, '2024-11-01', '2024-12-01', NULL, b'0');
INSERT INTO `transactions` VALUES (64, 3, 9, '2024-11-01', '2024-12-01', NULL, b'0');
INSERT INTO `transactions` VALUES (65, 19, 10, '2024-11-01', '2024-12-01', NULL, b'0');
INSERT INTO `transactions` VALUES (66, 4, 4, '2024-11-13', '2024-12-13', NULL, b'0');

-- ----------------------------
-- View structure for bookinventorysummary
-- ----------------------------
DROP VIEW IF EXISTS `bookinventorysummary`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `bookinventorysummary` AS select `b`.`bookid` AS `bookid`,`b`.`title` AS `title`,`i`.`Total_Quantity` AS `Total_Quantity`,`i`.`Available_Quantity` AS `Available_Quantity` from (`book` `b` join `inventory` `i` on((`b`.`bookid` = `i`.`BookID`)));

-- ----------------------------
-- View structure for booksavailable
-- ----------------------------
DROP VIEW IF EXISTS `booksavailable`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `booksavailable` AS select `b`.`title` AS `title`,`b`.`ISBN` AS `ISBN`,`a`.`name` AS `author_name` from (`book` `b` join `authors` `a` on((`b`.`authorid` = `a`.`authorid`))) where (`b`.`status` = 'available');

-- ----------------------------
-- View structure for membertransactions
-- ----------------------------
DROP VIEW IF EXISTS `membertransactions`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `membertransactions` AS select `m`.`name` AS `member_name`,`b`.`title` AS `book_title`,`t`.`borrow_date` AS `borrow_date`,`t`.`return_date` AS `return_date`,`t`.`actual_return_date` AS `actual_return_date`,`f`.`Amount` AS `fine_amount`,(case when (coalesce(`f`.`PaidStatus`,0) = 1) then 'paid' else 'unpaid' end) AS `PaidStatus` from (((`transactions` `t` join `members` `m` on((`t`.`memberid` = `m`.`memberid`))) join `book` `b` on((`t`.`bookid` = `b`.`bookid`))) left join `fine` `f` on((`t`.`transactionid` = `f`.`TransactionID`)));

-- ----------------------------
-- View structure for overduebooks
-- ----------------------------
DROP VIEW IF EXISTS `overduebooks`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `overduebooks` AS select `b`.`title` AS `title`,`b`.`ISBN` AS `ISBN`,`m`.`name` AS `member_name`,`t`.`return_date` AS `return_date`,`t`.`actual_return_date` AS `actual_return_date` from (((`transactions` `t` join `book` `b` on((`t`.`bookid` = `b`.`bookid`))) join `members` `m` on((`t`.`memberid` = `m`.`memberid`))) left join `fine` `f` on(((`t`.`transactionid` = `f`.`TransactionID`) and (`f`.`Reason` = 'Lost Book')))) where ((`t`.`actual_return_date` is null) and (`t`.`return_date` < curdate()) and (`f`.`TransactionID` is null));

-- ----------------------------
-- View structure for popularbooks
-- ----------------------------
DROP VIEW IF EXISTS `popularbooks`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `popularbooks` AS select `b`.`bookid` AS `bookid`,`b`.`title` AS `title`,count(`t`.`transactionid`) AS `transaction_count` from (`book` `b` left join `transactions` `t` on((`b`.`bookid` = `t`.`bookid`))) group by `b`.`bookid`,`b`.`title` order by `transaction_count` desc;

-- ----------------------------
-- Procedure structure for AddTransactions
-- ----------------------------
DROP PROCEDURE IF EXISTS `AddTransactions`;
delimiter ;;
CREATE PROCEDURE `AddTransactions`(
    IN input_memberid INT,
    IN input_book_titles VARCHAR(255)  -- Comma-separated book titles
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE book_id INT;
    DECLARE book_title VARCHAR(255);
    DECLARE book_cursor CURSOR FOR 
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(input_book_titles, ',', n), ',', -1)) 
        FROM (SELECT @rownum := @rownum + 1 AS n 
              FROM information_schema.columns, (SELECT @rownum := 0) r 
              LIMIT 255) numbers
        WHERE n <= (LENGTH(input_book_titles) - LENGTH(REPLACE(input_book_titles, ',', '')) + 1);

    -- Declare a handler for when the cursor finishes
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN book_cursor;

    read_loop: LOOP
        FETCH book_cursor INTO book_title;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Retrieve the book ID based on the title
        SELECT bookid INTO book_id
        FROM book
        WHERE title = book_title
          AND status = 'available'
        LIMIT 1;

        -- Check if the book exists and is available
        IF book_id IS NULL THEN
            -- Return an error if the book is unavailable
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more books are not available or do not exist.';
        ELSE
            -- Insert the transaction for each book
            INSERT INTO transactions (
                bookid,
                memberid,
                borrow_date,
                return_date,
                actual_return_date,
                fine_status
            ) VALUES (
                book_id,
                input_memberid,
                CURDATE(),
                CURDATE() + INTERVAL 30 DAY,
                NULL,
                0
            );
        END IF;
    END LOOP;

    CLOSE book_cursor;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for LostBookFine
-- ----------------------------
DROP PROCEDURE IF EXISTS `LostBookFine`;
delimiter ;;
CREATE PROCEDURE `LostBookFine`(
    IN p_member_id INT,
    IN p_bookid INT,
    IN p_transaction_id INT
)
BEGIN
    DECLARE v_price DECIMAL(10, 2);
    DECLARE v_total_quantity INT;

    -- Step 1: Fetch the price of the book from the book table
    SELECT price INTO v_price
    FROM book
    WHERE bookid = p_bookid;

    -- Step 2: Check if the price exists, otherwise raise an error
    IF v_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book price not found for the provided Book ID.';
    END IF;

    -- Step 3: Fetch the Original_Quantity from the inventory table
    SELECT Total_Quantity INTO v_total_quantity
    FROM inventory
    WHERE BookId = p_bookid;

    -- Step 4: Check if the book exists in inventory and has sufficient quantity
    IF v_total_quantity IS NULL OR v_total_quantity < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book not available in inventory.';
    END IF;

    -- Step 5: Insert the fine record into the fines table
    INSERT INTO fine (TransactionID, Amount, Reason, PaidStatus, memberid)
    VALUES (p_transaction_id, v_price, 'Lost Book', 0, p_member_id);

    -- Step 6: Update the inventory table to decrease the Original_Quantity by 1
    UPDATE inventory
    SET Total_Quantity = Total_Quantity - 1
    WHERE BookId = p_bookid;
    
    -- Step 7: Remove the overdue flag from the member_flags table
    DELETE FROM member_flags
    WHERE memberid = p_member_id
      AND flag_reason LIKE CONCAT('Overdue book: ', p_bookid);

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for PayFine
-- ----------------------------
DROP PROCEDURE IF EXISTS `PayFine`;
delimiter ;;
CREATE PROCEDURE `PayFine`(
    IN input_memberid INT,
    IN input_bookid INT
)
BEGIN
    DECLARE fine_exists INT;

    -- Check if there's an unpaid fine for the member and book
    SELECT COUNT(*) INTO fine_exists
    FROM fine
    WHERE memberid = input_memberid
      AND reason LIKE CONCAT('%', input_bookid, '%')  -- reason stores the bookid
      AND PaidStatus = 0;  -- Unpaid fine

    -- If a fine exists, mark it as paid
    IF fine_exists > 0 THEN
        UPDATE fine
        SET PaidStatus = 1
        WHERE memberid = input_memberid
          AND reason LIKE CONCAT('%', input_bookid, '%')
          AND PaidStatus = 0;

        -- Optionally, you can also update the transaction or perform other actions if needed
        -- Example: Log the payment, etc.
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No unpaid fine found for the member and book.';
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for UpdateActualReturnDate
-- ----------------------------
DROP PROCEDURE IF EXISTS `UpdateActualReturnDate`;
delimiter ;;
CREATE PROCEDURE `UpdateActualReturnDate`(
    IN input_memberid INT,
    IN input_bookid INT
)
BEGIN
    -- Update the actual_return_date for the given memberid and bookid
    UPDATE transactions
    SET actual_return_date = CURDATE()
    WHERE memberid = input_memberid
      AND bookid = input_bookid
      AND actual_return_date IS NULL;  -- Ensure it only updates if actual_return_date is currently NULL

    -- Optionally, check if a row was updated
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No matching transaction found for this member and book.';
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for check_overdue_books
-- ----------------------------
DROP EVENT IF EXISTS `check_overdue_books`;
delimiter ;;
CREATE EVENT `check_overdue_books`
ON SCHEDULE
EVERY '1' DAY STARTS '2024-07-04 13:22:14'
DO BEGIN

		-- Update transactions where fine_status should be set to 1
    UPDATE transactions t
    JOIN inventory i ON t.bookid = i.BookID
    SET t.fine_status = 1
    WHERE t.actual_return_date IS NULL
      AND t.return_date < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
			
    -- Update transactions where fine_status should be set to 1 and insert into Fine table
    INSERT INTO fine (TransactionID, Amount, Reason, PaidStatus)
    SELECT t.transactionid, 20.00, 'Late Return Deadline Surpassed (exceeded 30 days)', 0
    FROM transactions t
    WHERE t.actual_return_date IS NULL
      AND t.return_date < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
      AND t.transactionid NOT IN (SELECT TransactionID FROM fine);
END
;;
delimiter ;

-- ----------------------------
-- Event structure for update_transactions_event
-- ----------------------------
DROP EVENT IF EXISTS `update_transactions_event`;
delimiter ;;
CREATE EVENT `update_transactions_event`
ON SCHEDULE
EVERY '1' HOUR STARTS '2024-07-04 15:12:50'
DO BEGIN
    -- Update transactions where PaidStatus is 1 in Fine table
    UPDATE transactions t
    JOIN fine f ON t.transactionid = f.TransactionID
    SET t.fine_status = 0
    WHERE f.PaidStatus = 1
      AND t.fine_status = 1;  -- Only update where fine_status needs to be reset
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table fine
-- ----------------------------
DROP TRIGGER IF EXISTS `flag_unpaid_fines`;
delimiter ;;
CREATE TRIGGER `flag_unpaid_fines` AFTER INSERT ON `fine` FOR EACH ROW BEGIN
    -- Declare a variable to store the bookid
    DECLARE related_bookid INT;

    -- Check if the fine is unpaid (PaidStatus = 0)
    IF NEW.PaidStatus = 0 THEN
        -- Retrieve the bookid from the transactions table based on the fine's transactionid
        SELECT bookid INTO related_bookid
        FROM transactions
        WHERE transactionid = NEW.transactionid;
        
        -- Insert a flag for the member with the bookid in flag_reason
        INSERT INTO member_flags (memberid, flag_status, flag_reason)
        VALUES (NEW.memberid, TRUE, CONCAT('Unpaid fine for book: ', related_bookid))
        ON DUPLICATE KEY UPDATE flag_status = TRUE, flag_reason = CONCAT('Unpaid fine for book: ', related_bookid);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table fine
-- ----------------------------
DROP TRIGGER IF EXISTS `remove_unpaid_fine_flag`;
delimiter ;;
CREATE TRIGGER `remove_unpaid_fine_flag` AFTER UPDATE ON `fine` FOR EACH ROW BEGIN
    -- Declare a variable to store the bookid
    DECLARE related_bookid INT;

    -- Check if the PaidStatus is changed from 0 to 1 (paid)
    IF OLD.PaidStatus = 0 AND NEW.PaidStatus = 1 THEN
        -- Retrieve the bookid from the transactions table based on the fine's transactionid
        SELECT bookid INTO related_bookid
        FROM transactions
        WHERE transactionid = NEW.transactionid;
        
        -- Remove the "Unpaid fine" flag from the member_flags table
        DELETE FROM member_flags
        WHERE memberid = NEW.memberid
          AND flag_reason = CONCAT('Unpaid fine for book: ', related_bookid);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table inventory
-- ----------------------------
DROP TRIGGER IF EXISTS `update_book_status_trigger`;
delimiter ;;
CREATE TRIGGER `update_book_status_trigger` AFTER UPDATE ON `inventory` FOR EACH ROW BEGIN
    DECLARE available_count INT;

    -- Get the available quantity for the book after update
    SELECT Available_Quantity INTO available_count
    FROM inventory
    WHERE BookID = NEW.BookID;

    -- Update the status in the book table based on available quantity
    IF available_count > 0 THEN
        UPDATE book
        SET status = 'available'
        WHERE bookid = NEW.BookID;
    ELSE
        UPDATE book
        SET status = 'not available'
        WHERE bookid = NEW.BookID;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `after_borrow_trigger`;
delimiter ;;
CREATE TRIGGER `after_borrow_trigger` AFTER INSERT ON `transactions` FOR EACH ROW BEGIN
    UPDATE inventory
    SET Available_Quantity = Available_Quantity - 1
    WHERE BookID = NEW.bookid;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `flag_overdue_members`;
delimiter ;;
CREATE TRIGGER `flag_overdue_members` AFTER INSERT ON `transactions` FOR EACH ROW BEGIN
    -- Check if the borrow is overdue (30 days without return)
    IF NEW.actual_return_date IS NULL AND DATEDIFF(CURDATE(), NEW.borrow_date) > 30 THEN
        -- Insert a separate entry for each overdue book
        INSERT INTO member_flags (memberid, flag_status, flag_reason)
        VALUES (NEW.memberid, TRUE, CONCAT('Overdue book: ', NEW.bookid))
        ON DUPLICATE KEY UPDATE flag_status = TRUE, flag_reason = CONCAT('Overdue book: ', NEW.bookid);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `calculate_fine_trigger`;
delimiter ;;
CREATE TRIGGER `calculate_fine_trigger` BEFORE UPDATE ON `transactions` FOR EACH ROW BEGIN
    DECLARE fine_amount DECIMAL(10, 2) DEFAULT 5.00;
    
    IF NEW.actual_return_date > NEW.return_date THEN
        -- Update fine_status to 1
        SET NEW.fine_status = 1;

        -- Insert into Fine table
        INSERT INTO fine (TransactionID, Amount, Reason, PaidStatus, memberid)
        VALUES (NEW.transactionid, fine_amount, CONCAT('Late return of book ID ', NEW.bookid), 0, NEW.memberid);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `after_return_trigger`;
delimiter ;;
CREATE TRIGGER `after_return_trigger` AFTER UPDATE ON `transactions` FOR EACH ROW BEGIN
    IF NEW.actual_return_date IS NOT NULL THEN
        UPDATE inventory
        SET Available_Quantity = Available_Quantity + 1
        WHERE BookID = NEW.bookid;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `remove_overdue_flag_on_return`;
delimiter ;;
CREATE TRIGGER `remove_overdue_flag_on_return` AFTER UPDATE ON `transactions` FOR EACH ROW BEGIN
    -- Check if the actual_return_date is not null (i.e., the book is returned)
    IF NEW.actual_return_date IS NOT NULL THEN
        -- Remove the flag for the specific book that was returned
        DELETE FROM member_flags
        WHERE memberid = NEW.memberid
          AND flag_reason = CONCAT('Overdue book: ', NEW.bookid);
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
