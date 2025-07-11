import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

//Định nghĩa 1 interface cho các UseCase trong ứng dụng
/*

SuccessType: kiểu dữ liệu khi xử lý thành công (VD: User, List<Post>, void...).

Params: tham số đầu vào (VD: LoginParams, SignUpParams...).

Either<Failure, SuccessType>: đảm bảo mọi kết quả đều có thể là lỗi (Failure) hoặc kết quả thành công (SuccessType)

*/
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
