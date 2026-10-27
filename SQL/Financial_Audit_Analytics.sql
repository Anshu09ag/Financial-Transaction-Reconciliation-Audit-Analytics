====== Project: Financial Transaction Reconciliation & Audit Analytics =======

Purpose: Validate Excel exception checks using MySQL.
Database: MySQL v5.7 (DB Fiddle)
Data source: Synthetic transaction, approval and settlement datasets.

Tables:
1. Transactions
2. Approvals
3. SettlementLedger

Main validation rules:
R1 - Possible Duplicate Activity
R2 - Missing Approval Reference
R3 - Missing or Mismatched Approval Record
R4 - Approval Not Approved
R5 - Successful Transaction Not Settled
R6 - Settlement Amount Mismatch
R7 - Orphan Settlement Record

Note:
Exception flags identify records for review. They do not automatically establish fraud, unauthorised activity or financial loss.

-- =========================================================
-- SQL SCHEMA
-- =========================================================

-- Schema (MySQL v5.7)
 
    -- ======= 1. BUILD THE SCHEMA ============
    
     -- ==== TRANSACTIONS TABLE =====
    CREATE TABLE Transactions (
      TransactionID VARCHAR(20) PRIMARY KEY,
      TransactionDate DATETIME,
      Branch VARCHAR (50),
      Channel VARCHAR(30),
      Amount DECIMAL(12,2),
      TransactionStatus VARCHAR(20),
      ApprovalID VARCHAR(20),
      CustomerRef VARCHAR(20)
    );
    
     -- ==== APPROVALS TABLE =====
     CREATE TABLE Approvals (
      ApprovalID VARCHAR(20),
      TransactionID VARCHAR(20),
      ApproverRole VARCHAR (50),
      ApprovalStatus VARCHAR(20),
      ApprovalDate DATETIME
    );
    
      -- ==== SettlementLedger TABLE =====
       CREATE TABLE SettlementLedger (
      SettlementRef VARCHAR(20),
      TransactionID VARCHAR(20),
      SettlementDate DATETIME,
      SettledAmount DECIMAL(12,2),
      SettlementStatus VARCHAR(20)
    );
    
    
    INSERT INTO Transactions
    (TransactionID, TransactionDate, Branch, Channel, Amount,
     TransactionStatus, ApprovalID, CustomerRef)
    VALUES
    ('TXN00001', '2026-09-20 09:01:00', 'Delhi', 'UPI', 55680.90,
     'Success', 'APR00001', 'CUST9935');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00002', '2026-07-12 17:27:00', 'Delhi', 'Wallet', 2625.76, 'Success', 'APR00002', 'CUST4257');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00003', '2026-09-30 18:44:00', 'Pune', 'NEFT', 40984.38, 'Success', 'APR00003', 'CUST1106');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00004', '2026-07-21 19:27:00', 'Mumbai', 'UPI', 25683.73, 'Success', 'APR00004', 'CUST2584');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00005', '2026-08-15 21:22:00', 'Kolkata', 'Card', 45378.52, 'Success', 'APR00005', 'CUST7201');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00006', '2026-07-11 16:18:00', 'Mumbai', 'Wallet', 62248.00, 'Success', 'APR00006', 'CUST2139');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00007', '2026-07-06 18:14:00', 'Delhi', 'UPI', 58036.86, 'Pending', 'APR00007', 'CUST8428');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00008', '2026-09-20 21:23:00', 'Kolkata', 'NEFT', 12408.39, 'Success', 'APR00008', 'CUST2169');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00009', '2026-09-16 18:10:00', 'Bengaluru', 'Card', 40176.96, 'Success', 'APR00009', 'CUST4598');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00010', '2026-09-26 13:53:00', 'Jaipur', 'NEFT', 57681.44, 'Success', 'APR00010', 'CUST2084');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00011', '2026-07-28 22:36:00', 'Kolkata', 'Card', 65758.48, 'Success', 'APR00011', 'CUST8517');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00012', '2026-07-19 12:08:00', 'Mumbai', 'Wallet', 18685.41, 'Success', 'APR00012', 'CUST7543');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00013', '2026-08-16 11:08:00', 'Jaipur', 'UPI', 38337.09, 'Success', 'APR00013', 'CUST3621');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00014', '2026-09-26 14:38:00', 'Bengaluru', 'Wallet', 4998.70, 'Success', 'APR00014', 'CUST1188');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00015', '2026-09-26 19:07:00', 'Mumbai', 'NEFT', 51207.85, 'Success', 'APR00015', 'CUST8123');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00016', '2026-07-21 15:00:00', 'Mumbai', 'Wallet', 71547.74, 'Success', 'APR00016', 'CUST9317');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00017', '2026-07-14 21:40:00', 'Pune', 'IMPS', 22558.75, 'Success', 'APR00017', 'CUST3646');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00018', '2026-09-08 20:59:00', 'Mumbai', 'Card', 39893.94, 'Success', '', 'CUST6947');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00019', '2026-08-09 11:03:00', 'Jaipur', 'UPI', 18255.15, 'Success', 'APR00019', 'CUST2133');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00020', '2026-09-07 20:08:00', 'Pune', 'IMPS', 9847.26, 'Success', 'APR00020', 'CUST7932');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00021', '2026-07-28 22:34:00', 'Kolkata', 'NEFT', 56706.07, 'Success', 'APR00021', 'CUST7118');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00022', '2026-08-26 22:33:00', 'Jaipur', 'NEFT', 33998.59, 'Success', '', 'CUST4770');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00023', '2026-09-14 11:00:00', 'Delhi', 'UPI', 5556.73, 'Success', 'APR00023', 'CUST6413');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00024', '2026-07-10 16:15:00', 'Pune', 'IMPS', 21066.18, 'Success', 'APR00024', 'CUST8744');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00025', '2026-08-01 20:30:00', 'Jaipur', 'Card', 60610.40, 'Success', 'APR00025', 'CUST7735');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00026', '2026-08-29 21:46:00', 'Kolkata', 'UPI', 4299.30, 'Success', '', 'CUST6559');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00027', '2026-07-14 11:12:00', 'Bengaluru', 'IMPS', 14468.12, 'Success', 'APR00027', 'CUST5092');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00028', '2026-07-10 15:51:00', 'Jaipur', 'Wallet', 64635.85, 'Success', 'APR00028', 'CUST2528');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00029', '2026-07-31 10:26:00', 'Bengaluru', 'UPI', 36551.67, 'Success', 'APR00029', 'CUST1035');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00030', '2026-08-19 12:59:00', 'Bengaluru', 'Wallet', 58859.28, 'Success', 'APR00030', 'CUST8973');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00031', '2026-07-20 11:18:00', 'Kolkata', 'Wallet', 16523.14, 'Success', '', 'CUST6138');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00032', '2026-07-08 08:37:00', 'Pune', 'IMPS', 35889.94, 'Failed', '', 'CUST9320');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00033', '2026-07-11 21:11:00', 'Delhi', 'Card', 5371.97, 'Success', 'APR00033', 'CUST5033');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00034', '2026-09-13 17:02:00', 'Pune', 'Wallet', 46548.77, 'Success', 'APR00034', 'CUST5272');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00035', '2026-07-27 18:45:00', 'Delhi', 'NEFT', 23735.24, 'Success', 'APR00035', 'CUST2188');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00036', '2026-07-02 15:39:00', 'Jaipur', 'Wallet', 74884.47, 'Pending', 'APR00036', 'CUST5345');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00037', '2026-07-17 22:22:00', 'Mumbai', 'NEFT', 66094.60, 'Success', 'APR00037', 'CUST9900');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00038', '2026-09-29 12:39:00', 'Pune', 'UPI', 73793.03, 'Success', 'APR00038', 'CUST5905');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00039', '2026-09-23 09:56:00', 'Jaipur', 'Wallet', 10288.26, 'Success', 'APR00039', 'CUST5616');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00040', '2026-09-16 11:45:00', 'Mumbai', 'Wallet', 25880.30, 'Success', 'APR00040', 'CUST1832');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00041', '2026-07-12 18:27:00', 'Mumbai', 'IMPS', 62243.77, 'Success', 'APR00041', 'CUST5291');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00042', '2026-07-21 19:28:00', 'Jaipur', 'UPI', 41488.11, 'Success', '', 'CUST3442');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00043', '2026-09-08 08:53:00', 'Bengaluru', 'IMPS', 27848.89, 'Success', '', 'CUST6974');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00044', '2026-07-06 22:22:00', 'Jaipur', 'NEFT', 15953.22, 'Success', 'APR00044', 'CUST7658');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00045', '2026-09-18 19:09:00', 'Delhi', 'IMPS', 69450.85, 'Success', 'APR00045', 'CUST1406');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00046', '2026-07-23 19:59:00', 'Kolkata', 'IMPS', 25080.86, 'Failed', 'APR00046', 'CUST2771');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00047', '2026-08-18 21:02:00', 'Bengaluru', 'NEFT', 64429.85, 'Success', 'APR00047', 'CUST4728');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00048', '2026-07-29 08:42:00', 'Jaipur', 'NEFT', 14686.45, 'Success', 'APR00048', 'CUST9346');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00049', '2026-08-21 18:53:00', 'Jaipur', 'NEFT', 40332.13, 'Failed', 'APR00049', 'CUST5349');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00050', '2026-07-05 09:38:00', 'Mumbai', 'Card', 32733.64, 'Success', 'APR00050', 'CUST9379');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00051', '2026-07-15 14:57:00', 'Kolkata', 'Card', 43349.96, 'Success', '', 'CUST9821');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00052', '2026-09-26 19:47:00', 'Bengaluru', 'UPI', 55343.57, 'Success', 'APR00052', 'CUST6409');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00053', '2026-09-18 13:42:00', 'Mumbai', 'Wallet', 63639.14, 'Success', 'APR00053', 'CUST7691');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00054', '2026-08-11 14:44:00', 'Bengaluru', 'Card', 22350.23, 'Success', 'APR00054', 'CUST3851');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00055', '2026-09-17 17:19:00', 'Mumbai', 'NEFT', 30604.12, 'Success', 'APR00055', 'CUST6279');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00056', '2026-08-29 15:28:00', 'Kolkata', 'IMPS', 50753.14, 'Success', 'APR00056', 'CUST5649');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00057', '2026-09-04 18:40:00', 'Delhi', 'NEFT', 46539.75, 'Success', 'APR00057', 'CUST4262');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00058', '2026-07-19 08:02:00', 'Jaipur', 'Card', 18551.98, 'Success', 'APR00058', 'CUST4185');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00059', '2026-09-30 19:24:00', 'Kolkata', 'UPI', 37204.69, 'Success', 'APR00059', 'CUST2746');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00060', '2026-08-24 11:11:00', 'Bengaluru', 'UPI', 60357.21, 'Success', 'APR00060', 'CUST2988');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00061', '2026-08-28 10:51:00', 'Pune', 'Wallet', 34982.08, 'Success', 'APR00061', 'CUST8251');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00062', '2026-09-17 21:46:00', 'Pune', 'Card', 66928.52, 'Success', 'APR00062', 'CUST8777');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00063', '2026-08-27 12:48:00', 'Pune', 'Card', 18731.17, 'Success', 'APR00063', 'CUST5499');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00064', '2026-08-26 09:45:00', 'Mumbai', 'Wallet', 21608.18, 'Success', 'APR00064', 'CUST3471');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00065', '2026-07-30 14:44:00', 'Bengaluru', 'Card', 11672.19, 'Success', 'APR00065', 'CUST8633');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00066', '2026-08-23 08:13:00', 'Pune', 'UPI', 62508.61, 'Success', 'APR00066', 'CUST7232');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00067', '2026-08-31 08:22:00', 'Bengaluru', 'Wallet', 22571.30, 'Success', 'APR00067', 'CUST9947');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00068', '2026-09-16 22:14:00', 'Bengaluru', 'UPI', 36745.15, 'Success', 'APR00068', 'CUST7624');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00069', '2026-07-22 21:29:00', 'Pune', 'UPI', 68985.74, 'Pending', 'APR00069', 'CUST1444');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00070', '2026-07-11 18:27:00', 'Jaipur', 'NEFT', 10393.54, 'Success', 'APR00070', 'CUST4467');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00071', '2026-08-28 13:21:00', 'Bengaluru', 'NEFT', 57151.92, 'Success', 'APR00071', 'CUST8705');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00072', '2026-07-03 19:34:00', 'Delhi', 'UPI', 4143.40, 'Failed', 'APR00072', 'CUST1659');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00073', '2026-07-04 11:12:00', 'Delhi', 'IMPS', 62982.36, 'Success', 'APR00073', 'CUST2874');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00074', '2026-09-11 11:29:00', 'Delhi', 'Wallet', 52535.01, 'Success', 'APR00074', 'CUST2876');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00075', '2026-07-21 12:06:00', 'Pune', 'Card', 43506.68, 'Failed', 'APR00075', 'CUST4249');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00076', '2026-07-10 17:44:00', 'Kolkata', 'NEFT', 62335.23, 'Success', 'APR00076', 'CUST2983');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00077', '2026-09-11 20:02:00', 'Mumbai', 'UPI', 26203.48, 'Success', 'APR00077', 'CUST6590');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00078', '2026-07-02 21:26:00', 'Mumbai', 'Card', 61719.24, 'Success', 'APR00078', 'CUST8135');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00079', '2026-07-23 19:33:00', 'Pune', 'Card', 72419.16, 'Success', 'APR00079', 'CUST5397');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00080', '2026-08-11 21:15:00', 'Bengaluru', 'IMPS', 62347.14, 'Success', 'APR00080', 'CUST7209');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00081', '2026-08-13 08:31:00', 'Delhi', 'NEFT', 63858.72, 'Success', 'APR00081', 'CUST6576');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00082', '2026-08-05 22:38:00', 'Jaipur', 'Wallet', 52663.49, 'Success', 'APR00082', 'CUST2402');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00083', '2026-07-31 19:26:00', 'Kolkata', 'Card', 36771.19, 'Success', 'APR00083', 'CUST9041');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00084', '2026-08-27 20:01:00', 'Kolkata', 'IMPS', 7205.74, 'Success', 'APR00084', 'CUST7046');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00085', '2026-08-30 16:33:00', 'Pune', 'NEFT', 25945.87, 'Pending', 'APR00085', 'CUST8434');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00086', '2026-08-04 12:16:00', 'Mumbai', 'UPI', 17482.72, 'Success', 'APR00086', 'CUST4033');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00087', '2026-07-25 11:47:00', 'Pune', 'Wallet', 36443.84, 'Success', 'APR00087', 'CUST2647');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00088', '2026-07-25 12:14:00', 'Kolkata', 'Wallet', 27225.86, 'Success', 'APR00088', 'CUST1745');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00089', '2026-07-07 16:18:00', 'Bengaluru', 'UPI', 52381.95, 'Success', 'APR00089', 'CUST5658');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00090', '2026-08-30 15:28:00', 'Mumbai', 'Card', 25717.77, 'Failed', 'APR00090', 'CUST2070');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00091', '2026-08-21 15:04:00', 'Delhi', 'IMPS', 43382.33, 'Success', 'APR00091', 'CUST5978');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00092', '2026-07-11 11:07:00', 'Pune', 'Wallet', 41965.96, 'Success', 'APR00092', 'CUST9561');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00093', '2026-08-18 15:58:00', 'Bengaluru', 'NEFT', 33343.40, 'Success', 'APR00093', 'CUST1986');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00094', '2026-09-17 19:06:00', 'Delhi', 'NEFT', 71082.37, 'Success', 'APR00094', 'CUST3573');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00095', '2026-07-31 10:35:00', 'Bengaluru', 'Wallet', 5861.10, 'Success', 'APR00095', 'CUST1534');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00096', '2026-07-30 12:45:00', 'Jaipur', 'IMPS', 21383.20, 'Success', 'APR00096', 'CUST4241');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00097', '2026-08-24 09:34:00', 'Mumbai', 'IMPS', 17054.51, 'Success', '', 'CUST3718');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00098', '2026-08-09 17:47:00', 'Bengaluru', 'UPI', 61861.96, 'Failed', 'APR00098', 'CUST5982');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00099', '2026-09-28 14:17:00', 'Jaipur', 'Wallet', 37660.30, 'Success', '', 'CUST8078');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00100', '2026-08-11 17:16:00', 'Kolkata', 'Wallet', 2183.40, 'Success', 'APR00100', 'CUST1339');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00101', '2026-09-25 21:17:00', 'Delhi', 'Card', 43324.46, 'Success', 'APR00101', 'CUST8245');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00102', '2026-08-05 10:37:00', 'Jaipur', 'Card', 32832.40, 'Success', 'APR00102', 'CUST6460');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00103', '2026-08-11 18:06:00', 'Kolkata', 'Card', 64365.55, 'Success', 'APR00103', 'CUST7561');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00104', '2026-09-09 08:29:00', 'Jaipur', 'Card', 6832.47, 'Success', 'APR00104', 'CUST1018');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00105', '2026-09-23 21:34:00', 'Pune', 'NEFT', 34782.73, 'Success', 'APR00105', 'CUST9167');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00106', '2026-09-19 15:48:00', 'Delhi', 'NEFT', 4107.98, 'Success', 'APR00106', 'CUST8941');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00107', '2026-07-16 08:40:00', 'Delhi', 'NEFT', 45763.16, 'Success', 'APR00107', 'CUST7684');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00108', '2026-07-12 11:53:00', 'Jaipur', 'IMPS', 68491.51, 'Success', 'APR00108', 'CUST5781');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00109', '2026-09-04 19:17:00', 'Bengaluru', 'IMPS', 31307.90, 'Success', 'APR00109', 'CUST3369');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00110', '2026-08-19 11:58:00', 'Delhi', 'UPI', 45053.48, 'Success', 'APR00110', 'CUST7798');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00111', '2026-08-13 22:50:00', 'Mumbai', 'NEFT', 38203.39, 'Success', 'APR00111', 'CUST9022');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00112', '2026-07-20 15:34:00', 'Pune', 'Card', 36454.52, 'Success', 'APR00112', 'CUST6272');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00113', '2026-07-25 19:15:00', 'Bengaluru', 'UPI', 42991.87, 'Success', 'APR00113', 'CUST8749');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00114', '2026-09-29 22:51:00', 'Kolkata', 'IMPS', 28747.03, 'Pending', 'APR00114', 'CUST1606');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00115', '2026-07-17 16:37:00', 'Bengaluru', 'UPI', 25066.60, 'Success', 'APR00115', 'CUST8486');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00116', '2026-07-02 19:09:00', 'Delhi', 'UPI', 30895.90, 'Success', 'APR00116', 'CUST5342');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00117', '2026-08-13 17:44:00', 'Mumbai', 'Wallet', 29961.88, 'Success', 'APR00117', 'CUST6188');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00118', '2026-09-19 19:56:00', 'Jaipur', 'Wallet', 57015.29, 'Success', '', 'CUST5708');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00119', '2026-07-30 19:05:00', 'Kolkata', 'UPI', 32689.37, 'Success', 'APR00119', 'CUST5906');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00120', '2026-07-04 08:20:00', 'Mumbai', 'Card', 59761.72, 'Success', 'APR00120', 'CUST9702');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00121', '2026-08-22 17:43:00', 'Jaipur', 'Wallet', 59490.83, 'Success', 'APR00121', 'CUST4945');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00122', '2026-09-02 22:37:00', 'Mumbai', 'Card', 10948.05, 'Success', 'APR00122', 'CUST1153');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00123', '2026-08-29 22:18:00', 'Bengaluru', 'NEFT', 50901.41, 'Success', 'APR00123', 'CUST5901');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00124', '2026-09-20 14:44:00', 'Delhi', 'Card', 18944.84, 'Success', 'APR00124', 'CUST2747');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00125', '2026-07-31 14:36:00', 'Kolkata', 'NEFT', 27082.20, 'Success', '', 'CUST7484');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00126', '2026-08-05 08:36:00', 'Jaipur', 'Wallet', 64913.79, 'Success', 'APR00126', 'CUST5689');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00127', '2026-07-30 17:51:00', 'Pune', 'NEFT', 26585.99, 'Success', 'APR00127', 'CUST3240');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00128', '2026-09-19 09:57:00', 'Bengaluru', 'UPI', 47152.49, 'Success', 'APR00128', 'CUST3153');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00129', '2026-07-12 22:18:00', 'Delhi', 'IMPS', 24672.25, 'Success', 'APR00129', 'CUST6994');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00130', '2026-09-06 16:58:00', 'Bengaluru', 'NEFT', 20621.42, 'Success', 'APR00130', 'CUST6549');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00131', '2026-07-15 15:04:00', 'Kolkata', 'Card', 10771.59, 'Failed', 'APR00131', 'CUST6992');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00132', '2026-07-12 20:25:00', 'Bengaluru', 'NEFT', 1290.42, 'Success', 'APR00132', 'CUST5295');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00133', '2026-09-13 14:52:00', 'Kolkata', 'IMPS', 47981.56, 'Success', 'APR00133', 'CUST6374');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00134', '2026-09-17 11:41:00', 'Kolkata', 'NEFT', 4975.47, 'Success', 'APR00134', 'CUST2911');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00135', '2026-07-18 08:02:00', 'Jaipur', 'IMPS', 23001.25, 'Success', 'APR00135', 'CUST3222');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00136', '2026-08-19 15:23:00', 'Pune', 'Card', 50368.84, 'Success', 'APR00136', 'CUST3531');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00137', '2026-08-23 18:06:00', 'Mumbai', 'UPI', 62568.56, 'Success', 'APR00137', 'CUST4559');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00138', '2026-08-26 15:15:00', 'Kolkata', 'NEFT', 64194.90, 'Success', 'APR00138', 'CUST6876');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00139', '2026-07-08 14:17:00', 'Bengaluru', 'UPI', 14438.19, 'Success', 'APR00139', 'CUST1349');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00140', '2026-07-07 20:21:00', 'Pune', 'IMPS', 18456.78, 'Success', '', 'CUST4394');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00141', '2026-09-14 11:52:00', 'Delhi', 'Wallet', 65259.73, 'Success', '', 'CUST3370');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00142', '2026-07-17 16:16:00', 'Jaipur', 'IMPS', 59938.91, 'Success', '', 'CUST4898');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00143', '2026-09-14 13:01:00', 'Kolkata', 'Card', 13274.90, 'Success', 'APR00143', 'CUST2041');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00144', '2026-08-30 15:49:00', 'Bengaluru', 'Wallet', 27312.41, 'Success', 'APR00144', 'CUST1710');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00145', '2026-09-23 16:19:00', 'Jaipur', 'Card', 34488.68, 'Failed', 'APR00145', 'CUST7984');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00146', '2026-09-26 09:31:00', 'Jaipur', 'NEFT', 53502.00, 'Success', 'APR00146', 'CUST2076');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00147', '2026-07-17 12:39:00', 'Mumbai', 'Card', 47572.49, 'Success', 'APR00147', 'CUST9692');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00148', '2026-08-07 15:32:00', 'Kolkata', 'UPI', 45505.65, 'Success', 'APR00148', 'CUST4522');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00149', '2026-08-25 15:56:00', 'Bengaluru', 'Card', 17329.89, 'Success', 'APR00149', 'CUST2557');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00150', '2026-08-10 14:20:00', 'Delhi', 'Card', 49966.81, 'Success', '', 'CUST2398');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00151', '2026-07-12 14:06:00', 'Delhi', 'Wallet', 55908.03, 'Success', '', 'CUST6400');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00152', '2026-09-24 09:26:00', 'Bengaluru', 'UPI', 26681.46, 'Success', 'APR00152', 'CUST6119');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00153', '2026-08-15 09:36:00', 'Bengaluru', 'IMPS', 38179.09, 'Success', 'APR00153', 'CUST6736');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00154', '2026-09-10 13:07:00', 'Bengaluru', 'Wallet', 57254.77, 'Success', 'APR00154', 'CUST1430');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00155', '2026-09-16 22:42:00', 'Delhi', 'NEFT', 62252.19, 'Success', 'APR00155', 'CUST6062');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00156', '2026-08-13 13:00:00', 'Kolkata', 'Card', 13810.07, 'Success', '', 'CUST1502');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00157', '2026-07-12 19:33:00', 'Mumbai', 'IMPS', 16331.18, 'Success', 'APR00157', 'CUST6314');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00158', '2026-09-11 17:05:00', 'Pune', 'UPI', 66279.83, 'Success', 'APR00158', 'CUST5458');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00159', '2026-08-26 18:27:00', 'Mumbai', 'IMPS', 36553.21, 'Success', 'APR00159', 'CUST2864');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00160', '2026-08-14 14:07:00', 'Bengaluru', 'Wallet', 21422.67, 'Success', 'APR00160', 'CUST1744');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00161', '2026-07-29 14:38:00', 'Delhi', 'IMPS', 4344.95, 'Success', 'APR00161', 'CUST5742');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00162', '2026-08-11 09:00:00', 'Delhi', 'Card', 37429.55, 'Success', 'APR00162', 'CUST4770');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00163', '2026-09-03 16:53:00', 'Bengaluru', 'UPI', 50186.60, 'Success', 'APR00163', 'CUST8532');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00164', '2026-07-10 21:20:00', 'Kolkata', 'Card', 43288.00, 'Success', 'APR00164', 'CUST7636');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00165', '2026-07-03 13:10:00', 'Kolkata', 'NEFT', 60148.83, 'Success', 'APR00165', 'CUST2734');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00166', '2026-08-01 14:37:00', 'Mumbai', 'NEFT', 30183.62, 'Success', 'APR00166', 'CUST3754');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00167', '2026-07-10 16:40:00', 'Mumbai', 'NEFT', 8773.49, 'Success', 'APR00167', 'CUST3419');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00168', '2026-07-31 09:09:00', 'Delhi', 'UPI', 19383.62, 'Success', 'APR00168', 'CUST9095');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00169', '2026-08-29 20:36:00', 'Pune', 'Wallet', 57050.82, 'Success', 'APR00169', 'CUST6179');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00170', '2026-07-20 15:04:00', 'Mumbai', 'Wallet', 35301.85, 'Success', '', 'CUST9312');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00171', '2026-07-10 12:29:00', 'Mumbai', 'UPI', 34030.56, 'Success', 'APR00171', 'CUST2479');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00172', '2026-09-17 17:32:00', 'Kolkata', 'UPI', 28990.07, 'Success', 'APR00172', 'CUST4084');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00173', '2026-08-11 17:30:00', 'Bengaluru', 'UPI', 37727.21, 'Failed', 'APR00173', 'CUST6626');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00174', '2026-09-30 09:32:00', 'Kolkata', 'Card', 48548.00, 'Success', 'APR00174', 'CUST9586');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00175', '2026-09-05 17:10:00', 'Bengaluru', 'Card', 27451.37, 'Failed', 'APR00175', 'CUST1857');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00176', '2026-09-19 18:21:00', 'Kolkata', 'Card', 5176.91, 'Success', 'APR00176', 'CUST3463');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00177', '2026-08-12 09:37:00', 'Mumbai', 'Card', 49855.00, 'Failed', 'APR00177', 'CUST2388');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00178', '2026-08-09 16:24:00', 'Delhi', 'Wallet', 48351.12, 'Success', 'APR00178', 'CUST7937');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00179', '2026-09-04 13:01:00', 'Delhi', 'NEFT', 27354.18, 'Success', 'APR00179', 'CUST8967');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00180', '2026-07-25 11:08:00', 'Jaipur', 'Wallet', 11832.15, 'Success', 'APR00180', 'CUST9626');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00181', '2026-07-05 18:21:00', 'Pune', 'Card', 65760.36, 'Success', 'APR00181', 'CUST3962');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00182', '2026-09-27 20:39:00', 'Bengaluru', 'UPI', 60726.02, 'Success', 'APR00182', 'CUST4891');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00183', '2026-08-26 17:18:00', 'Delhi', 'Wallet', 56491.24, 'Success', 'APR00183', 'CUST8684');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00184', '2026-07-25 13:43:00', 'Bengaluru', 'NEFT', 71047.98, 'Pending', 'APR00184', 'CUST9239');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00185', '2026-09-06 14:10:00', 'Delhi', 'NEFT', 61312.62, 'Success', '', 'CUST8873');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00186', '2026-08-17 16:59:00', 'Jaipur', 'NEFT', 7918.58, 'Success', 'APR00186', 'CUST3626');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00187', '2026-08-04 15:57:00', 'Jaipur', 'IMPS', 38623.12, 'Success', 'APR00187', 'CUST6727');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00188', '2026-07-04 14:03:00', 'Bengaluru', 'UPI', 29884.93, 'Success', 'APR00188', 'CUST1461');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00189', '2026-08-10 22:06:00', 'Delhi', 'IMPS', 62978.43, 'Success', '', 'CUST8740');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00190', '2026-09-28 21:08:00', 'Pune', 'UPI', 56973.38, 'Success', 'APR00190', 'CUST1311');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00191', '2026-08-02 11:53:00', 'Pune', 'Wallet', 11426.59, 'Failed', 'APR00191', 'CUST5720');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00192', '2026-07-31 12:07:00', 'Pune', 'Card', 3819.27, 'Success', '', 'CUST9189');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00193', '2026-09-15 16:01:00', 'Kolkata', 'IMPS', 47488.63, 'Success', 'APR00193', 'CUST1025');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00194', '2026-09-17 13:15:00', 'Kolkata', 'UPI', 42907.11, 'Success', 'APR00194', 'CUST6908');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00195', '2026-07-09 16:34:00', 'Pune', 'UPI', 38172.75, 'Pending', 'APR00195', 'CUST8702');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00196', '2026-07-06 18:24:00', 'Jaipur', 'NEFT', 73582.70, 'Success', 'APR00196', 'CUST6649');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00197', '2026-07-31 19:42:00', 'Kolkata', 'NEFT', 47212.21, 'Success', 'APR00197', 'CUST6772');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00198', '2026-09-08 13:52:00', 'Kolkata', 'Card', 48298.97, 'Success', 'APR00198', 'CUST8840');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00199', '2026-09-19 10:51:00', 'Bengaluru', 'UPI', 10330.23, 'Success', 'APR00199', 'CUST1717');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00200', '2026-07-26 22:02:00', 'Bengaluru', 'Wallet', 23840.79, 'Success', 'APR00200', 'CUST1599');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00201', '2026-09-21 11:18:00', 'Kolkata', 'NEFT', 26933.82, 'Success', 'APR00201', 'CUST7029');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00202', '2026-08-25 22:25:00', 'Bengaluru', 'NEFT', 55812.25, 'Failed', 'APR00202', 'CUST9129');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00203', '2026-09-27 15:23:00', 'Jaipur', 'Card', 69342.21, 'Success', '', 'CUST3956');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00204', '2026-09-08 12:20:00', 'Mumbai', 'NEFT', 7919.19, 'Success', 'APR00204', 'CUST7981');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00205', '2026-07-22 19:28:00', 'Mumbai', 'Wallet', 26528.14, 'Success', 'APR00205', 'CUST5498');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00206', '2026-09-20 20:03:00', 'Mumbai', 'Wallet', 5859.33, 'Success', 'APR00206', 'CUST3621');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00207', '2026-07-04 10:54:00', 'Jaipur', 'IMPS', 45666.07, 'Success', '', 'CUST7001');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00208', '2026-08-16 14:36:00', 'Bengaluru', 'NEFT', 2670.80, 'Success', 'APR00208', 'CUST2259');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00209', '2026-09-12 10:33:00', 'Mumbai', 'IMPS', 27679.51, 'Success', 'APR00209', 'CUST1424');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00210', '2026-07-24 15:33:00', 'Mumbai', 'NEFT', 29177.31, 'Success', 'APR00210', 'CUST4515');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00211', '2026-09-17 12:44:00', 'Jaipur', 'IMPS', 68756.80, 'Success', 'APR00211', 'CUST8406');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00212', '2026-07-23 22:45:00', 'Kolkata', 'NEFT', 33522.06, 'Success', 'APR00212', 'CUST2063');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00213', '2026-09-09 16:18:00', 'Kolkata', 'IMPS', 66877.04, 'Success', 'APR00213', 'CUST9335');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00214', '2026-07-29 09:12:00', 'Bengaluru', 'UPI', 59456.91, 'Success', 'APR00214', 'CUST7044');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00215', '2026-08-29 20:35:00', 'Jaipur', 'NEFT', 9950.40, 'Failed', 'APR00215', 'CUST8842');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00216', '2026-09-06 14:49:00', 'Delhi', 'NEFT', 30855.16, 'Success', 'APR00216', 'CUST8372');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00217', '2026-08-29 18:33:00', 'Pune', 'Wallet', 26002.48, 'Success', 'APR00217', 'CUST3114');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00218', '2026-08-25 16:58:00', 'Pune', 'IMPS', 65148.82, 'Success', 'APR00218', 'CUST3653');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00219', '2026-08-11 22:45:00', 'Pune', 'NEFT', 17103.90, 'Failed', 'APR00219', 'CUST5105');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00220', '2026-07-26 18:35:00', 'Pune', 'Wallet', 20765.21, 'Success', 'APR00220', 'CUST3762');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00221', '2026-09-14 17:09:00', 'Pune', 'NEFT', 13047.25, 'Success', 'APR00221', 'CUST1674');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00222', '2026-07-04 09:02:00', 'Mumbai', 'IMPS', 71153.88, 'Success', 'APR00222', 'CUST7825');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00223', '2026-09-18 18:01:00', 'Mumbai', 'NEFT', 37478.34, 'Success', 'APR00223', 'CUST7653');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00224', '2026-08-08 15:04:00', 'Bengaluru', 'Card', 51723.86, 'Success', 'APR00224', 'CUST6573');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00225', '2026-09-16 10:20:00', 'Mumbai', 'Card', 64646.01, 'Success', 'APR00225', 'CUST7070');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00226', '2026-09-04 16:06:00', 'Mumbai', 'Card', 24103.91, 'Success', 'APR00226', 'CUST2586');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00227', '2026-07-07 12:24:00', 'Delhi', 'NEFT', 64846.25, 'Success', 'APR00227', 'CUST6123');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00228', '2026-07-25 20:10:00', 'Bengaluru', 'NEFT', 37495.35, 'Success', 'APR00228', 'CUST2475');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00229', '2026-08-20 16:29:00', 'Mumbai', 'UPI', 72509.83, 'Success', '', 'CUST9108');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00230', '2026-09-15 22:53:00', 'Pune', 'UPI', 49155.94, 'Success', 'APR00230', 'CUST8060');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00231', '2026-07-18 22:16:00', 'Mumbai', 'UPI', 54631.23, 'Success', 'APR00231', 'CUST4189');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00232', '2026-08-16 16:18:00', 'Pune', 'NEFT', 5746.50, 'Success', 'APR00232', 'CUST2946');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00233', '2026-07-17 09:25:00', 'Pune', 'NEFT', 28146.58, 'Pending', 'APR00233', 'CUST4261');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00234', '2026-09-16 16:25:00', 'Delhi', 'NEFT', 37630.82, 'Success', 'APR00234', 'CUST9508');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00235', '2026-08-28 10:38:00', 'Pune', 'NEFT', 67011.59, 'Success', 'APR00235', 'CUST5902');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00236', '2026-09-14 13:32:00', 'Kolkata', 'Wallet', 62164.63, 'Success', 'APR00236', 'CUST1272');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00237', '2026-08-17 13:43:00', 'Mumbai', 'UPI', 8442.94, 'Success', 'APR00237', 'CUST5350');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00238', '2026-09-22 20:49:00', 'Jaipur', 'Wallet', 43490.96, 'Success', 'APR00238', 'CUST9589');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00239', '2026-09-19 19:39:00', 'Kolkata', 'IMPS', 58151.81, 'Success', '', 'CUST2800');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00240', '2026-07-25 08:28:00', 'Kolkata', 'IMPS', 23698.51, 'Success', 'APR00240', 'CUST8726');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00241', '2026-07-08 19:08:00', 'Kolkata', 'Card', 39021.57, 'Success', 'APR00241', 'CUST6140');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00242', '2026-07-23 15:58:00', 'Kolkata', 'NEFT', 40101.25, 'Success', 'APR00242', 'CUST4150');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00243', '2026-08-01 12:35:00', 'Mumbai', 'NEFT', 22562.81, 'Failed', 'APR00243', 'CUST9011');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00244', '2026-08-10 15:22:00', 'Kolkata', 'NEFT', 42146.45, 'Failed', 'APR00244', 'CUST9899');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00245', '2026-08-18 22:25:00', 'Delhi', 'NEFT', 61423.72, 'Failed', '', 'CUST2294');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00246', '2026-08-14 22:28:00', 'Delhi', 'IMPS', 49283.91, 'Success', 'APR00246', 'CUST5442');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00247', '2026-09-10 19:17:00', 'Pune', 'IMPS', 10511.15, 'Success', 'APR00247', 'CUST9700');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00248', '2026-07-29 18:14:00', 'Kolkata', 'Card', 4173.71, 'Success', 'APR00248', 'CUST3252');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00249', '2026-07-01 16:59:00', 'Bengaluru', 'Card', 12056.10, 'Success', 'APR00249', 'CUST5706');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00250', '2026-08-11 12:41:00', 'Kolkata', 'Wallet', 4672.40, 'Success', 'APR00250', 'CUST1611');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00251', '2026-07-23 14:56:00', 'Jaipur', 'Card', 62860.97, 'Failed', 'APR00251', 'CUST4052');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00252', '2026-08-07 22:02:00', 'Jaipur', 'NEFT', 942.72, 'Success', 'APR00252', 'CUST9901');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00253', '2026-09-06 15:56:00', 'Bengaluru', 'NEFT', 70407.40, 'Success', 'APR00253', 'CUST2845');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00254', '2026-08-12 10:46:00', 'Delhi', 'UPI', 34553.86, 'Success', 'APR00254', 'CUST5833');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00255', '2026-09-11 18:48:00', 'Kolkata', 'Card', 14688.81, 'Success', 'APR00255', 'CUST9442');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00256', '2026-08-11 09:25:00', 'Delhi', 'Card', 50276.88, 'Success', 'APR00256', 'CUST5064');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00257', '2026-07-01 12:24:00', 'Mumbai', 'NEFT', 17855.21, 'Success', 'APR00257', 'CUST1187');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00258', '2026-08-03 18:23:00', 'Jaipur', 'Card', 52034.45, 'Success', 'APR00258', 'CUST7642');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00259', '2026-09-26 16:59:00', 'Mumbai', 'UPI', 67160.10, 'Success', 'APR00259', 'CUST5833');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00260', '2026-08-17 17:14:00', 'Delhi', 'Card', 16629.86, 'Success', 'APR00260', 'CUST7121');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00261', '2026-08-23 19:35:00', 'Kolkata', 'IMPS', 68481.57, 'Success', 'APR00261', 'CUST2341');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00262', '2026-09-06 15:33:00', 'Pune', 'UPI', 52856.52, 'Success', '', 'CUST9972');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00263', '2026-09-03 11:36:00', 'Pune', 'Card', 40365.35, 'Success', 'APR00263', 'CUST4365');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00264', '2026-09-30 17:31:00', 'Jaipur', 'Card', 7047.89, 'Success', 'APR00264', 'CUST7806');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00265', '2026-08-28 17:03:00', 'Mumbai', 'UPI', 42020.09, 'Success', 'APR00265', 'CUST1049');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00266', '2026-07-28 17:04:00', 'Jaipur', 'Wallet', 3635.41, 'Success', 'APR00266', 'CUST2130');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00267', '2026-08-30 08:18:00', 'Kolkata', 'Card', 30812.80, 'Success', 'APR00267', 'CUST7266');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00268', '2026-08-27 21:58:00', 'Kolkata', 'Wallet', 68030.86, 'Success', 'APR00268', 'CUST6697');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00269', '2026-07-16 10:34:00', 'Delhi', 'UPI', 29631.13, 'Success', 'APR00269', 'CUST5888');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00270', '2026-08-29 18:46:00', 'Delhi', 'IMPS', 40947.29, 'Success', 'APR00270', 'CUST3541');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00271', '2026-08-05 11:59:00', 'Jaipur', 'Card', 65671.81, 'Success', 'APR00271', 'CUST1256');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00272', '2026-07-31 11:04:00', 'Pune', 'UPI', 7792.03, 'Success', 'APR00272', 'CUST1724');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00273', '2026-08-21 15:14:00', 'Jaipur', 'IMPS', 40597.05, 'Success', 'APR00273', 'CUST5739');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00274', '2026-07-30 21:58:00', 'Pune', 'NEFT', 54930.93, 'Success', 'APR00274', 'CUST3347');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00275', '2026-09-23 16:14:00', 'Pune', 'Wallet', 31163.63, 'Success', 'APR00275', 'CUST3869');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00276', '2026-09-19 18:27:00', 'Mumbai', 'Card', 41799.84, 'Success', 'APR00276', 'CUST6222');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00277', '2026-09-28 14:26:00', 'Pune', 'Card', 11404.02, 'Success', 'APR00277', 'CUST4692');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00278', '2026-08-08 21:45:00', 'Jaipur', 'Wallet', 11040.29, 'Success', 'APR00278', 'CUST7824');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00279', '2026-09-10 16:08:00', 'Mumbai', 'UPI', 29284.32, 'Success', 'APR00279', 'CUST7079');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00280', '2026-07-12 16:46:00', 'Bengaluru', 'Wallet', 62248.12, 'Success', 'APR00280', 'CUST2192');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00281', '2026-07-25 20:48:00', 'Delhi', 'Card', 44171.88, 'Success', 'APR00281', 'CUST6455');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00282', '2026-08-08 22:00:00', 'Kolkata', 'UPI', 16082.63, 'Success', 'APR00282', 'CUST8846');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00283', '2026-08-01 19:38:00', 'Delhi', 'Wallet', 52856.70, 'Success', 'APR00283', 'CUST5637');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00284', '2026-08-18 15:34:00', 'Mumbai', 'Wallet', 48741.92, 'Success', 'APR00284', 'CUST8635');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00285', '2026-07-13 20:46:00', 'Delhi', 'NEFT', 35344.41, 'Success', 'APR00285', 'CUST1749');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00286', '2026-09-11 21:14:00', 'Pune', 'Wallet', 55658.62, 'Success', 'APR00286', 'CUST7841');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00287', '2026-08-07 10:12:00', 'Delhi', 'Card', 24907.43, 'Success', 'APR00287', 'CUST6530');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00288', '2026-08-02 20:52:00', 'Kolkata', 'Card', 36774.43, 'Success', 'APR00288', 'CUST6770');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00289', '2026-07-22 10:46:00', 'Pune', 'UPI', 41104.34, 'Success', 'APR00289', 'CUST2217');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00290', '2026-09-24 08:48:00', 'Kolkata', 'IMPS', 727.19, 'Success', '', 'CUST3474');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00291', '2026-07-02 11:32:00', 'Kolkata', 'Wallet', 34336.72, 'Success', 'APR00291', 'CUST8993');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00292', '2026-07-03 08:34:00', 'Pune', 'NEFT', 41485.36, 'Success', 'APR00292', 'CUST5697');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00293', '2026-07-03 16:52:00', 'Delhi', 'UPI', 52414.97, 'Success', 'APR00293', 'CUST9591');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00294', '2026-07-20 11:12:00', 'Mumbai', 'NEFT', 46578.62, 'Success', 'APR00294', 'CUST2294');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00295', '2026-08-17 14:29:00', 'Delhi', 'NEFT', 42483.91, 'Pending', 'APR00295', 'CUST2320');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00296', '2026-09-22 21:41:00', 'Bengaluru', 'Card', 57029.04, 'Success', 'APR00296', 'CUST1919');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00297', '2026-09-20 08:44:00', 'Bengaluru', 'NEFT', 13060.92, 'Success', 'APR00297', 'CUST2562');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00298', '2026-09-06 22:02:00', 'Kolkata', 'Wallet', 17425.05, 'Failed', 'APR00298', 'CUST1762');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00299', '2026-07-10 18:59:00', 'Kolkata', 'UPI', 21207.88, 'Success', 'APR00299', 'CUST6152');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00300', '2026-07-03 11:37:00', 'Bengaluru', 'UPI', 11028.32, 'Success', 'APR00300', 'CUST4939');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00301', '2026-09-11 21:54:00', 'Mumbai', 'Card', 29339.46, 'Failed', 'APR00301', 'CUST3292');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00302', '2026-09-27 19:05:00', 'Jaipur', 'UPI', 37684.27, 'Pending', 'APR00302', 'CUST2245');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00303', '2026-08-13 17:49:00', 'Mumbai', 'UPI', 46136.43, 'Success', 'APR00303', 'CUST8381');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00304', '2026-09-01 11:22:00', 'Delhi', 'Wallet', 41589.57, 'Success', 'APR00304', 'CUST2404');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00305', '2026-09-18 12:51:00', 'Mumbai', 'IMPS', 18672.12, 'Success', 'APR00305', 'CUST3527');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00306', '2026-08-19 13:23:00', 'Mumbai', 'Card', 8214.68, 'Success', 'APR00306', 'CUST5419');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00307', '2026-07-14 10:05:00', 'Pune', 'Wallet', 14257.54, 'Success', 'APR00307', 'CUST1430');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00308', '2026-07-12 13:35:00', 'Mumbai', 'Card', 7206.55, 'Success', '', 'CUST7779');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00309', '2026-08-19 20:05:00', 'Delhi', 'Wallet', 54432.08, 'Success', 'APR00309', 'CUST7237');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00310', '2026-07-22 10:17:00', 'Jaipur', 'IMPS', 22759.56, 'Success', 'APR00310', 'CUST7899');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00311', '2026-08-08 15:50:00', 'Delhi', 'Card', 5999.87, 'Success', 'APR00311', 'CUST4203');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00312', '2026-08-28 09:08:00', 'Mumbai', 'Wallet', 23023.19, 'Failed', 'APR00312', 'CUST6399');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00313', '2026-08-26 13:27:00', 'Pune', 'IMPS', 61206.79, 'Success', 'APR00313', 'CUST4290');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00314', '2026-08-31 13:11:00', 'Mumbai', 'Card', 72351.95, 'Failed', 'APR00314', 'CUST4971');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00315', '2026-08-11 14:17:00', 'Jaipur', 'Wallet', 61282.97, 'Success', 'APR00315', 'CUST9939');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00316', '2026-07-24 18:49:00', 'Bengaluru', 'IMPS', 41369.91, 'Failed', 'APR00316', 'CUST5773');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00317', '2026-09-27 09:52:00', 'Kolkata', 'Card', 63622.15, 'Success', 'APR00317', 'CUST5961');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00318', '2026-07-31 12:42:00', 'Bengaluru', 'UPI', 11772.21, 'Success', 'APR00318', 'CUST8851');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00319', '2026-09-13 14:34:00', 'Kolkata', 'Card', 38119.30, 'Failed', 'APR00319', 'CUST6890');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00320', '2026-09-28 22:51:00', 'Jaipur', 'UPI', 40383.72, 'Success', 'APR00320', 'CUST6816');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00321', '2026-07-22 18:39:00', 'Kolkata', 'Card', 3561.18, 'Pending', 'APR00321', 'CUST6432');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00322', '2026-08-25 09:00:00', 'Kolkata', 'Wallet', 7620.84, 'Success', 'APR00322', 'CUST4621');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00323', '2026-08-27 13:25:00', 'Kolkata', 'Wallet', 34863.97, 'Success', 'APR00323', 'CUST1402');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00324', '2026-08-31 09:18:00', 'Jaipur', 'IMPS', 31344.16, 'Failed', 'APR00324', 'CUST6620');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00325', '2026-08-28 20:13:00', 'Jaipur', 'Card', 39203.33, 'Success', 'APR00325', 'CUST8412');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00326', '2026-08-10 09:19:00', 'Jaipur', 'NEFT', 3590.06, 'Success', 'APR00326', 'CUST3692');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00327', '2026-08-01 16:11:00', 'Bengaluru', 'Card', 41505.29, 'Success', 'APR00327', 'CUST7636');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00328', '2026-09-19 10:11:00', 'Jaipur', 'Wallet', 48125.80, 'Success', 'APR00328', 'CUST8365');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00329', '2026-09-14 14:24:00', 'Mumbai', 'UPI', 582.64, 'Success', 'APR00329', 'CUST9796');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00330', '2026-07-24 13:20:00', 'Kolkata', 'Card', 14981.30, 'Success', 'APR00330', 'CUST6134');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00331', '2026-09-15 14:39:00', 'Mumbai', 'Card', 29592.66, 'Success', 'APR00331', 'CUST5873');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00332', '2026-09-17 17:05:00', 'Delhi', 'NEFT', 50490.23, 'Success', 'APR00332', 'CUST7116');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00333', '2026-09-27 10:32:00', 'Pune', 'Card', 29287.63, 'Success', 'APR00333', 'CUST8973');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00334', '2026-09-20 16:44:00', 'Delhi', 'Wallet', 68957.28, 'Failed', 'APR00334', 'CUST5732');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00335', '2026-07-18 10:20:00', 'Mumbai', 'UPI', 63188.39, 'Success', 'APR00335', 'CUST4196');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00336', '2026-08-19 16:32:00', 'Bengaluru', 'Card', 49066.96, 'Success', 'APR00336', 'CUST8272');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00337', '2026-09-01 10:05:00', 'Delhi', 'NEFT', 42513.49, 'Success', '', 'CUST4683');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00338', '2026-09-07 12:10:00', 'Bengaluru', 'Wallet', 58610.33, 'Success', 'APR00338', 'CUST2871');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00339', '2026-08-04 20:34:00', 'Jaipur', 'Card', 61790.39, 'Success', 'APR00339', 'CUST7965');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00340', '2026-07-14 19:53:00', 'Jaipur', 'Card', 49111.96, 'Success', 'APR00340', 'CUST2425');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00341', '2026-08-26 21:07:00', 'Kolkata', 'Wallet', 58228.47, 'Success', 'APR00341', 'CUST8015');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00342', '2026-07-22 17:08:00', 'Jaipur', 'Wallet', 58917.49, 'Success', 'APR00342', 'CUST5605');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00343', '2026-09-15 16:10:00', 'Mumbai', 'Wallet', 24443.11, 'Success', 'APR00343', 'CUST9428');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00344', '2026-09-25 21:06:00', 'Bengaluru', 'UPI', 10385.27, 'Success', 'APR00344', 'CUST3078');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00345', '2026-09-28 21:08:00', 'Delhi', 'Card', 18913.37, 'Success', 'APR00345', 'CUST5402');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00346', '2026-09-19 14:24:00', 'Jaipur', 'Card', 34036.38, 'Success', 'APR00346', 'CUST5558');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00347', '2026-09-27 22:56:00', 'Mumbai', 'Wallet', 27838.07, 'Failed', '', 'CUST2526');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00348', '2026-08-28 18:42:00', 'Pune', 'Card', 52372.35, 'Success', 'APR00348', 'CUST8039');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00349', '2026-07-28 15:17:00', 'Pune', 'Wallet', 24384.17, 'Success', 'APR00349', 'CUST8951');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00350', '2026-08-13 22:43:00', 'Kolkata', 'Card', 57228.49, 'Success', '', 'CUST3588');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00351', '2026-08-26 15:00:00', 'Kolkata', 'IMPS', 74389.91, 'Success', 'APR00351', 'CUST5945');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00352', '2026-07-21 21:59:00', 'Mumbai', 'NEFT', 65775.48, 'Success', 'APR00352', 'CUST3711');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00353', '2026-07-07 14:40:00', 'Delhi', 'Card', 23086.82, 'Success', 'APR00353', 'CUST2559');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00354', '2026-07-01 11:30:00', 'Pune', 'Card', 6075.92, 'Success', '', 'CUST6629');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00355', '2026-07-16 21:27:00', 'Delhi', 'Card', 52128.82, 'Success', 'APR00355', 'CUST2678');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00356', '2026-07-14 13:23:00', 'Delhi', 'IMPS', 66103.93, 'Success', '', 'CUST1138');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00357', '2026-09-17 18:10:00', 'Kolkata', 'IMPS', 33147.43, 'Success', 'APR00357', 'CUST8248');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00358', '2026-07-28 09:57:00', 'Pune', 'Card', 7759.77, 'Success', 'APR00358', 'CUST8035');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00359', '2026-08-10 20:08:00', 'Delhi', 'Wallet', 18772.03, 'Success', 'APR00359', 'CUST5668');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00360', '2026-09-27 08:54:00', 'Delhi', 'Wallet', 63568.48, 'Success', 'APR00360', 'CUST4090');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00361', '2026-08-20 12:41:00', 'Delhi', 'Card', 4329.04, 'Failed', 'APR00361', 'CUST4949');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00362', '2026-09-02 18:38:00', 'Jaipur', 'NEFT', 5558.15, 'Failed', 'APR00362', 'CUST3162');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00363', '2026-08-19 21:53:00', 'Kolkata', 'IMPS', 42736.43, 'Success', 'APR00363', 'CUST2195');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00364', '2026-07-03 17:04:00', 'Jaipur', 'Card', 1281.06, 'Success', 'APR00364', 'CUST9209');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00365', '2026-08-23 14:44:00', 'Pune', 'Wallet', 30320.24, 'Success', 'APR00365', 'CUST2369');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00366', '2026-08-09 09:32:00', 'Delhi', 'Wallet', 69089.13, 'Pending', 'APR00366', 'CUST2083');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00367', '2026-08-09 19:27:00', 'Jaipur', 'IMPS', 54814.39, 'Success', 'APR00367', 'CUST8118');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00368', '2026-07-15 15:39:00', 'Kolkata', 'IMPS', 45760.22, 'Success', 'APR00368', 'CUST3248');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00369', '2026-09-28 08:10:00', 'Pune', 'NEFT', 37356.87, 'Success', 'APR00369', 'CUST3079');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00370', '2026-08-04 19:56:00', 'Mumbai', 'Card', 9074.74, 'Failed', 'APR00370', 'CUST2046');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00371', '2026-08-03 19:36:00', 'Pune', 'NEFT', 47158.08, 'Success', '', 'CUST3734');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00372', '2026-08-17 10:16:00', 'Kolkata', 'UPI', 58056.34, 'Failed', 'APR00372', 'CUST9336');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00373', '2026-07-01 08:54:00', 'Bengaluru', 'NEFT', 64753.90, 'Success', 'APR00373', 'CUST3458');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00374', '2026-07-23 22:54:00', 'Kolkata', 'Card', 2893.43, 'Success', 'APR00374', 'CUST5067');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00375', '2026-08-23 22:46:00', 'Pune', 'NEFT', 24165.15, 'Success', 'APR00375', 'CUST1862');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00376', '2026-07-23 11:51:00', 'Bengaluru', 'UPI', 38804.12, 'Success', 'APR00376', 'CUST5625');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00377', '2026-08-09 13:05:00', 'Delhi', 'NEFT', 41593.58, 'Success', 'APR00377', 'CUST5979');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00378', '2026-09-18 11:29:00', 'Delhi', 'Wallet', 27778.45, 'Pending', 'APR00378', 'CUST5016');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00379', '2026-07-20 08:59:00', 'Mumbai', 'UPI', 30900.20, 'Success', 'APR00379', 'CUST1023');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00380', '2026-09-23 14:54:00', 'Delhi', 'Wallet', 55421.68, 'Success', 'APR00380', 'CUST7878');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00381', '2026-09-01 08:09:00', 'Delhi', 'Wallet', 53446.02, 'Success', 'APR00381', 'CUST7102');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00382', '2026-08-28 19:05:00', 'Kolkata', 'Card', 43662.60, 'Success', '', 'CUST2020');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00383', '2026-08-25 18:08:00', 'Mumbai', 'Card', 17948.69, 'Success', 'APR00383', 'CUST6345');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00384', '2026-08-10 15:17:00', 'Delhi', 'Wallet', 17712.44, 'Failed', 'APR00384', 'CUST2731');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00385', '2026-07-22 15:29:00', 'Mumbai', 'IMPS', 23723.99, 'Success', 'APR00385', 'CUST8591');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00386', '2026-08-03 21:07:00', 'Mumbai', 'Wallet', 7008.96, 'Success', '', 'CUST6370');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00387', '2026-07-19 09:45:00', 'Pune', 'UPI', 18804.35, 'Success', 'APR00387', 'CUST5262');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00388', '2026-07-23 08:25:00', 'Pune', 'IMPS', 64131.45, 'Success', 'APR00388', 'CUST2669');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00389', '2026-07-18 09:00:00', 'Delhi', 'IMPS', 4859.77, 'Success', 'APR00389', 'CUST7563');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00390', '2026-08-17 18:40:00', 'Pune', 'NEFT', 70333.72, 'Success', 'APR00390', 'CUST2228');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00391', '2026-07-03 09:12:00', 'Delhi', 'UPI', 67711.58, 'Success', 'APR00391', 'CUST6432');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00392', '2026-07-16 08:29:00', 'Bengaluru', 'Card', 4035.17, 'Failed', 'APR00392', 'CUST7270');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00393', '2026-09-26 14:11:00', 'Mumbai', 'NEFT', 26707.26, 'Failed', 'APR00393', 'CUST3435');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00394', '2026-07-05 17:39:00', 'Bengaluru', 'Card', 46369.04, 'Success', 'APR00394', 'CUST8848');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00395', '2026-07-08 09:17:00', 'Kolkata', 'Wallet', 28880.39, 'Success', 'APR00395', 'CUST9907');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00396', '2026-07-03 14:50:00', 'Bengaluru', 'NEFT', 53574.46, 'Success', 'APR00396', 'CUST9231');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00397', '2026-08-11 14:17:00', 'Delhi', 'UPI', 13691.24, 'Success', 'APR00397', 'CUST5602');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00398', '2026-07-08 20:30:00', 'Delhi', 'IMPS', 39825.06, 'Success', 'APR00398', 'CUST4951');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00399', '2026-08-04 16:52:00', 'Delhi', 'Wallet', 59394.98, 'Success', 'APR00399', 'CUST7363');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00400', '2026-08-15 22:53:00', 'Delhi', 'Wallet', 74367.76, 'Success', 'APR00400', 'CUST6878');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00401', '2026-09-14 08:45:00', 'Pune', 'IMPS', 52616.92, 'Failed', 'APR00401', 'CUST4084');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00402', '2026-09-02 16:19:00', 'Jaipur', 'IMPS', 13372.87, 'Success', 'APR00402', 'CUST1326');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00403', '2026-09-06 15:00:00', 'Delhi', 'NEFT', 25047.12, 'Success', 'APR00403', 'CUST6301');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00404', '2026-07-08 08:09:00', 'Jaipur', 'Wallet', 44099.04, 'Failed', 'APR00404', 'CUST2188');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00405', '2026-08-17 19:42:00', 'Mumbai', 'NEFT', 29820.77, 'Success', 'APR00405', 'CUST3580');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00406', '2026-08-25 20:40:00', 'Delhi', 'Wallet', 72059.49, 'Success', 'APR00406', 'CUST6846');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00407', '2026-07-29 18:37:00', 'Kolkata', 'NEFT', 61130.45, 'Success', 'APR00407', 'CUST1029');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00408', '2026-09-28 17:25:00', 'Pune', 'UPI', 63844.08, 'Success', 'APR00408', 'CUST6213');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00409', '2026-09-17 11:40:00', 'Delhi', 'NEFT', 42524.88, 'Failed', 'APR00409', 'CUST4899');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00410', '2026-08-14 13:10:00', 'Kolkata', 'NEFT', 47804.96, 'Failed', 'APR00410', 'CUST5345');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00411', '2026-07-27 11:44:00', 'Jaipur', 'UPI', 5317.66, 'Success', '', 'CUST8179');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00412', '2026-08-23 10:56:00', 'Mumbai', 'Wallet', 31197.93, 'Failed', 'APR00412', 'CUST8855');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00413', '2026-09-12 18:48:00', 'Jaipur', 'UPI', 51615.24, 'Success', 'APR00413', 'CUST6221');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00414', '2026-08-03 09:04:00', 'Delhi', 'UPI', 25800.16, 'Failed', 'APR00414', 'CUST2525');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00415', '2026-08-13 17:39:00', 'Bengaluru', 'IMPS', 67018.66, 'Success', 'APR00415', 'CUST8113');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00416', '2026-07-21 08:06:00', 'Bengaluru', 'Wallet', 24999.32, 'Pending', 'APR00416', 'CUST9849');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00417', '2026-08-03 18:18:00', 'Bengaluru', 'Wallet', 22480.70, 'Success', 'APR00417', 'CUST9043');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00418', '2026-07-20 08:23:00', 'Kolkata', 'Wallet', 535.21, 'Success', 'APR00418', 'CUST2589');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00419', '2026-07-04 11:10:00', 'Bengaluru', 'UPI', 47954.75, 'Pending', 'APR00419', 'CUST7512');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00420', '2026-08-30 15:57:00', 'Pune', 'Card', 49662.74, 'Success', 'APR00420', 'CUST7249');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00421', '2026-08-17 10:28:00', 'Mumbai', 'IMPS', 3585.12, 'Success', 'APR00421', 'CUST2009');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00422', '2026-07-20 20:44:00', 'Mumbai', 'Wallet', 50143.27, 'Success', 'APR00422', 'CUST4727');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00423', '2026-09-09 08:53:00', 'Pune', 'Card', 29186.18, 'Success', 'APR00423', 'CUST4860');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00424', '2026-08-30 12:05:00', 'Jaipur', 'Wallet', 29761.63, 'Success', 'APR00424', 'CUST9467');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00425', '2026-09-12 18:39:00', 'Bengaluru', 'IMPS', 11271.71, 'Failed', 'APR00425', 'CUST3738');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00426', '2026-07-28 20:12:00', 'Kolkata', 'Card', 9682.40, 'Success', 'APR00426', 'CUST3422');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00427', '2026-09-15 12:20:00', 'Jaipur', 'UPI', 68332.64, 'Failed', 'APR00427', 'CUST7510');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00428', '2026-09-09 13:54:00', 'Jaipur', 'Wallet', 20896.01, 'Success', 'APR00428', 'CUST7874');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00429', '2026-07-15 14:09:00', 'Jaipur', 'UPI', 11327.93, 'Success', 'APR00429', 'CUST2654');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00430', '2026-08-06 21:34:00', 'Mumbai', 'Card', 66040.15, 'Success', 'APR00430', 'CUST8750');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00431', '2026-07-05 10:17:00', 'Kolkata', 'Card', 30372.30, 'Success', '', 'CUST6431');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00432', '2026-09-27 11:03:00', 'Mumbai', 'UPI', 55994.80, 'Failed', 'APR00432', 'CUST5965');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00433', '2026-08-09 12:53:00', 'Jaipur', 'IMPS', 36998.54, 'Success', 'APR00433', 'CUST8259');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00434', '2026-08-11 12:46:00', 'Delhi', 'Card', 31403.76, 'Success', 'APR00434', 'CUST7671');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00435', '2026-09-01 20:33:00', 'Pune', 'IMPS', 65072.38, 'Success', '', 'CUST9303');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00436', '2026-08-21 10:49:00', 'Jaipur', 'IMPS', 63884.33, 'Success', 'APR00436', 'CUST4288');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00437', '2026-07-08 11:02:00', 'Kolkata', 'IMPS', 34369.54, 'Failed', 'APR00437', 'CUST8605');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00438', '2026-09-03 14:40:00', 'Delhi', 'NEFT', 69249.75, 'Success', 'APR00438', 'CUST8308');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00439', '2026-07-23 21:30:00', 'Delhi', 'NEFT', 44119.30, 'Success', 'APR00439', 'CUST2480');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00440', '2026-08-06 08:24:00', 'Delhi', 'IMPS', 3961.42, 'Success', 'APR00440', 'CUST4387');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00441', '2026-08-04 18:26:00', 'Kolkata', 'UPI', 38617.77, 'Success', 'APR00441', 'CUST3167');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00442', '2026-09-21 10:38:00', 'Pune', 'NEFT', 60114.64, 'Success', 'APR00442', 'CUST5511');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00443', '2026-08-24 22:24:00', 'Delhi', 'Card', 63906.07, 'Success', 'APR00443', 'CUST9530');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00444', '2026-09-18 14:37:00', 'Kolkata', 'NEFT', 7897.83, 'Success', 'APR00444', 'CUST5631');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00445', '2026-08-08 18:06:00', 'Mumbai', 'NEFT', 36259.95, 'Success', 'APR00445', 'CUST5278');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00446', '2026-09-22 19:57:00', 'Pune', 'IMPS', 48947.12, 'Success', 'APR00446', 'CUST7620');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00447', '2026-09-23 13:43:00', 'Bengaluru', 'NEFT', 10709.73, 'Success', 'APR00447', 'CUST7857');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00448', '2026-08-21 14:47:00', 'Pune', 'IMPS', 2890.10, 'Success', 'APR00448', 'CUST4643');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00449', '2026-09-26 16:40:00', 'Kolkata', 'NEFT', 58921.05, 'Failed', 'APR00449', 'CUST3785');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00450', '2026-09-23 22:35:00', 'Delhi', 'NEFT', 13789.91, 'Success', 'APR00450', 'CUST3999');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00451', '2026-09-26 22:21:00', 'Delhi', 'NEFT', 49168.99, 'Success', 'APR00451', 'CUST6428');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00452', '2026-08-17 12:37:00', 'Bengaluru', 'UPI', 22230.32, 'Success', 'APR00452', 'CUST2166');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00453', '2026-08-30 22:12:00', 'Bengaluru', 'Wallet', 37660.68, 'Success', 'APR00453', 'CUST1885');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00454', '2026-07-20 10:12:00', 'Bengaluru', 'IMPS', 25864.57, 'Pending', 'APR00454', 'CUST3954');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00455', '2026-07-11 15:21:00', 'Kolkata', 'UPI', 47419.70, 'Success', '', 'CUST5481');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00456', '2026-07-27 20:49:00', 'Bengaluru', 'UPI', 12853.28, 'Success', 'APR00456', 'CUST8105');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00457', '2026-09-20 14:25:00', 'Jaipur', 'UPI', 32319.65, 'Success', 'APR00457', 'CUST7112');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00458', '2026-07-02 22:20:00', 'Jaipur', 'UPI', 56824.37, 'Success', 'APR00458', 'CUST5076');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00459', '2026-07-29 19:56:00', 'Bengaluru', 'Wallet', 25990.15, 'Success', 'APR00459', 'CUST3736');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00460', '2026-07-09 21:02:00', 'Kolkata', 'Wallet', 22540.62, 'Success', 'APR00460', 'CUST6535');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00461', '2026-08-25 22:43:00', 'Bengaluru', 'NEFT', 74661.56, 'Success', 'APR00461', 'CUST3701');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00462', '2026-08-21 08:14:00', 'Delhi', 'UPI', 17018.02, 'Pending', 'APR00462', 'CUST3768');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00463', '2026-07-16 13:45:00', 'Kolkata', 'NEFT', 48877.89, 'Success', 'APR00463', 'CUST1796');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00464', '2026-09-15 08:42:00', 'Jaipur', 'UPI', 8331.48, 'Success', 'APR00464', 'CUST7230');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00465', '2026-07-16 16:16:00', 'Kolkata', 'UPI', 35711.13, 'Success', 'APR00465', 'CUST2654');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00466', '2026-09-23 16:17:00', 'Bengaluru', 'UPI', 46804.13, 'Success', 'APR00466', 'CUST2928');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00467', '2026-08-06 09:50:00', 'Delhi', 'NEFT', 8193.21, 'Success', 'APR00467', 'CUST4304');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00468', '2026-08-15 19:26:00', 'Bengaluru', 'IMPS', 22327.50, 'Success', 'APR00468', 'CUST8875');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00469', '2026-08-12 11:00:00', 'Jaipur', 'Wallet', 1203.02, 'Success', 'APR00469', 'CUST3443');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00470', '2026-07-12 20:32:00', 'Mumbai', 'IMPS', 5859.85, 'Success', 'APR00470', 'CUST5850');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00471', '2026-08-03 15:03:00', 'Jaipur', 'NEFT', 7710.72, 'Success', 'APR00471', 'CUST6123');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00472', '2026-08-24 19:07:00', 'Jaipur', 'UPI', 7351.14, 'Success', 'APR00472', 'CUST3793');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00473', '2026-08-12 13:57:00', 'Kolkata', 'UPI', 32969.16, 'Success', 'APR00473', 'CUST6615');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00474', '2026-07-24 09:25:00', 'Bengaluru', 'Card', 30168.70, 'Success', 'APR00474', 'CUST3732');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00475', '2026-07-15 10:44:00', 'Delhi', 'UPI', 54549.23, 'Pending', 'APR00475', 'CUST8908');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00476', '2026-09-11 18:28:00', 'Mumbai', 'Wallet', 13799.23, 'Success', '', 'CUST3140');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00477', '2026-08-31 22:31:00', 'Jaipur', 'UPI', 8692.08, 'Success', 'APR00477', 'CUST6148');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00478', '2026-07-02 19:55:00', 'Pune', 'Wallet', 50925.19, 'Success', 'APR00478', 'CUST6542');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00479', '2026-09-05 16:44:00', 'Kolkata', 'IMPS', 52618.37, 'Success', 'APR00479', 'CUST7305');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00480', '2026-07-20 21:52:00', 'Jaipur', 'UPI', 41986.23, 'Pending', 'APR00480', 'CUST3571');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00481', '2026-09-03 21:30:00', 'Jaipur', 'Card', 63927.37, 'Success', 'APR00481', 'CUST6421');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00482', '2026-08-05 08:32:00', 'Bengaluru', 'IMPS', 16897.31, 'Success', '', 'CUST8277');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00483', '2026-09-12 15:05:00', 'Jaipur', 'Card', 64280.04, 'Success', 'APR00483', 'CUST1291');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00484', '2026-07-14 14:26:00', 'Jaipur', 'Wallet', 2928.44, 'Success', 'APR00484', 'CUST5990');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00485', '2026-09-04 16:13:00', 'Mumbai', 'NEFT', 49181.05, 'Success', 'APR00485', 'CUST4652');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00486', '2026-08-28 13:35:00', 'Kolkata', 'NEFT', 57614.38, 'Success', 'APR00486', 'CUST2868');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00487', '2026-07-13 20:42:00', 'Kolkata', 'NEFT', 16825.60, 'Success', 'APR00487', 'CUST7125');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00488', '2026-09-28 09:02:00', 'Kolkata', 'Card', 67291.56, 'Success', 'APR00488', 'CUST4209');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00489', '2026-07-25 09:59:00', 'Delhi', 'NEFT', 63951.53, 'Success', 'APR00489', 'CUST7790');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00490', '2026-07-06 22:40:00', 'Bengaluru', 'Card', 62850.60, 'Success', 'APR00490', 'CUST9260');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00491', '2026-07-18 15:00:00', 'Bengaluru', 'Wallet', 39894.73, 'Success', 'APR00491', 'CUST9328');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00492', '2026-07-23 19:37:00', 'Jaipur', 'Card', 13230.36, 'Success', 'APR00492', 'CUST6273');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00493', '2026-09-03 22:24:00', 'Kolkata', 'IMPS', 31545.19, 'Success', 'APR00493', 'CUST6617');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00494', '2026-08-07 15:51:00', 'Kolkata', 'Wallet', 10219.54, 'Success', 'APR00494', 'CUST9975');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00495', '2026-08-10 19:47:00', 'Delhi', 'IMPS', 70179.53, 'Success', 'APR00495', 'CUST5760');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00496', '2026-09-26 13:58:00', 'Kolkata', 'IMPS', 50509.94, 'Pending', 'APR00496', 'CUST6281');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00497', '2026-09-29 09:48:00', 'Pune', 'Card', 26579.78, 'Success', 'APR00497', 'CUST9747');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00498', '2026-08-06 22:54:00', 'Jaipur', 'UPI', 31823.38, 'Success', 'APR00498', 'CUST1869');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00499', '2026-09-24 08:12:00', 'Mumbai', 'NEFT', 20206.63, 'Success', 'APR00499', 'CUST2016');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00500', '2026-09-27 20:18:00', 'Mumbai', 'Card', 15499.07, 'Success', 'APR00500', 'CUST4675');
    INSERT INTO Transactions (TransactionID, TransactionDate, Branch, Channel, Amount, TransactionStatus, ApprovalID, CustomerRef) VALUES ('TXN00501', '2026-07-23 20:01:00', 'Kolkata', 'IMPS', 25080.86, 'Failed', 'APR00046', 'CUST2771');
    
    
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00001', 'TXN00001', 'Finance Reviewer', 'Approved', '2026-09-20 07:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00002', 'TXN00002', 'Operations Lead', 'Approved', '2026-07-12 16:11:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00003', 'TXN00003', 'Finance Reviewer', 'Approved', '2026-09-30 17:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00004', 'TXN00004', 'Operations Lead', 'Approved', '2026-07-21 18:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00005', 'TXN00005', 'Branch Manager', 'Approved', '2026-08-15 20:11:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00006', 'TXN00006', 'Operations Lead', 'Approved', '2026-07-11 15:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00007', 'TXN00007', 'Branch Manager', 'Approved', '2026-07-06 17:55:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00008', 'TXN00008', 'Branch Manager', 'Approved', '2026-09-20 21:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00009', 'TXN00009', 'Branch Manager', 'Approved', '2026-09-16 16:44:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00010', 'TXN00010', 'Finance Reviewer', 'Approved', '2026-09-26 13:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00011', 'TXN00011', 'Operations Lead', 'Approved', '2026-07-28 22:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00012', 'TXN00012', 'Branch Manager', 'Approved', '2026-07-19 11:45:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00013', 'TXN00013', 'Branch Manager', 'Approved', '2026-08-16 09:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00014', 'TXN00014', 'Finance Reviewer', 'Approved', '2026-09-26 13:21:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00015', 'TXN00015', 'Finance Reviewer', 'Approved', '2026-09-26 18:44:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00016', 'TXN00016', 'Operations Lead', 'Approved', '2026-07-21 14:13:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00017', 'TXN00017', 'Branch Manager', 'Approved', '2026-07-14 21:01:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00019', 'TXN00019', 'Operations Lead', 'Approved', '2026-08-09 10:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00020', 'TXN00020', 'Branch Manager', 'Approved', '2026-09-07 18:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00021', 'TXN00021', 'Branch Manager', 'Approved', '2026-07-28 22:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00023', 'TXN00023', 'Branch Manager', 'Approved', '2026-09-14 10:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00024', 'TXN00024', 'Operations Lead', 'Approved', '2026-07-10 15:07:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00025', 'TXN00025', 'Branch Manager', 'Approved', '2026-08-01 19:11:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00027', 'TXN00027', 'Branch Manager', 'Approved', '2026-07-14 09:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00028', 'TXN00028', 'Finance Reviewer', 'Pending', '2026-07-10 14:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00029', 'TXN00029', 'Finance Reviewer', 'Approved', '2026-07-31 09:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00030', 'TXN00030', 'Operations Lead', 'Approved', '2026-08-19 12:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00033', 'TXN00033', 'Operations Lead', 'Approved', '2026-07-11 19:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00034', 'TXN00034', 'Operations Lead', 'Approved', '2026-09-13 15:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00035', 'TXN00035', 'Finance Reviewer', 'Approved', '2026-07-27 17:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00036', 'TXN00036', 'Operations Lead', 'Approved', '2026-07-02 15:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00037', 'TXN00037', 'Finance Reviewer', 'Approved', '2026-07-17 21:44:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00038', 'TXN00038', 'Branch Manager', 'Approved', '2026-09-29 12:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00039', 'TXN00039', 'Operations Lead', 'Approved', '2026-09-23 09:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00040', 'TXN00040', 'Finance Reviewer', 'Approved', '2026-09-16 10:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00041', 'TXN00041', 'Operations Lead', 'Approved', '2026-07-12 17:44:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00044', 'TXN00044', 'Operations Lead', 'Approved', '2026-07-06 21:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00045', 'TXN00045', 'Branch Manager', 'Approved', '2026-09-18 18:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00046', 'TXN00046', 'Finance Reviewer', 'Approved', '2026-07-23 19:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00047', 'TXN00047', 'Operations Lead', 'Approved', '2026-08-18 19:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00048', 'TXN00048', 'Operations Lead', 'Approved', '2026-07-29 08:27:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00049', 'TXN00049', 'Finance Reviewer', 'Approved', '2026-08-21 18:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00050', 'TXN00050', 'Finance Reviewer', 'Approved', '2026-07-05 09:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00052', 'TXN00052', 'Branch Manager', 'Approved', '2026-09-26 19:03:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00053', 'TXN00053', 'Finance Reviewer', 'Approved', '2026-09-18 12:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00054', 'TXN00054', 'Branch Manager', 'Approved', '2026-08-11 13:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00055', 'TXN00055', 'Branch Manager', 'Approved', '2026-09-17 16:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00056', 'TXN00056', 'Operations Lead', 'Approved', '2026-08-29 14:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00057', 'TXN00057', 'Finance Reviewer', 'Approved', '2026-09-04 17:33:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00058', 'TXN00058', 'Operations Lead', 'Approved', '2026-07-19 06:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00059', 'TXN00059', 'Operations Lead', 'Approved', '2026-09-30 19:21:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00060', 'TXN00060', 'Branch Manager', 'Approved', '2026-08-24 10:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00061', 'TXN00061', 'Operations Lead', 'Approved', '2026-08-28 10:31:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00062', 'TXN00062', 'Operations Lead', 'Approved', '2026-09-17 21:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00063', 'TXN00063', 'Operations Lead', 'Approved', '2026-08-27 12:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00064', 'TXN00064', 'Finance Reviewer', 'Approved', '2026-08-26 09:21:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00065', 'TXN00065', 'Finance Reviewer', 'Approved', '2026-07-30 14:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00066', 'TXN00066', 'Finance Reviewer', 'Approved', '2026-08-23 08:08:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00067', 'TXN00067', 'Operations Lead', 'Approved', '2026-08-31 07:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00068', 'TXN00068', 'Branch Manager', 'Approved', '2026-09-16 21:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00069', 'TXN00069', 'Branch Manager', 'Approved', '2026-07-22 21:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00070', 'TXN00070', 'Branch Manager', 'Approved', '2026-07-11 18:22:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00071', 'TXN00071', 'Branch Manager', 'Approved', '2026-08-28 12:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00072', 'TXN00072', 'Finance Reviewer', 'Approved', '2026-07-03 18:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00073', 'TXN00073', 'Finance Reviewer', 'Approved', '2026-07-04 10:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00074', 'TXN00074', 'Operations Lead', 'Approved', '2026-09-11 10:21:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00075', 'TXN00075', 'Operations Lead', 'Approved', '2026-07-21 11:47:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00076', 'TXN00076', 'Branch Manager', 'Approved', '2026-07-10 16:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00077', 'TXN00077', 'Finance Reviewer', 'Pending', '2026-09-11 19:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00078', 'TXN00078', 'Finance Reviewer', 'Approved', '2026-07-02 20:36:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00079', 'TXN00079', 'Finance Reviewer', 'Approved', '2026-07-23 19:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00080', 'TXN00080', 'Branch Manager', 'Approved', '2026-08-11 21:09:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00081', 'TXN00081', 'Finance Reviewer', 'Approved', '2026-08-13 08:19:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00082', 'TXN00082', 'Operations Lead', 'Approved', '2026-08-05 22:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00083', 'TXN00083', 'Branch Manager', 'Approved', '2026-07-31 18:01:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00084', 'TXN00084', 'Finance Reviewer', 'Approved', '2026-08-27 18:47:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00085', 'TXN00085', 'Operations Lead', 'Approved', '2026-08-30 16:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00086', 'TXN00086', 'Operations Lead', 'Approved', '2026-08-04 11:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00087', 'TXN00087', 'Operations Lead', 'Approved', '2026-07-25 10:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00088', 'TXN00088', 'Finance Reviewer', 'Approved', '2026-07-25 11:54:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00089', 'TXN00089', 'Branch Manager', 'Approved', '2026-07-07 16:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00090', 'TXN00090', 'Finance Reviewer', 'Approved', '2026-08-30 15:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00092', 'TXN00092', 'Operations Lead', 'Approved', '2026-07-11 10:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00093', 'TXN00093', 'Finance Reviewer', 'Approved', '2026-08-18 15:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00094', 'TXN00094', 'Operations Lead', 'Approved', '2026-09-17 18:22:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00095', 'TXN00095', 'Finance Reviewer', 'Approved', '2026-07-31 10:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00096', 'TXN00096', 'Branch Manager', 'Approved', '2026-07-30 11:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00098', 'TXN00098', 'Branch Manager', 'Approved', '2026-08-09 17:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00100', 'TXN00100', 'Branch Manager', 'Approved', '2026-08-11 16:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00101', 'TXN00101', 'Finance Reviewer', 'Approved', '2026-09-25 20:01:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00102', 'TXN00102', 'Finance Reviewer', 'Approved', '2026-08-05 09:07:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00103', 'TXN00103', 'Operations Lead', 'Approved', '2026-08-11 17:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00104', 'TXN00104', 'Operations Lead', 'Approved', '2026-09-09 07:03:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00105', 'TXN00105', 'Finance Reviewer', 'Approved', '2026-09-23 20:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00106', 'TXN00106', 'Finance Reviewer', 'Approved', '2026-09-19 14:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00107', 'TXN00107', 'Operations Lead', 'Approved', '2026-07-16 08:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00108', 'TXN00108', 'Finance Reviewer', 'Approved', '2026-07-12 10:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00109', 'TXN00109', 'Operations Lead', 'Approved', '2026-09-04 18:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00110', 'TXN00110', 'Branch Manager', 'Approved', '2026-08-19 10:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00111', 'TXN00111', 'Operations Lead', 'Approved', '2026-08-13 21:59:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00112', 'TXN00112', 'Branch Manager', 'Approved', '2026-07-20 14:08:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00113', 'TXN00113', 'Operations Lead', 'Approved', '2026-07-25 18:33:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00114', 'TXN00114', 'Operations Lead', 'Approved', '2026-09-29 22:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00115', 'TXN00115', 'Operations Lead', 'Approved', '2026-07-17 15:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00116', 'TXN00116', 'Operations Lead', 'Approved', '2026-07-02 18:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00117', 'TXN00117', 'Operations Lead', 'Approved', '2026-08-13 17:27:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00119', 'TXN00119', 'Finance Reviewer', 'Approved', '2026-07-30 18:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00120', 'TXN00120', 'Operations Lead', 'Approved', '2026-07-04 08:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00121', 'TXN00121', 'Operations Lead', 'Approved', '2026-08-22 16:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00122', 'TXN00122', 'Finance Reviewer', 'Approved', '2026-09-02 21:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00123', 'TXN00123', 'Branch Manager', 'Approved', '2026-08-29 21:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00124', 'TXN00124', 'Operations Lead', 'Approved', '2026-09-20 14:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00126', 'TXN00126', 'Finance Reviewer', 'Approved', '2026-08-05 07:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00127', 'TXN00127', 'Finance Reviewer', 'Approved', '2026-07-30 16:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00128', 'TXN00128', 'Finance Reviewer', 'Approved', '2026-09-19 08:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00129', 'TXN00129', 'Finance Reviewer', 'Approved', '2026-07-12 21:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00130', 'TXN00130', 'Operations Lead', 'Approved', '2026-09-06 15:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00131', 'TXN00131', 'Operations Lead', 'Approved', '2026-07-15 14:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00132', 'TXN00132', 'Operations Lead', 'Approved', '2026-07-12 19:33:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00133', 'TXN00133', 'Branch Manager', 'Approved', '2026-09-13 13:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00134', 'TXN00134', 'Finance Reviewer', 'Approved', '2026-09-17 10:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00135', 'TXN00135', 'Operations Lead', 'Approved', '2026-07-18 06:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00136', 'TXN00136', 'Branch Manager', 'Approved', '2026-08-19 15:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00137', 'TXN00137', 'Finance Reviewer', 'Approved', '2026-08-23 16:44:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00138', 'TXN00138', 'Branch Manager', 'Approved', '2026-08-26 13:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00139', 'TXN00139', 'Branch Manager', 'Approved', '2026-07-08 13:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00143', 'TXN00143', 'Operations Lead', 'Approved', '2026-09-14 12:03:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00144', 'TXN00144', 'Branch Manager', 'Approved', '2026-08-30 15:08:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00145', 'TXN00145', 'Operations Lead', 'Approved', '2026-09-23 14:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00146', 'TXN00146', 'Operations Lead', 'Approved', '2026-09-26 08:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00147', 'TXN00147', 'Finance Reviewer', 'Pending', '2026-07-17 11:54:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00148', 'TXN00148', 'Branch Manager', 'Approved', '2026-08-07 14:13:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00149', 'TXN00149', 'Finance Reviewer', 'Approved', '2026-08-25 15:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00152', 'TXN00152', 'Operations Lead', 'Approved', '2026-09-24 08:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00153', 'TXN00153', 'Branch Manager', 'Approved', '2026-08-15 08:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00154', 'TXN00154', 'Operations Lead', 'Approved', '2026-09-10 12:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00155', 'TXN00155', 'Branch Manager', 'Approved', '2026-09-16 21:12:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00157', 'TXN00157', 'Finance Reviewer', 'Approved', '2026-07-12 18:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00158', 'TXN00158', 'Finance Reviewer', 'Approved', '2026-09-11 16:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00159', 'TXN00159', 'Operations Lead', 'Approved', '2026-08-26 17:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00160', 'TXN00160', 'Branch Manager', 'Approved', '2026-08-14 13:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00161', 'TXN00161', 'Finance Reviewer', 'Approved', '2026-07-29 13:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00162', 'TXN00162', 'Operations Lead', 'Approved', '2026-08-11 07:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00163', 'TXN00163', 'Branch Manager', 'Approved', '2026-09-03 16:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00164', 'TXN00164', 'Finance Reviewer', 'Approved', '2026-07-10 20:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00165', 'TXN00165', 'Finance Reviewer', 'Approved', '2026-07-03 12:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00166', 'TXN00166', 'Branch Manager', 'Approved', '2026-08-01 13:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00167', 'TXN00167', 'Operations Lead', 'Approved', '2026-07-10 15:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00168', 'TXN00168', 'Finance Reviewer', 'Rejected', '2026-07-31 07:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00169', 'TXN00169', 'Branch Manager', 'Approved', '2026-08-29 19:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00171', 'TXN00171', 'Finance Reviewer', 'Approved', '2026-07-10 11:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00172', 'TXN00172', 'Operations Lead', 'Approved', '2026-09-17 16:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00173', 'TXN00173', 'Finance Reviewer', 'Approved', '2026-08-11 16:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00174', 'TXN00174', 'Finance Reviewer', 'Approved', '2026-09-30 08:27:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00175', 'TXN00175', 'Operations Lead', 'Approved', '2026-09-05 16:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00176', 'TXN00176', 'Finance Reviewer', 'Approved', '2026-09-19 18:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00177', 'TXN00177', 'Finance Reviewer', 'Approved', '2026-08-12 08:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00178', 'TXN00178', 'Branch Manager', 'Approved', '2026-08-09 14:55:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00179', 'TXN00179', 'Branch Manager', 'Approved', '2026-09-04 11:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00180', 'TXN00180', 'Operations Lead', 'Approved', '2026-07-25 10:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00181', 'TXN00181', 'Finance Reviewer', 'Approved', '2026-07-05 18:09:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00182', 'TXN00182', 'Branch Manager', 'Approved', '2026-09-27 19:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00183', 'TXN00183', 'Finance Reviewer', 'Approved', '2026-08-26 15:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00184', 'TXN00184', 'Finance Reviewer', 'Approved', '2026-07-25 13:03:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00186', 'TXN00186', 'Finance Reviewer', 'Approved', '2026-08-17 16:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00187', 'TXN00187', 'Finance Reviewer', 'Approved', '2026-08-04 14:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00188', 'TXN00188', 'Operations Lead', 'Approved', '2026-07-04 13:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00190', 'TXN00190', 'Finance Reviewer', 'Approved', '2026-09-28 20:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00191', 'TXN00191', 'Operations Lead', 'Pending', '2026-08-02 11:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00193', 'TXN00193', 'Operations Lead', 'Approved', '2026-09-15 14:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00194', 'TXN00194', 'Finance Reviewer', 'Approved', '2026-09-17 12:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00195', 'TXN00195', 'Operations Lead', 'Approved', '2026-07-09 15:33:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00196', 'TXN00196', 'Finance Reviewer', 'Approved', '2026-07-06 18:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00197', 'TXN00197', 'Finance Reviewer', 'Pending', '2026-07-31 18:22:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00198', 'TXN00198', 'Branch Manager', 'Approved', '2026-09-08 13:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00199', 'TXN00199', 'Branch Manager', 'Approved', '2026-09-19 10:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00200', 'TXN00200', 'Operations Lead', 'Approved', '2026-07-26 21:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00201', 'TXN00201', 'Operations Lead', 'Approved', '2026-09-21 11:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00202', 'TXN00202', 'Finance Reviewer', 'Approved', '2026-08-25 22:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00204', 'TXN00204', 'Finance Reviewer', 'Approved', '2026-09-08 10:55:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00205', 'TXN00205', 'Operations Lead', 'Approved', '2026-07-22 19:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00206', 'TXN00206', 'Operations Lead', 'Approved', '2026-09-20 19:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00208', 'TXN00208', 'Operations Lead', 'Approved', '2026-08-16 13:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00209', 'TXN00209', 'Branch Manager', 'Approved', '2026-09-12 10:22:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00210', 'TXN00210', 'Branch Manager', 'Approved', '2026-07-24 15:13:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00211', 'TXN00211', 'Operations Lead', 'Approved', '2026-09-17 11:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00212', 'TXN00212', 'Operations Lead', 'Approved', '2026-07-23 21:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00213', 'TXN00213', 'Finance Reviewer', 'Approved', '2026-09-09 15:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00214', 'TXN00214', 'Finance Reviewer', 'Approved', '2026-07-29 08:27:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00215', 'TXN00215', 'Branch Manager', 'Approved', '2026-08-29 20:20:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00216', 'TXN00216', 'Branch Manager', 'Approved', '2026-09-06 13:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00217', 'TXN00217', 'Operations Lead', 'Approved', '2026-08-29 17:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00218', 'TXN00218', 'Branch Manager', 'Approved', '2026-08-25 16:08:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00219', 'TXN00219', 'Operations Lead', 'Approved', '2026-08-11 21:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00220', 'TXN00220', 'Operations Lead', 'Approved', '2026-07-26 17:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00221', 'TXN00221', 'Operations Lead', 'Approved', '2026-09-14 16:01:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00222', 'TXN00222', 'Finance Reviewer', 'Rejected', '2026-07-04 08:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00223', 'TXN00223', 'Finance Reviewer', 'Approved', '2026-09-18 17:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00224', 'TXN00224', 'Finance Reviewer', 'Approved', '2026-08-08 14:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00225', 'TXN00225', 'Operations Lead', 'Approved', '2026-09-16 10:07:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00226', 'TXN00226', 'Operations Lead', 'Approved', '2026-09-04 15:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00227', 'TXN00227', 'Operations Lead', 'Approved', '2026-07-07 11:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00228', 'TXN00228', 'Finance Reviewer', 'Approved', '2026-07-25 19:45:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00230', 'TXN00230', 'Finance Reviewer', 'Approved', '2026-09-15 21:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00231', 'TXN00231', 'Branch Manager', 'Approved', '2026-07-18 22:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00232', 'TXN00232', 'Finance Reviewer', 'Approved', '2026-08-16 16:09:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00233', 'TXN00233', 'Branch Manager', 'Approved', '2026-07-17 08:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00234', 'TXN00234', 'Branch Manager', 'Approved', '2026-09-16 15:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00235', 'TXN00235', 'Branch Manager', 'Approved', '2026-08-28 10:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00236', 'TXN00236', 'Branch Manager', 'Approved', '2026-09-14 12:12:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00237', 'TXN00237', 'Branch Manager', 'Approved', '2026-08-17 12:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00238', 'TXN00238', 'Finance Reviewer', 'Approved', '2026-09-22 20:21:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00240', 'TXN00240', 'Finance Reviewer', 'Approved', '2026-07-25 08:12:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00241', 'TXN00241', 'Branch Manager', 'Approved', '2026-07-08 18:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00242', 'TXN00242', 'Operations Lead', 'Approved', '2026-07-23 14:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00243', 'TXN00243', 'Finance Reviewer', 'Approved', '2026-08-01 12:11:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00244', 'TXN00244', 'Branch Manager', 'Approved', '2026-08-10 14:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00246', 'TXN00246', 'Operations Lead', 'Approved', '2026-08-14 22:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00247', 'TXN00247', 'Finance Reviewer', 'Approved', '2026-09-10 18:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00248', 'TXN00248', 'Operations Lead', 'Approved', '2026-07-29 16:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00249', 'TXN00249', 'Operations Lead', 'Approved', '2026-07-01 16:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00250', 'TXN00250', 'Operations Lead', 'Approved', '2026-08-11 11:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00251', 'TXN00251', 'Operations Lead', 'Approved', '2026-07-23 14:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00252', 'TXN00252', 'Operations Lead', 'Rejected', '2026-08-07 21:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00253', 'TXN00253', 'Branch Manager', 'Approved', '2026-09-06 14:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00254', 'TXN00254', 'Branch Manager', 'Approved', '2026-08-12 10:23:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00255', 'TXN00255', 'Finance Reviewer', 'Approved', '2026-09-11 18:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00256', 'TXN00256', 'Finance Reviewer', 'Approved', '2026-08-11 08:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00257', 'TXN00257', 'Finance Reviewer', 'Approved', '2026-07-01 11:27:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00258', 'TXN00258', 'Finance Reviewer', 'Approved', '2026-08-03 18:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00259', 'TXN00259', 'Branch Manager', 'Approved', '2026-09-26 16:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00260', 'TXN00260', 'Operations Lead', 'Approved', '2026-08-17 16:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00261', 'TXN00261', 'Branch Manager', 'Approved', '2026-08-23 19:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00263', 'TXN00263', 'Branch Manager', 'Approved', '2026-09-03 11:01:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00264', 'TXN00264', 'Branch Manager', 'Approved', '2026-09-30 16:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00265', 'TXN00265', 'Finance Reviewer', 'Approved', '2026-08-28 16:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00266', 'TXN00266', 'Operations Lead', 'Approved', '2026-07-28 16:55:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00267', 'TXN00267', 'Finance Reviewer', 'Approved', '2026-08-30 07:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00268', 'TXN00268', 'Finance Reviewer', 'Approved', '2026-08-27 20:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00269', 'TXN00269', 'Branch Manager', 'Approved', '2026-07-16 09:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00270', 'TXN00270', 'Operations Lead', 'Approved', '2026-08-29 17:54:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00271', 'TXN00271', 'Branch Manager', 'Approved', '2026-08-05 10:36:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00272', 'TXN00272', 'Branch Manager', 'Approved', '2026-07-31 10:20:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00273', 'TXN00273', 'Branch Manager', 'Approved', '2026-08-21 14:36:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00274', 'TXN00274', 'Finance Reviewer', 'Approved', '2026-07-30 20:47:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00275', 'TXN00275', 'Branch Manager', 'Pending', '2026-09-23 14:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00276', 'TXN00276', 'Branch Manager', 'Approved', '2026-09-19 17:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00277', 'TXN00277', 'Branch Manager', 'Approved', '2026-09-28 13:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00278', 'TXN00278', 'Operations Lead', 'Approved', '2026-08-08 20:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00279', 'TXN00279', 'Operations Lead', 'Approved', '2026-09-10 15:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00280', 'TXN00280', 'Branch Manager', 'Approved', '2026-07-12 15:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00281', 'TXN00281', 'Branch Manager', 'Approved', '2026-07-25 20:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00282', 'TXN00282', 'Finance Reviewer', 'Approved', '2026-08-08 20:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00283', 'TXN00283', 'Finance Reviewer', 'Pending', '2026-08-01 18:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00284', 'TXN00284', 'Branch Manager', 'Approved', '2026-08-18 15:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00285', 'TXN00285', 'Operations Lead', 'Approved', '2026-07-13 20:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00286', 'TXN00286', 'Operations Lead', 'Approved', '2026-09-11 19:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00287', 'TXN00287', 'Finance Reviewer', 'Approved', '2026-08-07 08:45:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00288', 'TXN00288', 'Finance Reviewer', 'Approved', '2026-08-02 19:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00289', 'TXN00289', 'Branch Manager', 'Approved', '2026-07-22 10:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00291', 'TXN00291', 'Finance Reviewer', 'Approved', '2026-07-02 10:08:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00292', 'TXN00292', 'Branch Manager', 'Approved', '2026-07-03 07:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00293', 'TXN00293', 'Branch Manager', 'Approved', '2026-07-03 15:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00294', 'TXN00294', 'Branch Manager', 'Approved', '2026-07-20 09:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00295', 'TXN00295', 'Branch Manager', 'Approved', '2026-08-17 14:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00296', 'TXN00296', 'Operations Lead', 'Approved', '2026-09-22 20:25:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00297', 'TXN00297', 'Branch Manager', 'Approved', '2026-09-20 08:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00298', 'TXN00298', 'Branch Manager', 'Approved', '2026-09-06 20:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00299', 'TXN00299', 'Branch Manager', 'Approved', '2026-07-10 18:33:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00300', 'TXN00300', 'Operations Lead', 'Approved', '2026-07-03 10:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00301', 'TXN00301', 'Operations Lead', 'Approved', '2026-09-11 20:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00302', 'TXN00302', 'Finance Reviewer', 'Approved', '2026-09-27 18:23:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00303', 'TXN00303', 'Branch Manager', 'Approved', '2026-08-13 16:33:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00304', 'TXN00304', 'Branch Manager', 'Approved', '2026-09-01 11:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00305', 'TXN00305', 'Operations Lead', 'Approved', '2026-09-18 11:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00306', 'TXN00306', 'Branch Manager', 'Approved', '2026-08-19 12:12:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00307', 'TXN00307', 'Branch Manager', 'Approved', '2026-07-14 08:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00309', 'TXN00309', 'Branch Manager', 'Approved', '2026-08-19 18:44:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00310', 'TXN00310', 'Finance Reviewer', 'Approved', '2026-07-22 09:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00311', 'TXN00311', 'Branch Manager', 'Approved', '2026-08-08 15:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00312', 'TXN00312', 'Branch Manager', 'Approved', '2026-08-28 08:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00313', 'TXN00313', 'Finance Reviewer', 'Approved', '2026-08-26 12:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00314', 'TXN00314', 'Operations Lead', 'Approved', '2026-08-31 12:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00315', 'TXN00315', 'Finance Reviewer', 'Approved', '2026-08-11 13:58:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00316', 'TXN00316', 'Finance Reviewer', 'Approved', '2026-07-24 17:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00317', 'TXN00317', 'Operations Lead', 'Approved', '2026-09-27 09:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00318', 'TXN00318', 'Finance Reviewer', 'Approved', '2026-07-31 11:25:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00319', 'TXN00319', 'Branch Manager', 'Approved', '2026-09-13 13:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00320', 'TXN00320', 'Branch Manager', 'Approved', '2026-09-28 22:12:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00321', 'TXN00321', 'Operations Lead', 'Approved', '2026-07-22 17:27:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00322', 'TXN00322', 'Branch Manager', 'Approved', '2026-08-25 07:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00323', 'TXN00323', 'Branch Manager', 'Approved', '2026-08-27 12:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00324', 'TXN00324', 'Finance Reviewer', 'Approved', '2026-08-31 07:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00325', 'TXN00325', 'Finance Reviewer', 'Approved', '2026-08-28 20:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00326', 'TXN00326', 'Branch Manager', 'Approved', '2026-08-10 08:59:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00327', 'TXN00327', 'Finance Reviewer', 'Approved', '2026-08-01 15:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00328', 'TXN00328', 'Operations Lead', 'Approved', '2026-09-19 08:45:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00329', 'TXN00329', 'Branch Manager', 'Approved', '2026-09-14 13:37:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00330', 'TXN00330', 'Operations Lead', 'Approved', '2026-07-24 12:47:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00332', 'TXN00332', 'Branch Manager', 'Approved', '2026-09-17 16:58:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00333', 'TXN00333', 'Finance Reviewer', 'Approved', '2026-09-27 10:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00334', 'TXN00334', 'Operations Lead', 'Approved', '2026-09-20 16:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00335', 'TXN00335', 'Branch Manager', 'Approved', '2026-07-18 09:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00336', 'TXN00336', 'Finance Reviewer', 'Approved', '2026-08-19 16:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00339', 'TXN00339', 'Branch Manager', 'Approved', '2026-08-04 19:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00340', 'TXN00340', 'Branch Manager', 'Approved', '2026-07-14 19:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00341', 'TXN00341', 'Branch Manager', 'Approved', '2026-08-26 20:38:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00342', 'TXN00342', 'Branch Manager', 'Approved', '2026-07-22 16:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00343', 'TXN00343', 'Branch Manager', 'Approved', '2026-09-15 15:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00344', 'TXN00344', 'Branch Manager', 'Approved', '2026-09-25 20:07:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00345', 'TXN00345', 'Branch Manager', 'Approved', '2026-09-28 20:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00346', 'TXN00346', 'Operations Lead', 'Approved', '2026-09-19 13:03:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00348', 'TXN00348', 'Operations Lead', 'Pending', '2026-08-28 18:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00349', 'TXN00349', 'Operations Lead', 'Approved', '2026-07-28 13:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00351', 'TXN00351', 'Finance Reviewer', 'Approved', '2026-08-26 14:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00352', 'TXN00352', 'Branch Manager', 'Approved', '2026-07-21 21:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00353', 'TXN00353', 'Operations Lead', 'Approved', '2026-07-07 13:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00355', 'TXN00355', 'Branch Manager', 'Approved', '2026-07-16 20:09:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00357', 'TXN00357', 'Branch Manager', 'Approved', '2026-09-17 16:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00358', 'TXN00358', 'Finance Reviewer', 'Approved', '2026-07-28 08:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00359', 'TXN00359', 'Finance Reviewer', 'Approved', '2026-08-10 19:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00360', 'TXN00360', 'Operations Lead', 'Approved', '2026-09-27 07:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00361', 'TXN00361', 'Branch Manager', 'Approved', '2026-08-20 11:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00362', 'TXN00362', 'Operations Lead', 'Approved', '2026-09-02 17:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00363', 'TXN00363', 'Finance Reviewer', 'Approved', '2026-08-19 21:21:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00364', 'TXN00364', 'Operations Lead', 'Approved', '2026-07-03 16:35:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00365', 'TXN00365', 'Finance Reviewer', 'Rejected', '2026-08-23 13:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00366', 'TXN00366', 'Branch Manager', 'Approved', '2026-08-09 09:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00367', 'TXN00367', 'Branch Manager', 'Pending', '2026-08-09 18:22:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00368', 'TXN00368', 'Branch Manager', 'Approved', '2026-07-15 14:48:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00369', 'TXN00369', 'Operations Lead', 'Approved', '2026-09-28 06:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00370', 'TXN00370', 'Branch Manager', 'Approved', '2026-08-04 19:25:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00372', 'TXN00372', 'Branch Manager', 'Approved', '2026-08-17 10:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00373', 'TXN00373', 'Finance Reviewer', 'Approved', '2026-07-01 08:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00374', 'TXN00374', 'Branch Manager', 'Approved', '2026-07-23 22:23:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00375', 'TXN00375', 'Finance Reviewer', 'Pending', '2026-08-23 22:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00376', 'TXN00376', 'Operations Lead', 'Approved', '2026-07-23 11:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00377', 'TXN00377', 'Finance Reviewer', 'Approved', '2026-08-09 11:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00378', 'TXN00378', 'Finance Reviewer', 'Approved', '2026-09-18 10:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00379', 'TXN00379', 'Operations Lead', 'Approved', '2026-07-20 08:07:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00380', 'TXN00380', 'Branch Manager', 'Approved', '2026-09-23 14:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00381', 'TXN00381', 'Finance Reviewer', 'Approved', '2026-09-01 06:47:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00383', 'TXN00383', 'Branch Manager', 'Approved', '2026-08-25 17:58:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00384', 'TXN00384', 'Operations Lead', 'Approved', '2026-08-10 14:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00385', 'TXN00385', 'Finance Reviewer', 'Approved', '2026-07-22 14:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00387', 'TXN00387', 'Operations Lead', 'Approved', '2026-07-19 08:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00388', 'TXN00388', 'Finance Reviewer', 'Approved', '2026-07-23 07:58:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00389', 'TXN00389', 'Finance Reviewer', 'Approved', '2026-07-18 08:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00390', 'TXN00390', 'Finance Reviewer', 'Rejected', '2026-08-17 17:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00391', 'TXN00391', 'Finance Reviewer', 'Approved', '2026-07-03 09:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00392', 'TXN00392', 'Branch Manager', 'Approved', '2026-07-16 07:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00393', 'TXN00393', 'Finance Reviewer', 'Approved', '2026-09-26 13:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00394', 'TXN00394', 'Branch Manager', 'Approved', '2026-07-05 17:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00395', 'TXN00395', 'Finance Reviewer', 'Approved', '2026-07-08 08:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00397', 'TXN00397', 'Finance Reviewer', 'Approved', '2026-08-11 13:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00398', 'TXN00398', 'Finance Reviewer', 'Rejected', '2026-07-08 19:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00399', 'TXN00399', 'Finance Reviewer', 'Approved', '2026-08-04 16:23:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00400', 'TXN00400', 'Operations Lead', 'Approved', '2026-08-15 22:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00401', 'TXN00401', 'Finance Reviewer', 'Approved', '2026-09-14 08:09:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00402', 'TXN00402', 'Branch Manager', 'Approved', '2026-09-02 15:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00403', 'TXN00403', 'Operations Lead', 'Approved', '2026-09-06 13:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00404', 'TXN00404', 'Branch Manager', 'Approved', '2026-07-08 07:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00405', 'TXN00405', 'Finance Reviewer', 'Approved', '2026-08-17 19:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00406', 'TXN00406', 'Operations Lead', 'Approved', '2026-08-25 19:13:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00407', 'TXN00407', 'Finance Reviewer', 'Approved', '2026-07-29 18:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00408', 'TXN00408', 'Branch Manager', 'Approved', '2026-09-28 16:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00409', 'TXN00409', 'Branch Manager', 'Approved', '2026-09-17 11:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00410', 'TXN00410', 'Operations Lead', 'Rejected', '2026-08-14 13:00:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00412', 'TXN00412', 'Branch Manager', 'Approved', '2026-08-23 10:41:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00413', 'TXN00413', 'Finance Reviewer', 'Approved', '2026-09-12 18:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00414', 'TXN00414', 'Branch Manager', 'Approved', '2026-08-03 07:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00415', 'TXN00415', 'Branch Manager', 'Approved', '2026-08-13 16:11:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00416', 'TXN00416', 'Finance Reviewer', 'Rejected', '2026-07-21 07:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00417', 'TXN00417', 'Operations Lead', 'Approved', '2026-08-03 16:55:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00418', 'TXN00418', 'Branch Manager', 'Approved', '2026-07-20 08:14:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00419', 'TXN00419', 'Branch Manager', 'Approved', '2026-07-04 10:40:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00420', 'TXN00420', 'Finance Reviewer', 'Approved', '2026-08-30 15:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00421', 'TXN00421', 'Finance Reviewer', 'Approved', '2026-08-17 09:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00422', 'TXN00422', 'Operations Lead', 'Approved', '2026-07-20 19:18:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00423', 'TXN00423', 'Finance Reviewer', 'Approved', '2026-09-09 07:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00424', 'TXN00424', 'Operations Lead', 'Approved', '2026-08-30 10:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00425', 'TXN00425', 'Branch Manager', 'Approved', '2026-09-12 17:59:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00426', 'TXN00426', 'Branch Manager', 'Approved', '2026-07-28 19:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00427', 'TXN00427', 'Operations Lead', 'Approved', '2026-09-15 11:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00428', 'TXN00428', 'Branch Manager', 'Approved', '2026-09-09 13:17:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00429', 'TXN00429', 'Operations Lead', 'Rejected', '2026-07-15 12:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00430', 'TXN00430', 'Branch Manager', 'Approved', '2026-08-06 20:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00432', 'TXN00432', 'Branch Manager', 'Pending', '2026-09-27 09:34:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00433', 'TXN00433', 'Finance Reviewer', 'Approved', '2026-08-09 12:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00434', 'TXN00434', 'Branch Manager', 'Approved', '2026-08-11 12:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00436', 'TXN00436', 'Finance Reviewer', 'Approved', '2026-08-21 10:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00437', 'TXN00437', 'Operations Lead', 'Approved', '2026-07-08 09:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00438', 'TXN00438', 'Finance Reviewer', 'Approved', '2026-09-03 13:59:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00439', 'TXN00439', 'Operations Lead', 'Approved', '2026-07-23 20:32:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00440', 'TXN00440', 'Finance Reviewer', 'Pending', '2026-08-06 07:15:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00441', 'TXN00441', 'Operations Lead', 'Approved', '2026-08-04 18:22:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00442', 'TXN00442', 'Operations Lead', 'Rejected', '2026-09-21 10:19:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00443', 'TXN00443', 'Operations Lead', 'Approved', '2026-08-24 22:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00444', 'TXN00444', 'Branch Manager', 'Pending', '2026-09-18 13:27:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00445', 'TXN00445', 'Finance Reviewer', 'Approved', '2026-08-08 17:28:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00446', 'TXN00446', 'Operations Lead', 'Approved', '2026-09-22 18:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00447', 'TXN00447', 'Finance Reviewer', 'Approved', '2026-09-23 12:30:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00448', 'TXN00448', 'Finance Reviewer', 'Approved', '2026-08-21 13:50:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00449', 'TXN00449', 'Operations Lead', 'Approved', '2026-09-26 15:38:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00450', 'TXN00450', 'Branch Manager', 'Approved', '2026-09-23 21:24:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00451', 'TXN00451', 'Branch Manager', 'Approved', '2026-09-26 21:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00452', 'TXN00452', 'Finance Reviewer', 'Approved', '2026-08-17 11:39:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00453', 'TXN00453', 'Operations Lead', 'Approved', '2026-08-30 22:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00454', 'TXN00454', 'Finance Reviewer', 'Approved', '2026-07-20 08:57:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00456', 'TXN00456', 'Finance Reviewer', 'Approved', '2026-07-27 20:13:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00457', 'TXN00457', 'Branch Manager', 'Approved', '2026-09-20 13:16:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00458', 'TXN00458', 'Operations Lead', 'Approved', '2026-07-02 22:08:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00459', 'TXN00459', 'Finance Reviewer', 'Approved', '2026-07-29 18:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00460', 'TXN00460', 'Operations Lead', 'Approved', '2026-07-09 19:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00461', 'TXN00461', 'Branch Manager', 'Approved', '2026-08-25 21:56:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00463', 'TXN00463', 'Operations Lead', 'Approved', '2026-07-16 13:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00464', 'TXN00464', 'Operations Lead', 'Approved', '2026-09-15 08:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00465', 'TXN00465', 'Operations Lead', 'Approved', '2026-07-16 16:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00466', 'TXN00466', 'Branch Manager', 'Approved', '2026-09-23 15:20:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00467', 'TXN00467', 'Finance Reviewer', 'Pending', '2026-08-06 08:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00468', 'TXN00468', 'Operations Lead', 'Approved', '2026-08-15 18:31:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00469', 'TXN00469', 'Finance Reviewer', 'Approved', '2026-08-12 10:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00470', 'TXN00470', 'Finance Reviewer', 'Approved', '2026-07-12 20:13:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00471', 'TXN00471', 'Branch Manager', 'Approved', '2026-08-03 13:55:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00472', 'TXN00472', 'Operations Lead', 'Approved', '2026-08-24 17:51:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00473', 'TXN00473', 'Operations Lead', 'Approved', '2026-08-12 13:04:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00474', 'TXN00474', 'Finance Reviewer', 'Approved', '2026-07-24 08:31:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00475', 'TXN00475', 'Branch Manager', 'Approved', '2026-07-15 09:31:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00477', 'TXN00477', 'Branch Manager', 'Approved', '2026-08-31 21:42:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00478', 'TXN00478', 'Operations Lead', 'Approved', '2026-07-02 19:49:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00479', 'TXN00479', 'Operations Lead', 'Approved', '2026-09-05 16:05:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00480', 'TXN00480', 'Operations Lead', 'Approved', '2026-07-20 20:52:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00481', 'TXN00481', 'Branch Manager', 'Approved', '2026-09-03 21:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00483', 'TXN00483', 'Branch Manager', 'Approved', '2026-09-12 13:43:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00484', 'TXN00484', 'Finance Reviewer', 'Approved', '2026-07-14 13:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00485', 'TXN00485', 'Finance Reviewer', 'Approved', '2026-09-04 15:19:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00486', 'TXN00486', 'Branch Manager', 'Approved', '2026-08-28 12:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00487', 'TXN00487', 'Finance Reviewer', 'Approved', '2026-07-13 20:26:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00488', 'TXN00488', 'Operations Lead', 'Approved', '2026-09-28 08:53:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00489', 'TXN00489', 'Finance Reviewer', 'Approved', '2026-07-25 08:44:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00490', 'TXN00490', 'Operations Lead', 'Approved', '2026-07-06 22:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00491', 'TXN00491', 'Finance Reviewer', 'Approved', '2026-07-18 13:31:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00492', 'TXN00492', 'Branch Manager', 'Approved', '2026-07-23 18:23:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00493', 'TXN00493', 'Branch Manager', 'Approved', '2026-09-03 22:03:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00494', 'TXN00494', 'Finance Reviewer', 'Approved', '2026-08-07 15:10:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00495', 'TXN00495', 'Operations Lead', 'Approved', '2026-08-10 19:29:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00496', 'TXN00496', 'Operations Lead', 'Approved', '2026-09-26 13:23:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00497', 'TXN00497', 'Operations Lead', 'Approved', '2026-09-29 09:02:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00498', 'TXN00498', 'Branch Manager', 'Approved', '2026-08-06 21:46:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00499', 'TXN00499', 'Finance Reviewer', 'Rejected', '2026-09-24 07:06:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00500', 'TXN00500', 'Branch Manager', 'Approved', '2026-09-27 19:54:00');
    INSERT INTO Approvals (ApprovalID, TransactionID, ApproverRole, ApprovalStatus, ApprovalDate) VALUES ('APR00046', 'TXN00501', 'Branch Manager', 'Approved', '2026-07-23 19:39:00');
    
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00001', 'TXN00001', '2026-09-21 09:01:00', 55680.90, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00002', 'TXN00002', '2026-07-14 17:27:00', 2625.76, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00003', 'TXN00003', '2026-10-03 18:44:00', 40984.38, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00004', 'TXN00004', '2026-07-23 19:27:00', 25683.73, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00005', 'TXN00005', '2026-08-17 21:22:00', 45378.52, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00006', 'TXN00006', '2026-07-14 16:18:00', 62248.00, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00007', 'TXN00008', '2026-09-22 21:23:00', 12408.39, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00008', 'TXN00009', '2026-09-17 18:10:00', 40176.96, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00009', 'TXN00010', '2026-09-28 13:53:00', 57681.44, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00010', 'TXN00011', '2026-07-28 22:36:00', 65758.48, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00011', 'TXN00012', '2026-07-19 12:08:00', 18685.41, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00012', 'TXN00013', '2026-08-18 11:08:00', 38337.09, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00013', 'TXN00014', '2026-09-28 14:38:00', 4998.70, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00014', 'TXN00016', '2026-07-21 15:00:00', 71547.74, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00015', 'TXN00017', '2026-07-14 21:40:00', 22558.75, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00016', 'TXN00018', '2026-09-10 20:59:00', 39893.94, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00017', 'TXN00019', '2026-08-11 11:03:00', 18255.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00018', 'TXN00020', '2026-09-08 20:08:00', 9847.26, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00019', 'TXN00021', '2026-07-29 22:34:00', 56706.07, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00020', 'TXN00022', '2026-08-26 22:33:00', 33998.59, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00021', 'TXN00023', '2026-09-16 11:00:00', 5556.73, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00022', 'TXN00024', '2026-07-13 16:15:00', 21066.18, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00023', 'TXN00025', '2026-08-01 20:30:00', 60610.40, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00024', 'TXN00026', '2026-08-30 21:46:00', 4299.30, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00025', 'TXN00027', '2026-07-15 11:12:00', 14468.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00026', 'TXN00028', '2026-07-12 15:51:00', 64635.85, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00027', 'TXN00029', '2026-07-31 10:26:00', 36551.67, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00028', 'TXN00030', '2026-08-21 12:59:00', 58859.28, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00029', 'TXN00033', '2026-07-14 21:11:00', 5371.97, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00030', 'TXN00034', '2026-09-14 17:02:00', 46548.77, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00031', 'TXN00035', '2026-07-27 18:45:00', 23735.24, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00032', 'TXN00037', '2026-07-17 22:22:00', 66094.60, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00033', 'TXN00038', '2026-09-30 12:39:00', 73793.03, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00034', 'TXN00039', '2026-09-23 09:56:00', 10288.26, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00035', 'TXN00040', '2026-09-19 11:45:00', 25880.30, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00036', 'TXN00041', '2026-07-13 18:27:00', 62243.77, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00037', 'TXN00043', '2026-09-08 08:53:00', 27848.89, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00038', 'TXN00044', '2026-07-06 22:22:00', 15953.22, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00039', 'TXN00045', '2026-09-20 19:09:00', 69450.85, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00040', 'TXN00047', '2026-08-21 21:02:00', 64429.85, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00041', 'TXN00048', '2026-07-29 08:42:00', 14436.45, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00042', 'TXN00050', '2026-07-05 09:38:00', 32733.64, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00043', 'TXN00051', '2026-07-15 14:57:00', 43349.96, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00044', 'TXN00052', '2026-09-26 19:47:00', 55343.57, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00045', 'TXN00053', '2026-09-21 13:42:00', 63639.14, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00046', 'TXN00054', '2026-08-14 14:44:00', 22350.23, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00047', 'TXN00055', '2026-09-20 17:19:00', 30604.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00048', 'TXN00056', '2026-08-31 15:28:00', 50753.14, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00049', 'TXN00057', '2026-09-06 18:40:00', 46539.75, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00050', 'TXN00058', '2026-07-19 08:02:00', 18451.98, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00051', 'TXN00059', '2026-10-03 19:24:00', 37204.69, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00052', 'TXN00060', '2026-08-26 11:11:00', 60357.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00053', 'TXN00061', '2026-08-30 10:51:00', 34982.08, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00054', 'TXN00062', '2026-09-18 21:46:00', 66928.52, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00055', 'TXN00063', '2026-08-29 12:48:00', 18731.17, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00056', 'TXN00064', '2026-08-26 09:45:00', 21608.18, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00057', 'TXN00065', '2026-08-02 14:44:00', 11672.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00058', 'TXN00066', '2026-08-23 08:13:00', 62508.61, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00059', 'TXN00067', '2026-09-03 08:22:00', 22571.30, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00060', 'TXN00068', '2026-09-17 22:14:00', 36745.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00061', 'TXN00070', '2026-07-12 18:27:00', 10393.54, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00062', 'TXN00071', '2026-08-30 13:21:00', 57151.92, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00063', 'TXN00073', '2026-07-06 11:12:00', 62982.36, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00064', 'TXN00074', '2026-09-12 11:29:00', 52535.01, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00065', 'TXN00077', '2026-09-14 20:02:00', 26203.48, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00066', 'TXN00078', '2026-07-04 21:26:00', 61719.24, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00067', 'TXN00079', '2026-07-25 19:33:00', 72419.16, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00068', 'TXN00080', '2026-08-11 21:15:00', 62347.14, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00069', 'TXN00081', '2026-08-15 08:31:00', 63858.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00070', 'TXN00082', '2026-08-06 22:38:00', 52663.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00071', 'TXN00083', '2026-07-31 19:26:00', 36771.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00072', 'TXN00084', '2026-08-27 20:01:00', 7205.74, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00073', 'TXN00086', '2026-08-05 12:16:00', 17482.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00074', 'TXN00087', '2026-07-28 11:47:00', 36443.84, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00075', 'TXN00088', '2026-07-28 12:14:00', 27225.86, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00076', 'TXN00089', '2026-07-09 16:18:00', 52381.95, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00077', 'TXN00091', '2026-08-21 15:04:00', 43382.33, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00078', 'TXN00092', '2026-07-12 11:07:00', 41965.96, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00079', 'TXN00093', '2026-08-19 15:58:00', 33343.40, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00080', 'TXN00094', '2026-09-18 19:06:00', 71082.37, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00081', 'TXN00095', '2026-08-01 10:35:00', 5861.10, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00082', 'TXN00096', '2026-08-01 12:45:00', 21383.20, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00083', 'TXN00097', '2026-08-25 09:34:00', 17054.51, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00084', 'TXN00099', '2026-09-28 14:17:00', 37660.30, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00085', 'TXN00100', '2026-08-13 17:16:00', 2183.40, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00086', 'TXN00101', '2026-09-25 21:17:00', 43324.46, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00087', 'TXN00102', '2026-08-05 10:37:00', 32832.40, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00088', 'TXN00103', '2026-08-13 18:06:00', 64365.55, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00089', 'TXN00104', '2026-09-10 08:29:00', 6832.47, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00090', 'TXN00105', '2026-09-23 21:34:00', 34782.73, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00091', 'TXN00106', '2026-09-20 15:48:00', 4107.98, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00092', 'TXN00107', '2026-07-18 08:40:00', 45763.16, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00093', 'TXN00108', '2026-07-12 11:53:00', 68491.51, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00094', 'TXN00109', '2026-09-05 19:17:00', 31307.90, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00095', 'TXN00110', '2026-08-21 11:58:00', 45053.48, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00096', 'TXN00111', '2026-08-15 22:50:00', 38203.39, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00097', 'TXN00112', '2026-07-21 15:34:00', 36454.52, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00098', 'TXN00113', '2026-07-25 19:15:00', 42991.87, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00099', 'TXN00115', '2026-07-18 16:37:00', 25066.60, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00100', 'TXN00116', '2026-07-05 19:09:00', 30895.90, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00101', 'TXN00118', '2026-09-20 19:56:00', 57015.29, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00102', 'TXN00119', '2026-07-31 19:05:00', 32689.37, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00103', 'TXN00120', '2026-07-05 08:20:00', 59761.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00104', 'TXN00121', '2026-08-22 17:43:00', 59490.83, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00105', 'TXN00122', '2026-09-04 22:37:00', 10948.05, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00106', 'TXN00123', '2026-09-01 22:18:00', 50901.41, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00107', 'TXN00124', '2026-09-23 14:44:00', 18944.84, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00108', 'TXN00125', '2026-08-01 14:36:00', 27082.20, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00109', 'TXN00126', '2026-08-06 08:36:00', 64913.79, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00110', 'TXN00127', '2026-08-02 17:51:00', 26585.99, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00111', 'TXN00128', '2026-09-22 09:57:00', 47152.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00112', 'TXN00129', '2026-07-13 22:18:00', 24672.25, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00113', 'TXN00130', '2026-09-09 16:58:00', 20621.42, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00114', 'TXN00132', '2026-07-13 20:25:00', 1290.42, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00115', 'TXN00133', '2026-09-13 14:52:00', 47981.56, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00116', 'TXN00134', '2026-09-17 11:41:00', 4975.47, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00117', 'TXN00135', '2026-07-18 08:02:00', 23001.25, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00118', 'TXN00136', '2026-08-22 15:23:00', 50368.84, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00119', 'TXN00137', '2026-08-23 18:06:00', 62568.56, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00120', 'TXN00138', '2026-08-29 15:15:00', 64194.90, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00121', 'TXN00139', '2026-07-08 14:17:00', 14438.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00122', 'TXN00140', '2026-07-08 20:21:00', 18456.78, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00123', 'TXN00141', '2026-09-17 11:52:00', 65259.73, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00124', 'TXN00142', '2026-07-17 16:16:00', 59688.91, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00125', 'TXN00143', '2026-09-15 13:01:00', 13274.90, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00126', 'TXN00144', '2026-09-01 15:49:00', 27312.41, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00127', 'TXN00146', '2026-09-28 09:31:00', 53502.00, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00128', 'TXN00147', '2026-07-19 12:39:00', 47572.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00129', 'TXN00148', '2026-08-10 15:32:00', 45505.65, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00130', 'TXN00149', '2026-08-28 15:56:00', 17329.89, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00131', 'TXN00150', '2026-08-13 14:20:00', 49966.81, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00132', 'TXN00151', '2026-07-14 14:06:00', 55908.03, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00133', 'TXN00152', '2026-09-25 09:26:00', 26681.46, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00134', 'TXN00153', '2026-08-16 09:36:00', 38179.09, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00135', 'TXN00154', '2026-09-11 13:07:00', 57254.77, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00136', 'TXN00155', '2026-09-18 22:42:00', 62252.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00137', 'TXN00156', '2026-08-13 13:00:00', 13810.07, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00138', 'TXN00157', '2026-07-12 19:33:00', 16331.18, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00139', 'TXN00158', '2026-09-14 17:05:00', 66279.83, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00140', 'TXN00159', '2026-08-26 18:27:00', 36553.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00141', 'TXN00160', '2026-08-14 14:07:00', 21422.67, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00142', 'TXN00161', '2026-08-01 14:38:00', 4344.95, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00143', 'TXN00162', '2026-08-11 09:00:00', 37429.55, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00144', 'TXN00163', '2026-09-06 16:53:00', 50186.60, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00145', 'TXN00164', '2026-07-12 21:20:00', 43288.00, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00146', 'TXN00165', '2026-07-04 13:10:00', 60148.83, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00147', 'TXN00166', '2026-08-03 14:37:00', 30183.62, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00148', 'TXN00167', '2026-07-10 16:40:00', 8673.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00149', 'TXN00168', '2026-08-02 09:09:00', 19383.62, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00150', 'TXN00169', '2026-08-30 20:36:00', 57050.82, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00151', 'TXN00170', '2026-07-20 15:04:00', 35301.85, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00152', 'TXN00171', '2026-07-12 12:29:00', 34030.56, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00153', 'TXN00172', '2026-09-18 17:32:00', 28990.07, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00154', 'TXN00174', '2026-10-03 09:32:00', 48548.00, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00155', 'TXN00176', '2026-09-22 18:21:00', 5176.91, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00156', 'TXN00178', '2026-08-11 16:24:00', 48351.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00157', 'TXN00179', '2026-09-06 13:01:00', 27354.18, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00158', 'TXN00180', '2026-07-27 11:08:00', 11832.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00159', 'TXN00181', '2026-07-08 18:21:00', 65760.36, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00160', 'TXN00182', '2026-09-30 20:39:00', 60726.02, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00161', 'TXN00183', '2026-08-26 17:18:00', 56491.24, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00162', 'TXN00185', '2026-09-09 14:10:00', 61312.62, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00163', 'TXN00186', '2026-08-18 16:59:00', 7918.58, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00164', 'TXN00187', '2026-08-06 15:57:00', 38623.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00165', 'TXN00188', '2026-07-05 14:03:00', 29984.93, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00166', 'TXN00189', '2026-08-12 22:06:00', 62978.43, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00167', 'TXN00190', '2026-10-01 21:08:00', 56973.38, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00168', 'TXN00192', '2026-08-02 12:07:00', 3819.27, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00169', 'TXN00193', '2026-09-16 16:01:00', 47488.63, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00170', 'TXN00194', '2026-09-18 13:15:00', 42907.11, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00171', 'TXN00196', '2026-07-07 18:24:00', 73582.70, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00172', 'TXN00197', '2026-08-02 19:42:00', 47212.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00173', 'TXN00198', '2026-09-08 13:52:00', 48298.97, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00174', 'TXN00199', '2026-09-19 10:51:00', 10330.23, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00175', 'TXN00200', '2026-07-26 22:02:00', 23840.79, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00176', 'TXN00201', '2026-09-23 11:18:00', 26933.82, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00177', 'TXN00203', '2026-09-29 15:23:00', 69342.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00178', 'TXN00204', '2026-09-10 12:20:00', 7919.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00179', 'TXN00205', '2026-07-23 19:28:00', 26528.14, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00180', 'TXN00206', '2026-09-23 20:03:00', 5859.33, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00181', 'TXN00207', '2026-07-06 10:54:00', 45666.07, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00182', 'TXN00208', '2026-08-17 14:36:00', 2670.80, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00183', 'TXN00209', '2026-09-15 10:33:00', 27679.51, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00184', 'TXN00210', '2026-07-27 15:33:00', 29077.31, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00185', 'TXN00211', '2026-09-19 12:44:00', 68756.80, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00186', 'TXN00212', '2026-07-25 22:45:00', 33522.06, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00187', 'TXN00213', '2026-09-11 16:18:00', 66877.04, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00188', 'TXN00214', '2026-08-01 09:12:00', 59456.91, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00189', 'TXN00216', '2026-09-09 14:49:00', 30855.16, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00190', 'TXN00217', '2026-08-30 18:33:00', 26002.48, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00191', 'TXN00218', '2026-08-25 16:58:00', 65148.82, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00192', 'TXN00220', '2026-07-29 18:35:00', 20765.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00193', 'TXN00221', '2026-09-15 17:09:00', 13047.25, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00194', 'TXN00222', '2026-07-07 09:02:00', 71403.88, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00195', 'TXN00223', '2026-09-20 18:01:00', 37478.34, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00196', 'TXN00224', '2026-08-08 15:04:00', 51723.86, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00197', 'TXN00225', '2026-09-16 10:20:00', 64646.01, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00198', 'TXN00226', '2026-09-04 16:06:00', 24103.91, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00199', 'TXN00227', '2026-07-09 12:24:00', 64846.25, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00200', 'TXN00228', '2026-07-27 20:10:00', 37495.35, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00201', 'TXN00229', '2026-08-22 16:29:00', 72509.83, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00202', 'TXN00230', '2026-09-16 22:53:00', 49155.94, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00203', 'TXN00231', '2026-07-19 22:16:00', 54631.23, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00204', 'TXN00232', '2026-08-18 16:18:00', 5746.50, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00205', 'TXN00234', '2026-09-19 16:25:00', 37630.82, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00206', 'TXN00235', '2026-08-30 10:38:00', 67011.59, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00207', 'TXN00236', '2026-09-15 13:32:00', 62164.63, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00208', 'TXN00237', '2026-08-20 13:43:00', 8442.94, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00209', 'TXN00238', '2026-09-22 20:49:00', 43490.96, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00210', 'TXN00239', '2026-09-21 19:39:00', 58151.81, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00211', 'TXN00240', '2026-07-27 08:28:00', 23698.51, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00212', 'TXN00241', '2026-07-11 19:08:00', 39021.57, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00213', 'TXN00242', '2026-07-26 15:58:00', 40101.25, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00214', 'TXN00246', '2026-08-14 22:28:00', 49283.91, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00215', 'TXN00247', '2026-09-12 19:17:00', 10511.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00216', 'TXN00248', '2026-07-29 18:14:00', 4173.71, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00217', 'TXN00249', '2026-07-01 16:59:00', 12056.10, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00218', 'TXN00250', '2026-08-11 12:41:00', 4672.40, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00219', 'TXN00252', '2026-08-07 22:02:00', 942.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00220', 'TXN00253', '2026-09-06 15:56:00', 70407.40, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00221', 'TXN00254', '2026-08-14 10:46:00', 34553.86, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00222', 'TXN00255', '2026-09-14 18:48:00', 14688.81, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00223', 'TXN00256', '2026-08-12 09:25:00', 50276.88, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00224', 'TXN00257', '2026-07-03 12:24:00', 17855.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00225', 'TXN00258', '2026-08-05 18:23:00', 52034.45, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00226', 'TXN00259', '2026-09-27 16:59:00', 67160.10, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00227', 'TXN00260', '2026-08-20 17:14:00', 16629.86, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00228', 'TXN00261', '2026-08-25 19:35:00', 68481.57, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00229', 'TXN00262', '2026-09-07 15:33:00', 52856.52, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00230', 'TXN00263', '2026-09-05 11:36:00', 40365.35, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00231', 'TXN00264', '2026-09-30 17:31:00', 7047.89, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00232', 'TXN00266', '2026-07-30 17:04:00', 3635.41, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00233', 'TXN00267', '2026-09-02 08:18:00', 30812.80, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00234', 'TXN00268', '2026-08-27 21:58:00', 68030.86, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00235', 'TXN00269', '2026-07-17 10:34:00', 29631.13, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00236', 'TXN00270', '2026-08-30 18:46:00', 40947.29, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00237', 'TXN00271', '2026-08-08 11:59:00', 65671.81, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00238', 'TXN00272', '2026-08-03 11:04:00', 7792.03, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00239', 'TXN00273', '2026-08-21 15:14:00', 40597.05, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00240', 'TXN00274', '2026-08-01 21:58:00', 54930.93, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00241', 'TXN00275', '2026-09-25 16:14:00', 31163.63, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00242', 'TXN00276', '2026-09-20 18:27:00', 41799.84, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00243', 'TXN00277', '2026-10-01 14:26:00', 11404.02, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00244', 'TXN00278', '2026-08-11 21:45:00', 11040.29, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00245', 'TXN00279', '2026-09-10 16:08:00', 29034.32, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00246', 'TXN00280', '2026-07-14 16:46:00', 62248.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00247', 'TXN00281', '2026-07-25 20:48:00', 44171.88, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00248', 'TXN00282', '2026-08-11 22:00:00', 16082.63, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00249', 'TXN00283', '2026-08-04 19:38:00', 52856.70, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00250', 'TXN00284', '2026-08-18 15:34:00', 48741.92, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00251', 'TXN00285', '2026-07-14 20:46:00', 35344.41, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00252', 'TXN00286', '2026-09-11 21:14:00', 55658.62, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00253', 'TXN00287', '2026-08-09 10:12:00', 24907.43, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00254', 'TXN00288', '2026-08-02 20:52:00', 36774.43, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00255', 'TXN00289', '2026-07-25 10:46:00', 41104.34, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00256', 'TXN00290', '2026-09-24 08:48:00', 727.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00257', 'TXN00291', '2026-07-02 11:32:00', 34336.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00258', 'TXN00292', '2026-07-06 08:34:00', 41485.36, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00259', 'TXN00293', '2026-07-05 16:52:00', 52414.97, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00260', 'TXN00294', '2026-07-20 11:12:00', 46578.62, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00261', 'TXN00296', '2026-09-23 21:41:00', 57029.04, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00262', 'TXN00297', '2026-09-21 08:44:00', 13060.92, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00263', 'TXN00299', '2026-07-13 18:59:00', 21207.88, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00264', 'TXN00300', '2026-07-05 11:37:00', 11028.32, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00265', 'TXN00303', '2026-08-14 17:49:00', 46136.43, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00266', 'TXN00305', '2026-09-21 12:51:00', 18672.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00267', 'TXN00306', '2026-08-19 13:23:00', 8214.68, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00268', 'TXN00307', '2026-07-16 10:05:00', 14257.54, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00269', 'TXN00308', '2026-07-12 13:35:00', 7206.55, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00270', 'TXN00309', '2026-08-19 20:05:00', 54432.08, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00271', 'TXN00310', '2026-07-24 10:17:00', 22759.56, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00272', 'TXN00311', '2026-08-09 15:50:00', 5999.87, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00273', 'TXN00315', '2026-08-13 14:17:00', 61282.97, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00274', 'TXN00317', '2026-09-30 09:52:00', 63622.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00275', 'TXN00318', '2026-08-03 12:42:00', 11772.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00276', 'TXN00320', '2026-09-30 22:51:00', 40383.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00277', 'TXN00322', '2026-08-26 09:00:00', 7620.84, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00278', 'TXN00323', '2026-08-29 13:25:00', 34863.97, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00279', 'TXN00325', '2026-08-31 20:13:00', 39203.33, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00280', 'TXN00327', '2026-08-02 16:11:00', 41505.29, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00281', 'TXN00328', '2026-09-21 10:11:00', 48125.80, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00282', 'TXN00329', '2026-09-14 14:24:00', 582.64, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00283', 'TXN00330', '2026-07-27 13:20:00', 14981.30, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00284', 'TXN00331', '2026-09-16 14:39:00', 29592.66, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00285', 'TXN00332', '2026-09-19 17:05:00', 50490.23, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00286', 'TXN00333', '2026-09-27 10:32:00', 29287.63, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00287', 'TXN00335', '2026-07-19 10:20:00', 63188.39, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00288', 'TXN00336', '2026-08-22 16:32:00', 49066.96, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00289', 'TXN00337', '2026-09-04 10:05:00', 42513.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00290', 'TXN00338', '2026-09-09 12:10:00', 58610.33, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00291', 'TXN00339', '2026-08-04 20:34:00', 61790.39, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00292', 'TXN00341', '2026-08-26 21:07:00', 58228.47, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00293', 'TXN00342', '2026-07-24 17:08:00', 58917.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00294', 'TXN00343', '2026-09-18 16:10:00', 24443.11, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00295', 'TXN00344', '2026-09-25 21:06:00', 10385.27, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00296', 'TXN00345', '2026-09-28 21:08:00', 18913.37, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00297', 'TXN00346', '2026-09-19 14:24:00', 34036.38, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00298', 'TXN00348', '2026-08-28 18:42:00', 52372.35, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00299', 'TXN00349', '2026-07-31 15:17:00', 24384.17, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00300', 'TXN00350', '2026-08-14 22:43:00', 57228.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00301', 'TXN00351', '2026-08-29 15:00:00', 74389.91, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00302', 'TXN00352', '2026-07-23 21:59:00', 65775.48, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00303', 'TXN00353', '2026-07-10 14:40:00', 23086.82, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00304', 'TXN00354', '2026-07-02 11:30:00', 6075.92, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00305', 'TXN00355', '2026-07-17 21:27:00', 52128.82, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00306', 'TXN00356', '2026-07-16 13:23:00', 66103.93, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00307', 'TXN00357', '2026-09-19 18:10:00', 33147.43, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00308', 'TXN00358', '2026-07-31 09:57:00', 7759.77, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00309', 'TXN00359', '2026-08-11 20:08:00', 18772.03, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00310', 'TXN00360', '2026-09-29 08:54:00', 63568.48, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00311', 'TXN00363', '2026-08-22 21:53:00', 42736.43, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00312', 'TXN00365', '2026-08-23 14:44:00', 30320.24, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00313', 'TXN00367', '2026-08-11 19:27:00', 54814.39, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00314', 'TXN00369', '2026-09-30 08:10:00', 37356.87, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00315', 'TXN00373', '2026-07-03 08:54:00', 64753.90, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00316', 'TXN00374', '2026-07-24 22:54:00', 2893.43, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00317', 'TXN00375', '2026-08-24 22:46:00', 24165.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00318', 'TXN00376', '2026-07-24 11:51:00', 38804.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00319', 'TXN00377', '2026-08-09 13:05:00', 41593.58, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00320', 'TXN00379', '2026-07-21 08:59:00', 30900.20, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00321', 'TXN00380', '2026-09-26 14:54:00', 55421.68, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00322', 'TXN00381', '2026-09-01 08:09:00', 53446.02, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00323', 'TXN00382', '2026-08-31 19:05:00', 43662.60, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00324', 'TXN00383', '2026-08-27 18:08:00', 17948.69, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00325', 'TXN00385', '2026-07-25 15:29:00', 23723.99, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00326', 'TXN00386', '2026-08-04 21:07:00', 7008.96, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00327', 'TXN00387', '2026-07-19 09:45:00', 18804.35, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00328', 'TXN00388', '2026-07-23 08:25:00', 64131.45, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00329', 'TXN00389', '2026-07-19 09:00:00', 4859.77, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00330', 'TXN00390', '2026-08-18 18:40:00', 70333.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00331', 'TXN00391', '2026-07-06 09:12:00', 67711.58, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00332', 'TXN00394', '2026-07-05 17:39:00', 46369.04, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00333', 'TXN00395', '2026-07-11 09:17:00', 28880.39, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00334', 'TXN00396', '2026-07-06 14:50:00', 53574.46, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00335', 'TXN00397', '2026-08-14 14:17:00', 13691.24, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00336', 'TXN00398', '2026-07-11 20:30:00', 39825.06, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00337', 'TXN00399', '2026-08-05 16:52:00', 59394.98, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00338', 'TXN00400', '2026-08-18 22:53:00', 74367.76, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00339', 'TXN00402', '2026-09-03 16:19:00', 13372.87, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00340', 'TXN00403', '2026-09-09 15:00:00', 25047.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00341', 'TXN00405', '2026-08-17 19:42:00', 29820.77, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00342', 'TXN00406', '2026-08-27 20:40:00', 72059.49, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00343', 'TXN00407', '2026-07-29 18:37:00', 61130.45, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00344', 'TXN00408', '2026-09-30 17:25:00', 63844.08, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00345', 'TXN00411', '2026-07-30 11:44:00', 5317.66, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00346', 'TXN00413', '2026-09-13 18:48:00', 51615.24, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00347', 'TXN00415', '2026-08-13 17:39:00', 67018.66, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00348', 'TXN00417', '2026-08-04 18:18:00', 22480.70, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00349', 'TXN00418', '2026-07-20 08:23:00', 535.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00350', 'TXN00420', '2026-09-01 15:57:00', 49662.74, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00351', 'TXN00421', '2026-08-18 10:28:00', 3485.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00352', 'TXN00422', '2026-07-22 20:44:00', 50143.27, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00353', 'TXN00423', '2026-09-10 08:53:00', 29186.18, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00354', 'TXN00424', '2026-09-02 12:05:00', 29761.63, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00355', 'TXN00426', '2026-07-28 20:12:00', 9682.40, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00356', 'TXN00428', '2026-09-10 13:54:00', 20896.01, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00357', 'TXN00429', '2026-07-15 14:09:00', 11327.93, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00358', 'TXN00430', '2026-08-06 21:34:00', 66040.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00359', 'TXN00431', '2026-07-07 10:17:00', 30372.30, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00360', 'TXN00433', '2026-08-10 12:53:00', 37248.54, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00361', 'TXN00434', '2026-08-11 12:46:00', 31403.76, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00362', 'TXN00435', '2026-09-01 20:33:00', 65072.38, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00363', 'TXN00436', '2026-08-24 10:49:00', 63884.33, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00364', 'TXN00438', '2026-09-03 14:40:00', 69249.75, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00365', 'TXN00439', '2026-07-25 21:30:00', 44119.30, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00366', 'TXN00440', '2026-08-06 08:24:00', 3961.42, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00367', 'TXN00441', '2026-08-06 18:26:00', 38617.77, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00368', 'TXN00442', '2026-09-23 10:38:00', 60114.64, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00369', 'TXN00443', '2026-08-27 22:24:00', 63906.07, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00370', 'TXN00444', '2026-09-18 14:37:00', 7897.83, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00371', 'TXN00445', '2026-08-09 18:06:00', 36259.95, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00372', 'TXN00446', '2026-09-23 19:57:00', 48947.12, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00373', 'TXN00447', '2026-09-24 13:43:00', 10709.73, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00374', 'TXN00448', '2026-08-24 14:47:00', 2890.10, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00375', 'TXN00450', '2026-09-25 22:35:00', 13789.91, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00376', 'TXN00451', '2026-09-27 22:21:00', 49168.99, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00377', 'TXN00452', '2026-08-18 12:37:00', 22230.32, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00378', 'TXN00453', '2026-08-31 22:12:00', 37660.68, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00379', 'TXN00455', '2026-07-12 15:21:00', 47419.70, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00380', 'TXN00456', '2026-07-28 20:49:00', 12853.28, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00381', 'TXN00457', '2026-09-20 14:25:00', 32319.65, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00382', 'TXN00458', '2026-07-03 22:20:00', 56824.37, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00383', 'TXN00459', '2026-08-01 19:56:00', 25990.15, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00384', 'TXN00460', '2026-07-11 21:02:00', 22540.62, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00385', 'TXN00461', '2026-08-26 22:43:00', 74661.56, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00386', 'TXN00463', '2026-07-18 13:45:00', 48877.89, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00387', 'TXN00464', '2026-09-16 08:42:00', 8331.48, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00388', 'TXN00465', '2026-07-16 16:16:00', 35711.13, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00389', 'TXN00466', '2026-09-26 16:17:00', 46804.13, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00390', 'TXN00467', '2026-08-09 09:50:00', 8193.21, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00391', 'TXN00468', '2026-08-16 19:26:00', 22327.50, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00392', 'TXN00469', '2026-08-12 11:00:00', 1203.02, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00393', 'TXN00470', '2026-07-13 20:32:00', 5859.85, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00394', 'TXN00471', '2026-08-04 15:03:00', 7710.72, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00395', 'TXN00472', '2026-08-27 19:07:00', 7351.14, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00396', 'TXN00473', '2026-08-14 13:57:00', 32969.16, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00397', 'TXN00474', '2026-07-27 09:25:00', 30168.70, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00398', 'TXN00476', '2026-09-14 18:28:00', 13799.23, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00399', 'TXN00477', '2026-08-31 22:31:00', 8692.08, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00400', 'TXN00478', '2026-07-02 19:55:00', 50925.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00401', 'TXN00479', '2026-09-08 16:44:00', 52618.37, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00402', 'TXN00481', '2026-09-06 21:30:00', 63927.37, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00403', 'TXN00482', '2026-08-05 08:32:00', 16897.31, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00404', 'TXN00483', '2026-09-14 15:05:00', 64280.04, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00405', 'TXN00484', '2026-07-15 14:26:00', 2928.44, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00406', 'TXN00485', '2026-09-04 16:13:00', 49181.05, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00407', 'TXN00486', '2026-08-31 13:35:00', 57614.38, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00408', 'TXN00487', '2026-07-13 20:42:00', 16825.60, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00409', 'TXN00488', '2026-09-29 09:02:00', 67291.56, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00410', 'TXN00489', '2026-07-25 09:59:00', 63951.53, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00411', 'TXN00490', '2026-07-07 22:40:00', 62850.60, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00412', 'TXN00491', '2026-07-20 15:00:00', 39894.73, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00413', 'TXN00492', '2026-07-24 19:37:00', 13230.36, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00414', 'TXN00493', '2026-09-03 22:24:00', 31545.19, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00415', 'TXN00494', '2026-08-07 15:51:00', 10219.54, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00416', 'TXN00495', '2026-08-11 19:47:00', 70179.53, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00417', 'TXN00497', '2026-09-30 09:48:00', 26579.78, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00418', 'TXN00498', '2026-08-07 22:54:00', 31823.38, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00419', 'TXN00499', '2026-09-24 08:12:00', 20206.63, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00420', 'TXN00500', '2026-09-30 20:18:00', 15499.07, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00421', 'TXN90001', '2026-08-06 00:00:00', 12715.83, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00422', 'TXN90002', '2026-07-16 00:00:00', 18021.57, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00423', 'TXN90003', '2026-07-26 00:00:00', 568.89, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00424', 'TXN90004', '2026-08-02 00:00:00', 738.05, 'Settled');
    INSERT INTO SettlementLedger (SettlementRef, TransactionID, SettlementDate, SettledAmount, SettlementStatus) VALUES ('SET00425', 'TXN90005', '2026-09-02 00:00:00', 17180.52, 'Settled');
    
    
-- =========================================================
-- SECTION 1: TABLE STRUCTURE AND DATA OVERVIEW
-- =========================================================

   DESCRIBE Transactions;
   DESCRIBE Approvals;
   DESCRIBE SettlementLedger;
    
   SELECT COUNT(*) AS TotalTransactions FROM Transactions;
   SELECT COUNT(*) AS TotalApprovals FROM Approvals;
   SELECT COUNT(*) AS TotalSettlements FROM SettlementLedger;
    
  -- Transaction count by status
    
    SELECT TransactionStatus,
    COUNT(*) AS TotalTransactionStatus
    FROM Transactions
    GROUP BY TransactionStatus
    ORDER BY TransactionStatus;

-- =========================================================
-- SECTION 2: R1 - POSSIBLE DUPLICATE ACTIVITY
-- =========================================================

-- Purpose:
-- Identify groups of transactions sharing the same CustomerRef, Amount, and calendar date.

-- Method:
-- TransactionDate is converted to a date, so the time component is excluded from the grouping.

-- Important limitation:
-- This query identifies potential duplicate activity only.Transactions may be legitimate separate attempts, retries, or other activity on the same day. A match does not prove
-- a duplicate payment, fraud, or financial loss.

-- Result:
-- One group containing two transaction rows:TXN00046 and TXN00501. 
-- Both transactions have Failed status.Manual review is required.

    SELECT
       CustomerRef,
       Amount,
       DATE(TransactionDate) AS TransactionDates,
      COUNT(*) AS DuplicateCount
    FROM Transactions
    GROUP BY
       CustomerRef,
       Amount,
       DATE(TransactionDate)
    HAVING COUNT(*) > 1
    ORDER BY DuplicateCount DESC;
    
R1 supporting evidence:
-- Retrieve the individual transaction records in the identified group to support manual review.
    
    SELECT
         TransactionID,
         TransactionDate,
         CustomerRef,
         Amount,
         TransactionStatus,
         ApprovalID
    FROM Transactions
     WHERE CustomerRef = 'CUST2771'
       AND Amount = 25080.86
       AND DATE(TransactionDate) = '2026-07-23'
     ORDER BY TransactionDate;

-- =========================================================
-- SECTION 3: R2 - MISSING APPROVAL REFERENCE
-- =========================================================

-- Check for missing approval references in Transactions table.
    
    SELECT COUNT(*) AS MissingApprovalReferences
    FROM Transactions
     WHERE ApprovalID IS NULL
      OR TRIM(ApprovalID) = '';
    
-- Retrieve the 44 individual transaction records for Rule 2.
    
    SELECT
       TransactionID,
       TransactionDate,
       CustomerRef,
       Amount,
       TransactionStatus,
       ApprovalID
   FROM Transactions
   WHERE ApprovalID IS NULL
    OR TRIM(ApprovalID) = '' 
   ORDER BY TransactionID;
    
-- =========================================================
-- SECTION 4: R3A - MISSING OR MISMATCHED APPROVAL RECORD
-- ========================================================= 
 
-- Purpose:
-- Identify transactions with a nonblank ApprovalID that do not have a matching Approvals record for both TransactionID and ApprovalID.

-- Method:
-- A LEFT JOIN matches both identifiers. Rows without a matching approval record are returned.

-- Result:
-- Five transaction rows were identified.

-- Note:
-- This query identifies the exception but does not by itself explain whether the transaction record is missing or whether the approval identifiers differ.
    
   SELECT 
      t.TransactionID,
      t.ApprovalID
   FROM Transactions t
   LEFT JOIN Approvals a
    ON t.TransactionID = a.TransactionID
     AND t.ApprovalID = a.ApprovalID
    WHERE t.ApprovalID IS NOT NULL
     AND TRIM(t.ApprovalID) <> ''
     AND a.TransactionID IS NULL
    ORDER BY t.TransactionID;

-- =========================================================
-- R3B: DIAGNOSTIC INVESTIGATION OF R3 EXCEPTIONS
-- =========================================================

-- Purpose:
-- Check whether a TransactionID is absent from Approvals or whether its ApprovalID differs from the transaction's ApprovalID.

-- Method:
-- Join on TransactionID only, then compare the two ApprovalID values.

-- Finding:
-- Five transactions had no corresponding record in Approvals for their TransactionID. No ApprovalID mismatches were found.

-- Interpretation:
-- This identifies missing approval records in the available dataset. It does not establish whether approval was never obtained or whether the record was omitted.
    
    SELECT
      t.TransactionID,
      t.ApprovalID AS TransactionApprovalID,
      a.ApprovalID AS ApprovalTableApprovalID,
        CASE
          WHEN a.TransactionID IS NULL
            THEN 'No approval record for TransactionID'
         WHEN a.ApprovalID IS NULL
           OR a.ApprovalID <> t.ApprovalID
            THEN 'TransactionID exists but ApprovalID differs'
     END AS R3Issue
    FROM Transactions t
    LEFT JOIN Approvals a
      ON t.TransactionID = a.TransactionID
      WHERE t.ApprovalID IS NOT NULL
       AND TRIM(t.ApprovalID) <> ''
       AND (
        a.TransactionID IS NULL
        OR a.ApprovalID IS NULL
        OR a.ApprovalID <> t.ApprovalID
     );
      
-- Retrieve the 5 individual transaction records for Rule 3.
      
    SELECT
       t.TransactionID,
       t.TransactionDate,
       t.CustomerRef,
       t.Amount,
       t.TransactionStatus,
       t.ApprovalID
    FROM Transactions t
    LEFT JOIN Approvals a
     ON t.TransactionID = a.TransactionID
      AND t.ApprovalID = a.ApprovalID
    WHERE t.ApprovalID IS NOT NULL
      AND TRIM(t.ApprovalID) <> ''
      AND a.TransactionID IS NULL;
    
-- =========================================================
-- SECTION 5: R4 - APPROVAL NOT APPROVED
-- =========================================================       

-- Check whether transactions with a matching approval record have an ApprovalStatus other than Approved, including blank statuses.
    
    SELECT
      t.TransactionID,
      t.ApprovalID,
      a.ApprovalStatus
    FROM Transactions t
    INNER JOIN Approvals a
     ON t.TransactionID = a.TransactionID
      AND t.ApprovalID = a.ApprovalID
    WHERE t.ApprovalID IS NOT NULL
      AND TRIM(t.ApprovalID) <> ''
      AND (
         a.ApprovalStatus IS NULL
         OR TRIM(a.ApprovalStatus) = ''
         OR TRIM(a.ApprovalStatus) <> 'Approved'
        )
    ORDER BY t.TransactionID;
    
-- Retrieve the 25 individual transaction records for Rule 4.
      
    SELECT
      t.TransactionID,
      t.TransactionDate,
      t.CustomerRef,
      t.Amount,
      t.TransactionStatus,
      t.ApprovalID,
      a.ApprovalStatus
    FROM Transactions t
    INNER JOIN Approvals a
      ON t.TransactionID = a.TransactionID
        AND t.ApprovalID = a.ApprovalID
      WHERE t.ApprovalID IS NOT NULL
        AND TRIM(t.ApprovalID) <> ''
      AND (
          a.ApprovalStatus IS NULL
          OR TRIM(a.ApprovalStatus) = ''
          OR TRIM(a.ApprovalStatus) <> 'Approved'
         )
     ORDER BY t.TransactionID;

-- =========================================================
-- SECTION 6: R5 - SUCCESSFUL TRANSACTION NOT SETTLED
-- =========================================================

-- Check transactions marked Success in the Transactions table that have no corresponding record in SettlementLedger.
    
    SELECT
       t.TransactionID,
       t.TransactionStatus,
       t.Amount
    FROM Transactions t
    LEFT JOIN SettlementLedger s
      ON t.TransactionID = s.TransactionID
      WHERE t.TransactionStatus = 'Success'
        AND s.TransactionID IS NULL
      ORDER BY t.TransactionID;
     
-- Retrieve the 13 individual transaction records for Rule 5.
     
    SELECT
       t.TransactionID,
       t.TransactionDate,
       t.CustomerRef,
       t.Amount,
       t.TransactionStatus,
       t.ApprovalID
    FROM Transactions t
    LEFT JOIN SettlementLedger s
      ON t.TransactionID = s.TransactionID
      WHERE t.TransactionStatus = 'Success'
        AND s.TransactionID IS NULL
      ORDER BY t.TransactionID;

-- =========================================================
-- SECTION 7: R6 - SETTLEMENT AMOUNT MISMATCH
-- =========================================================

-- Compare the transaction amount in Transactions with the settled amount in SettlementLedger for matching transaction IDs.
    
    SELECT 
       t.TransactionID,
       t.Amount AS TransactionAmount,
       s.SettledAmount
    FROM Transactions t
    INNER JOIN SettlementLedger s
      ON t.TransactionID = s.TransactionID
      WHERE t.Amount <> s.SettledAmount
      ORDER BY t.TransactionID;
    
-- Retrieve the 10 individual transaction records for Rule 6.
    SELECT
      t.TransactionID,
      t.TransactionDate,
      t.CustomerRef,
      t.Amount AS TransactionAmount,
      t.TransactionStatus,
      t.ApprovalID,
      s.SettlementRef,
      s.SettledAmount,
      s.SettlementStatus
    FROM Transactions t
    INNER JOIN SettlementLedger s
      ON t.TransactionID = s.TransactionID
      WHERE t.Amount <> s.SettledAmount
      ORDER BY t.TransactionID;

-- =========================================================
-- SECTION 8: R7 - ORPHAN SETTLEMENT RECORD
-- =========================================================

-- Check for records in SettlementLedger whose TransactionID does not exist in the Transactions table and retrieve the R7 records.
    
    SELECT
        s.TransactionID,
        s.SettlementRef,
        s.SettlementDate,
        s.SettledAmount,
        s.SettlementStatus
    FROM SettlementLedger s
    LEFT JOIN Transactions t
     ON s.TransactionID = t.TransactionID
     WHERE t.TransactionID IS NULL
     ORDER BY s.TransactionID;

-- =========================================================
-- SECTION 9: ADDITIONAL DATA-QUALITY CHECKS
-- =========================================================

-- Check duplicate ApprovalIDs values in Approvals.Check whether the Approvals table contains duplicate ApprovalID values

SELECT
ApprovalID,
COUNT(*) AS RecordCount
FROM Approvals
GROUP BY ApprovalID
HAVING COUNT(*) >1;

-- Investigate the records associated with APR00046.
-- Check whether the ID is associated with different transactions.

SELECT
    ApprovalID,
    TransactionID,
    ApproverRole,
    ApprovalStatus,
    ApprovalDate
FROM Approvals
WHERE ApprovalID = 'APR00046';

-- Check for duplicate TransactionID values in SettlementLedger.

SELECT
    TransactionID,
    COUNT(*) AS RecordCount
FROM SettlementLedger
GROUP BY TransactionID
HAVING COUNT(*) > 1;

-- Check for duplicate SettlementRef values in SettlementLedger.

SELECT
    SettlementRef,
    COUNT(*) AS RecordCount
FROM SettlementLedger
GROUP BY SettlementRef
HAVING COUNT(*) > 1;


--  DB Fiddle: https://www.dbfiddle.com/