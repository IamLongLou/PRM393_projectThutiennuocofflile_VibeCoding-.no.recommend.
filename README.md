# Water Billing Collection System - PRM393

Dự án phát triển hệ thống thu tiền nước hoàn chỉnh bằng Flutter dành cho nhân viên ghi chỉ số (Sử dụng AI).

## 📝 Hướng dẫn Luồng Nghiệp vụ (AI Prompt Reference)

Dưới đây là mô tả chi tiết luồng hoạt động của ứng dụng để phục vụ việc phát triển và bảo trì. 
*Lưu ý: 

---

### 1. Khởi động & Truy cập (Phần 1)
- **Splash Screen:** Màn hình khởi chạy với màu xanh đậm (`#1A237E`). Hiển thị logo Water Billing và thanh tiến trình trong 3 giây trước khi tự động chuyển sang Login.
- **Login Screen:** Giao diện đăng nhập tập trung. Hỗ trợ đăng nhập nhanh để demo: nhập bất kỳ thông tin nào hoặc sử dụng `nhanvien01`/`123456` để vào Dashboard.
- **Home Dashboard:** Trung tâm điều hướng với 4 thẻ chức năng chính:
    - **Khách hàng (Tím):** Quản lý danh sách hộ dân.
    - **Đồng bộ (Xanh ngọc):** Quản lý dữ liệu chưa tải lên server.
    - **Thống kê (Xanh dương):** Biểu đồ tiêu thụ cá nhân/khu vực.
    - **Lịch sử (Cam):** Tra cứu toàn bộ hóa đơn đã thu.

### 2. Quy trình Thu tiền & Ghi chỉ số (Phần 2)
- **Danh sách khách hàng:** Hiển thị dưới dạng Card với tên (Nguyen Bao Long, Pham Tu Anh...), địa chỉ và Badge lượng nước hiện tại. Hỗ trợ tìm kiếm thời gian thực.
- **Chi tiết khách hàng:** Hiển thị thông tin liên lạc, vị trí và thẻ chỉ số nước hiện tại (`currentReading`).
- **Lịch sử khách hàng:** Liệt kê các hóa đơn cũ (Tháng, Chỉ số đầu/cuối, Tiêu thụ, Thành tiền). 
- **Ghi chỉ số (Màn 7):** Kích hoạt khi nhấn vào một tháng trong lịch sử. Nhân viên nhập chỉ số mới. Hệ thống tự động kiểm tra: `Chỉ số mới >= Chỉ số cũ`.
- **Chụp ảnh (Màn 8):** Màn hình xác nhận ảnh công tơ. Hiện tại đang giả lập ảnh đồng hồ nước mẫu để chạy mượt mà trên môi trường Web/Chrome.

### 3. Thanh toán & Biên lai (Phần 3)
- **Thanh toán (Màn 9):** Tự động tính toán: `Tiêu thụ = Mới - Cũ`. Áp đơn giá 12.000đ/m³ và VAT 10%. Hiển thị tổng tiền nổi bật với màu hồng (`accentPink`).
- **Biên lai (Màn 10):** Sau khi xác nhận, hệ thống sinh mã hóa đơn duy nhất, cập nhật trạng thái khách hàng thành "Đã hoàn thành" và hiển thị mã QR Code để kiểm tra.
- **Cập nhật tức thì:** Hóa đơn mới sẽ tự động xuất hiện tại đầu danh sách Lịch sử và cập nhật `currentReading` của khách hàng đó ngay lập tức mà không cần load lại trang.

### 4. Thống kê & Đồng bộ (Phần 4)
- **Thống kê (Bảng 11):** Giao diện Modern White UI.
    - Thanh chọn khách hàng nằm ngang với Avatar.
    - Thẻ trạng thái "Đã thanh toán" đen sang trọng.
    - 4 thẻ Summary: Tổng tiêu thụ, Chi phí, Trung bình, Lần ghi cuối.
    - Biểu đồ BarChart thống kê tương quan tiêu thụ 6 tháng.
- **Đồng bộ (Bảng 12):** Giao diện Teal UI.
    - Banner cảnh báo "3 bản ghi chờ đồng bộ".
    - Danh sách các phiếu thu chưa được đẩy lên cloud (Pending).
    - Nút "Sync Now" thực hiện đẩy dữ liệu và làm sạch danh sách chờ.

---

## 🛠 Công nghệ sử dụng
- **Framework:** Flutter 3.x (Hỗ trợ Web/Android/iOS)
- **State Management:** Provider
- **Charts:** fl_chart
- **QR Code:** qr_flutter
- **Mock Data:** Dữ liệu được viết sẵn (hardcoded) trong các Provider để đảm bảo ứng dụng luôn chạy được ngay cả khi không có kết nối Database thật trên trình duyệt.

## 🚀 Cách chạy ứng dụng
1. Mở thư mục dự án trong Android Studio hoặc VS Code.
2. Chạy lệnh: `flutter pub get` để tải các thư viện.
3. Chạy lệnh: `flutter run -d chrome` (hoặc chọn thiết bị giả lập).
4. Đăng nhập với bất kỳ thông tin nào để bắt đầu trải nghiệm.
