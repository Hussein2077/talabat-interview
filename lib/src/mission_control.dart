import 'command.dart';
import 'exceptions.dart';
import 'mission.dart';
import 'plateau.dart';
import 'position.dart';
import 'rover.dart';

/// Runs a [Mission] the way the kata describes it: rovers move one after
/// the other, and each rover finishes all its commands before the next
/// one starts.
///
/// Two rules keep the rovers safe:
/// * a rover may not land or drive off the plateau;
/// * a rover may not land on or drive into a rover that is already there.
///
/// A refused move stops the mission with a [RoverException], so a bad plan is
/// never half-executed silently.
final class MissionControl {
  const MissionControl();

  /// The final state of every rover, in input order.
  List<Rover> run(Mission mission) {
    final finished = <Rover>[];

    for (var i = 0; i < mission.deployments.length; i++) {
      final number = i + 1;
      final deployment = mission.deployments[i];

      var rover = deployment.landing;
      _check(rover.position, number, mission.plateau, finished);

      for (final command in deployment.commands) {
        final next = rover.apply(command);
        if (command == Command.move) {
          _check(next.position, number, mission.plateau, finished);
        }
        rover = next;
      }
      finished.add(rover);
    }
    return finished;
  }

  /// Runs [input] in the kata format and returns the kata output, one line
  /// per rover.
  String runText(String input) =>
      run(Mission.parse(input)).map((rover) => rover.toString()).join('\n');

  void _check(
    Position target,
    int roverNumber,
    Plateau plateau,
    List<Rover> others,
  ) {
    if (!plateau.contains(target)) {
      throw OutOfPlateauException(roverNumber, target);
    }
    for (var j = 0; j < others.length; j++) {
      if (others[j].position == target) {
        throw CollisionException(roverNumber, target, j + 1);
      }
    }
  }
}
