import '../../entities/event/event_entity.dart';
import '../../repositories/firebase_repository.dart';

class ReadSingleEventUseCase {
  final FirebaseRepository firebaseRepository;
  const ReadSingleEventUseCase({required this.firebaseRepository});

  Stream<List<EventEntity>> call(String eventId) {
    return firebaseRepository.readSingleEvent(eventId);
  }
}
