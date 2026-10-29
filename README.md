# Financial Transaction Reconciliation & Audit Analytics

## Project Overview

This project demonstrates a rule-based financial transaction reconciliation and audit analytics workflow using synthetic transaction, approval, and settlement data. It combines Excel-based validation, SQL queries, and an interactive Power BI report to identify exceptions that may require further investigation.

The project is designed to support reconciliation review and audit analysis. Identified exceptions are review indicators and should not automatically be interpreted as fraud.

## Business Objective

- Validate transaction records against approval and settlement data.
- Identify missing approval references and approval-record issues.
- Detect potential duplicate activity and settlement discrepancies.
- Summarize exception patterns to support audit review and follow-up.

## Tools Used

- **Microsoft Excel:** Data review, rule-based exception analysis, summary reporting, and validation.
- **SQL (MySQL):** Queries, joins, exception identification, and reconciliation checks.
- **Microsoft Power BI:** Interactive transaction and exception reporting.

## Reconciliation Rules

| Rule ID | Exception Type                     | Purpose                                                                                      |
|---------|------------------------------------|----------------------------------------------------------------------------------------------|                                                                                     
| R1      | Possible duplicate activity        | Flags records with the same customer reference, amount, and calendar date for manual review. |
| R2      | Missing approval reference         | Identifies transactions with a blank approval reference.                                     |
| R3      | Approval record missing            | Identifies transactions whose approval reference has no matching approval record.            |
| R4      | Approval not approved              | Identifies matched approval records that are not marked Approved.                            |
| R5      | Successful transaction not settled | Identifies successful transactions without a corresponding settlement record.                |
| R6      | Settlement amount mismatch         | Flags differences between transaction and settlement amounts.                                |                  
| R7      | Orphan settlement                  | Identifies settlement records without a matching transaction.                                |

## Key Results

- **501** transaction records analyzed.
- **104** exception records identified across seven reconciliation rules.
- Exceptions reviewed across transaction, approval, and settlement data.
- Excel summaries and SQL validation outputs prepared to support cross-checking.
- An interactive Power BI report is being developed to present transaction KPIs, exception breakdowns, and filterable exception details.

*Exception records may overlap and do not necessarily represent the same number of unique transactions. Potential duplicate activity is flagged for review and is not automatically classified as fraud.*

## Repository Structure

- `data/` — Synthetic source CSV files.
- `Excel/` — Main Excel analysis workbook.
- `SQL/` — SQL script and SQL working/validation workbooks, screenshots of reconciliation queries and results.
- `PowerBI/` — Power BI report file.
- `README.md` — Project overview and documentation.

## Data Note

All data used in this portfolio project is synthetic and is intended for demonstration and learning purposes. No real customer or banking transaction data is intended to be included.

## Project Status

The Excel analysis, SQL validation, and Power BI report are completed. The report includes an Executive Overview and a Reconciliation Analysis page, with interactive filtering, transaction KPIs, and rule-based exception details.
