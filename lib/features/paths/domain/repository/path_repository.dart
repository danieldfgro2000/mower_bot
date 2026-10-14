import 'package:mower_bot/core/domain/command_submission_result.dart';

abstract class PathRepository {
  Future<void> dispose();
  Future<List<String>> fetchPaths();
  Future<CommandSubmissionResult> startRecord();
  Future<CommandSubmissionResult> stopRecord(String name);
  Future<CommandSubmissionResult> playPath(String name);
  Future<CommandSubmissionResult> stopPath(String name);
  Future<CommandSubmissionResult> deletePath(String name);
}
