import 'package:spm_project/features/voice_management/voice_controller.dart';
import 'package:go_router/go_router.dart';

final notesRoute = [
  GoRoute(
    path: '/notes',
    name: 'notes',
    builder: (context, state) => const VoiceController(),
  ),
];
