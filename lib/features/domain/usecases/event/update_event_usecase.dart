import '../../entities/event/event_entity.dart';
import '../../repositories/firebase_repository.dart';

class UpdateEventUseCase {
  final FirebaseRepository firebaseRepository;
  const UpdateEventUseCase({required this.firebaseRepository});

  Future<void> call(EventEntity eventEntity) {
    return firebaseRepository.updateEvent(eventEntity);
  }
}
