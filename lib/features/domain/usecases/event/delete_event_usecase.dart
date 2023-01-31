import '../../entities/event/event_entity.dart';
import '../../repositories/firebase_repository.dart';

class DeleteEventUseCase {
  final FirebaseRepository firebaseRepository;
  const DeleteEventUseCase({required this.firebaseRepository});

  Future<void> call(EventEntity eventEntity) {
    return firebaseRepository.deleteEvent(eventEntity);
  }
}
