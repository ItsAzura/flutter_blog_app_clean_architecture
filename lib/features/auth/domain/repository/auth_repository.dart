import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

//Định nghĩa một interface cho AuthRepository để quản lý các chức năng liên quan đến xác thực người dùng.
abstract interface class AuthRepository {
  //Đăng ký người dùng mới bằng email và mật khẩu.
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  //Đăng nhập người dùng bằng email và mật khẩu.
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  //Lấy thông tin người dùng hiện tại.
  Future<Either<Failure, User>> currentUser();

  //Đăng xuất người dùng hiện tại.
  Future<Either<Failure, void>> signOut();
}
