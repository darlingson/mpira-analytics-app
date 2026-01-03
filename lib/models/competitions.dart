import 'dart:convert';

class Competitions {
  bool success;
  List<Datum> data;

  Competitions({required this.success, required this.data});

  Competitions copyWith({bool? success, List<Datum>? data}) =>
      Competitions(success: success ?? this.success, data: data ?? this.data);

  factory Competitions.fromRawJson(String str) =>
      Competitions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Competitions.fromJson(Map<String, dynamic> json) => Competitions(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  String type;
  String season;

  Datum({
    required this.id,
    required this.name,
    required this.type,
    required this.season,
  });

  Datum copyWith({int? id, String? name, String? type, String? season}) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        season: season ?? this.season,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    season: json["season"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "season": season,
  };
}
