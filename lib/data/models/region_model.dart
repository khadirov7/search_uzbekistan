class RegionModel {
  final int id;
  final String name;

  RegionModel({required this.id, required this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DistrictModel {
  final int id;
  final String name;
  final int regionId;

  DistrictModel({required this.id, required this.name, required this.regionId});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      name: json['name'],
      regionId: json['region_id'],
    );
  }
}

class QuarterModel {
  final int id;
  final String name;
  final int districtId;

  QuarterModel({required this.id, required this.name, required this.districtId});

  factory QuarterModel.fromJson(Map<String, dynamic> json) {
    return QuarterModel(
      id: json['id'],
      name: json['name'],
      districtId: json['district_id'],
    );
  }
}
