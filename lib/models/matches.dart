import 'dart:convert';

List<Matches> matchesFromJson(String str) => List<Matches>.from(json.decode(str).map((x) => Matches.fromJson(x)));

String matchesToJson(List<Matches> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Matches {
    int id;
    String season;
    String matchDate;
    String homeTeam;
    String awayTeam;
    String finalScore;
    String halfTime;

    Matches({
        required this.id,
        required this.season,
        required this.matchDate,
        required this.homeTeam,
        required this.awayTeam,
        required this.finalScore,
        required this.halfTime,
    });

    factory Matches.fromJson(Map<String, dynamic> json) => Matches(
        id: json["id"],
        season: json["season"],
        matchDate: json["match_date"],
        homeTeam: json["home_team"],
        awayTeam: json["away_team"],
        finalScore: json["final_score"],
        halfTime: json["half_time"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "season": season,
        "match_date": matchDate,
        "home_team": homeTeam,
        "away_team": awayTeam,
        "final_score": finalScore,
        "half_time": halfTime,
    };
}
