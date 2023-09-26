import 'dart:convert';

import 'package:frc_8033_scouting_shared/frc_8033_scouting_shared.dart';
import 'package:http/http.dart' as http;

class TournamentSchedule {
  TournamentSchedule({required this.matches});

  List<ScheduleMatch> matches;

  static Future<TournamentSchedule> fromServer(
    String authority,
    String tournamentKey,
  ) async {
    final response =
        await http.get(Uri.http(authority, '/API/manager/getMatches', {
      'tournamentKey': tournamentKey,
    }));

    if (response.statusCode != 200) {
      String error;
      try {
        error = jsonDecode(response.body)['result'];
      } catch (e) {
        error = '${response.statusCode} ${response.reasonPhrase}';
      }

      throw error;
    }

    List<dynamic> matchesResponse = jsonDecode(response.body) as List<dynamic>;

    List<ScheduleMatch> currentMatches = [];

    for (var matchMap in matchesResponse) {
      ScheduleMatch match = currentMatches.firstWhere(
        (m) =>
            m.identity.toMediumKey() ==
            (matchMap['key'] as String).replaceAll(RegExp('_\\d+\$'), ""),
        orElse: () => ScheduleMatch(
          identity: GameMatchIdentity.fromLongKey(matchMap['key']),
          teams: [0, 0, 0, 0, 0, 0],
          ordinalNumber: matchMap['ordinalNumber'],
        ),
      );

      match.teams[int.parse((matchMap['key'] as String).split("_").last)] =
          int.parse(
        (matchMap['team'] as String).replaceAll(RegExp("^frc"), ""),
      );

      if (!currentMatches.contains(match)) {
        currentMatches.add(match);
      }
    }

    return TournamentSchedule(matches: currentMatches);
  }
}

class ScheduleMatch {
  ScheduleMatch({
    required this.identity,
    required this.teams,
    required this.ordinalNumber,
  });

  GameMatchIdentity identity;
  List<int> teams;
  int ordinalNumber;
}
