# GaraMan – Hệ thống quản lý gara ô tô (Đề số 30 – PTIT)

Cài đặt các module trong báo cáo *Phân tích thiết kế hệ thống phần mềm*:

| Module (theo báo cáo)                  | Actor    | Trang JSP (`webapp/view/...`)                                                                                         | DAO / Model                                   |
|----------------------------------------|----------|------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| Đăng nhập                              | Tất cả   | `login1.jsp`, `doLogin1.jsp`, `index1.jsp`, `logout1.jsp`                                                              | `MemberDAO1`, `Member1`                       |
| Tìm kiếm thông tin dịch vụ             | Customer | `customer/customerMainFrm1.jsp` → `searchServiceFrm1.jsp` → `serviceDetailFrm1.jsp`                                    | `ServiceDAO1`, `Service1`                     |
| Tìm kiếm thông tin phụ tùng            | Customer | `customer/customerMainFrm1.jsp` → `searchPartFrm1.jsp` → `partDetailFrm1.jsp`                                          | `PartDAO1`, `Part1`                           |
| Thống kê khách hàng theo doanh thu     | Manager  | `manager/managerMainFrm1.jsp` → `selectStatisticFrm1.jsp` → `customerStatisticByRevenueFrm1.jsp` → `invoiceListFrm1.jsp` → `invoiceDetailFrm1.jsp` | `CustomerStatisticDAO1`, `CustomerDAO1`, `InvoiceDAO1`, `CustomerStatistic1`, `Customer1`, `Invoice1`, `InvoiceService1`, `InvoicePart1`, `Vehicle1` |

Tên lớp/hàm bám theo biểu đồ lớp và kịch bản v3.0 của báo cáo (`DAO1`, `searchServiceByName`, `getServiceDetailByID`,
`searchPartByName`, `getPartDetailByID`, `getCustomerStatisticByRevenue`, `getCustomerByID`,
`getInvoiceListByCustomer`, `getInvoiceDetailByID`). Luồng gọi: JSP → DAO → Model đúng như sequence diagram.

## Công nghệ
Java 11+, JSP/Servlet 4 (Tomcat 9 / Jetty 9.4), JDBC, MySQL 8, Maven.

## Cài đặt & chạy

### 1. Tạo CSDL (MySQL)
```sql
CREATE DATABASE garaman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
```bash
mysql -u root -p garaman < database/garaman.sql      # tạo bảng theo ERD + dữ liệu mẫu
```
Sửa `src/main/resources/db.properties` (url, user, password). Có thể ghi đè bằng biến môi trường
`DB_URL`, `DB_USER`, `DB_PASSWORD` hoặc tham số JVM `-Ddb.url=...`.

### 2. Chạy
* **Cách nhanh (không cần cài Tomcat):** `mvn jetty:run` → mở <http://localhost:8080/gara-man/>
* **Không cần cả MySQL (dữ liệu mẫu trong bộ nhớ H2):** `mvn jetty:run -Pdemo`
* **Tomcat 9:** `mvn clean package` → chép `target/gara-man.war` vào `webapps/` của Tomcat 9
  (Tomcat 10+ dùng namespace `jakarta.*` nên không chạy được bản này).
* Chạy kiểm thử DAO: `mvn test` (dùng H2 chế độ MySQL, nạp `database/garaman.sql`).

### 3. Tài khoản mẫu (mật khẩu: `123456`)
| Tài khoản | Vai trò | Dùng cho |
|---|---|---|
| `KH001`, `KH002`, `KH003` | Khách hàng | Tìm kiếm dịch vụ / phụ tùng |
| `manager1` | Quản lý | Xem báo cáo → Thống kê khách hàng theo doanh thu |
| `sales1`, `stock1`, `mech1` | Bán hàng / Kho / Kỹ thuật | Đăng nhập được, nhưng báo cáo chưa có module cho các vai trò này |

Thử nhanh: đăng nhập `manager1` → *Xem báo cáo* → *Thống kê khách hàng theo doanh thu* → chọn `01/01/2026`–`17/09/2026`
→ KH001 (3.500.000 đ, 2 hóa đơn), KH002 (2.100.000 đ) → click khách hàng → click *Xem hóa đơn*.

## Cấu trúc
```
gara-man/
├── pom.xml
├── database/garaman.sql                  # schema theo ERD + dữ liệu mẫu
└── src/
    ├── main/java/com/ptit/garaman/
    │   ├── dao/     DAO1, ServiceDAO1, PartDAO1, MemberDAO1, CustomerDAO1, InvoiceDAO1, CustomerStatisticDAO1
    │   ├── model/   Member1, Customer1, Employee1, Salesman1, Manager1, StockKeeper1, Mechanic1, Vehicle1,
    │   │            Service1, Part1, Invoice1, InvoiceService1, InvoicePart1, CustomerStatistic1
    │   ├── filter/  AuthFilter  (UTF-8 + phân quyền /view/customer, /view/manager)
    │   └── util/    PasswordUtil1 (PBKDF2), Fmt1 (định dạng tiền/ngày, chống XSS)
    ├── main/resources/db.properties
    ├── main/webapp/  index1.jsp, login1.jsp, doLogin1.jsp, logout1.jsp, error1.jsp, assets/style.css
    │   ├── WEB-INF/  web.xml, jspf/header.jspf, jspf/footer.jspf
    │   └── view/customer/*.jsp, view/manager/*.jsp
    └── test/java/.../DaoTest.java
```

## Quy ước nghiệp vụ / khác biệt nhỏ so với báo cáo
* Doanh thu chỉ tính hóa đơn có trạng thái **"Đã thanh toán"**; khoảng ngày tính cả hai đầu mút.
  Doanh thu và danh sách hóa đơn của khách hàng luôn khớp nhau.
* Cột tiền dùng `DOUBLE` (không dùng `FLOAT`) để không mất độ chính xác khi cộng nhiều hóa đơn.
* Lớp chi tiết dịch vụ của hóa đơn đặt tên `InvoiceService1` (theo biểu đồ lớp và kịch bản) thay cho `InvoiceDetail1` trong sơ đồ thư mục.
* `login1.jsp`, `doLogin1.jsp`, `index1.jsp` đặt ở thư mục gốc `webapp/` (đặt trong `WEB-INF` thì trình duyệt không truy cập được).
* Mật khẩu lưu dạng băm PBKDF2 (không lưu rõ); tạo mật khẩu mới bằng `PasswordUtil1.hash("...")`.
* Tìm kiếm không phân biệt hoa/thường; để trống ô từ khóa sẽ liệt kê tất cả.
* Chưa làm các chức năng ngoài 3 module trên (nhập kho, thanh toán, đặt lịch, thống kê dịch vụ/phụ tùng/nhà cung cấp…); bảng CSDL của chúng đã có sẵn trong `garaman.sql`.
