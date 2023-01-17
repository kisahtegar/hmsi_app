import 'package:flutter/material.dart';
import 'package:hmsi_app/features/domain/entities/app_entity.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';
import 'package:hmsi_app/features/presentation/pages/article/detail_article/detail_article_page.dart';
import 'package:hmsi_app/features/presentation/pages/article/edit_article/edit_article_page.dart';
import 'package:hmsi_app/features/presentation/pages/article/upload_article/upload_article_page.dart';
import 'package:hmsi_app/features/presentation/pages/credential/sign_in_page.dart';
import 'package:hmsi_app/features/presentation/pages/credential/sign_up_page.dart';
import 'package:hmsi_app/features/presentation/pages/credential/welcome_page.dart';
import 'package:hmsi_app/features/presentation/pages/profile/edit_profile_page.dart';

import 'const.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageConst.welcomePage:
        return routeBuilder(const WelcomePage());

      case PageConst.signInPage:
        return routeBuilder(const SignInPage());

      case PageConst.signUpPage:
        return routeBuilder(const SignUpPage());

      case PageConst.editProfilePage:
        if (args is UserEntity) {
          return routeBuilder(EditProfilePage(currentUser: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.uploadArticlePage:
        if (args is UserEntity) {
          return routeBuilder(UploadArticlePage(currentUser: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.detailArticlePage:
        if (args is AppEntity) {
          return routeBuilder(DetailArticlePage(appEntity: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.editArticlePage:
        if (args is ArticleEntity) {
          return routeBuilder(EditArticlePage(article: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      default:
        const NoPageFound();
    }
    return null;
  }
}

// Route Builder
dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

// No Page Found
class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: const Center(
        child: Text("No Page Found"),
      ),
    );
  }
}
