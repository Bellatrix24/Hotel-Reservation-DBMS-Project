import pandas as pd
from openpyxl import Workbook
from openpyxl.utils.dataframe import dataframe_to_rows
from openpyxl.styles import Font, Border, Side

sheets_data = {
    "Reservation Details": pd.DataFrame({
        "ReservationID": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        "CustomerName": ["John Doe", "Jane Smith", "Alice Johnson", "Bob Brown", "Charlie Davis", "Diana Miller", "Eve Wilson", "Frank Moore", "John Doe", "Jane Smith"],
        "RoomNumber": ["101", "102", "201", "202", "301", "302", "401", "402", "403", "203"],
        "CategoryName": ["Standard", "Standard", "Deluxe", "Deluxe", "Suite", "Suite", "Family", "Family", "Family", "Deluxe"],
        "CheckInDate": ["2026-06-01", "2026-05-15", "2026-04-01", "2026-05-12", "2026-07-10", "2026-05-14", "2026-03-10", "2026-06-15", "2026-08-01", "2026-05-01"],
        "CheckOutDate": ["2026-06-05", "2026-05-20", "2026-04-03", "2026-05-20", "2026-07-15", "2026-05-16", "2026-03-15", "2026-06-20", "2026-08-10", "2026-05-05"],
        "ReservationStatus": ["Booked", "CheckedIn", "CheckedOut", "CheckedIn", "Booked", "CheckedIn", "CheckedOut", "Cancelled", "Booked", "CheckedOut"]
    }),
    "Revenue By Category": pd.DataFrame({
        "CategoryName": ["Family", "Deluxe", "Suite", "Standard"],
        "TotalRevenue": [2800, 2100, 1750, 900]
    }),
    "Customers Multiple Res": pd.DataFrame({
        "CustomerID": [1, 2],
        "FirstName": ["John", "Jane"],
        "LastName": ["Doe", "Smith"],
        "TotalReservations": [2, 2]
    }),
    "Pending Payments": pd.DataFrame({
        "CustomerName": ["Charlie Davis"],
        "BillID": [5],
        "BillAmount": [1250],
        "AmountPaid": [1250],
        "PaymentStatus": ["Pending"],
        "PaymentDate": ["2026-07-10 14:15:00"]
    }),
    "Monthly Revenue": pd.DataFrame({
        "BillMonth": [3, 4, 5, 6, 8],
        "MonthlyRevenue": [1000, 300, 2800, 400, 1800]
    }),
    "Unbooked Rooms": pd.DataFrame({
        "RoomNumber": ["103", "104"],
        "CategoryName": ["Standard", "Standard"]
    }),
    "Highest Bill Per Cust": pd.DataFrame({
        "FirstName": ["John", "Jane", "Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"],
        "LastName": ["Doe", "Smith", "Johnson", "Brown", "Davis", "Miller", "Wilson", "Moore"],
        "HighestBill": [1800, 600, 300, 1200, 1250, 500, 1000, 0]
    }),
    "Transaction Demo": pd.DataFrame({
        "DemoName": ["Successful Booking Transaction", "Failed Double Booking Transaction"],
        "Result": ["COMMITTED", "ROLLED BACK"],
        "Explanation": ["Reservation + bill + payment inserted together", "Overlapping booking prevented"]
    }),
    "DCL Permissions": pd.DataFrame({
        "GranteeRole": ["ReceptionistRole", "ReceptionistRole", "ReceptionistRole", "ReceptionistRole"],
        "ObjectName": ["Customers", "Customers", "Reservations", "Reservations"],
        "Permission": ["INSERT", "SELECT", "INSERT", "SELECT"],
        "PermissionState": ["GRANT", "GRANT", "GRANT", "GRANT"]
    })
}

wb = Workbook()
wb.remove(wb.active)  # Remove default empty sheet

thin_border = Border(left=Side(style='thin'), 
                     right=Side(style='thin'), 
                     top=Side(style='thin'), 
                     bottom=Side(style='thin'))
bold_font = Font(bold=True)

for sheet_name, df in sheets_data.items():
    ws = wb.create_sheet(title=sheet_name[:31])
    
    # Write dataframe rows to worksheet
    for r in dataframe_to_rows(df, index=False, header=True):
        ws.append(r)
        
    # Formatting
    for col_idx, column_cells in enumerate(ws.columns, 1):
        max_length = 0
        for cell in column_cells:
            # Apply borders to all data cells
            cell.border = thin_border
            
            # Apply bold font to header row
            if cell.row == 1:
                cell.font = bold_font
                
            # Calculate max length for auto-fitting width
            try:
                if len(str(cell.value)) > max_length:
                    max_length = len(str(cell.value))
            except:
                pass
                
        # Set column width with a bit of padding
        adjusted_width = (max_length + 3)
        ws.column_dimensions[column_cells[0].column_letter].width = adjusted_width
        
    # Freeze the top header row
    ws.freeze_panes = 'A2'

wb.save("Output/sample_results_final.xlsx")
print("Saved Output/sample_results_final.xlsx successfully with realistic data and formatting!")
