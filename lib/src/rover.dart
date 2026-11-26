import 'command.dart';
import 'direction.dart';
import 'position.dart';

/// A rover's place and heading.
///
/// Rovers are immutable: every command returns a new rover. That keeps the
/// rules easy to test and lets mission control check a move before it
/// accepts it.
final class Rover {
  const Rover(this.position, this.direction);

  final Position position;
  final Direction direction;

  /// The rover after one [command], without any safety checks.
  Rover apply(Command command) => switch (command) {
        Command.left => Rover(position, direction.left),
        Command.right => Rover(position, direction.right),
        Command.move => Rover(position.step(direction), direction),
      };

  @override
  bool operator ==(Object other) =>
      other is Rover &&
      other.position == position &&
      other.direction == direction;

  @override
  int get hashCode => Object.hash(position, direction);

  /// The output format of the kata, for example `1 3 N`.
  @override
  String toString() => '$position ${direction.code}';
}
