import '../../entities/user/user_entity.dart';
import '../../repositories/firebase_repository.dart';

class SignUpUserUseCase {
  final FirebaseRepository firebaseRepository;

  SignUpUserUseCase({required this.firebaseRepository});

  Future<void> call(UserEntity userEntity) {
    return firebaseRepository.signUpUser(userEntity);
  }
}
