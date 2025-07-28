import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_event.dart';
import 'package:mower_bot/features/paths/presentation/bloc/path_state.dart';
import 'package:mower_bot/features/paths/presentation/bloc/paths_bloc.dart';

class PathsPage extends StatelessWidget {
  static const String routeName = '/paths';

  const PathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pathsBloc = context.read<PathBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Saved paths')),
      body: BlocBuilder<PathBloc, PathState>(
        builder: (context, state) {
          print('PathsPage: Current state: $state');
          switch (state) {
            case PathInitial():
              pathsBloc.add(FetchPaths());
              return const Center(child: CircularProgressIndicator());
            case PathLoading():
              return const Center(child: CircularProgressIndicator());
            case PathLoaded():
              if (state.paths.isEmpty) {
                return const Center(child: Text('No saved paths'));
              }
              return ListView.builder(
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
                            onPressed: () => pathsBloc.add(PlayPath(name)),
                            icon: Icon(isActive? Icons.pause : Icons.play_arrow),
                          ),
                          if(isActive)
                            IconButton(
                              onPressed: () => pathsBloc.add(StopPath(name)),
                              icon: Icon(Icons.stop),
                            ),
                          IconButton(
                            onPressed: () =>
                                _confirmDelete(context, name, pathsBloc),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            case PathError():
              return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

void _confirmDelete(BuildContext context, String name, PathBloc pathsBloc) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Delete path'),
      content: Text('Are you sure you want to delete the path "$name"?'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
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
