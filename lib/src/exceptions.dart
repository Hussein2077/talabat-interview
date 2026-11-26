import 'position.dart';

/// Base type for a move that mission control refuses.
sealed class RoverException implements Exception {
  const RoverException(this.roverNumber, this.target);

  /// 1-based number of the rover, in input order.
  final int roverNumber;

  /// Where the rover tried to go.
  final Position target;

  String get message;

  @override
  String toString() => message;
}

/// The rover would drive off the edge of the plateau.
final class OutOfPlateauException extends RoverException {
  const OutOfPlateauException(super.roverNumber, super.target);

  @override
  String get message =>
      'Rover $roverNumber would leave the plateau at ($target).';
}

/// The rover would drive into another rover.
final class CollisionException extends RoverException {
  const CollisionException(super.roverNumber, super.target, this.otherRover);

  /// 1-based number of the rover already standing at [target].
  final int otherRover;

  @override
  String get message =>
      'Rover $roverNumber would hit rover $otherRover at ($target).';
}
