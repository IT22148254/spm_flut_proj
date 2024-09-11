// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:agora_uikit/agora_uikit.dart' as _i554;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import '../core/services/auth_service.dart' as _i377;
import '../core/services/user_service.dart' as _i990;
import '../features/videoConference/services/conference_room_service.dart'
    as _i401;
import '../features/videoConference/services/my_agora_service.dart' as _i38;
import 'agora_module.dart' as _i549;
import 'conference_room_service_module.dart' as _i971;
import 'firebase_auth_module.dart' as _i32;
import 'firestore_module.dart' as _i431;
import 'go_router_module.dart' as _i956;
import 'logger_module.dart' as _i987;
import 'user_service_module.dart' as _i695;

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
    final agoraModule = _$AgoraModule();
    final firebaseAuthModule = _$FirebaseAuthModule();
    final firestoreModule = _$FirestoreModule();
    final goRouterModule = _$GoRouterModule();
    final loggerModule = _$LoggerModule();
    final conferenceRoomServiceModule = _$ConferenceRoomServiceModule();
    final userServiceModule = _$UserServiceModule();
    gh.lazySingleton<_i554.AgoraClient>(() => agoraModule.client);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseAuthModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firestoreModule.firestore);
    gh.lazySingleton<_i583.GoRouter>(() => goRouterModule.goRouter);
    gh.lazySingleton<_i974.Logger>(() => loggerModule.logger);
    gh.lazySingleton<_i401.ConferenceRoomService>(
        () => conferenceRoomServiceModule.conferenceRoomService);
    gh.lazySingleton<_i990.UserService>(() => userServiceModule.userService);
    gh.lazySingleton<_i38.MyAgoraService>(() => _i38.MyAgoraServiceImpl());
    gh.lazySingleton<_i377.AuthService>(() => _i377.FirebaseAuthService(
          gh<_i59.FirebaseAuth>(),
          gh<_i974.Logger>(),
        ));
    return this;
  }
}

class _$AgoraModule extends _i549.AgoraModule {}

class _$FirebaseAuthModule extends _i32.FirebaseAuthModule {}

class _$FirestoreModule extends _i431.FirestoreModule {}

class _$GoRouterModule extends _i956.GoRouterModule {}

class _$LoggerModule extends _i987.LoggerModule {}

class _$ConferenceRoomServiceModule extends _i971.ConferenceRoomServiceModule {}

class _$UserServiceModule extends _i695.UserServiceModule {}
