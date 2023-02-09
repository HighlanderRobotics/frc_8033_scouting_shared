import 'package:flutter/material.dart';

enum RobotRole {
  offense,
  defense,
  feeder,
}

extension RobotRoleExtension on RobotRole {
  String get name {
    switch (this) {
      case RobotRole.offense:
        return "Offense";
      case RobotRole.defense:
        return "Defense";
      case RobotRole.feeder:
        return "Feeder";
    }
  }

  IconData get littleEmblem {
    switch (this) {
      case RobotRole.offense:
        return Icons.sports_score;
      case RobotRole.defense:
        return Icons.shield_outlined;
      case RobotRole.feeder:
        return Icons.conveyor_belt;
    }
  }
}
