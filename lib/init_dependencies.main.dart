part of 'init_dependencies.dart';

//Tạo một đối tượng GetIt để quản lý các phụ thuộc trong ứng dụng
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  //Khởi tạo auth
  _initAuth();

  //Khởi tạo blog
  _initBlog();

  //khởi tạo Sdk Supabase
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  //Đăng ký SupabaseClient vào serviceLocator để sử dụng trong các phần khác của ứng dụng
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
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
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
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

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
