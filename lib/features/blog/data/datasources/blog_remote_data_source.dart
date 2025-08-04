import 'dart:io';
import 'dart:typed_data'; // Added for Uint8List

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required dynamic image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);

  //* Hàm tải lên hình ảnh bài viết
  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // Lấy tất cả bài viết từ bảng blogs và thông tin người dùng từ bảng profiles
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)');

      // Nếu không có bài viết nào thì ném ra ngoại lệ
      if (blogs.isEmpty) {
        throw ServerException('No blogs found');
      }

      // Chuyển đổi danh sách bài viết từ Map sang BlogModel và thêm tên người đăng
      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //* Hàm tải lên bài viết
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      // Kiểm tra xem bài viết có hợp lệ không
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();

      //Nếu không có dữ liệu trả về thì ném ra ngoại lệ
      if (blogData.isEmpty) {
        throw ServerException('Failed to upload blog');
      }

      // Chuyển đổi dữ liệu trả về sang BlogModel và trả về
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //* Hàm tải lên hình ảnh bài viết
  @override
  Future<String> uploadBlogImage({
    required dynamic image,
    required BlogModel blog,
  }) async {
    try {
      //Nếu là web thì image sẽ là Uint8List, nếu là mobile thì image sẽ là File
      if (image is File) {
        await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      } else if (image is Uint8List) {
        await supabaseClient.storage
            .from('blog_images')
            .uploadBinary(blog.id, image);
      } else {
        throw ServerException('Invalid image type');
      }

      // Trả về URL công khai của hình ảnh đã tải lên
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
