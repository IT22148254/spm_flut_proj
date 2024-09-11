import 'package:spm_project/features/videoConference/services/conference_room_service.dart';
import 'package:injectable/injectable.dart';


@module 
abstract class ConferenceRoomServiceModule {
  @lazySingleton 
  ConferenceRoomService get conferenceRoomService => ConferenceRoomService();
}