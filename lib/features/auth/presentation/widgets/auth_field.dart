import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }
        
        // Thêm validation cho email
        if (hintText == 'Email') {
          // Regex cải tiến cho email validation
          final emailRegex = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            caseSensitive: false,
          );
          if (!emailRegex.hasMatch(value.trim())) {
            return "Email không hợp lệ! Ví dụ: example@email.com";
          }
          
          // Kiểm tra thêm một số trường hợp đặc biệt
          if (value.trim().length > 254) {
            return "Email quá dài!";
          }
          
          if (value.trim().startsWith('.') || value.trim().endsWith('.')) {
            return "Email không được bắt đầu hoặc kết thúc bằng dấu chấm!";
          }
        }
        
        // Thêm validation cho password
        if (hintText == 'Password' && value.length < 6) {
          return "Mật khẩu phải có ít nhất 6 ký tự!";
        }
        
        return null;
      },
      obscureText: isObscureText,
    );
  }
}