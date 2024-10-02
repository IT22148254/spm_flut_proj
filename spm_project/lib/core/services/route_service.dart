import 'package:spm_project/features/videoConference/services/conference_routes.dart';
import 'package:spm_project/core/services/auth_routes.dart';
import 'package:spm_project/features/voice_management/services/note_routes.dart';
import 'package:spm_project/features/educational_quiz/quiz_routes.dart';

final appRoutes = [
  ...conferenceRoutes,
  ...authRoutes,
  ...notesRoute,
  ...quizRoutes,
];