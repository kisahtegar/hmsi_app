import '../../entities/user/user_entity.dart';
import '../../repositories/firebase_repository.dart';

class SignInUserUseCase {
  final FirebaseRepository firebaseRepository;

  SignInUserUseCase({required this.firebaseRepository});

  Future<void> call(UserEntity userEntity) {
    return firebaseRepository.signInUser(userEntity);
  }
}
