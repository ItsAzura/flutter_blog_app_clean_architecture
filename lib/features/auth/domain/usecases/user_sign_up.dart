import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

/*

UserSignUp là UseCase (tác vụ nghiệp vụ) dùng để thực hiện đăng ký người dùng.

Nó kế thừa từ interface UseCase<SuccessType, Params>:

- SuccessType = User: nếu thành công, trả về đối tượng User.

- Params = UserSignUpParams: đầu vào là thông tin đăng ký (email, password, name).

*/

class UserSignUp implements UseCase<User, UserSignUpParams> {
  //Khởi tạo một đối tượng AuthRepository để tương tác với dữ liệu người dùng
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  //Triển khai phương thức call để thực hiện đăng ký người dùng
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    //Kiểm tra xem các tham số đầu vào có hợp lệ không
    if (params.email.isEmpty ||
        params.password.isEmpty ||
        params.name.isEmpty) {
      return left(Failure('Email, password, and name must not be empty.'));
    }

    // Thêm validation cho email format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    
    if (!emailRegex.hasMatch(params.email.trim())) {
      return left(Failure('Email không hợp lệ. Vui lòng kiểm tra lại định dạng email.'));
    }

    // Kiểm tra độ dài email
    if (params.email.trim().length > 254) {
      return left(Failure('Email quá dài.'));
    }

    // Kiểm tra độ dài password
    if (params.password.length < 6) {
      return left(Failure('Mật khẩu phải có ít nhất 6 ký tự.'));
    }

    //Gọi phương thức signUpWithEmailPassword từ authRepository để đăng ký người dùng
    return await authRepository.signUpWithEmailPassword(
      name: params.name.trim(),
      email: params.email.trim().toLowerCase(), // Normalize email
      password: params.password,
    );
  }
}

// Định nghĩa lớp UserSignUpParams để chứa các tham số đầu vào cho việc đăng ký người dùng
class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
