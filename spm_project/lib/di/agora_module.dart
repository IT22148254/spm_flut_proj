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
              '007eJxTYGBd9oN3n/Ocyj1FPP1GjZtti1XXrm0scuHfKaulb7JnRZkCg7GlRZplclqygWVikolJiqGFebKlpYWhiZmlZZpFUprRuejfaQ2BjAyXt09gYIRCEJ+doaAoMSm/JIOBAQAzeh/k',
        ),
        enabledPermission: [Permission.camera, Permission.microphone],
      );

}
