/// An instruction sent to a rover.
enum Command {
  /// Turn 90 degrees left without moving.
  left('L'),

  /// Turn 90 degrees right without moving.
  right('R'),

  /// Move forward one grid point.
  move('M');

  const Command(this.code);

  /// The letter used in the input: L, R or M.
  final String code;

  /// Reads one command from its letter.
  static Command parse(String code) {
    for (final command in values) {
      if (command.code == code) return command;
    }
    throw FormatException('Unknown command "$code". Use L, R or M.');
  }

  /// Reads a line such as `LMLMLMLMM`. An empty line means no commands.
  /// Spaces are ignored and lowercase letters are accepted.
  static List<Command> parseAll(String line) => line
      .toUpperCase()
      .split('')
      .where((c) => c.trim().isNotEmpty)
      .map(parse)
      .toList();
}
