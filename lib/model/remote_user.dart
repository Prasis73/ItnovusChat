class RemoteUser {
  final String uid;
  final String email;
  final String userImage;
  final String userName;

  RemoteUser({
    required this.email,
    required this.uid,
    required this.userImage,
    required this.userName,
  });

  factory RemoteUser.fromJson(Map<String, dynamic> json) {
    return RemoteUser(
      email: json["email"],
      uid: json["uid"],
      userImage: json["image_url"],
      userName: json["username"],


    );
  }
}
