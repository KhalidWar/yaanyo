class AppUser {
  const AppUser({
    this.uid,
    this.name,
    this.email,
    this.profilePic,
  });

  final String uid, name, email, profilePic;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'profilePic': profilePic,
      };
}
