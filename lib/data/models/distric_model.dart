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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region_id': regionId,
    };
  }
}
