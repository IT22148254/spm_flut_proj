import 'package:go_router/go_router.dart';
import 'package:spm_project/features/videoConference/screens/start_page.dart';
import 'package:spm_project/features/videoConference/screens/video_conf_page.dart';

final conferenceRoutes = [
  GoRoute(
    path: '/rooms',
    name: 'conference_start_page',
    // builder: (context, state) => const StartPage(),
    builder:(context, state) => const StartPage(),
  ),
  GoRoute(
    path: '/video_conf',
    name: 'video_conf_page',
    builder: (context, state) => const VideoConferencePage(),
  ),
];