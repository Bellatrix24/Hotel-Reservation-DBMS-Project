from fpdf import FPDF
import os

class PDF(FPDF):
    def header(self):
        # We don't want a repeated header on every page, so we leave it empty
        pass

    def footer(self):
        # Go to 1.5 cm from bottom
        self.set_y(-15)
        self.set_font("Helvetica", "I", 10)
        # Print page number
        self.cell(0, 10, f"Page {self.page_no()}", align="C")

pdf = PDF()
pdf.add_page()
pdf.set_font("Helvetica", size=12)

# Give a little top margin
pdf.ln(10)

with open('Documentation/normalization_report.md', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line:
            pdf.ln(6)
            continue
        
        if line.startswith('### '):
            pdf.set_font("Helvetica", "B", 13)
            pdf.multi_cell(0, 8, line.replace('### ', '').strip(), new_x="LMARGIN", new_y="NEXT")
            pdf.set_font("Helvetica", size=12)
        elif line.startswith('## '):
            pdf.ln(4)
            pdf.set_font("Helvetica", "B", 14)
            pdf.multi_cell(0, 8, line.replace('## ', '').strip(), new_x="LMARGIN", new_y="NEXT")
            pdf.set_font("Helvetica", size=12)
            pdf.ln(2)
        elif line.startswith('# '):
            pdf.set_font("Helvetica", "B", 18)
            pdf.multi_cell(0, 10, line.replace('# ', '').strip(), align="C", new_x="LMARGIN", new_y="NEXT")
            pdf.set_font("Helvetica", size=12)
            pdf.ln(6)
        elif line.startswith('- '):
            pdf.multi_cell(0, 7, "    " + line, new_x="LMARGIN", new_y="NEXT")
        else:
            pdf.multi_cell(0, 7, line, new_x="LMARGIN", new_y="NEXT")

pdf.output("Documentation/normalization_report.pdf")
print("Saved Documentation/normalization_report.pdf")
