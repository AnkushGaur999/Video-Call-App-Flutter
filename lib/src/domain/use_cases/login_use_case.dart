import 'package:video_call_app/src/config/data_state.dart';
import 'package:video_call_app/src/data/models/login_response.dart';
import 'package:video_call_app/src/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<DataState<LoginResponse>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(email, password);
  }
}
