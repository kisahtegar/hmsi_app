import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hmsi_app/features/presentation/pages/credential/welcome_page.dart';
import 'features/presentation/cubits/auth/auth_cubit.dart';
import 'features/presentation/cubits/credential/credential_cubit.dart';
import 'features/presentation/cubits/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'features/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'features/presentation/cubits/user/user_cubit.dart';
import 'features/presentation/pages/main_screen/main_screen.dart';
import 'firebase_options.dart';
import 'on_generate_route.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Calling this cubit when app started
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
      ],
      child: MaterialApp(
        title: 'HMSI App',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: '/',
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return const WelcomePage();
                }
              },
            );
          }
        },
      ),
    );
  }
}
