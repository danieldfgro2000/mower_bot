import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_event.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_state.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';

class PathsPage extends StatefulWidget {
  static const String routeName = '/paths';

  const PathsPage({super.key});

  @override
  State<PathsPage> createState() => _PathsPageState();
}

class _PathsPageState extends State<PathsPage> {
  bool _isActive = false;
  late final RouteInformationProvider _routeInfoProvider;
  late final VoidCallback _routeListener;

  void _fetchPaths() {
    context.read<PathBloc>().add(FetchPaths());
  }

  void _syncActiveFromRoute() {
    final location = _routeInfoProvider.value.uri.toString();
    final nowActive = location.startsWith(PathsPage.routeName);

    if (nowActive && !_isActive) {
      _isActive = true;
      _fetchPaths();
    } else if (!nowActive && _isActive) {
      _isActive = false;
    }
  }

  @override
  void initState() {
    super.initState();

    final router = GoRouter.of(context);
    _routeInfoProvider = router.routeInformationProvider;
    _routeListener = _syncActiveFromRoute;
    _routeInfoProvider.addListener(_routeListener);

    // Evaluate immediately so an initial /paths route also refreshes.
    _syncActiveFromRoute();
  }

  @override
  void dispose() {
    _routeInfoProvider.removeListener(_routeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pathsBloc = context.read<PathBloc>();
    return BlocBuilder<PathBloc, PathState>(
      builder: (context, state) {
        return switch (state) {
          PathInitial() || PathLoading() =>
            const Center(child: CircularProgressIndicator()),
          PathLoaded() when state.paths.isEmpty =>
            const Center(child: Text('No saved paths')),
          PathLoaded() => Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                itemCount: state.paths.length,
                itemBuilder: (context, index) {
                  final name = state.paths[index];
                  final isActive = state.activePath == name;
                  return Card(
                    child: ListTile(
                      title: Text(name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => isActive
                                ? pathsBloc.add(StopPath(name))
                                : pathsBloc.add(PlayPath(name)),
                            icon: Icon(isActive ? Icons.stop : Icons.play_arrow),
                          ),
                          IconButton(
                            onPressed: () =>
                                _confirmDelete(context, name, pathsBloc),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          PathError() => Center(child: Text('Error: ${state.message}')),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

// ── dialogs ──────────────────────────────────────────────────


void _confirmDelete(BuildContext context, String name, PathBloc pathsBloc) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Delete path'),
      content: Text('Are you sure you want to delete "$name"?'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            pathsBloc.add(DeletePath(name));
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
