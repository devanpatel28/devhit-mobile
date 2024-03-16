class UserTransaction {
  final int userTransId;
  final String userTransDate;
  final int userTransAmount;
  final String userTransDetail;
  // Add other fields as necessary

  UserTransaction({
    required this.userTransId,
    required this.userTransDate,
    required this.userTransAmount,
    required this.userTransDetail,
  });

  factory UserTransaction.fromJson(Map<String, dynamic> json) {
    return UserTransaction  (
        userTransId: json['transac_id'],
        userTransDate: json['transac_date'],
        userTransAmount: json['transac_amount'],
        userTransDetail: json['transac_details'],
    );
  }
}
