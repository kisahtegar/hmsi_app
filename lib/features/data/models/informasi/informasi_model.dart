import '../../../domain/entities/informasi/informasi_entity.dart';

class InformasiModel extends InformasiEntity {
  const InformasiModel({
    String? title,
    String? imageUrl,
    String? link,
  }) : super(
          title: title,
          imageUrl: imageUrl,
          link: link,
        );

  factory InformasiModel.fromJson(Map<String, dynamic> json) {
    return InformasiModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      link: json['link'],
    );
  }
}
