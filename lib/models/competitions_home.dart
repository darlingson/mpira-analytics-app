import 'dart:convert';

class CompetitionsHome {
    bool success;
    List<Datum> data;

    CompetitionsHome({
        required this.success,
        required this.data,
    });

    CompetitionsHome copyWith({
        bool? success,
        List<Datum>? data,
    }) => 
        CompetitionsHome(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory CompetitionsHome.fromRawJson(String str) => CompetitionsHome.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CompetitionsHome.fromJson(Map<String, dynamic> json) => CompetitionsHome(
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
    List<TopScorer> topScorers;

    Datum({
        required this.id,
        required this.name,
        required this.type,
        required this.season,
        required this.topScorers,
    });

    Datum copyWith({
        int? id,
        String? name,
        String? type,
        String? season,
        List<TopScorer>? topScorers,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            type: type ?? this.type,
            season: season ?? this.season,
            topScorers: topScorers ?? this.topScorers,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        season: json["season"],
        topScorers: List<TopScorer>.from(json["top_scorers"].map((x) => TopScorer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "season": season,
        "top_scorers": List<dynamic>.from(topScorers.map((x) => x.toJson())),
    };
}

class TopScorer {
    int goals;
    int playerId;
    dynamic teamName;
    String playerName;

    TopScorer({
        required this.goals,
        required this.playerId,
        required this.teamName,
        required this.playerName,
    });

    TopScorer copyWith({
        int? goals,
        int? playerId,
        dynamic teamName,
        String? playerName,
    }) => 
        TopScorer(
            goals: goals ?? this.goals,
            playerId: playerId ?? this.playerId,
            teamName: teamName ?? this.teamName,
            playerName: playerName ?? this.playerName,
        );

    factory TopScorer.fromRawJson(String str) => TopScorer.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TopScorer.fromJson(Map<String, dynamic> json) => TopScorer(
        goals: json["goals"],
        playerId: json["player_id"],
        teamName: json["team_name"],
        playerName: json["player_name"],
    );

    Map<String, dynamic> toJson() => {
        "goals": goals,
        "player_id": playerId,
        "team_name": teamName,
        "player_name": playerName,
    };
}
