import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'features/data/data_sources/remote_data_source/firebase_remote_data_source.dart';
import 'features/data/data_sources/remote_data_source/firebase_remote_data_source_impl.dart';
import 'features/data/repositories/firebase_repository_impl.dart';
import 'features/domain/repositories/firebase_repository.dart';
import 'features/domain/usecases/article/create_article_usecase.dart';
import 'features/domain/usecases/article/delete_article_usecase.dart';
import 'features/domain/usecases/article/like_article_usecase.dart';
import 'features/domain/usecases/article/read_articles_usecase.dart';
import 'features/domain/usecases/article/read_single_article_usecase.dart';
import 'features/domain/usecases/article/update_article_usecase.dart';
import 'features/domain/usecases/comment/create_comment_usecase.dart';
import 'features/domain/usecases/comment/delete_comment_usecase.dart';
import 'features/domain/usecases/comment/like_comment_usecase.dart';
import 'features/domain/usecases/comment/read_comments_usecase.dart';
import 'features/domain/usecases/comment/update_comment_usecase.dart';
import 'features/domain/usecases/event/create_event_usecase.dart';
import 'features/domain/usecases/event/delete_event_usecase.dart';
import 'features/domain/usecases/event/read_events_usecase.dart';
import 'features/domain/usecases/event/read_single_event_usecase.dart';
import 'features/domain/usecases/event/update_event_usecase.dart';
import 'features/domain/usecases/reply/create_reply_usecase.dart';
import 'features/domain/usecases/reply/delete_reply_usecase.dart';
import 'features/domain/usecases/reply/like_reply_usecase.dart';
import 'features/domain/usecases/reply/read_replys_usecase.dart';
import 'features/domain/usecases/reply/update_reply_usecase.dart';
import 'features/domain/usecases/user/create_user_usecase.dart';
import 'features/domain/usecases/user/get_current_uid_usecase.dart';
import 'features/domain/usecases/user/get_single_other_user_usecase.dart';
import 'features/domain/usecases/user/get_single_user_usecase.dart';
import 'features/domain/usecases/user/get_users_usecase.dart';
import 'features/domain/usecases/user/is_sign_in_usecase.dart';
import 'features/domain/usecases/user/sign_in_user_usecase.dart';
import 'features/domain/usecases/user/sign_out_usecase.dart';
import 'features/domain/usecases/user/sign_up_user_usecase.dart';
import 'features/domain/usecases/user/update_user_usecase.dart';
import 'features/domain/usecases/user/upload_image_to_storage_usecase.dart';
import 'features/presentation/cubits/article/article_cubit.dart';
import 'features/presentation/cubits/article/get_single_article/get_single_article_cubit.dart';
import 'features/presentation/cubits/auth/auth_cubit.dart';
import 'features/presentation/cubits/comment/comment_cubit.dart';
import 'features/presentation/cubits/credential/credential_cubit.dart';
import 'features/presentation/cubits/event/event_cubit.dart';
import 'features/presentation/cubits/event/get_single_event/get_single_event_cubit.dart';
import 'features/presentation/cubits/reply/reply_cubit.dart';
import 'features/presentation/cubits/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'features/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'features/presentation/cubits/user/user_cubit.dart';

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

  // GetSingleArticleCubit
  sl.registerFactory(
    () => GetSingleArticleCubit(
      readSingleArticleUseCase: sl.call(),
    ),
  );

  // CommentCubit
  sl.registerFactory(
    () => CommentCubit(
      createCommentUseCase: sl.call(),
      readCommentsUseCase: sl.call(),
      updateCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
    ),
  );

  // ReplyCubit
  sl.registerFactory(
    () => ReplyCubit(
      createReplyUseCase: sl.call(),
      readReplysUseCase: sl.call(),
      updateReplyUseCase: sl.call(),
      deleteReplyUseCase: sl.call(),
      likeReplyUseCase: sl.call(),
    ),
  );

  // EventCubit
  sl.registerFactory(
    () => EventCubit(
      createEventUseCase: sl.call(),
      readEventsUseCase: sl.call(),
      updateEventUseCase: sl.call(),
      deleteEventUseCase: sl.call(),
    ),
  );

  // GetSingleEventCubit
  sl.registerFactory(
    () => GetSingleEventCubit(
      readSingleEventUseCase: sl.call(),
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
      () => ReadSingleArticleUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateArticleUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteArticleUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => LikeArticleUseCase(firebaseRepository: sl.call()));

  // Comment
  sl.registerLazySingleton(
      () => CreateCommentUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadCommentsUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateCommentUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteCommentUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => LikeCommentUseCase(firebaseRepository: sl.call()));

  // Reply
  sl.registerLazySingleton(
      () => CreateReplyUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadReplysUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateReplyUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteReplyUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => LikeReplyUseCase(firebaseRepository: sl.call()));

  // Event
  sl.registerLazySingleton(
      () => CreateEventUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadEventsUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadSingleEventUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateEventUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteEventUseCase(firebaseRepository: sl.call()));

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
