class Admin {
  final int adminId;
  final String adminName;
  final String adminRole;
  final String adminMobile;
  // Add other fields as necessary

  Admin({
    required this.adminId,
    required this.adminName,
    required this.adminRole,
    required this.adminMobile,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json['admin_id'],
      adminName: json['admin_name'],
      adminRole: json['admin_role'],
      adminMobile: json['admin_mob'],
    );
  }
}
