### 1. Flow đi qua từng file (theo thứ tự thường gặp)

**Bước 1: Người dùng nhấn vào một blog trên BlogPage**

- File: `lib/features/blog/presentation/pages/blog_page.dart`
  - Widget: `BlogPage`
  - Hàm: `build` → sử dụng `ListView.builder` để render các `BlogCard`.

**Bước 2: Xử lý sự kiện nhấn vào BlogCard**

- File: `lib/features/blog/presentation/widgets/blog_card.dart`
  - Widget: `BlogCard`
  - Hàm: `onTap` hoặc `GestureDetector`/`InkWell` trong widget này sẽ bắt sự kiện nhấn.
  - Thường sẽ gọi: `Navigator.push(context, MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog)))`

**Bước 3: Hiển thị chi tiết blog**

- File: `lib/features/blog/presentation/pages/blog_viewer_page.dart`
  - Widget: `BlogViewerPage`
  - Hàm: `build` nhận dữ liệu blog (thường qua constructor) và hiển thị chi tiết.

---

### 2. Trong mỗi file, các hàm được gọi và vai trò

#### a. `blog_page.dart`

- `build`: Tạo danh sách blog, mỗi item là một `BlogCard`.
- `BlogCard`: Nhận dữ liệu blog, truyền xuống widget con.

#### b. `blog_card.dart`

- `build`: Hiển thị thông tin tóm tắt blog.
- `onTap`/`GestureDetector`/`InkWell`: Khi nhấn, thực hiện điều hướng sang trang chi tiết blog.

#### c. `blog_viewer_page.dart`

- `build`: Nhận dữ liệu blog từ constructor, render chi tiết blog.

---

### 3. File/hàm hỗ trợ liên quan

- **Model:** `lib/features/blog/domain/entities/blog.dart` (định nghĩa entity Blog)
- **Utils:** Có thể dùng các hàm format ngày, tính thời gian đọc (`lib/core/utils/format_date.dart`, `calculate_reading_time.dart`)
- **Custom Widgets:** Có thể dùng widget hiển thị ảnh, markdown, v.v.
- **Service/Repository:** Nếu trang chi tiết cần fetch lại blog từ server (theo id), sẽ gọi qua repository và datasource.

---

### 4. Điều kiện logic, pipeline, event tác động

- Nếu chỉ truyền object blog từ danh sách sang trang chi tiết: Không có pipeline phức tạp, chỉ là truyền dữ liệu qua constructor.
- Nếu chỉ truyền id, trang chi tiết sẽ gọi event (ví dụ: `BlogFetchDetail`) để lấy dữ liệu blog từ backend, qua các lớp:
  - Bloc/Cubit → UseCase → Repository → DataSource → API
- Có thể có xử lý loading, error, success trong `blog_viewer_page.dart` nếu fetch lại dữ liệu.

---

### 5. Sơ đồ flow (dạng danh sách thứ tự)

1. **BlogPage** (render danh sách blog)
2. **BlogCard** (hiển thị blog, lắng nghe sự kiện nhấn)
3. **onTap BlogCard** → `Navigator.push` đến **BlogViewerPage**
4. **BlogViewerPage** (hiển thị chi tiết blog, có thể fetch lại dữ liệu nếu cần)
5. **(Nếu fetch lại)**: Bloc/Event → UseCase → Repository → DataSource → API → Repository → UseCase → Bloc → UI

---

### 6. Overview ngắn gọn

Khi người dùng nhấn vào một blog trên trang danh sách, app sẽ điều hướng sang trang chi tiết blog (`BlogViewerPage`). Dữ liệu blog có thể được truyền trực tiếp hoặc fetch lại từ server. Toàn bộ flow tuân thủ kiến trúc clean architecture: UI → Bloc → Domain → Data → Remote/Local Source. Các helper như format ngày, tính thời gian đọc có thể được sử dụng để hiển thị thông tin chi tiết hơn.

---

**Nếu bạn cần phân tích chi tiết từng hàm thực tế trong code, hãy thử lại sau khi hệ thống truy cập file ổn định, hoặc cung cấp nội dung file `blog_card.dart` và `blog_viewer_page.dart` để mình phân tích sâu hơn!**
