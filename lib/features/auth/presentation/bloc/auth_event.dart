part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

//Các Sự kiện của auth

//* Sự kiện đăng ký người dùng
final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({required this.name, required this.email, required this.password});
}

//* Sự kiện đăng nhập người dùng
final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

//* Sự kiện kiểm tra người dùng đã đăng nhập hay chưa
final class AuthIsUserLoggedIn extends AuthEvent {}

//* Sự kiện đăng xuất người dùng
final class AuthSignOut extends AuthEvent {}
