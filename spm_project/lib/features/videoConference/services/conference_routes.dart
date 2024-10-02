import 'package:go_router/go_router.dart';
import 'package:spm_project/features/videoConference/screens/room_options_page.dart';
import 'package:spm_project/features/videoConference/screens/start_page.dart';
import 'package:spm_project/features/videoConference/screens/video_conf_page.dart';

final conferenceRoutes = [
  GoRoute(
    path: '/room_create',
    name: 'conference_create_page',
    builder:(context, state) => const StartPage(),
  ),
  GoRoute(
    path: '/video_conf',
    name: 'video_conf_page',
    builder: (context, state) {
      final channelName = state.extra as String;
      return VideoConferencePage(channelName:channelName);},
  ),
  GoRoute(
    path: '/options',
    name: 'options_page',
    builder: (context, state) => const RoomOptionsPage(),
  ),
];