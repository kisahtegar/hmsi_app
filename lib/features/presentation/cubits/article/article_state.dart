part of 'article_cubit.dart';

abstract class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final List<ArticleEntity> articles;
  const ArticleLoaded({required this.articles});

  @override
  List<Object> get props => [articles];
}

class ArticleFailure extends ArticleState {}
