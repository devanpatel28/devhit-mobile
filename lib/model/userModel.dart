class User {
  final int userId;
  final String userName;
  final String userEmail;
  final String userMobile;
  final String userAdress;
  final int projectId;
  // Add other fields as necessary

  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userMobile,
    required this.userAdress,
    required this.projectId
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      userMobile: json['user_mobile'],
      userAdress: json['user_address'],
        projectId:json['pro_id']
      // Initialize other fields
    );
  }
}
