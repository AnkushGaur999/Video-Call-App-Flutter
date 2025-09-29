import 'package:get_it/get_it.dart';
import 'package:video_call_app/src/config/services/call_service.dart';
import 'package:video_call_app/src/data/repositories/auth_repository_impl.dart';
import 'package:video_call_app/src/domain/repositories/auth_repository.dart';
import 'package:video_call_app/src/domain/use_cases/login_use_case.dart';
import 'package:video_call_app/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:video_call_app/src/presentation/bloc/video_call/video_call_bloc.dart';

/// Global instance of GetIt for dependency injection
GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  ///
  /// Register Services
  ///

  getIt.registerFactory(() => CallService());

  ///
  /// Register Repositories
  ///
  getIt.registerFactory<AuthRepository>(() => AuthRepositoryImpl());

  ///
  /// Register Use Cases
  ///

  getIt.registerFactory(
    () => LoginUseCase(authRepository: getIt<AuthRepository>()),
  );

  ///
  /// Register Blocs
  ///

  getIt.registerFactory(() => AuthBloc(loginUseCase: getIt<LoginUseCase>()));

  getIt.registerFactory(() => VideoCallBloc(callService: getIt<CallService>()));
}
