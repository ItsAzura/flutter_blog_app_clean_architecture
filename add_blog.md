### 1. Flow đi qua từng file (theo thứ tự)

#### **Bước 1: UI - Người dùng nhấn nút thêm blog**

- **File:** `lib/features/blog/presentation/pages/add_new_blog_page.dart`
  - Người dùng nhập thông tin blog và nhấn nút "Thêm" (hoặc tương tự).
  - Hàm xử lý sự kiện (ví dụ: `onPressed` của nút) sẽ được gọi.

#### **Bước 2: Bloc - Gửi Event**

- **File:** `lib/features/blog/presentation/bloc/blog_bloc.dart`
  - Hàm trong UI sẽ gọi `context.read<BlogBloc>().add(UploadBlogEvent(...))`.
  - Bloc nhận event `UploadBlogEvent`.

#### **Bước 3: Bloc xử lý Event**

- **File:** `lib/features/blog/presentation/bloc/blog_bloc.dart`
  - Bloc nhận event, gọi hàm xử lý (thường là `mapEventToState` hoặc trong `on<UploadBlogEvent>`).
  - Bloc sẽ emit state `BlogLoading`, sau đó gọi usecase upload blog.

#### **Bước 4: Usecase**

- **File:** `lib/features/blog/domain/usecases/upload_blog.dart`
  - Bloc gọi hàm `UploadBlogUseCase.call(params)` để thực hiện logic nghiệp vụ.
  - Usecase kiểm tra điều kiện, chuẩn bị dữ liệu, gọi repository.

#### **Bước 5: Repository (Domain & Data)**

- **File:**
  - Domain: `lib/features/blog/domain/repositories/blog_repository.dart`
  - Data: `lib/features/blog/data/repositories/blog_repository_impl.dart`
  - Usecase gọi `BlogRepository.uploadBlog(...)`.
  - Repository implementation sẽ gọi đến datasource.

#### **Bước 6: DataSource**

- **File:**
  - Remote: `lib/features/blog/data/datasources/blog_remote_data_source.dart`
  - Local (nếu có): `lib/features/blog/data/datasources/blog_local_data_source.dart`
  - Repository gọi hàm upload blog của datasource (thường là remote).
  - DataSource thực hiện gọi API hoặc lưu trữ dữ liệu.

#### **Bước 7: Trả kết quả về UI**

- DataSource trả kết quả về repository → usecase → bloc.
- Bloc emit state thành công/thất bại (`BlogUploadSuccess` hoặc `BlogFailure`).
- UI lắng nghe state và hiển thị thông báo/snackbar hoặc chuyển trang.

---

### 2. Trong mỗi file, các hàm được gọi và vai trò

#### `add_new_blog_page.dart`

- `onPressed` (nút thêm blog): Lấy dữ liệu từ form, gọi `context.read<BlogBloc>().add(UploadBlogEvent(...))`.

#### `blog_bloc.dart`

- `on<UploadBlogEvent>`: Nhận event, emit `BlogLoading`, gọi usecase.
- `emit(BlogUploadSuccess)` hoặc `emit(BlogFailure)`.

#### `upload_blog.dart`

- `call(params)`: Nhận params, gọi repository.

#### `blog_repository.dart` & `blog_repository_impl.dart`

- `uploadBlog(...)`: Interface và implement, chuyển tiếp dữ liệu đến datasource.

#### `blog_remote_data_source.dart`

- `uploadBlog(...)`: Gọi API thêm blog, trả về kết quả.

---

### 3. File/hàm hỗ trợ (helper, util, middleware, service…)

- **CustomSnackbar** (`lib/core/common/widgets/custom_snackbar.dart`): Hiển thị thông báo thành công/thất bại.
- **AppPalette** (`lib/core/theme/app_palette.dart`): Màu sắc giao diện.
- **Các hàm validate, format, pick image** (nếu có): Trong `lib/core/utils/`.

---

### 4. Điều kiện logic, pipeline, event tác động

- Bloc sẽ kiểm tra state hiện tại, emit loading, thành công hoặc thất bại.
- Nếu upload thành công, có thể trigger fetch lại danh sách blog hoặc chuyển trang.
- Nếu thất bại, hiển thị lỗi qua snackbar.

---

### 5. Sơ đồ flow (dạng danh sách thứ tự)

1. **UI:** User nhấn nút thêm blog → Gọi event `UploadBlogEvent`.
2. **Bloc:** Nhận event → Emit `BlogLoading` → Gọi usecase.
3. **Usecase:** Xử lý logic → Gọi repository.
4. **Repository:** Gọi datasource (thường là remote).
5. **DataSource:** Gọi API thêm blog → Nhận kết quả.
6. **Repository → Usecase → Bloc:** Trả kết quả về.
7. **Bloc:** Emit state thành công/thất bại.
8. **UI:** Lắng nghe state → Hiển thị thông báo hoặc chuyển trang.

---

### 6. Overview ngắn gọn

Chức năng thêm blog vận hành theo mô hình Clean Architecture: UI gửi event lên Bloc, Bloc gọi Usecase, Usecase gọi Repository, Repository gọi DataSource để thực hiện thao tác thêm blog (thường là gọi API). Kết quả được trả ngược về qua các tầng, Bloc emit state để UI cập nhật giao diện hoặc hiển thị thông báo cho người dùng.

---

Nếu bạn muốn xem chi tiết code từng hàm hoặc cần sơ đồ dạng hình ảnh, hãy nói rõ nhé!
