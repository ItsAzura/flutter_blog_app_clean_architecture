import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  //* Đăng bài viết mới
  Future<Either<Failure, Blog>> uploadBlog({
    required dynamic image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  //* Lấy tất cả bài viết
  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
