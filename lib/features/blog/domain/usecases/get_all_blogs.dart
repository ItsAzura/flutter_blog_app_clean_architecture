import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);

  //* Hàm lấy tất cả bài viết
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    // Gọi phương thức getAllBlogs từ blogRepository để lấy danh sách bài viết
    return await blogRepository.getAllBlogs();
  }
}
