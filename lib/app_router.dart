import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mower_bot/features/connection/presentation/pages/connection_page.dart';
import 'package:mower_bot/features/control/presentation/pages/control_page.dart';
import 'package:mower_bot/features/paths/presentation/pages/paths_page.dart';

import 'shell/app_shell.dart';

final RouteObserver<ModalRoute<void>> mowerRouteObserver =
    RouteObserver<ModalRoute<void>>();

class AppRouter {
  static const connectionPath = '/connection';
  static const controlPath = '/control';
  static const pathsPath = '/paths';

  static GoRouter create() {
    return GoRouter(
      initialLocation: connectionPath,
      observers: [mowerRouteObserver],
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: connectionPath,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: ConnectionPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: controlPath,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: ControlPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: pathsPath,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: PathsPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
