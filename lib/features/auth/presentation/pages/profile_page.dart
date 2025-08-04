import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //BlogBuilder lây thông tin từ AppUserCubit để hiển thị thông tin người dùng
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        //Nếu user đã đăng nhập
        if (state is AppUserLoggedIn) {
          //Lấy thông tin người dùng từ state
          final user = state.user;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Thêm chức năng chỉnh sửa profile nếu muốn
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          //Nếu chưa đăng nhập thì hiển thị thông báo
          return const Center(
            child: Text('No user information', style: TextStyle(fontSize: 18)),
          );
        }
      },
    );
  }
}
