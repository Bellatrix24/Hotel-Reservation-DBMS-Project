
# Normalization Report

In the beginning, if we try to store all data in one single table (like customer details, room info, reservation, payments), it would create a lot of redundancy and repeated data. For example, customer details would be repeated for every booking, and room details would also repeat.

## 1NF (First Normal Form)
To achieve 1NF:
- All columns have atomic values (no multiple values in one column)
- Separate tables are created for Customers, Rooms, Reservations, etc.
- Each row is uniquely identified using primary keys

## 2NF (Second Normal Form)
To achieve 2NF:
- Removed partial dependency
- Data is split into separate tables so that each non-key attribute depends on the whole primary key
- Example: Room category details are stored separately instead of repeating in Rooms table

## 3NF (Third Normal Form)
To achieve 3NF:
- Removed transitive dependencies
- Example: Room category price is not stored in Rooms table, instead stored in RoomCategories table
- Billing and Payments are separated from Reservations

## BCNF (Brief)
Most tables follow BCNF as well because:
- Every determinant is a candidate key

## Final Conclusion
The database is properly normalized to reduce redundancy, avoid anomalies, and maintain data integrity.