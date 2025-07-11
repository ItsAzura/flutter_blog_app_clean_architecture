import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

//Định nghĩa lớp AuthRepositoryImpl để triển khai các chức năng của AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  //Khởi tạo một đối tượng AuthRemoteDataSource để tương tác với dữ liệu người dùng từ Supabase
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, User>> currentUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  //* Hàm đăng ký tài khoản mới với email và mật khẩu
  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      //Gọi phương thức signUpWithEmailPassword từ remoteDataSource để đăng ký tài khoản mới
      final userId = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      //Nếu userId rỗng, ném ra ngoại lệ ServerException
      if (userId.id.isEmpty) {
        throw ServerException(
          'Failed to sign up. User ID is empty.',
          code: 'USER_ID_EMPTY',
        );
      }

      //Trả về đối tượng User từ userId
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
