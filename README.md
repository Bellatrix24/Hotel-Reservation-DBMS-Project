# Hotel Reservation DBMS Project

## Overview
This project is a database system for managing hotel operations like bookings, rooms, customers, billing, and payments.

## Features
- Customer management
- Room and category management
- Reservation system
- Billing and payment tracking
- Trigger automation
- Transaction handling
- Role-based access control

## Database Design Approach
The database follows a fully normalized relational structure (up to 3NF/BCNF). 
- Primary and Foreign keys establish strict 1-to-M and 1-to-1 relationships between entities.
- Data integrity is enforced using UNIQUE, NOT NULL, and CHECK constraints.
- Denormalized views are created for reporting, and non-clustered indexes are applied for performance optimization.

## Database Tables
- Customers
- RoomCategories
- Rooms
- Reservations
- Bills
- Payments
- AuditLog

## How to Run
1. Open SSMS
2. Run scripts in order:
   - 01_create_database.sql
   - 02_ddl_tables.sql
   - 03_dml_sample_data.sql
   - 05_views.sql
   - 06_indexes.sql
   - 07_functions.sql
   - 08_triggers.sql
   - 04_queries.sql
   - 09_transactions.sql
   - 10_dcl_grant_revoke.sql

## Sample Queries
Includes complex queries using joins, subqueries, grouping, etc.

## Author
Saumya Singh

## Disclaimer
Some parts of the project such as sample data generation, and boilerplate scripts were assisted using AI tools.

However, the overall design, understanding, testing, and integration were done manually.
