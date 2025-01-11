Library Management System
Overview
The Library Management System is a comprehensive solution designed to efficiently manage and automate the operations of a library. This system tracks key aspects such as books, members, staff, inventory, transactions, fines, and book rentals. It provides a centralized platform to manage the lifecycle of a book, from its availability in the inventory to its rental and eventual return.

The system is built with several features and automated procedures to ensure smooth operation and accurate record-keeping. Key functionalities include:

Book Information: Tracks details about books, including titles, ISBNs, prices, and their availability in the library.
Inventory Management: Manages book inventory, including tracking the total quantity and availability of each book.
Member & Staff Management: Keeps records of library members and staff, including personal details and rental history.
Book Rentals: Manages the renting process for books, including the borrowing period and actual return dates.
Fine Management: Handles fines for late returns, damaged books, and lost books, ensuring members are charged appropriately.
Flag System: A flag system ensures that members with overdue books or fines are not allowed to rent more books until their issues are resolved.
Views: Several views have been implemented to simplify the retrieval of key data, such as OverdueBooks, to display overdue books and track rental status.
Key Features
Automated Triggers: The system utilizes triggers to maintain data integrity and automate certain actions. For example, fines are automatically calculated when books are overdue, and inventory levels are updated when books are rented or returned.
Stored Procedures: Simple and reusable stored procedures were created for adding transactions, paying fines, and processing book returns. This allows for easy interaction with the database without the need for complex queries each time.
Procedure for Handling Late Returns: Automatically calculates fines for overdue books.
Procedure for Lost/Damaged Books: Automatically fines the member for lost or damaged books and updates inventory.
Return Process: A procedure for marking books as returned, updating the inventory, and removing any overdue flags if applicable.
The system ensures that everything from tracking rentals, updating inventory, handling fines, and processing returns is automated, simplifying the library's workflow and reducing manual errors.
