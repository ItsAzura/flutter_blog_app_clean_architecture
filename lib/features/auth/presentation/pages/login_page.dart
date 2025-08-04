import 'package:blog_app/core/common/widgets/custom_snackbar.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        //Blog Consumer lắng nghe state khi user đăng nhập
        child: BlocConsumer<AuthBloc, AuthState>(
          //BlogListener thì lắng nghe state để thực hiện hành động
          listener: (context, state) {
            //Nếu thất bại thì hiện thông báo thất bại
            if (state is AuthFailure) {
              CustomSnackbar.show(
                context,
                state.message,
                backgroundColor: Colors.green, // tuỳ chọn
                duration: Duration(seconds: 2), // tuỳ chọn
                bottomPadding: 10,
              );
              //Nếu thành công thì hiện thông báo thành công
            } else if (state is AuthSuccess) {
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   BlogPage.route(),
              //   (route) => false,
              // );
              CustomSnackbar.show(
                context,
                "Login Successful!",
                backgroundColor: Colors.green, // tuỳ chọn
                duration: Duration(seconds: 2), // tuỳ chọn
                bottomPadding: 10,
              );
            }
          },
          //BlogBuilder thì lắng nghe state để cập nhật giao diện
          builder: (context, state) {
            //Nếu đang tải thì hiện CircularProgressIndicator
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In.',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  AuthField(hintText: 'Email', controller: emailController),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),
                  AuthButton(
                    buttonText: 'Sign in',
                    onPressed: () {
                      //Kiểm tra form có hợp lệ không
                      if (formKey.currentState!.validate()) {
                        //Nếu hợp lệ thì gọi sự kiện AuthLogin
                        context.read<AuthBloc>().add(
                          AuthLogin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SignUpPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppPalette.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
