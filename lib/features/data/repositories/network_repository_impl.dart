import '../data_sources/remote_data_source/network_remote_data_source.dart';
import '../../domain/entities/informasi/informasi_entity.dart';
import '../../domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkRemoteDataSource networkRemoteDataSource;

  NetworkRepositoryImpl({required this.networkRemoteDataSource});

  @override
  Future<List<InformasiEntity>> fetchInformasi(
          InformasiEntity informasiEntity) async =>
      networkRemoteDataSource.fetchInformasi(informasiEntity);
}
