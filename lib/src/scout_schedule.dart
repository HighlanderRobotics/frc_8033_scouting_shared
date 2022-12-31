import 'dart:convert';
import 'package:http/http.dart' as http;

class ScoutSchedule {
  ScoutSchedule({
    required this.version,
    required this.shifts,
  });

  int version;
  List<ScoutingShift> shifts;

  ScoutSchedule copy() {
    return ScoutSchedule(
      version: version,
      shifts: shifts.map((s) => s.copy()).toList(),
    );
  }

  List<String> getScoutsForMatch(int match) {
    List<String> scouts = [];
    for (ScoutingShift shift in shifts) {
      if (shift.start <= match && match <= shift.end) {
        scouts.addAll(shift.scouts);
      }
    }
    return scouts;
  }

  bool shiftsDoNotOverlap() {
    for (int i = 0; i < shifts.length - 1; i++) {
      for (int j = i + 1; j < shifts.length; j++) {
        if (shifts[i].end >= shifts[j].start &&
            shifts[i].start <= shifts[j].end) {
          return false;
        }
      }
    }
    return true;
  }

  bool noGapsBetweenShifts() {
    for (int i = 0; i < shifts.length - 1; i++) {
      if (shifts[i].end != shifts[i + 1].start - 1) {
        return false;
      }
    }
    return true;
  }

  bool allMatchNumbersPositive() {
    for (ScoutingShift shift in shifts) {
      if (shift.start < 0 || shift.end < 0) {
        return false;
      }
    }
    return true;
  }

  bool shiftsHaveValidRanges() {
    for (ScoutingShift shift in shifts) {
      if (shift.end < shift.start) {
        return false;
      }
    }
    return true;
  }

  bool noEmptyScoutNames() {
    for (ScoutingShift shift in shifts) {
      if (shift.scouts.any((s) => s.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  String? validate() {
    if (!shiftsDoNotOverlap()) return 'Some shifts overlap.';
    if (!noGapsBetweenShifts()) return 'Some shifts have gaps between them.';
    if (!allMatchNumbersPositive()) return 'Some match numbers are negative.';
    if (!shiftsHaveValidRanges()) {
      return 'Some shifts don\'t have valid ranges.';
    }
    if (!noEmptyScoutNames()) {
      return 'Some scout names are empty or contain only whitespace.';
    }

    // If it's valid, return null.
    return null;
  }

  String toJSON() {
    final shiftsMap = shifts
        .map((shift) => {
              'start': shift.start,
              'end': shift.end,
              'scouts': shift.scouts,
            })
        .toList();

    return jsonEncode({
      'version': version,
      'shifts': shiftsMap,
    });
  }

  Future<void> upload(String authority) async {
    http.post(
      Uri.http((authority), '/API/manager/updateScoutersSchedule'),
      body: toJSON(),
      headers: {
        'type': 'application/json',
      },
    );
  }

  Future<void> save(String authority) async {
    version++;
    await upload(authority);
  }
}

class ScoutingShift {
  ScoutingShift({
    required this.start,
    required this.end,
    required this.scouts,
  });

  int start;
  int end;
  List<String> scouts;

  ScoutingShift copy() {
    return ScoutingShift(
      start: start,
      end: end,
      scouts: List.from(scouts),
    );
  }
}