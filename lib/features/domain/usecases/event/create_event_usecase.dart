import '../../entities/event/event_entity.dart';
import '../../repositories/firebase_repository.dart';

class CreateEventUseCase {
  final FirebaseRepository firebaseRepository;
  const CreateEventUseCase({required this.firebaseRepository});

  Future<void> call(EventEntity eventEntity) {
    return firebaseRepository.createEvent(eventEntity);
  }
}
