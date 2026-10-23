import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

List<String> _findInwardDomainImports(Iterable<File> files) {
  final violations = <String>[];
  final inwardImport = RegExp(
    r"import 'package:mower_bot/(?:core/data/|features/[^']+/presentation/)",
  );

  for (final file in files) {
    final contents = file.readAsStringSync();
    for (final match in inwardImport.allMatches(contents)) {
      violations.add('${file.path}: ${match.group(0)}');
    }
  }

  return violations;
}

void main() {
  test('feature domain code does not import data or presentation layers', () {
    final domainFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              file.path.split(Platform.pathSeparator).contains('domain'),
        );

    expect(
      _findInwardDomainImports(domainFiles),
      isEmpty,
      reason: 'Domain code must own contracts and remain UI/data independent.',
    );
  });

  test('domain import boundary rejects an invalid fixture', () {
    final fixture = File(
      'test/architecture/fixtures/invalid_domain_import.txt',
    );

    expect(_findInwardDomainImports([fixture]), hasLength(1));
  });

  test('feature data implementations are owned by their feature', () {
    final misplacedFiles =
        [Directory('lib/core/data/dto'), Directory('lib/core/data/repo')]
            .where((directory) => directory.existsSync())
            .expand(
              (directory) => directory
                  .listSync(recursive: true)
                  .whereType<File>()
                  .where((file) => file.path.endsWith('.dart'))
                  .map((file) => file.path),
            );

    expect(
      misplacedFiles,
      isEmpty,
      reason: 'Feature DTOs and repositories must not live in generic core.',
    );
  });

  test('feature presentation does not import another feature presentation', () {
    final violations = <String>[];
    final featureFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    final featureImport = RegExp(
      r"import 'package:mower_bot/features/([^/]+)/presentation/",
    );

    for (final file in featureFiles) {
      final pathSegments = file.path.split(Platform.pathSeparator);
      final featureIndex = pathSegments.indexOf('features');
      final owner = pathSegments[featureIndex + 1];
      for (final match in featureImport.allMatches(file.readAsStringSync())) {
        final importedFeature = match.group(1);
        if (importedFeature != owner) {
          violations.add('${file.path}: ${match.group(0)}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Application coordination must not be owned by a feature BLoC.',
    );
  });

  test('shared telemetry freshness has one model declaration', () {
    final declarations = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .expand(
          (file) => RegExp(
            r'class TelemetryAgeModel\b',
          ).allMatches(file.readAsStringSync()).map((_) => file.path),
        )
        .toList();

    expect(
      declarations,
      hasLength(1),
      reason: 'Freshness semantics must not diverge across feature models.',
    );
  });

  test('composition, routing, and shell are application-owned', () {
    final legacyPaths = [
      'lib/core/di/injection_container.dart',
      'lib/app_router.dart',
      'lib/shell/app_shell.dart',
    ];

    expect(
      legacyPaths.where((path) => File(path).existsSync()),
      isEmpty,
      reason: 'Application composition must live under lib/app.',
    );
  });

  test('the core error barrel exports only non-UI APIs', () {
    final barrel = File('lib/core/error/error.dart').readAsStringSync();

    expect(barrel, isNot(contains("export 'error_ui.dart';")));
    expect(barrel, isNot(contains("export 'global_error_interceptor.dart';")));
  });

  test('platform services do not own Flutter widgets', () {
    final widgetFiles = Directory('lib/core/platform')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              file.readAsStringSync().contains(
                "import 'package:flutter/material.dart';",
              ),
        )
        .map((file) => file.path);

    expect(
      widgetFiles,
      isEmpty,
      reason: 'Feature presentation widgets must not live in core/platform.',
    );
  });

  test('unreachable and empty legacy modules are removed', () {
    final legacyPaths = [
      'lib/features/connection/domain/model/mower_connection_model.dart',
      'lib/features/control/domain/model/control_command_model.dart',
      'lib/features/connection/presentation/pages/components/connection_status_tile.dart',
      'lib/core/platform/platform_permissions.dart',
      'lib/core/error/exceptions.dart',
      'lib/core/error/failures.dart',
      'lib/features/paths/data/repository/path_repository_impl.dart',
      'lib/features/paths/domain/model/path_model.dart',
      'lib/features/telemetry/presentation/widgets/telemetry_page.dart',
      'lib/features/telemetry/presentation/widgets/drift_chart.dart',
    ];

    expect(legacyPaths.where((path) => File(path).existsSync()), isEmpty);
  });

  test('unused direct package and generator dependencies are removed', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final unusedEntries = [
      RegExp(r'^\s+http:', multiLine: true),
      RegExp(r'^\s+flutter_joystick:', multiLine: true),
      RegExp(r'^\s+json_annotation:', multiLine: true),
      RegExp(r'^\s+build_runner:', multiLine: true),
      RegExp(r'^\s+json_serializable:', multiLine: true),
      RegExp(r'^\s+fl_chart:', multiLine: true),
    ];

    expect(unusedEntries.where(pubspec.contains), isEmpty);
  });

  test('recording state is independent from drive control state', () {
    final controlBloc = File(
      'lib/features/control/presentation/bloc/control_bloc.dart',
    ).readAsStringSync();
    final controlState = File(
      'lib/features/control/presentation/bloc/control_state.dart',
    ).readAsStringSync();
    final recordingCubit = File(
      'lib/features/control/presentation/bloc/recording_cubit.dart',
    );

    expect(controlBloc, isNot(contains('SavePathUseCase')));
    expect(controlState, isNot(contains('isRecording')));
    expect(recordingCubit.existsSync(), isTrue);
  });
}
