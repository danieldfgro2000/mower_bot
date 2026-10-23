import 'package:mower_bot/core/domain/command_submission_result.dart';

abstract class ControlRepository {
  String? get videoStreamUrl;
  bool get isCtrlWsConnected;
  Future<CommandSubmissionResult> sendDriveCommand(
    Map<String, dynamic> command,
  );
}
