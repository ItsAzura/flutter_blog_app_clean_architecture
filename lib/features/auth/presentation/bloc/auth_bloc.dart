import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';

import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserSignout _userSignOut;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserSignout userSignOut,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _userSignOut = userSignOut,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthSignOut>(_onAuthSignOut);
  }

  //* Kiểm tra người dùng đã đăng nhập hay chưa
  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  //* Hàm Đăng ký người dùng
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    //gọi usecase đăng ký người dùng
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    //Trả về kết quả
    res.fold(
      //Thất bại thì emit AuthFailure cùng với message lỗi
      (failure) => emit(AuthFailure(failure.message)),

      //Thành công thì emit AuthSuccess cùng với thông tin người dùng
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  //* Hàm Đăng nhập người dùng
  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    //gọi usecase đăng nhập người dùng
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    //Trả về kết quả
    res.fold(
      //Nếu thất bại thì emit AuthFailure cùng với message lỗi
      (failure) => emit(AuthFailure(failure.message)),

      //Nếu thành công thì emit AuthSuccess cùng với thông tin người dùng
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  //* Hàm emit AuthSuccess
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    //Cập nhật thông tin người dùng trong AppUserCubit
    _appUserCubit.updateUser(user);

    //Emit trạng thái AuthSuccess với thông tin người dùng
    emit(AuthSuccess(user));
  }

  //* Hàm Đăng xuất người dùng
  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    //Gọi usecase đăng xuất người dùng
    final res = await _userSignOut(NoParams());

    res.fold((failure) => emit(AuthFailure(failure.message)), (_) {
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    });

    emit(AuthInitial());
  }
}
