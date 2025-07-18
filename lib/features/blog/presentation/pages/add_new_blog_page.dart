import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/custom_snackbar.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  Uint8List? webImage;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        if (kIsWeb) {
          webImage = pickedImage.bytes;
          image = null;
        } else {
          image = pickedImage.file;
          webImage = null;
        }
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        ((kIsWeb && webImage != null) || (!kIsWeb && image != null))) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
        BlogUpload(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: kIsWeb ? webImage! : image!,
          topics: selectedTopics,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () {
              uploadBlog();
            },
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            CustomSnackbar.show(
              context,
              state.error,
              backgroundColor: Colors.red, // tuỳ chọn
              duration: Duration(seconds: 2), // tuỳ chọn
              bottomPadding: 10,
            );
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BlogPage()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    (webImage != null || image != null)
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: kIsWeb && webImage != null
                                    ? Image.memory(webImage!, fit: BoxFit.cover)
                                    : image != null
                                        ? Image.file(image!, fit: BoxFit.cover)
                                        : const SizedBox(),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your image',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? const MaterialStatePropertyAll(
                                            AppPalette.gradient1,
                                          )
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPalette.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog title',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
