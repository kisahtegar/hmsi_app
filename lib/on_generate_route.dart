import 'package:flutter/material.dart';

import 'const.dart';
import 'features/domain/entities/article/article_entity.dart';
import 'features/domain/entities/event/event_entity.dart';
import 'features/domain/entities/user/user_entity.dart';
import 'features/presentation/pages/article/detail_article/detail_article_page.dart';
import 'features/presentation/pages/article/edit_article/edit_article_page.dart';
import 'features/presentation/pages/article/upload_article/upload_article_page.dart';
import 'features/presentation/pages/credential/sign_in_page.dart';
import 'features/presentation/pages/credential/sign_up_page.dart';
import 'features/presentation/pages/credential/welcome_page.dart';
import 'features/presentation/pages/home/about/about_page.dart';
import 'features/presentation/pages/home/event/create_event/create_event_page.dart';
import 'features/presentation/pages/home/event/edit_event/edit_event_page.dart';
import 'features/presentation/pages/home/event/event_page.dart';
import 'features/presentation/pages/profile/edit_profile_page.dart';

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
        if (args is String) {
          return routeBuilder(DetailArticlePage(articleId: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.editArticlePage:
        if (args is ArticleEntity) {
          return routeBuilder(EditArticlePage(article: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.eventPage:
        if (args is UserEntity) {
          return routeBuilder(EventPage(currentUser: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.createEventPage:
        if (args is UserEntity) {
          return routeBuilder(CreateEventPage(currentUser: args));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.editEventPage:
        if (args is EventEntity) {
          return routeBuilder(EditEventPage(event: args));
        } else {
          return routeBuilder(const NoPageFound());
        }
      case PageConst.aboutPage:
        return routeBuilder(const AboutPage());

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
