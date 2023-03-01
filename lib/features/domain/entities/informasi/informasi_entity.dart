import 'package:equatable/equatable.dart';

class InformasiEntity extends Equatable {
  final String? title;
  final String? imageUrl;
  final String? link;

  const InformasiEntity({
    this.title,
    this.imageUrl,
    this.link,
  });

  @override
  List<Object?> get props => [
        title,
        imageUrl,
        link,
      ];
}
