part of 'get_single_article_cubit.dart';

abstract class GetSingleArticleState extends Equatable {
  const GetSingleArticleState();

  @override
  List<Object> get props => [];
}

class GetSingleArticleInitial extends GetSingleArticleState {}

class GetSingleArticleLoading extends GetSingleArticleState {}

class GetSingleArticleLoaded extends GetSingleArticleState {
  final ArticleEntity article;
  const GetSingleArticleLoaded({required this.article});

  @override
  List<Object> get props => [article];
}

class GetSingleArticleFailure extends GetSingleArticleState {}
