
# Entity Relationship Justification

This database is designed for a Hotel Reservation System.

## Entities Used
- Customers
- RoomCategories
- Rooms
- Reservations
- Bills
- Payments
- AuditLog

## Relationships

1. Customer → Reservations
- One customer can have many reservations
- So it is a one-to-many relationship

2. RoomCategories → Rooms
- One category can have multiple rooms
- Example: many Deluxe rooms

3. Rooms → Reservations
- One room can have many reservations over time
- But at a specific time, it should not overlap

4. Reservations → Bills
- One reservation has one bill
- So one-to-one relationship

5. Reservations → Payments
- One reservation (through bill) can have multiple payments
- So one-to-many

6. AuditLog
- Stores changes done by triggers
- Helps in tracking updates and inserts

## Keys Used
- Primary keys for each table (CustomerID, RoomID, etc.)
- Foreign keys used to connect tables properly

## Conclusion
These relationships help maintain proper structure and avoid data duplication.