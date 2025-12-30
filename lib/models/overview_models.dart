import 'dart:convert';

class Overview {
  Goals goals;
  LeaguePulse leaguePulse;
  List<LateCollapse> lateCollapses;
  List<ComebackKing> comebackKings;
  List<AttackPattern> attackPatterns;
  List<ClutchPlayer> clutchPlayers;

  Overview({
    required this.goals,
    required this.leaguePulse,
    required this.lateCollapses,
    required this.comebackKings,
    required this.attackPatterns,
    required this.clutchPlayers,
  });

  Overview copyWith({
    Goals? goals,
    LeaguePulse? leaguePulse,
    List<LateCollapse>? lateCollapses,
    List<ComebackKing>? comebackKings,
    List<AttackPattern>? attackPatterns,
    List<ClutchPlayer>? clutchPlayers,
  }) => Overview(
    goals: goals ?? this.goals,
    leaguePulse: leaguePulse ?? this.leaguePulse,
    lateCollapses: lateCollapses ?? this.lateCollapses,
    comebackKings: comebackKings ?? this.comebackKings,
    attackPatterns: attackPatterns ?? this.attackPatterns,
    clutchPlayers: clutchPlayers ?? this.clutchPlayers,
  );

  factory Overview.fromRawJson(String str) =>
      Overview.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
    goals: Goals.fromJson(json["goals"]),
    leaguePulse: LeaguePulse.fromJson(json["league_pulse"]),
    lateCollapses: List<LateCollapse>.from(
      json["late_collapses"].map((x) => LateCollapse.fromJson(x)),
    ),
    comebackKings: List<ComebackKing>.from(
      json["comeback_kings"].map((x) => ComebackKing.fromJson(x)),
    ),
    attackPatterns: List<AttackPattern>.from(
      json["attack_patterns"].map((x) => AttackPattern.fromJson(x)),
    ),
    clutchPlayers: List<ClutchPlayer>.from(
      json["clutch_players"].map((x) => ClutchPlayer.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "goals": goals.toJson(),
    "league_pulse": leaguePulse.toJson(),
    "late_collapses": List<dynamic>.from(lateCollapses.map((x) => x.toJson())),
    "comeback_kings": List<dynamic>.from(comebackKings.map((x) => x.toJson())),
    "attack_patterns": List<dynamic>.from(
      attackPatterns.map((x) => x.toJson()),
    ),
    "clutch_players": List<dynamic>.from(clutchPlayers.map((x) => x.toJson())),
  };
}

class AttackPattern {
  String teamName;
  String totalTeamGoals;
  String uniqueScorers;
  PatternType patternType;

  AttackPattern({
    required this.teamName,
    required this.totalTeamGoals,
    required this.uniqueScorers,
    required this.patternType,
  });

  AttackPattern copyWith({
    String? teamName,
    String? totalTeamGoals,
    String? uniqueScorers,
    PatternType? patternType,
  }) => AttackPattern(
    teamName: teamName ?? this.teamName,
    totalTeamGoals: totalTeamGoals ?? this.totalTeamGoals,
    uniqueScorers: uniqueScorers ?? this.uniqueScorers,
    patternType: patternType ?? this.patternType,
  );

  factory AttackPattern.fromRawJson(String str) =>
      AttackPattern.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttackPattern.fromJson(Map<String, dynamic> json) => AttackPattern(
    teamName: json["team_name"],
    totalTeamGoals: json["total_team_goals"],
    uniqueScorers: json["unique_scorers"],
    patternType: patternTypeValues.map[json["pattern_type"]]!,
  );

  Map<String, dynamic> toJson() => {
    "team_name": teamName,
    "total_team_goals": totalTeamGoals,
    "unique_scorers": uniqueScorers,
    "pattern_type": patternTypeValues.reverse[patternType],
  };
}

enum PatternType { DISTRIBUTED_ATTACK, SINGLE_POINT_OF_FAILURE }

final patternTypeValues = EnumValues({
  "Distributed Attack": PatternType.DISTRIBUTED_ATTACK,
  "Single Point of Failure": PatternType.SINGLE_POINT_OF_FAILURE,
});

class ClutchPlayer {
  String playerName;
  String teamName;
  String clutchGoals;

  ClutchPlayer({
    required this.playerName,
    required this.teamName,
    required this.clutchGoals,
  });

  ClutchPlayer copyWith({
    String? playerName,
    String? teamName,
    String? clutchGoals,
  }) => ClutchPlayer(
    playerName: playerName ?? this.playerName,
    teamName: teamName ?? this.teamName,
    clutchGoals: clutchGoals ?? this.clutchGoals,
  );

  factory ClutchPlayer.fromRawJson(String str) =>
      ClutchPlayer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClutchPlayer.fromJson(Map<String, dynamic> json) => ClutchPlayer(
    playerName: json["player_name"],
    teamName: json["team_name"],
    clutchGoals: json["clutch_goals"],
  );

  Map<String, dynamic> toJson() => {
    "player_name": playerName,
    "team_name": teamName,
    "clutch_goals": clutchGoals,
  };
}

class ComebackKing {
  String teamName;
  String comebackWins;

  ComebackKing({required this.teamName, required this.comebackWins});

  ComebackKing copyWith({String? teamName, String? comebackWins}) =>
      ComebackKing(
        teamName: teamName ?? this.teamName,
        comebackWins: comebackWins ?? this.comebackWins,
      );

  factory ComebackKing.fromRawJson(String str) =>
      ComebackKing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ComebackKing.fromJson(Map<String, dynamic> json) => ComebackKing(
    teamName: json["team_name"],
    comebackWins: json["comeback_wins"],
  );

  Map<String, dynamic> toJson() => {
    "team_name": teamName,
    "comeback_wins": comebackWins,
  };
}

class Goals {
  int currentSeasonTotal;
  int lastSeasonTotal;
  String percentageChange;

  Goals({
    required this.currentSeasonTotal,
    required this.lastSeasonTotal,
    required this.percentageChange,
  });

  Goals copyWith({
    int? currentSeasonTotal,
    int? lastSeasonTotal,
    String? percentageChange,
  }) => Goals(
    currentSeasonTotal: currentSeasonTotal ?? this.currentSeasonTotal,
    lastSeasonTotal: lastSeasonTotal ?? this.lastSeasonTotal,
    percentageChange: percentageChange ?? this.percentageChange,
  );

  factory Goals.fromRawJson(String str) => Goals.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
    currentSeasonTotal: json["current_season_total"],
    lastSeasonTotal: json["last_season_total"],
    percentageChange: json["percentage_change"],
  );

  Map<String, dynamic> toJson() => {
    "current_season_total": currentSeasonTotal,
    "last_season_total": lastSeasonTotal,
    "percentage_change": percentageChange,
  };
}

class LateCollapse {
  String teamName;
  String collapseCount;

  LateCollapse({required this.teamName, required this.collapseCount});

  LateCollapse copyWith({String? teamName, String? collapseCount}) =>
      LateCollapse(
        teamName: teamName ?? this.teamName,
        collapseCount: collapseCount ?? this.collapseCount,
      );

  factory LateCollapse.fromRawJson(String str) =>
      LateCollapse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LateCollapse.fromJson(Map<String, dynamic> json) => LateCollapse(
    teamName: json["team_name"],
    collapseCount: json["collapse_count"],
  );

  Map<String, dynamic> toJson() => {
    "team_name": teamName,
    "collapse_count": collapseCount,
  };
}

class LeaguePulse {
  double avgCardsPerMatch;
  double homeWinPercentage;
  double avgGoalsPerMatch;
  int totalDraws;

  LeaguePulse({
    required this.avgCardsPerMatch,
    required this.homeWinPercentage,
    required this.avgGoalsPerMatch,
    required this.totalDraws,
  });

  LeaguePulse copyWith({
    double? avgCardsPerMatch,
    double? homeWinPercentage,
    double? avgGoalsPerMatch,
    int? totalDraws,
  }) => LeaguePulse(
    avgCardsPerMatch: avgCardsPerMatch ?? this.avgCardsPerMatch,
    homeWinPercentage: homeWinPercentage ?? this.homeWinPercentage,
    avgGoalsPerMatch: avgGoalsPerMatch ?? this.avgGoalsPerMatch,
    totalDraws: totalDraws ?? this.totalDraws,
  );

  factory LeaguePulse.fromRawJson(String str) =>
      LeaguePulse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaguePulse.fromJson(Map<String, dynamic> json) => LeaguePulse(
    avgCardsPerMatch: json["avg_cards_per_match"]?.toDouble(),
    homeWinPercentage: json["home_win_percentage"]?.toDouble(),
    avgGoalsPerMatch: json["avg_goals_per_match"]?.toDouble(),
    totalDraws: json["total_draws"],
  );

  Map<String, dynamic> toJson() => {
    "avg_cards_per_match": avgCardsPerMatch,
    "home_win_percentage": homeWinPercentage,
    "avg_goals_per_match": avgGoalsPerMatch,
    "total_draws": totalDraws,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
