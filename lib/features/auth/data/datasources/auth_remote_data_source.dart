import 'dart:developer';

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

  //Đăng xuất người dùng
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  //* Khởi tạo một đối tượng SupabaseClient để tương tác với Supabase
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  //* trả về phiên đăng nhập hiện tại
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      //Nếu mà có phiên đăng nhập thì lấy thông tin người dùng từ bảng profiles
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        //Trả về đối tượng UserModel từ dữ liệu người dùng
        return UserModel.fromJson(
          userData.first,
        ).copyWith(email: currentUserSession!.user.email);
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString(), code: 'GET_CURRENT_USER_ERROR');
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      //nếu email hoặc mật khẩu rỗng thì ném ra ngoại lệ
      if (email.isEmpty || password.isEmpty) {
        throw ServerException(
          'Email and password must not be empty.',
          code: 'EMPTY_FIELDS',
        );
      }

      //Gọi phương thức signInWithPassword của SupabaseClient để đăng nhập người dùng
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('User is null!', code: 'USER_NULL');
      }

      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
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
    } on ServerException {
      // Re-throw ServerException để giữ nguyên thông báo lỗi
      rethrow;
    } catch (e) {
      // Xử lý các lỗi khác từ Supabase
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('email_address_invalid') ||
          errorMessage.contains('invalid email') ||
          errorMessage.contains('email format')) {
        throw ServerException(
          'Email không hợp lệ. Vui lòng kiểm tra lại định dạng email.',
          code: 'INVALID_EMAIL',
        );
      } else if (errorMessage.contains('password') &&
          errorMessage.contains('weak')) {
        throw ServerException(
          'Mật khẩu phải có ít nhất 6 ký tự',
          code: 'WEAK_PASSWORD',
        );
      } else if (errorMessage.contains('already registered') ||
          errorMessage.contains('already exists') ||
          errorMessage.contains('email already')) {
        throw ServerException(
          'Email đã được đăng ký. Vui lòng sử dụng email khác.',
          code: 'EMAIL_EXISTS',
        );
      } else if (errorMessage.contains('network') ||
          errorMessage.contains('connection')) {
        throw ServerException(
          'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.',
          code: 'NETWORK_ERROR',
        );
      } else {
        // Log lỗi để debug
        log('Supabase Error: $e');
        throw ServerException(
          'Lỗi đăng ký: ${e.toString()}',
          code: 'SIGNUP_ERROR',
        );
      }
    }
  }

  @override
  Future<void> signOut() {
    try {
      //Gọi phương thức signOut của SupabaseClient để đăng xuất người dùng
      return supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      // Ném ra ngoại lệ ServerException nếu có lỗi xảy ra
      throw ServerException(e.message);
    } catch (e) {
      // Ném ra ngoại lệ ServerException với thông tin lỗi
      throw ServerException(e.toString());
    }
  }
}
