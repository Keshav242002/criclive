// To parse this JSON data, do
//
//     final liveMatchModel = liveMatchModelFromJson(jsonString);

import 'dart:convert';

List<LiveMatchModel> liveMatchModelFromJson(String str) => List<LiveMatchModel>.from(json.decode(str).map((x) => LiveMatchModel.fromJson(x)));

String liveMatchModelToJson(List<LiveMatchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LiveMatchModel {
  int matchId;
  List<Inning> innings;

  LiveMatchModel({
    required this.matchId,
    required this.innings,
  });

  factory LiveMatchModel.fromJson(Map<String, dynamic> json) => LiveMatchModel(
    matchId: json["match_id"] ?? 0, // Default to 0 if null
    innings: List<Inning>.from(
        (json["innings"] ?? []).map((x) => Inning.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "match_id": matchId,
    "innings": List<dynamic>.from(innings.map((x) => x.toJson())),
  };
}

class Inning {
  int bye;
  int wide;
  int extra;
  int overs;
  int score;
  int number;
  int legBye;
  int noBall;
  int penalty;
  int wickets;
  List<Partnership> partnerships;
  List<BattingLine> battingLines;
  List<BowlingLine> bowlingLines;
  int battingTeamId;
  int bowlingTeamId;
  String battingTeamName;
  String bowlingTeamName;
  String battingTeamHashImage;
  String bowlingTeamHashImage;

  Inning({
    required this.bye,
    required this.wide,
    required this.extra,
    required this.overs,
    required this.score,
    required this.number,
    required this.legBye,
    required this.noBall,
    required this.penalty,
    required this.wickets,
    required this.partnerships,
    required this.battingLines,
    required this.bowlingLines,
    required this.battingTeamId,
    required this.bowlingTeamId,
    required this.battingTeamName,
    required this.bowlingTeamName,
    required this.battingTeamHashImage,
    required this.bowlingTeamHashImage,
  });

  factory Inning.fromJson(Map<String, dynamic> json) => Inning(
    bye: json["bye"] ?? 0,
    wide: json["wide"] ?? 0,
    extra: json["extra"] ?? 0,
    overs: json["overs"] ?? 0,
    score: json["score"] ?? 0,
    number: json["number"] ?? 0,
    legBye: json["leg_bye"] ?? 0,
    noBall: json["no_ball"] ?? 0,
    penalty: json["penalty"] ?? 0,
    wickets: json["wickets"] ?? 0,
    partnerships: List<Partnership>.from(
        (json["partnerships"] ?? []).map((x) => Partnership.fromJson(x))),
    battingLines: List<BattingLine>.from(
        (json["batting_lines"] ?? []).map((x) => BattingLine.fromJson(x))),
    bowlingLines: List<BowlingLine>.from(
        (json["bowling_lines"] ?? []).map((x) => BowlingLine.fromJson(x))),
    battingTeamId: json["batting_team_id"] ?? 0,
    bowlingTeamId: json["bowling_team_id"] ?? 0,
    battingTeamName: json["batting_team_name"] ?? '',
    bowlingTeamName: json["bowling_team_name"] ?? '',
    battingTeamHashImage: json["batting_team_hash_image"] ?? '',
    bowlingTeamHashImage: json["bowling_team_hash_image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "bye": bye,
    "wide": wide,
    "extra": extra,
    "overs": overs,
    "score": score,
    "number": number,
    "leg_bye": legBye,
    "no_ball": noBall,
    "penalty": penalty,
    "wickets": wickets,
    "partnerships": List<dynamic>.from(partnerships.map((x) => x.toJson())),
    "batting_lines":
    List<dynamic>.from(battingLines.map((x) => x.toJson())),
    "bowling_lines":
    List<dynamic>.from(bowlingLines.map((x) => x.toJson())),
    "batting_team_id": battingTeamId,
    "bowling_team_id": bowlingTeamId,
    "batting_team_name": battingTeamName,
    "bowling_team_name": bowlingTeamName,
    "batting_team_hash_image": battingTeamHashImage,
    "bowling_team_hash_image": bowlingTeamHashImage,
  };
}


class BattingLine {
  int s4;
  int s6;
  int balls;
  int score;
  int playerId;
  String playerName;
  int wicketTypeId;
  WicketTypeName wicketTypeName;
  String playerHashImage;

  BattingLine({
    required this.s4,
    required this.s6,
    required this.balls,
    required this.score,
    required this.playerId,
    required this.playerName,
    required this.wicketTypeId,
    required this.wicketTypeName,
    required this.playerHashImage,
  });

  factory BattingLine.fromJson(Map<String, dynamic> json) => BattingLine(
    s4: json["s4"] ?? 0,
    s6: json["s6"] ?? 0,
    balls: json["balls"] ?? 0,
    score: json["score"] ?? 0,
    playerId: json["player_id"] ?? 0,
    playerName: json["player_name"] ?? '',
    wicketTypeId: json["wicket_type_id"] ?? 0,
    wicketTypeName: wicketTypeNameValues.map[json["wicket_type_name"]] ??
        WicketTypeName.DID_NOT_BAT, // Default to DID_NOT_BAT if null
    playerHashImage: json["player_hash_image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "s4": s4,
    "s6": s6,
    "balls": balls,
    "score": score,
    "player_id": playerId,
    "player_name": playerName,
    "wicket_type_id": wicketTypeId,
    "wicket_type_name": wicketTypeNameValues.reverse[wicketTypeName],
    "player_hash_image": playerHashImage,
  };
}

enum WicketTypeName {
  BATTING,
  DID_NOT_BAT
}

final wicketTypeNameValues = EnumValues({
  "Batting": WicketTypeName.BATTING,
  "Did not bat": WicketTypeName.DID_NOT_BAT,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}


class BowlingLine {
  int run;
  int over;
  int wide;
  int maiden;
  int noball;
  int wicket;
  int playerId;
  String playerName;
  String playerHashImage;

  BowlingLine({
    required this.run,
    required this.over,
    required this.wide,
    required this.maiden,
    required this.noball,
    required this.wicket,
    required this.playerId,
    required this.playerName,
    required this.playerHashImage,
  });

  factory BowlingLine.fromJson(Map<String, dynamic> json) => BowlingLine(
    run: json["run"] ?? 0,
    over: json["over"] ?? 0,
    wide: json["wide"] ?? 0,
    maiden: json["maiden"] ?? 0,
    noball: json["noball"] ?? 0,
    wicket: json["wicket"] ?? 0,
    playerId: json["player_id"] ?? 0,
    playerName: json["player_name"] ?? '',
    playerHashImage: json["player_hash_image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "run": run,
    "over": over,
    "wide": wide,
    "maiden": maiden,
    "noball": noball,
    "wicket": wicket,
    "player_id": playerId,
    "player_name": playerName,
    "player_hash_image": playerHashImage,
  };
}

class Partnership {
  int balls;
  int score;
  int player1Id;
  int player2Id;
  String player1Name;
  String player2Name;
  String player1HashImage;
  String player2HashImage;

  Partnership({
    required this.balls,
    required this.score,
    required this.player1Id,
    required this.player2Id,
    required this.player1Name,
    required this.player2Name,
    required this.player1HashImage,
    required this.player2HashImage,
  });

  factory Partnership.fromJson(Map<String, dynamic> json) => Partnership(
    balls: json["balls"] ?? 0,
    score: json["score"] ?? 0,
    player1Id: json["player1_id"] ?? 0,
    player2Id: json["player2_id"] ?? 0,
    player1Name: json["player1_name"] ?? '',
    player2Name: json["player2_name"] ?? '',
    player1HashImage: json["player1_hash_image"] ?? '',
    player2HashImage: json["player2_hash_image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "balls": balls,
    "score": score,
    "player1_id": player1Id,
    "player2_id": player2Id,
    "player1_name": player1Name,
    "player2_name": player2Name,
    "player1_hash_image": player1HashImage,
    "player2_hash_image": player2HashImage,
  };
}



