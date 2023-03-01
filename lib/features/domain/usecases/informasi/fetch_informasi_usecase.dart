import '../../entities/informasi/informasi_entity.dart';
import '../../repositories/network_repository.dart';

class FetchInformasiUsecase {
  final NetworkRepository networkRepository;

  FetchInformasiUsecase({required this.networkRepository});

  Future<List<InformasiEntity>> call(InformasiEntity informasiEntity) {
    return networkRepository.fetchInformasi(informasiEntity);
  }
}
