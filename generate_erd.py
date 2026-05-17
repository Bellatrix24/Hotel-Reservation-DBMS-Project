import base64
import urllib.request
import os

mermaid_code = """
erDiagram
    Customers ||--o{ Reservations : "makes"
    RoomCategories ||--o{ Rooms : "categorizes"
    Rooms ||--o{ Reservations : "booked in"
    Reservations ||--|| Bills : "generates"
    Bills ||--o{ Payments : "receives"
    
    Customers {
        INT CustomerID PK
        NVARCHAR FirstName
        NVARCHAR LastName
        NVARCHAR Email
        NVARCHAR Phone
        NVARCHAR Address
        DATETIME CreatedAt
    }
    RoomCategories {
        INT CategoryID PK
        NVARCHAR CategoryName
        DECIMAL BasePrice
        NVARCHAR Description
    }
    Rooms {
        INT RoomID PK
        NVARCHAR RoomNumber
        INT CategoryID FK
        NVARCHAR RoomStatus
        DATETIME CreatedAt
    }
    Reservations {
        INT ReservationID PK
        INT CustomerID FK
        INT RoomID FK
        DATETIME CheckInDate
        DATETIME CheckOutDate
        NVARCHAR ReservationStatus
        DECIMAL TotalAmount
        DATETIME CreatedAt
    }
    Bills {
        INT BillID PK
        INT ReservationID FK
        DECIMAL TotalAmount
        DATETIME BillDate
    }
    Payments {
        INT PaymentID PK
        INT BillID FK
        DATETIME PaymentDate
        DECIMAL AmountPaid
        NVARCHAR PaymentMethod
        NVARCHAR PaymentStatus
    }
    AuditLog {
        INT LogID PK
        NVARCHAR TableName
        NVARCHAR OperationType
        INT RecordID
        NVARCHAR ChangeDescription
        NVARCHAR ChangedBy
        DATETIME ChangedAt
    }
"""

encoded = base64.urlsafe_b64encode(mermaid_code.encode('utf-8')).decode('ascii')
url = f"https://mermaid.ink/img/{encoded}?type=png&bgColor=white"

os.makedirs("ERD", exist_ok=True)

req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req) as response, open("ERD/er_diagram.png", 'wb') as out_file:
    data = response.read()
    out_file.write(data)

print("Saved ERD/er_diagram.png")
