import 'command.dart';
import 'direction.dart';
import 'plateau.dart';
import 'position.dart';
import 'rover.dart';

/// One rover to deploy: where it lands and what it is told to do.
final class Deployment {
  const Deployment(this.landing, this.commands);

  final Rover landing;
  final List<Command> commands;
}

/// Everything in one input: the plateau and the rovers, in order.
final class Mission {
  const Mission(this.plateau, this.deployments);

  final Plateau plateau;
  final List<Deployment> deployments;

  /// Reads the kata input format:
  ///
  /// ```text
  /// 5 5
  /// 1 2 N
  /// LMLMLMLMM
  /// 3 3 E
  /// MMRMMRMRRM
  /// ```
  ///
  /// The first line is the upper-right corner of the plateau. Then each rover
  /// has two lines: its landing position and heading, and its commands.
  static Mission parse(String input) {
    final lines = input.replaceAll('\r\n', '\n').split('\n');
    while (lines.isNotEmpty && lines.last.trim().isEmpty) {
      lines.removeLast();
    }
    if (lines.isEmpty) {
      throw const FormatException('The input is empty.');
    }

    final plateau = _parsePlateau(lines.first);
    final roverLines = lines.sublist(1);
    if (roverLines.length.isOdd) {
      throw FormatException(
        'Rover ${roverLines.length ~/ 2 + 1} has a position but no '
        'command line.',
      );
    }

    final deployments = <Deployment>[
      for (var i = 0; i < roverLines.length; i += 2)
        Deployment(
          _parseRover(roverLines[i], i ~/ 2 + 1),
          Command.parseAll(roverLines[i + 1]),
        ),
    ];
    return Mission(plateau, deployments);
  }

  static Plateau _parsePlateau(String line) {
    final parts = _words(line);
    if (parts.length != 2) {
      throw FormatException(
        'The first line must be the plateau size, like "5 5". Got "$line".',
      );
    }
    return Plateau(_int(parts[0], line), _int(parts[1], line));
  }

  static Rover _parseRover(String line, int number) {
    final parts = _words(line);
    if (parts.length != 3) {
      throw FormatException(
        'Rover $number must look like "1 2 N". Got "$line".',
      );
    }
    return Rover(
      Position(_int(parts[0], line), _int(parts[1], line)),
      Direction.parse(parts[2].toUpperCase()),
    );
  }

  static List<String> _words(String line) =>
      line.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  static int _int(String value, String line) =>
      int.tryParse(value) ??
      (throw FormatException('"$value" is not a whole number in "$line".'));
}
