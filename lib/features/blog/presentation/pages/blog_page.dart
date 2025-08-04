import 'package:blog_app/core/common/widgets/custom_snackbar.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/profile_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/bottom_nav_bar.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [BlogPage(), AddNewBlogPage(), ProfilePage()];

  @override
  void initState() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //BlocListener lắng nghe sự kiện
    return BlocListener<AuthBloc, AuthState>(
      // Lắng nghe sự kiện AuthBloc
      listener: (context, state) {
        //Nếu user đăng xuất thì điều hướng về trang đăng nhập
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blog App'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOut());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),

        body: _selectedIndex == 0
            ? BlocConsumer<BlogBloc, BlogState>(
                listener: (context, state) {
                  if (state is BlogFailure) {
                    CustomSnackbar.show(
                      context,
                      state.error,
                      backgroundColor: Colors.red, // tuỳ chọn
                      duration: Duration(seconds: 2), // tuỳ chọn
                      bottomPadding: 10,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is BlogLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is BlogsDisplaySuccess) {
                    return ListView.builder(
                      itemCount: state.blogs.length,
                      itemBuilder: (context, index) {
                        final blog = state.blogs[index];
                        return BlogCard(
                          blog: blog,
                          color: index % 2 == 0
                              ? AppPalette.gradient1
                              : AppPalette.gradient2,
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              )
            : _pages[_selectedIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
