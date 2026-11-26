import 'direction.dart';

/// A point on the plateau. (0, 0) is the bottom-left corner.
final class Position {
  const Position(this.x, this.y);

  final int x;
  final int y;

  /// The position one step away in [direction].
  Position step(Direction direction) =>
      Position(x + direction.dx, y + direction.dy);

  @override
  bool operator ==(Object other) =>
      other is Position && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '$x $y';
}
