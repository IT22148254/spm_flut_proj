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
              '007eJxTYLCUksmKmtd0KGFKwbLXGibaNpcdLVSiTr2ZGtg9q5g5rl2BwdjSIs0yOS3ZwDIxycQkxdDCPNnS0sLQxMzSMs0iKc3o1tIHaQ2BjAzRpVIsjAwQCOKzMxQUJSbll2QwMAAAEcMe/w==',
        ),
        enabledPermission: [Permission.camera, Permission.microphone],
      );
}
