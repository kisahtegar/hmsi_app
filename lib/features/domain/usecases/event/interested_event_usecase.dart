import '../../entities/event/event_entity.dart';
import '../../repositories/firebase_repository.dart';

class InterestedEventUseCase {
  final FirebaseRepository firebaseRepository;
  const InterestedEventUseCase({required this.firebaseRepository});

  Future<void> call(EventEntity eventEntity) {
    return firebaseRepository.interestedEvent(eventEntity);
  }
}
