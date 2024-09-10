import 'package:injectable/injectable.dart';
import 'package:agora_uikit/agora_uikit.dart';

@module
abstract class AgoraModule {
  @lazySingleton
  AgoraClient get client => AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: '398f9cfc09ab44d187c99814699f8bf2',
          channelName: 'praboth',
          tempToken:
              '007eJxTYJhmbhuSaaA/T0/qx9z66zt+S3EEbTQK9fk2IX6KYtMS7XMKDMaWFmmWyWnJBpaJSSYmKYYW5smWlhaGJmaWlmkWSWlG+zMepDUEMjIEL5nExMgAgSA+C0NJanEJAwMA6FseuQ==',
        ),
        enabledPermission: [Permission.camera, Permission.microphone],
      );
}
