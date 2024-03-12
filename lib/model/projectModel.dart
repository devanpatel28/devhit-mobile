class Project {
  final int pId;
  final String proName;
  final String proAddress;
  final int proArea;
  final int proNoResidence;
  final String proImage;
  final String proBrochure;
  final String proStatus;
  final int pro2bhk;
  final int pro3bhk;
  final double proPercent;
  // Add other fields as necessary

  Project({
    required this.pId,
    required this.proName,
    required this.proAddress,
    required this.proArea,
    required this.proNoResidence,
    required this.proImage,
    required this.proBrochure,
    required this.proStatus,
    required this.pro2bhk,
    required this.pro3bhk,
    required this.proPercent
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        pId : json['project_id'],
        proName : json['project_name'],
        proAddress : json['project_address'],
        proArea : json['project_area'],
        proNoResidence : json['pro_no_residence'],
        proImage : json['project_image'],
        proBrochure : json['project_brochure'],
        proStatus : json['pro_status'],
        pro2bhk : json['pro_2bhk'],
        pro3bhk : json['pro_3bhk'],
        proPercent : json['pro_percent']
    );
  }
}
