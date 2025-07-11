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

    //Gọi phương thức signUpWithEmailPassword từ authRepository để đăng ký người dùng
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
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
