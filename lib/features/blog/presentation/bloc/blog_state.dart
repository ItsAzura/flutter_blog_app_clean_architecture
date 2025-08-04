part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

//Các trạng thái của blog

//* Trạng thái ban đầu, lúc khởi tạo ứng dụng
final class BlogInitial extends BlogState {}

//* Trạng thái đang tải, thường dùng khi thực hiện các tác vụ như đăng bài, lấy danh sách bài viết
final class BlogLoading extends BlogState {}

//* Trạng thái thành công, khi người dùng đăng bài hoặc lấy danh sách bài viết thành công
final class BlogFailure extends BlogState {
  final String error;
  BlogFailure(this.error);
}

//* Trạng thái thành công khi người dùng đăng bài viết mới
final class BlogUploadSuccess extends BlogState {}

//* Trạng thái thành công khi lấy danh sách bài viết
final class BlogsDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  BlogsDisplaySuccess(this.blogs);
}
