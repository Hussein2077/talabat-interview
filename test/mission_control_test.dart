import 'package:talabat_interview/mars_rover.dart';
import 'package:test/test.dart';

void main() {
  const control = MissionControl();

  group('the kata example', () {
    test('gives the expected output', () {
      const input = '''
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM
''';
      expect(control.runText(input), '1 3 N\n5 1 E');
    });
  });

  group('MissionControl', () {
    test('a rover with no commands stays where it landed', () {
      expect(control.runText('5 5\n2 2 W\n\n0 0 N\nM'), '2 2 W\n0 1 N');
    });

    test('accepts Windows line endings and extra spaces', () {
      expect(control.runText('5 5\r\n 1  2  N \r\nLMLMLMLMM\r\n'), '1 3 N');
    });

    test('runs a single point plateau', () {
      expect(control.runText('0 0\n0 0 N\nLRLR'), '0 0 N');
    });

    test('stops a rover that would drive off the plateau', () {
      expect(
        () => control.runText('5 5\n0 0 S\nM'),
        throwsA(isA<OutOfPlateauException>()
            .having((e) => e.roverNumber, 'roverNumber', 1)
            .having((e) => e.target, 'target', const Position(0, -1))),
      );
    });

    test('refuses a landing outside the plateau', () {
      expect(
        () => control.runText('5 5\n6 1 N\nM'),
        throwsA(isA<OutOfPlateauException>()),
      );
    });

    test('stops a rover that would hit a rover already in place', () {
      expect(
        () => control.runText('5 5\n1 1 N\n\n1 0 N\nM'),
        throwsA(isA<CollisionException>()
            .having((e) => e.roverNumber, 'roverNumber', 2)
            .having((e) => e.otherRover, 'otherRover', 1)
            .having((e) => e.target, 'target', const Position(1, 1))),
      );
    });

    test('refuses a landing on top of another rover', () {
      expect(
        () => control.runText('5 5\n1 1 N\n\n1 1 E\nM'),
        throwsA(isA<CollisionException>()),
      );
    });

    test('a rover may drive through where another rover started', () {
      // Rover 1 leaves (1, 1) before rover 2 starts, so the point is free.
      const input = '5 5\n1 1 N\nM\n1 0 N\nM';
      expect(control.runText(input), '1 2 N\n1 1 N');
    });

    test('returns the final rovers in input order', () {
      final rovers = control.run(Mission.parse('3 3\n0 0 E\nMM\n3 3 S\nM'));
      expect(rovers, const [
        Rover(Position(2, 0), Direction.east),
        Rover(Position(3, 2), Direction.south),
      ]);
    });
  });

  group('Mission.parse', () {
    test('rejects empty input', () {
      expect(() => Mission.parse('  \n'), throwsFormatException);
    });

    test('rejects a bad plateau line', () {
      expect(() => Mission.parse('5\n1 2 N\nM'), throwsFormatException);
      expect(() => Mission.parse('a b\n1 2 N\nM'), throwsFormatException);
    });

    test('rejects a bad rover line', () {
      expect(() => Mission.parse('5 5\n1 2\nM'), throwsFormatException);
      expect(() => Mission.parse('5 5\n1 2 Q\nM'), throwsFormatException);
    });

    test('rejects a rover without a command line', () {
      expect(() => Mission.parse('5 5\n1 2 N'), throwsFormatException);
    });

    test('a plateau with no rovers is valid', () {
      expect(Mission.parse('5 5').deployments, isEmpty);
    });
  });
}
