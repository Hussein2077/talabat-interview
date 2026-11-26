/// The four compass directions a rover can face, in clockwise order.
enum Direction {
  north('N', 0, 1),
  east('E', 1, 0),
  south('S', 0, -1),
  west('W', -1, 0);

  const Direction(this.code, this.dx, this.dy);

  /// The single letter used in the input and output: N, E, S or W.
  final String code;

  /// How far one step in this direction moves along x.
  final int dx;

  /// How far one step in this direction moves along y.
  final int dy;

  /// The direction after a 90 degree turn to the left.
  Direction get left => values[(index + values.length - 1) % values.length];

  /// The direction after a 90 degree turn to the right.
  Direction get right => values[(index + 1) % values.length];

  /// Reads a direction from its letter, for example `N`.
  static Direction parse(String code) {
    for (final direction in values) {
      if (direction.code == code) return direction;
    }
    throw FormatException('Unknown direction "$code". Use N, E, S or W.');
  }
}
