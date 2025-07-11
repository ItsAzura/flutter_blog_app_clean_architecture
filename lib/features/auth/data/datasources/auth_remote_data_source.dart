import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Định nghĩa 1 interface định nghĩa các chức năng cần thiết để làm việc với dữ liệu người dùng từ Supabase
abstract interface class AuthRemoteDataSource {
  //Lấy phiên đăng nhập
  Session? get currentUserSession;

  //Đăng ký tài khoản mới
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  //Đăng nhập tài khoản
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  //Lấy thông tin người dùng hiện tại
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  //Khởi tạo một đối tượng SupabaseClient để tương tác với Supabase
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  //trả về phiên đăng nhập hiện tại
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  //* Đăng ký tài khoản mới với email và mật khẩu
  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      //nếu tên, email hoặc mật khẩu rỗng thì ném ra ngoại lệ
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw ServerException(
          'Name, email, and password must not be empty.',
          code: 'EMPTY_FIELDS',
        );
      }

      //Gọi phương thức signUp của SupabaseClient để đăng ký người dùng mới
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );

      //Nếu không có người dùng nào được trả về, ném ra ngoại lệ
      if (response.user == null) {
        throw ServerException('User is null!', code: 'USER_NULL');
      }

      //trả về một đối tượng UserModel được tạo từ thông tin người dùng trả về từ Supabase
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException('User is null!', code: 'USER_NULL');
    }
  }
}
