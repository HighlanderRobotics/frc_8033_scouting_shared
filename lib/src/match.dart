class GameMatchIdentity {
  GameMatchIdentity(
    this.type,
    this.number,
    this.tournamentKey,
  );

  String tournamentKey;
  MatchType type;
  int number;

  /// Create a shorter user-readable description of the match
  String getShortLocalizedDescription() =>
      "${type.shortName.toUpperCase()}$number";

  /// Create a user-readable description of the match
  String getLocalizedDescription({
    includeType = true,
    includeNumber = true,
    includeTournament = true,
  }) {
    if (includeType && !includeNumber && !includeTournament) {
      return "${type.localizedDescriptionPlural.toLowerCase()} match";
    }
    if (includeType && !includeNumber && includeTournament) {
      return "${type.localizedDescriptionPlural.toLowerCase()} match at $tournamentKey";
    } // TODO: Make tournament key localizer
    if (includeType && includeNumber && !includeTournament) {
      return "${type.localizedDescriptionSingular} $number";
    } // TODO: Make tournament key localizer
    if (!includeType && includeNumber && includeTournament) {
      return "Match #$number at $tournamentKey";
    } // TODO: Make tournament key localizer
    if (!includeType && includeNumber && !includeTournament) {
      return "Match #$number";
    }
    if (!includeType && !includeNumber && includeTournament) {
      return "Match at $tournamentKey";
    } // TODO: Make tournament key localizer
    if (!includeType && !includeNumber && !includeTournament) return "Match";
    if (includeType && includeNumber && includeTournament) {
      return "${type.localizedDescriptionSingular.toLowerCase()} $number at $tournamentKey";
    } // TODO: Make tournament key localizer

    return "this should never happen";
  }

  /// Create a match from a long match key such as `2022cc_qm14_1`
  factory GameMatchIdentity.fromLongKey(String longKey) {
    List<String> elements = longKey.split("_");

    return GameMatchIdentity(
      MatchTypeExtension.fromShortName(
          elements[1].replaceAll(RegExp('\\d'), "")),
      int.parse(elements[1].replaceAll(RegExp('[a-zA-Z]'), "")),
      elements[0],
    );
  }

  String toMediumKey() => "${tournamentKey}_${type.shortName}$number";
}

enum MatchType {
  qualifier,
  elimination,
}

extension MatchTypeExtension on MatchType {
  String get localizedDescriptionPlural {
    switch (this) {
      case MatchType.qualifier:
        return "Qualifiers";
      case MatchType.elimination:
        return "Eliminations";
    }
  }

  String get localizedDescriptionSingular {
    switch (this) {
      case MatchType.qualifier:
        return "Qualifier";
      case MatchType.elimination:
        return "Elimination";
    }
  }

  String get shortName {
    switch (this) {
      case MatchType.qualifier:
        return "qm";
      case MatchType.elimination:
        return "em";
    }
  }

  static MatchType fromShortName(String shortName) =>
      MatchType.values.firstWhere((element) => element.shortName == shortName);
}
