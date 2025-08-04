part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

//Các trạng thái của auth

//* Trạng thái ban đầu, lúc khởi tạo ứng dụng
final class AuthInitial extends AuthState {}

//* Trạng thái đang tải, thường dùng khi thực hiện các tác vụ như đăng nhập, đăng ký
final class AuthLoading extends AuthState {}

//* Trạng thái thành công, khi người dùng đăng nhập hoặc đăng ký thành công
final class AuthSuccess extends AuthState {
  // Thông tin User
  final User user;

  AuthSuccess(this.user);
}

//* Trạng thái thất bại, khi có lỗi xảy ra trong quá trình đăng nhập hoặc đăng ký
final class AuthFailure extends AuthState {
  // Thông báo lỗi
  final String message;

  AuthFailure(this.message);
}
