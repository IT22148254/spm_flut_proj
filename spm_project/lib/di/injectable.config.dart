// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import '../core/services/auth_service.dart' as _i377;
import 'firebase_auth_module.dart' as _i32;
import 'logger_module.dart' as _i987;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final loggerModule = _$LoggerModule();
    final firebaseAuthModule = _$FirebaseAuthModule();
    gh.lazySingleton<_i974.Logger>(() => loggerModule.logger);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseAuthModule.firebaseAuth);
    gh.lazySingleton<_i377.AuthService>(() => _i377.FirebaseAuthService(
          gh<_i59.FirebaseAuth>(),
          gh<_i974.Logger>(),
        ));
    return this;
  }
}

class _$LoggerModule extends _i987.LoggerModule {}

class _$FirebaseAuthModule extends _i32.FirebaseAuthModule {}
