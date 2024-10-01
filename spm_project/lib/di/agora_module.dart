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
              '007eJxTYLD+darrT4SJGLf59d6Zf5cf2KiVqF2Ylr/sqMDT8y93r/dXYDC2tEizTE5LNrBMTDIxSTG0ME+2tLQwNDGztEyzSEozumL9OK0hkJFh8kEVZkYGCATx2RkKihKT8ksyGBgAQ7witA==',
        ),
        enabledPermission: [Permission.camera, Permission.microphone],
      );

}
