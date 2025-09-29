import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_call_app/src/config/data_state.dart';
import 'package:video_call_app/src/data/models/login_response.dart';
import 'package:video_call_app/src/domain/use_cases/login_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginEvent>(_login);
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await loginUseCase.call(
      email: event.email,
      password: event.password,
    );

    if (result is DataSuccess) {
      emit(AuthSuccess(response: result.data!));
    } else {
      emit(AuthFailure(error: result.error!));
    }
  }
}
