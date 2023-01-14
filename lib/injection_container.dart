import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hmsi_app/features/data/data_sources/remote_data_source/firebase_remote_data_source.dart';
import 'package:hmsi_app/features/data/data_sources/remote_data_source/firebase_remote_data_source_impl.dart';
import 'package:hmsi_app/features/data/repositories/firebase_repository_impl.dart';
import 'package:hmsi_app/features/domain/repositories/firebase_repository.dart';
import 'package:hmsi_app/features/domain/usecases/article/create_article_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/delete_article_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/like_article_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/read_articles_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/update_article_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/create_user_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/get_single_other_user_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/get_single_user_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/get_users_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/is_sign_in_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/sign_in_user_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/sign_out_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/sign_up_user_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/user/update_user_usecase.dart';
import 'package:hmsi_app/features/presentation/cubits/article/article_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/auth/auth_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/credential/credential_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/user/user_cubit.dart';

import 'features/domain/usecases/user/upload_image_to_storage_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // !-- Cubit --!

  // AuthCubit
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  // CredentialCubit
  sl.registerFactory(
    () => CredentialCubit(
      signInUserUseCase: sl.call(),
      signUpUserUseCase: sl.call(),
    ),
  );

  // UserCubit
  sl.registerFactory(
    () => UserCubit(
      getUsersUseCase: sl.call(),
      updateUserUseCase: sl.call(),
    ),
  );

  // GetSingleUserCubit
  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUseCase: sl.call()));

  // GetSingleOtherUserCubit
  sl.registerFactory(
      () => GetSingleOtherUserCubit(getSingleOtherUserUseCase: sl.call()));

  // ArticleCubit
  sl.registerFactory(
    () => ArticleCubit(
      createArticleUseCase: sl.call(),
      readArticlesUseCase: sl.call(),
      updateArticleUseCase: sl.call(),
      deleteArticleUseCase: sl.call(),
      likeArticleUseCase: sl.call(),
    ),
  );

  // !-- Use Cases --!

  // user
  sl.registerLazySingleton(
      () => CreateUserUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => GetCurrentUidUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => GetSingleOtherUserUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => GetSingleUserUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => GetUsersUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => IsSignInUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => SignInUserUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(() => SignOutUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => SignUpUserUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateUserUseCase(firebaseRepository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(firebaseRepository: sl.call()));

  // Article
  sl.registerLazySingleton(
      () => CreateArticleUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadArticlesUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateArticleUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteArticleUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => LikeArticleUseCase(firebaseRepository: sl.call()));

  // !-- Repository --!
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(firebaseRemoteDataSource: sl.call()));

  // !-- Remote Data Source --!
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      firebaseFirestore: sl.call(),
      firebaseAuth: sl.call(),
      firebaseStorage: sl.call(),
    ),
  );

  // !-- External --!
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
