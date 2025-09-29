import 'package:video_call_app/src/config/data_state.dart';
import 'package:video_call_app/src/data/models/login_response.dart';
import 'package:video_call_app/src/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<DataState<LoginResponse>> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));

    if (email == "john@gmail.com" && password == "123456") {
      return DataSuccess(
        data: LoginResponse(
          success: true,
          message: "Login Successful",
          error: false,
        ),
      );
    } else {
      return DataError(error: "Invalid Email/Password");
    }
  }
}
