import 'dart:convert';

class MatchesResponse {
  bool success;
  Data data;

  MatchesResponse({required this.success, required this.data});

  MatchesResponse copyWith({bool? success, Data? data}) => MatchesResponse(
    success: success ?? this.success,
    data: data ?? this.data,
  );

  factory MatchesResponse.fromRawJson(String str) =>
      MatchesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MatchesResponse.fromJson(Map<String, dynamic> json) =>
      MatchesResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
}

class Data {
  String season;
  Pagination pagination;
  List<Match> matches;

  Data({required this.season, required this.pagination, required this.matches});

  Data copyWith({
    String? season,
    Pagination? pagination,
    List<Match>? matches,
  }) => Data(
    season: season ?? this.season,
    pagination: pagination ?? this.pagination,
    matches: matches ?? this.matches,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    season: json["season"],
    pagination: Pagination.fromJson(json["pagination"]),
    matches: List<Match>.from(json["matches"].map((x) => Match.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "season": season,
    "pagination": pagination.toJson(),
    "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
  };
}

class Match {
  int id;
  DateTime date;
  dynamic venue;
  int? scoreHome;
  int? scoreAway;
  Competition competition;
  String monthKey;
  String monthName;
  Team homeTeam;
  Team awayTeam;

  Match({
    required this.id,
    required this.date,
    required this.venue,
    required this.scoreHome,
    required this.scoreAway,
    required this.competition,
    required this.monthKey,
    required this.monthName,
    required this.homeTeam,
    required this.awayTeam,
  });

  Match copyWith({
    int? id,
    DateTime? date,
    dynamic venue,
    int? scoreHome,
    int? scoreAway,
    Competition? competition,
    String? monthKey,
    String? monthName,
    Team? homeTeam,
    Team? awayTeam,
  }) => Match(
    id: id ?? this.id,
    date: date ?? this.date,
    venue: venue ?? this.venue,
    scoreHome: scoreHome ?? this.scoreHome,
    scoreAway: scoreAway ?? this.scoreAway,
    competition: competition ?? this.competition,
    monthKey: monthKey ?? this.monthKey,
    monthName: monthName ?? this.monthName,
    homeTeam: homeTeam ?? this.homeTeam,
    awayTeam: awayTeam ?? this.awayTeam,
  );

  factory Match.fromRawJson(String str) => Match.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    venue: json["venue"],
    scoreHome: json["score_home"],
    scoreAway: json["score_away"],
    competition: Competition.fromJson(json["competition"]),
    monthKey: json["month_key"],
    monthName: json["month_name"],
    homeTeam: Team.fromJson(json["home_team"]),
    awayTeam: Team.fromJson(json["away_team"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date.toIso8601String(),
    "venue": venue,
    "score_home": scoreHome,
    "score_away": scoreAway,
    "competition": competition.toJson(),
    "month_key": monthKey,
    "month_name": monthName,
    "home_team": homeTeam.toJson(),
    "away_team": awayTeam.toJson(),
  };
}

class Team {
  int id;
  String name;
  dynamic logoUrl;
  String shortName;

  Team({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.shortName,
  });

  Team copyWith({int? id, String? name, dynamic logoUrl, String? shortName}) =>
      Team(
        id: id ?? this.id,
        name: name ?? this.name,
        logoUrl: logoUrl ?? this.logoUrl,
        shortName: shortName ?? this.shortName,
      );

  factory Team.fromRawJson(String str) => Team.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    id: json["id"],
    name: json["name"],
    logoUrl: json["logo_url"],
    shortName: json["short_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo_url": logoUrl,
    "short_name": shortName,
  };
}

class Competition {
  int id;
  String name;
  String type;

  Competition({required this.id, required this.name, required this.type});

  Competition copyWith({int? id, String? name, String? type}) => Competition(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
  );

  factory Competition.fromRawJson(String str) =>
      Competition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Competition.fromJson(Map<String, dynamic> json) =>
      Competition(id: json["id"], name: json["name"], type: json["type"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "type": type};
}

class Pagination {
  int page;
  int limit;
  int total;
  int totalPages;
  bool hasNext;
  bool hasPrev;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  Pagination copyWith({
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    bool? hasNext,
    bool? hasPrev,
  }) => Pagination(
    page: page ?? this.page,
    limit: limit ?? this.limit,
    total: total ?? this.total,
    totalPages: totalPages ?? this.totalPages,
    hasNext: hasNext ?? this.hasNext,
    hasPrev: hasPrev ?? this.hasPrev,
  );

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["totalPages"],
    hasNext: json["hasNext"],
    hasPrev: json["hasPrev"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPages": totalPages,
    "hasNext": hasNext,
    "hasPrev": hasPrev,
  };
}
