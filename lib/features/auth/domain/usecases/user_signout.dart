import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignout implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  const UserSignout(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    // Gọi phương thức signOut từ authRepository để đăng xuất người dùng
    return authRepository.signOut().then((result) {
      return result.fold(
        (failure) => left(failure), // Trả về lỗi nếu có
        (_) async {
          // Nếu đăng xuất thành công, trả về thông tin người dùng hiện tại (có thể là null)
          return await authRepository.currentUser();
        },
      );
    });
  }
}
