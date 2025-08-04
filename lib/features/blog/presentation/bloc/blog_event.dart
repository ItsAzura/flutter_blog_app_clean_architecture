part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

//Các sự kiện của blog

//* Sự kiện đăng bài viết

final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final dynamic image;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

//* Sự kiện lấy tất cả bài viết
final class BlogFetchAllBlogs extends BlogEvent {}
