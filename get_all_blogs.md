## 1. Flow qua từng file (theo thứ tự thực thi)

### **A. UI Layer**

#### **File:** `lib/features/blog/presentation/pages/blog_page.dart`

- **Hàm:** `initState` của `_BlogPageState`
  - Gọi: `context.read<BlogBloc>().add(BlogFetchAllBlogs())`
  - **Vai trò:** Khi trang BlogPage được khởi tạo, gửi event yêu cầu lấy tất cả blog lên `BlogBloc`.

---

### **B. Bloc Layer**

#### **File:** `lib/features/blog/presentation/bloc/blog_bloc.dart`

- **Hàm:** `on<BlogFetchAllBlogs>(_onFetchAllBlogs)`
- **Hàm:** `_onFetchAllBlogs`
  - Gọi: `final res = await _getAllBlogs(NoParams())`
  - **Vai trò:** Nhận event, chuyển state sang `BlogLoading`, gọi usecase lấy blog.

---

### **C. Usecase Layer**

#### **File:** `lib/features/blog/domain/usecases/get_all_blogs.dart`

- **Hàm:** `call(NoParams params)`
  - Gọi: `return await blogRepository.getAllBlogs();`
  - **Vai trò:** Đóng vai trò trung gian, gọi repository để lấy dữ liệu blog.

---

### **D. Repository Layer**

#### **File:** `lib/features/blog/data/repositories/blog_repository_impl.dart`

- **Hàm:** `getAllBlogs()`
  - Gọi: `final blogs = await blogRemoteDataSource.getAllBlogs();`
  - **Vai trò:** Kiểm tra kết nối mạng (có thể), gọi remote data source để lấy dữ liệu blog từ backend.

---

### **E. Data Source Layer**

#### **File:** `lib/features/blog/data/datasources/blog_remote_data_source.dart`

- **Hàm:** `getAllBlogs()`
  - Gọi:
    ```dart
    final blogs = await supabaseClient
        .from('blogs')
        .select('*, profiles (name)');
    ```
    - Parse dữ liệu: `.map((blog) => BlogModel.fromJson(blog).copyWith(posterName: blog['profiles']['name']))`
  - **Vai trò:** Gửi truy vấn đến Supabase, lấy dữ liệu blog và thông tin người đăng, chuyển đổi sang `BlogModel`.

---

### **F. Model & Entity Layer**

#### **File:** `lib/features/blog/data/models/blog_model.dart`

- **Hàm:** `BlogModel.fromJson(Map<String, dynamic> map)`
  - **Vai trò:** Chuyển đổi dữ liệu JSON từ backend thành đối tượng `BlogModel`.
- **Hàm:** `copyWith`
  - **Vai trò:** Bổ sung hoặc ghi đè các trường (ví dụ: `posterName`).

#### **File:** `lib/features/blog/domain/entities/blog.dart`

- **Class:** `Blog`
  - **Vai trò:** Định nghĩa entity Blog trả về cho UI.

---

### **G. UI Layer (Tiếp tục)**

#### **File:** `lib/features/blog/presentation/pages/blog_page.dart`

- **Hàm:** `BlocConsumer<BlogBloc, BlogState>`
  - **Logic:** Khi nhận state `BlogsDisplaySuccess`, hiển thị danh sách blog lên UI.

---

## 2. Các hàm hỗ trợ, helper, middleware, service liên quan

- **Kết nối mạng:**
  - `lib/core/network/connection_checker.dart`
    - `ConnectionChecker.isConnected`: Kiểm tra kết nối Internet (có thể dùng trong repository).
- **Xử lý lỗi:**
  - `lib/core/error/exceptions.dart` (`ServerException`)
  - `lib/core/error/failures.dart` (`Failure`)
- **Chuyển đổi dữ liệu:**
  - `BlogModel.fromJson`, `copyWith`
- **Hiển thị thông báo lỗi:**
  - `lib/core/common/widgets/custom_snackbar.dart` (`CustomSnackbar.show`)

---

## 3. Điều kiện logic, pipeline, event tác động đến flow

- **Event:**
  - `BlogFetchAllBlogs` được gửi khi trang BlogPage khởi tạo.
- **State:**
  - `BlogLoading` → `BlogsDisplaySuccess` (thành công) hoặc `BlogFailure` (thất bại).
- **Xử lý lỗi:**
  - Nếu không có blog hoặc lỗi backend, ném exception và chuyển sang state `BlogFailure`.
- **Kết nối mạng:**
  - Nếu không có mạng (có thể), trả về lỗi kết nối.

---

## 4. Sơ đồ flow (dạng danh sách thứ tự)

```mermaid
flowchart TD
    A[BlogPage.initState] --> B[BlogBloc.add(BlogFetchAllBlogs)]
    B --> C[BlogBloc._onFetchAllBlogs]
    C --> D[GetAllBlogs Usecase.call]
    D --> E[BlogRepositoryImpl.getAllBlogs]
    E --> F[BlogRemoteDataSourceImpl.getAllBlogs]
    F --> G[SupabaseClient.from('blogs').select]
    G --> H[BlogModel.fromJson + copyWith]
    H --> I[Trả về List<Blog> cho Bloc]
    I --> J[BlogBloc emit BlogsDisplaySuccess]
    J --> K[UI hiển thị ListView BlogCard]
```

---

## 5. Overview ngắn gọn

**Khi trang BlogPage được mở, event BlogFetchAllBlogs được gửi lên BlogBloc. Bloc gọi usecase GetAllBlogs, usecase này gọi repository, repository gọi remote data source để truy vấn dữ liệu blog từ Supabase. Dữ liệu được chuyển đổi thành BlogModel, trả về Bloc, Bloc emit state BlogsDisplaySuccess, và UI hiển thị danh sách blog. Nếu có lỗi, state BlogFailure sẽ được emit và UI sẽ hiển thị thông báo lỗi.**

---

Nếu bạn cần chi tiết code từng hàm hoặc muốn xem thêm về các phần như caching/local data, hãy cho mình biết!
