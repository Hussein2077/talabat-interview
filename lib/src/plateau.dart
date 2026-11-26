import 'position.dart';

/// The rectangular area the rovers explore, from (0, 0) to ([maxX], [maxY]).
final class Plateau {
  Plateau(this.maxX, this.maxY) {
    if (maxX < 0 || maxY < 0) {
      throw ArgumentError(
        'The upper-right corner must not be negative, got ($maxX, $maxY).',
      );
    }
  }

  final int maxX;
  final int maxY;

  /// Whether [position] is on the plateau, edges included.
  bool contains(Position position) =>
      position.x >= 0 &&
      position.y >= 0 &&
      position.x <= maxX &&
      position.y <= maxY;
}
