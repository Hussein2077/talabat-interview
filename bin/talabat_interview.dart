import 'dart:convert';
import 'dart:io';

import 'package:talabat_interview/mars_rover.dart';

/// Runs the Mars Rover kata.
///
///   dart run                    reads the input from stdin
///   dart run bin/talabat_interview.dart input.txt   reads it from a file
Future<void> main(List<String> arguments) async {
  final String input;
  if (arguments.isNotEmpty) {
    input = await File(arguments.first).readAsString();
  } else {
    input = await stdin.transform(utf8.decoder).join();
  }

  try {
    stdout.writeln(const MissionControl().runText(input));
  } on FormatException catch (e) {
    stderr.writeln('Invalid input: ${e.message}');
    exitCode = 64;
  } on RoverException catch (e) {
    stderr.writeln(e.message);
    exitCode = 1;
  }
}
