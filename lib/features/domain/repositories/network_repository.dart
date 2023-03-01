import '../entities/informasi/informasi_entity.dart';

abstract class NetworkRepository {
  Future<List<InformasiEntity>> fetchInformasi(InformasiEntity informasiEntity);
}
