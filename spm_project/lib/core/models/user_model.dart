class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

//from json object to UserModel object
//@param json: json object
//@return UserModel object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

//from UserModel object to JSON
//@param userModel: UserModel object
//@return json object
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

//copy userModel with new values
//returns new UserModel object with new values for specified fields, or original values if no new value provided.
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
