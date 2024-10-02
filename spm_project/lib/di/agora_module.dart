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
              '007eJxTYCiY/E/yoeYLzpBk+ZTQlhu6K/7y5LOGTJyuI39UoDLrjZsCg7GlRZplclqygWVikolJiqGFebKlpYWhiZmlZZpFUprRp6a/aQ2BjAztn44xMjJAIIjPzlBQlJiUX5LBwAAAYFMgsw==',
        ),
        enabledPermission: [Permission.camera, Permission.microphone],
      );

}
