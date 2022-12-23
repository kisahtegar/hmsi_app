import '../../repositories/firebase_repository.dart';

class SignOutUseCase {
  final FirebaseRepository firebaseRepository;

  SignOutUseCase({required this.firebaseRepository});

  Future<void> call() {
    return firebaseRepository.signOut();
  }
}
