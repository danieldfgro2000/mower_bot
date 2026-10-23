import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/core/domain/command_submission_result.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/camera_cubit.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/recording_cubit.dart';
import 'package:mower_bot/features/control/presentation/pages/control_page.dart';
import 'package:mower_bot/features/paths/domain/usecases/save_path.dart';
import 'package:mower_bot/features/telemetry/domain/usecases/observer_telemetry_use_case.dart';

class _MockGetVideoStreamUrlUseCase extends Mock
    implements GetVideoStreamUrlUseCase {}

class _MockSendDriveCommandUseCase extends Mock
    implements SendDriveCommandUseCase {}

class _MockObserverTelemetryUseCase extends Mock
    implements ObserverTelemetryUseCase {}

class _MockSavePathUseCase extends Mock implements SavePathUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late _MockGetVideoStreamUrlUseCase getVideoStreamUrl;
  late _MockSavePathUseCase savePath;
  late ControlBloc controlBloc;
  late CameraCubit cameraCubit;
  late RecordingCubit recordingCubit;
  late GoRouter router;

  setUp(() {
    getVideoStreamUrl = _MockGetVideoStreamUrlUseCase();
    final sendCommand = _MockSendDriveCommandUseCase();
    final observeTelemetry = _MockObserverTelemetryUseCase();
    savePath = _MockSavePathUseCase();

    when(() => getVideoStreamUrl()).thenReturn(null);
    when(() => observeTelemetry()).thenAnswer((_) => const Stream.empty());
    when(
      () => sendCommand(any()),
    ).thenAnswer((_) async => CommandSubmissionResult.submitted);
    when(
      () => savePath.startRecording(),
    ).thenAnswer((_) async => CommandSubmissionResult.submitted);
    when(
      () => savePath.saveRecording(any()),
    ).thenAnswer((_) async => CommandSubmissionResult.submitted);
    when(
      () => savePath.discardRecording(),
    ).thenAnswer((_) async => CommandSubmissionResult.submitted);

    controlBloc = ControlBloc(sendCommand, observeTelemetry);
    cameraCubit = CameraCubit(getVideoStreamUrl);
    recordingCubit = RecordingCubit(savePath);
    router = GoRouter(
      initialLocation: ControlPage.routeName,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, navigationShell) => navigationShell,
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: ControlPage.routeName,
                  pageBuilder: (_, _) =>
                      const NoTransitionPage(child: ControlPage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/other',
                  pageBuilder: (_, _) =>
                      const NoTransitionPage(child: Text('Other')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  });

  tearDown(() async {
    router.dispose();
    await recordingCubit.close();
    await cameraCubit.close();
    await controlBloc.close();
  });

  Widget buildApp({TextScaler textScaler = TextScaler.noScaling}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ControlBloc>.value(value: controlBloc),
        BlocProvider<CameraCubit>.value(value: cameraCubit),
        BlocProvider<RecordingCubit>.value(value: recordingCubit),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child!,
        ),
      ),
    );
  }

  testWidgets(
    'repeated control-tab entry leaves one active lifecycle refresh listener',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      for (var index = 0; index < 3; index++) {
        router.go('/other');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump();
        expect(find.byType(ControlPage, skipOffstage: false), findsOneWidget);
        router.go(ControlPage.routeName);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump();
      }

      clearInteractions(getVideoStreamUrl);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();

      verify(() => getVideoStreamUrl()).called(1);
    },
  );

  testWidgets(
    'STOP remains visible and tappable on a narrow large-text layout',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(220, 180));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
      await tester.pump();

      expect(tester.takeException(), isNull);
      final stop = find.text('STOP');
      expect(stop, findsOneWidget);

      final stopRect = tester.getRect(
        find.ancestor(of: stop, matching: find.byType(IconButton)),
      );
      expect(stopRect.left, greaterThanOrEqualTo(0));
      expect(stopRect.top, greaterThanOrEqualTo(0));
      expect(stopRect.right, lessThanOrEqualTo(220));
      expect(stopRect.bottom, lessThanOrEqualTo(180));

      await tester.tap(stop);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('canceling path naming stops and discards the recording', (
    tester,
  ) async {
    await recordingCubit.startRecording();
    await tester.pumpWidget(buildApp());
    final recordButton = find.byWidgetPredicate(
      (widget) => widget is IconButton && widget.tooltip == 'Record Path',
    );
    expect(tester.widget<IconButton>(recordButton).isSelected, isTrue);

    await tester.tap(recordButton);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Path name'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    verify(() => savePath.discardRecording()).called(1);
  });

  testWidgets('empty path name keeps the dialog open with validation', (
    tester,
  ) async {
    await recordingCubit.startRecording();
    await tester.pumpWidget(buildApp());
    final recordButton = find.byWidgetPredicate(
      (widget) => widget is IconButton && widget.tooltip == 'Record Path',
    );

    await tester.tap(recordButton);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Path name'), findsOneWidget);
    expect(find.text('Enter a path name'), findsOneWidget);
    verifyNever(() => savePath.saveRecording(any()));
    verifyNever(() => savePath.discardRecording());
  });
}
