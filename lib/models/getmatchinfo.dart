// To parse this JSON data, do
//
//     final getMatchInfo = getMatchInfoFromJson(jsonString);

import 'dart:convert';

List<GetMatchInfo> getMatchInfoFromJson(String str) => List<GetMatchInfo>.from(json.decode(str).map((x) => GetMatchInfo.fromJson(x)));

String getMatchInfoToJson(List<GetMatchInfo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetMatchInfo {
  int id;
  String name;
  int tournamentId;
  String tournamentName;
  int tournamentImportance;
  int seasonId;
  String seasonName;
  Status status;
  String statusType;
  int arenaId;
  String arenaName;
  String arenaHashImage;
  String? refereeName;
  int homeTeamId;
  String homeTeamName;
  String homeTeamHashImage;
  int awayTeamId;
  String awayTeamName;
  String awayTeamHashImage;
  TeamScore? homeTeamScore;
  TeamScore? awayTeamScore;
  DateTime startTime;
  DateTime endTime;
  int duration;
  int? lineupsId;
  int classId;
  String className;
  String classHashImage;
  int leagueId;
  String leagueName;
  String leagueHashImage;

  GetMatchInfo({
    required this.id,
    required this.name,
    required this.tournamentId,
    required this.tournamentName,
    required this.tournamentImportance,
    required this.seasonId,
    required this.seasonName,
    required this.status,
    required this.statusType,
    required this.arenaId,
    required this.arenaName,
    required this.arenaHashImage,
    this.refereeName,
    required this.homeTeamId,
    required this.homeTeamName,
    required this.homeTeamHashImage,
    required this.awayTeamId,
    required this.awayTeamName,
    required this.awayTeamHashImage,
    this.homeTeamScore,
    this.awayTeamScore,
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.lineupsId,
    required this.classId,
    required this.className,
    required this.classHashImage,
    required this.leagueId,
    required this.leagueName,
    required this.leagueHashImage,
  });

  factory GetMatchInfo.fromJson(Map<String, dynamic> json) => GetMatchInfo(
    id: json["id"],
    name: json["name"],
    tournamentId: json["tournament_id"],
    tournamentName: json["tournament_name"],
    tournamentImportance: json["tournament_importance"],
    seasonId: json["season_id"],
    seasonName: json["season_name"],
    status: Status.fromJson(json["status"]),
    statusType: json["status_type"],
    arenaId: json["arena_id"],
    arenaName: json["arena_name"],
    arenaHashImage: json["arena_hash_image"],
    refereeName: json["referee_name"],
    homeTeamId: json["home_team_id"],
    homeTeamName: json["home_team_name"],
    homeTeamHashImage: json["home_team_hash_image"],
    awayTeamId: json["away_team_id"],
    awayTeamName: json["away_team_name"],
    awayTeamHashImage: json["away_team_hash_image"],
    homeTeamScore: json["home_team_score"] == null ? null : TeamScore.fromJson(json["home_team_score"]),
    awayTeamScore: json["away_team_score"] == null ? null : TeamScore.fromJson(json["away_team_score"]),
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    duration: json["duration"],
    lineupsId: json["lineups_id"],
    classId: json["class_id"],
    className: json["class_name"],
    classHashImage: json["class_hash_image"],
    leagueId: json["league_id"],
    leagueName: json["league_name"],
    leagueHashImage: json["league_hash_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "tournament_id": tournamentId,
    "tournament_name": tournamentName,
    "tournament_importance": tournamentImportance,
    "season_id": seasonId,
    "season_name": seasonName,
    "status": status.toJson(),
    "status_type": statusType,
    "arena_id": arenaId,
    "arena_name": arenaName,
    "arena_hash_image": arenaHashImage,
    "referee_name": refereeName,
    "home_team_id": homeTeamId,
    "home_team_name": homeTeamName,
    "home_team_hash_image": homeTeamHashImage,
    "away_team_id": awayTeamId,
    "away_team_name": awayTeamName,
    "away_team_hash_image": awayTeamHashImage,
    "home_team_score": homeTeamScore?.toJson(),
    "away_team_score": awayTeamScore?.toJson(),
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "duration": duration,
    "lineups_id": lineupsId,
    "class_id": classId,
    "class_name": className,
    "class_hash_image": classHashImage,
    "league_id": leagueId,
    "league_name": leagueName,
    "league_hash_image": leagueHashImage,
  };
}

class TeamScore {
  int current;
  int display;

  TeamScore({
    required this.current,
    required this.display,
  });

  factory TeamScore.fromJson(Map<String, dynamic> json) => TeamScore(
    current: json["current"],
    display: json["display"],
  );

  Map<String, dynamic> toJson() => {
    "current": current,
    "display": display,
  };
}

class Status {
  String type;
  String reason;

  Status({
    required this.type,
    required this.reason,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    type: json["type"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "reason": reason,
  };
}
