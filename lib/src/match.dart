import 'package:flutter/foundation.dart';

class Match {
  Match(
    this.type,
    this.number,
    this.tournamentKey,
  );

  String tournamentKey;
  MatchType type;
  int number;

  /// Create a match from
  factory Match.fromLongKey(String longKey) {
    List<String> elements = longKey.split("_");

    return Match(
      MatchTypeExtension.fromShortName(elements[1].substring(0, 2)),
      int.parse(elements[1].substring(2)),
      elements[0],
    );
  }
}

enum MatchType {
  qualifier,
  semiFinal,
  quarterFinal,
  eliminationFinal,
  finals,
}

extension MatchTypeExtension on MatchType {
  String get localizedDescriptionPlural {
    switch (this) {
      case MatchType.qualifier:
        return "Qualifiers";
      case MatchType.semiFinal:
        return "Semi-Finals";
      case MatchType.quarterFinal:
        return "Quarter-Finals";
      case MatchType.eliminationFinal:
        return "Elimination Finals";
      case MatchType.finals:
        return "Finals";
    }
  }

  String get localizedDescriptionSingular {
    switch (this) {
      case MatchType.qualifier:
        return "Qualifier";
      case MatchType.semiFinal:
        return "Semi-Final";
      case MatchType.quarterFinal:
        return "Quarter-Final";
      case MatchType.eliminationFinal:
        return "Elimination Final";
      case MatchType.finals:
        return "Final";
    }
  }

  String get shortName {
    switch (this) {
      case MatchType.qualifier:
        return "qm";
      case MatchType.semiFinal:
        return "sf";
      case MatchType.quarterFinal:
        return "qf";
      case MatchType.eliminationFinal:
        return "ef";
      case MatchType.finals:
        return "f";
    }
  }

  static MatchType fromShortName(String shortName) =>
      MatchType.values.firstWhere((element) => element.shortName == shortName);
}
