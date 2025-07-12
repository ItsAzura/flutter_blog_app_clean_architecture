part of 'init_dependencies.dart';

//Tạo một đối tượng GetIt để quản lý các phụ thuộc trong ứng dụng
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  //Khởi tạo auth
  _initAuth();

  //khởi tạo Sdk Supabase
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  //Đăng ký SupabaseClient vào serviceLocator để sử dụng trong các phần khác của ứng dụng
  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    //* Datasource
    //Đăng ký class AuthRemoteDataSourceImpl là implementation cho interface AuthRemoteDataSource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    //* Repository
    // đăng ký AuthRepositoryImpl làm repository xử lý logic nghiệp vụ.
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    //* Usecases
    // Đăng ký UserSignUp use case để xử lý đăng ký người dùng
    ..registerFactory(() => UserSignUp(serviceLocator()))
    // Đăng ký UserLogin use case để xử lý đăng nhập người dùng
    ..registerFactory(() => UserLogin(serviceLocator()))
    // Đăng ký CurrentUser use case để lấy thông tin người dùng hiện tại
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //* Bloc
    // Đăng ký AuthBloc để quản lý trạng thái đăng nhập và đăng ký
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
