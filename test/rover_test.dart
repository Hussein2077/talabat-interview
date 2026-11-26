import 'package:talabat_interview/mars_rover.dart';
import 'package:test/test.dart';

void main() {
  group('Direction', () {
    test('turning left goes N -> W -> S -> E -> N', () {
      expect(Direction.north.left, Direction.west);
      expect(Direction.west.left, Direction.south);
      expect(Direction.south.left, Direction.east);
      expect(Direction.east.left, Direction.north);
    });

    test('turning right goes N -> E -> S -> W -> N', () {
      expect(Direction.north.right, Direction.east);
      expect(Direction.east.right, Direction.south);
      expect(Direction.south.right, Direction.west);
      expect(Direction.west.right, Direction.north);
    });

    test('parses its letter and rejects others', () {
      expect(Direction.parse('S'), Direction.south);
      expect(() => Direction.parse('X'), throwsFormatException);
    });
  });

  group('Position', () {
    test('steps one point in each direction', () {
      const origin = Position(2, 2);
      expect(origin.step(Direction.north), const Position(2, 3));
      expect(origin.step(Direction.east), const Position(3, 2));
      expect(origin.step(Direction.south), const Position(2, 1));
      expect(origin.step(Direction.west), const Position(1, 2));
    });
  });

  group('Plateau', () {
    final plateau = Plateau(5, 5);

    test('contains its corners and edges', () {
      expect(plateau.contains(const Position(0, 0)), isTrue);
      expect(plateau.contains(const Position(5, 5)), isTrue);
      expect(plateau.contains(const Position(0, 5)), isTrue);
    });

    test('does not contain points outside it', () {
      expect(plateau.contains(const Position(-1, 0)), isFalse);
      expect(plateau.contains(const Position(0, 6)), isFalse);
      expect(plateau.contains(const Position(6, 6)), isFalse);
    });

    test('rejects a negative size', () {
      expect(() => Plateau(-1, 5), throwsArgumentError);
    });
  });

  group('Command', () {
    test('parses a command line, ignoring spaces and case', () {
      expect(Command.parseAll('LmR M'), [
        Command.left,
        Command.move,
        Command.right,
        Command.move,
      ]);
    });

    test('an empty line means no commands', () {
      expect(Command.parseAll(''), isEmpty);
    });

    test('rejects unknown letters', () {
      expect(() => Command.parseAll('LMX'), throwsFormatException);
    });
  });

  group('Rover', () {
    const rover = Rover(Position(1, 2), Direction.north);

    test('L and R turn without moving', () {
      expect(rover.apply(Command.left),
          const Rover(Position(1, 2), Direction.west));
      expect(rover.apply(Command.right),
          const Rover(Position(1, 2), Direction.east));
    });

    test('M moves one point forward', () {
      expect(rover.apply(Command.move),
          const Rover(Position(1, 3), Direction.north));
    });

    test('prints in the kata output format', () {
      expect(rover.toString(), '1 2 N');
    });
  });
}
