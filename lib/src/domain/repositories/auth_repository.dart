import 'package:video_call_app/src/config/data_state.dart';
import 'package:video_call_app/src/data/models/login_response.dart';

abstract class AuthRepository {
  Future<DataState<LoginResponse>> login(String email, String password);
}
