-- =====================================================================
-- GaraMan - Co so du lieu (theo ERD trong bao cao, bang tbl...1)
-- Cach dung (MySQL 8):
--   CREATE DATABASE garaman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
--   mysql -u root -p garaman < database/garaman.sql
-- Tai khoan mau: mat khau tat ca = 123456
--   manager1 (Quan ly) | sales1 | stock1 | mech1 | KH001, KH002, KH003 (Khach hang)
-- =====================================================================

DROP TABLE IF EXISTS tblStockInReceiptPart1;
DROP TABLE IF EXISTS tblStockInReceipt1;
DROP TABLE IF EXISTS tblSupplier1;
DROP TABLE IF EXISTS tblInvoicePart1;
DROP TABLE IF EXISTS tblInvoiceService1;
DROP TABLE IF EXISTS tblInvoice1;
DROP TABLE IF EXISTS tblAppointment1;
DROP TABLE IF EXISTS tblVehicle1;
DROP TABLE IF EXISTS tblEmployee1;
DROP TABLE IF EXISTS tblPart1;
DROP TABLE IF EXISTS tblService1;
DROP TABLE IF EXISTS tblMember1;

CREATE TABLE tblMember1 (
  id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  birthday DATE NULL,
  address VARCHAR(255) NULL,
  email VARCHAR(255) NULL,
  phoneNumber VARCHAR(255) NULL,
  role VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uq_member_username UNIQUE (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblEmployee1 (
  tbMember1id INT NOT NULL,
  position VARCHAR(255) NOT NULL,
  PRIMARY KEY (tbMember1id),
  CONSTRAINT fk_employee_member FOREIGN KEY (tbMember1id) REFERENCES tblMember1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblVehicle1 (
  id INT NOT NULL AUTO_INCREMENT,
  description VARCHAR(255) NULL,
  licensePlate VARCHAR(255) NOT NULL,
  customerId INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_vehicle_customer FOREIGN KEY (customerId) REFERENCES tblMember1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblAppointment1 (
  id INT NOT NULL AUTO_INCREMENT,
  creationTime DATE NOT NULL,
  appointmentTime DATE NOT NULL,
  status VARCHAR(255) NOT NULL,
  customerId INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_appointment_customer FOREIGN KEY (customerId) REFERENCES tblMember1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblService1 (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  price DOUBLE NOT NULL,
  description VARCHAR(1000) NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblPart1 (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  price DOUBLE NOT NULL,
  description VARCHAR(1000) NULL,
  remainingQuantity INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblInvoice1 (
  id INT NOT NULL AUTO_INCREMENT,
  `time` DATE NOT NULL,
  totalAmount DOUBLE NOT NULL,
  status VARCHAR(255) NOT NULL,
  customerId INT NOT NULL,
  employeeId INT NOT NULL,
  vehicleId INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_invoice_customer FOREIGN KEY (customerId) REFERENCES tblMember1(id),
  CONSTRAINT fk_invoice_employee FOREIGN KEY (employeeId) REFERENCES tblEmployee1(tbMember1id),
  CONSTRAINT fk_invoice_vehicle FOREIGN KEY (vehicleId) REFERENCES tblVehicle1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblInvoiceService1 (
  id INT NOT NULL AUTO_INCREMENT,
  totalAmount DOUBLE NOT NULL,
  quantity INT NOT NULL,
  employeeId INT NOT NULL,
  invoiceId INT NOT NULL,
  serviceId INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_is_employee FOREIGN KEY (employeeId) REFERENCES tblEmployee1(tbMember1id),
  CONSTRAINT fk_is_invoice FOREIGN KEY (invoiceId) REFERENCES tblInvoice1(id),
  CONSTRAINT fk_is_service FOREIGN KEY (serviceId) REFERENCES tblService1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblInvoicePart1 (
  id INT NOT NULL AUTO_INCREMENT,
  totalAmount DOUBLE NOT NULL,
  quantity INT NOT NULL,
  invoiceId INT NOT NULL,
  partId INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_ip_invoice FOREIGN KEY (invoiceId) REFERENCES tblInvoice1(id),
  CONSTRAINT fk_ip_part FOREIGN KEY (partId) REFERENCES tblPart1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblSupplier1 (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NULL,
  phoneNumber VARCHAR(255) NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblStockInReceipt1 (
  id INT NOT NULL AUTO_INCREMENT,
  code VARCHAR(255) NOT NULL,
  `time` DATE NOT NULL,
  totalPrice DOUBLE NOT NULL,
  status VARCHAR(255) NOT NULL,
  employeeId INT NOT NULL,
  supplierId INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uq_receipt_code UNIQUE (code),
  CONSTRAINT fk_receipt_employee FOREIGN KEY (employeeId) REFERENCES tblEmployee1(tbMember1id),
  CONSTRAINT fk_receipt_supplier FOREIGN KEY (supplierId) REFERENCES tblSupplier1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblStockInReceiptPart1 (
  id INT NOT NULL AUTO_INCREMENT,
  totalPrice DOUBLE NOT NULL,
  quantity INT NOT NULL,
  stockInReceiptId INT NOT NULL,
  partId INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_sirp_receipt FOREIGN KEY (stockInReceiptId) REFERENCES tblStockInReceipt1(id),
  CONSTRAINT fk_sirp_part FOREIGN KEY (partId) REFERENCES tblPart1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================ DU LIEU MAU ============================
INSERT INTO tblMember1 (id, username, password, name, birthday, address, email, phoneNumber, role) VALUES
 (1, 'manager1', 'pbkdf2$65536$a4c123b1612dd272d1371c17149d4395$f0b5eb2f81fe04544cfffff5837ebe4b55f0323f5a417deefe858e7c59601d15', 'Nguyễn Quản Lý', '1985-03-10', 'Cầu Giấy, TP. Hà Nội', 'manager@garaman.vn', '0900000001', 'manager'),
 (2, 'sales1',   'pbkdf2$65536$36b3216fdaeeb975729fae923d5a4fd1$7224f0a6bd48816d2ecd1de7c2170e7fae4fea0be9b3e8f45be61878e4f56786', 'Trần Thị Ngọc C', '1995-07-21', 'Thanh Xuân, TP. Hà Nội', 'sales@garaman.vn', '0900000002', 'salesman'),
 (3, 'stock1',   'pbkdf2$65536$2aabfe228f219e9cb0eb53f16947ccf2$612384fd4a57e59434510436f11fca7c7f72227dd15e682464fe77e0359b852d', 'Hoàng Văn Kho', '1990-01-05', 'Long Biên, TP. Hà Nội', 'stock@garaman.vn', '0900000003', 'stockkeeper'),
 (4, 'mech1',    'pbkdf2$65536$5ec84d8dbc74254770f58904dba41ecc$a43e33163316e3ab826859bfaf75b2e5df68045024212471de93d66575d59a07', 'Lê Văn Kỹ Thuật', '1992-11-30', 'Nam Từ Liêm, TP. Hà Nội', 'mech@garaman.vn', '0900000004', 'mechanic'),
 (5, 'KH001',    'pbkdf2$65536$cc3fc1626e53a13043b026c48bbf33fe$0803c79e3aa6951a44a3df4568d8b177a46690f0c0fbb97acfa2f5d1f1ea7d1a', 'Nguyễn Văn A', '1998-02-14', 'Hà Đông, TP. Hà Nội', 'nguyenvana@example.com', '0901234567', 'customer'),
 (6, 'KH002',    'pbkdf2$65536$ff9243a8f506b40928b5b7a767c76fb0$83a9554810914b1fc836ef52378cfc92dacd901c5be9ff01853cc674c41ea570', 'Trần Thị B', '2000-09-09', 'Đống Đa, TP. Hà Nội', 'tranthib@example.com', '0912345678', 'customer'),
 (7, 'KH003',    'pbkdf2$65536$08f86bebb2737f6a6f0fb23c6f5da2ce$67e53cdc96d39c68e76bba9ec92fbb9651dc3c684cbb0dcbc0c77bacb648d58a', 'Phạm Văn E', '1996-12-25', 'Hai Bà Trưng, TP. Hà Nội', 'phamvane@example.com', '0923456789', 'customer');

INSERT INTO tblEmployee1 (tbMember1id, position) VALUES
 (1, 'Manager'), (2, 'Salesman'), (3, 'StockKeeper'), (4, 'Mechanic');

INSERT INTO tblVehicle1 (id, description, licensePlate, customerId) VALUES
 (1, 'Toyota Vios 2020', '30A-123.45', 5),
 (2, 'Honda City 2021', '29B-678.90', 6),
 (3, 'Mazda 3 2019', '30F-111.22', 7);

INSERT INTO tblService1 (id, name, price, description) VALUES
 (1, 'Thay dầu máy', 250000, 'Thay dầu máy định kỳ là một hoạt động bảo vệ hệ thống động cơ của xe. Bởi dầu nhớt là một dung dịch đảm nhận vai trò bôi trơn, hạn chế sự ma sát, từ đó giúp động cơ vận hành mượt mà hơn. Nắm được thời gian cũng như cách tự thay dầu nhớt đơn giản tại nhà giúp người lái tiết kiệm được một khoản chi phí bảo dưỡng.'),
 (2, 'Thay dầu hộp số', 350000, 'Thay dầu hộp số giúp bôi trơn các bánh răng, giảm mài mòn và giữ cho xe sang số êm ái, kéo dài tuổi thọ hộp số.'),
 (3, 'Rửa xe', 200000, 'Rửa xe toàn bộ ngoại thất và hút bụi nội thất.');

INSERT INTO tblPart1 (id, name, price, description, remainingQuantity) VALUES
 (1, 'Má phanh trước', 500000, 'Má phanh trước là bộ phận quan trọng trong hệ thống phanh của ô tô, có chức năng tạo ma sát với đĩa phanh để giúp xe giảm tốc độ và dừng lại an toàn. Sản phẩm được sử dụng để thay thế má phanh đã bị mòn hoặc hư hỏng, giúp duy trì hiệu quả phanh và đảm bảo an toàn trong quá trình vận hành.', 12),
 (2, 'Má phanh sau', 380000, 'Má phanh sau giúp cân bằng lực phanh giữa hai cầu xe, đảm bảo xe dừng ổn định.', 8),
 (3, 'Ắc quy 12V', 1270000, 'Ắc quy 12V cung cấp điện khởi động động cơ và duy trì hoạt động của các thiết bị điện trên xe.', 5);

-- Hoa don (status: 'Đã thanh toán' / 'Chưa thanh toán')
INSERT INTO tblInvoice1 (id, `time`, totalAmount, status, customerId, employeeId, vehicleId) VALUES
 (1, '2026-01-01', 2500000, 'Đã thanh toán', 5, 2, 1),
 (2, '2026-06-01', 1000000, 'Đã thanh toán', 5, 2, 1),
 (3, '2026-03-15', 2100000, 'Đã thanh toán', 6, 2, 2),
 (4, '2026-08-20',  800000, 'Chưa thanh toán', 6, 2, 2),
 (5, '2025-12-15', 1000000, 'Đã thanh toán', 5, 2, 1);

INSERT INTO tblInvoiceService1 (id, totalAmount, quantity, employeeId, invoiceId, serviceId) VALUES
 (1, 500000, 2, 4, 1, 1),
 (2, 350000, 1, 4, 1, 2),
 (3, 500000, 2, 4, 2, 1),
 (4, 250000, 1, 4, 3, 1),
 (5, 200000, 1, 4, 3, 3),
 (6, 500000, 2, 4, 4, 1),
 (7, 500000, 2, 4, 5, 1);

INSERT INTO tblInvoicePart1 (id, totalAmount, quantity, invoiceId, partId) VALUES
 (1, 380000, 1, 1, 2),
 (2, 1270000, 1, 1, 3),
 (3, 500000, 1, 2, 1),
 (4, 380000, 1, 3, 2),
 (5, 1270000, 1, 3, 3),
 (6, 300000, 1, 4, 2),
 (7, 500000, 1, 5, 1);

INSERT INTO tblSupplier1 (id, name, address, phoneNumber) VALUES
 (1, 'Công ty Phụ tùng Việt Nhật', 'Hà Nội', '0243000111');

INSERT INTO tblStockInReceipt1 (id, code, `time`, totalPrice, status, employeeId, supplierId) VALUES
 (1, 'PN001', '2026-01-02', 5000000, 'Đã nhập', 3, 1);

INSERT INTO tblStockInReceiptPart1 (id, totalPrice, quantity, stockInReceiptId, partId) VALUES
 (1, 5000000, 10, 1, 1);
