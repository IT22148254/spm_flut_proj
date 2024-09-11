import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_project/di/injectable.dart';
import 'package:spm_project/features/videoConference/models/conference_room_model.dart';

class ConferenceRoomService {
  final FirebaseFirestore firestore = getit<FirebaseFirestore>();

  // Create a new conference room
  Future<ConferenceRoom> createConferenceRoom(ConferenceRoom conferenceRoom) async {
    try {
      DocumentReference docRef = await firestore
          .collection('conferenceRooms')
          .add(conferenceRoom.toJson());

      return conferenceRoom.copyWith(roomId: docRef.id);
    } catch (e) {
      throw Exception('Failed to create conference room: $e');
    }
  }

  // Get ConferenceRoom by ID from Firestore
  Future<ConferenceRoom?> getConferenceRoomById(String roomId) async {
    try {
      var roomSnapshot = await firestore.collection('conferenceRooms').doc(roomId).get();
      if (roomSnapshot.exists) {
        return ConferenceRoom.fromJson(roomSnapshot.data() as Map<String, dynamic>, roomSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get conference room by ID: $e');
    }
  }


  // Add a participant to the conference room
  Future<void> addParticipant(String roomId, String participantId) async {
    try {
      await firestore.collection('conferenceRooms').doc(roomId).update({
        'participantIds': FieldValue.arrayUnion([participantId])
      });
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  // Remove a participant from the conference room
  Future<void> removeParticipant(String roomId, String participantId) async {
    try {
      await firestore.collection('conferenceRooms').doc(roomId).update({
        'participantIds': FieldValue.arrayRemove([participantId])
      });
    } catch (e) {
      throw Exception('Failed to remove participant: $e');
    }
  }

  // Update the conference room details
  Future<void> updateConferenceRoom(ConferenceRoom conferenceRoom) async {
    try {
      await firestore.collection('conferenceRooms').doc(conferenceRoom.roomId).update(conferenceRoom.toJson());
    } catch (e) {
      throw Exception('Failed to update conference room: $e');
    }
  }

  // Delete a conference room
  Future<void> deleteConferenceRoom(String roomId) async {
    try {
      await firestore.collection('conferenceRooms').doc(roomId).delete();
    } catch (e) {
      throw Exception('Failed to delete conference room: $e');
    }
  }

  // Get all conference rooms hosted by a specific user
  Future<List<ConferenceRoom>> getHostedConferenceRooms(String hostId) async {
    try {
      var roomsSnapshot = await firestore
          .collection('conferenceRooms')
          .where('hostId', isEqualTo: hostId)
          .get();
      
      return roomsSnapshot.docs.map((doc) => ConferenceRoom.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to get hosted conference rooms: $e');
    }
  }

  // Get all conference rooms a user is participating in
  Future<List<ConferenceRoom>> getParticipatedConferenceRooms(String participantId) async {
    try {
      var roomsSnapshot = await firestore
          .collection('conferenceRooms')
          .where('participantIds', arrayContains: participantId)
          .get();
      
      return roomsSnapshot.docs.map((doc) => ConferenceRoom.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to get participated conference rooms: $e');
    }
  }

  // Start a conference (e.g., set isActive to true)
  Future<void> startConference(String roomId) async {
    try {
      await firestore.collection('conferenceRooms').doc(roomId).update({
        'isActive': true,
      });
    } catch (e) {
      throw Exception('Failed to start conference: $e');
    }
  }

  // Stop a conference (e.g., set isActive to false)
  Future<void> stopConference(String roomId) async {
    try {
      await firestore.collection('conferenceRooms').doc(roomId).update({
        'isActive': false,
      });
    } catch (e) {
      throw Exception('Failed to stop conference: $e');
    }
  }

}
