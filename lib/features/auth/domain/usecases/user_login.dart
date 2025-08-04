import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  // Triển khai phương thức call để thực hiện đăng nhập người dùng
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    // Kiểm tra xem các tham số đầu vào có hợp lệ không
    if (params.email.isEmpty || params.password.isEmpty) {
      return left(Failure('Email and password must not be empty.'));
    }

    // Thêm validation cho email format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(params.email.trim())) {
      return left(
        Failure('Email không hợp lệ. Vui lòng kiểm tra lại định dạng email.'),
      );
    }

    // Kiểm tra độ dài email
    if (params.email.trim().length > 254) {
      return left(Failure('Email quá dài.'));
    }

    // Kiểm tra độ dài password
    if (params.password.length < 6) {
      return left(Failure('Mật khẩu phải có ít nhất 6 ký tự.'));
    }

    // Gọi phương thức loginWithEmailPassword từ authRepository để đăng nhập người dùng
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
