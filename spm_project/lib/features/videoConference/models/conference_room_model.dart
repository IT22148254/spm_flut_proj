class ConferenceRoom { 
  final String roomId;
  final String roomName;
  final String hostId;
  final List<String> participantIds;
  final bool isActive;

  ConferenceRoom({
    required this.roomId,
    required this.roomName,
    required this.hostId,
    required this.participantIds,
    this.isActive = false,
  });

  //conversion of JSON to ConferenceRoom object
  //@param json: JSON object
  //@return ConferenceRoom object
  factory ConferenceRoom.fromJson(Map<String,dynamic> json, String docId){
    return ConferenceRoom(
      roomId:docId,
      roomName:json['roomName'],
      hostId: json['hostId'],
      participantIds: List<String>.from(json['participantIds']),
      isActive: json['isActive'],
    );
  }

  //conversion of ConferenceRoom object to JSON
  //@param conferenceRoom: ConferenceRoom object
  //@return json: JSON object
  Map<String,dynamic> toJson(){
    return{
      'roomName':roomName,
      'hostId':hostId,
      'participantIds':participantIds,
      'isActive':isActive,
    };
  }

  // CopyWith method to create a new instance with modified properties
  //creating a new instance with modified properties
  ConferenceRoom copyWith({
    String? roomId,
    String? roomName,
    String? hostId,
    List<String>? participantIds,
    bool? isActive,
  }) {
    return ConferenceRoom(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      hostId: hostId ?? this.hostId,
      participantIds: participantIds ?? this.participantIds,
      isActive: isActive ?? this.isActive,
    );
  }

}