import '../../entities/event/event_entity.dart';
import '../../repositories/firebase_repository.dart';

class ReadEventsUseCase {
  final FirebaseRepository firebaseRepository;
  const ReadEventsUseCase({required this.firebaseRepository});

  Stream<List<EventEntity>> call(EventEntity eventEntity) {
    return firebaseRepository.readEvents(eventEntity);
  }
}
