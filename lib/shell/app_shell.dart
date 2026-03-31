import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // With StatefulShellRoute, the selected index is owned by navigationShell.
  int get _currentIndex => widget.navigationShell.currentIndex;

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    // Preserve per-branch navigation stacks.
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final currentIndex = _currentIndex;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
            builder: (context, state) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Menu',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.wifi_rounded),
                    title: const Text('Setup'),
                    selected: currentIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                      widget.navigationShell.goBranch(0);
                    },
                  ),
                  ListTile(
                    leading:
                        state.connectionStatus == ConnectionStatus.ctrlWsConnected
                            ? const Icon(Icons.link_off)
                            : const Icon(Icons.link),
                    title: Text(
                      state.connectionStatus == ConnectionStatus.ctrlWsConnected
                          ? 'Disconnect'
                          : 'Connect',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      state.connectionStatus == ConnectionStatus.ctrlWsConnected
                          ? context
                              .read<MowerConnectionBloc>()
                              .add(DisconnectFromMower())
                          : context
                              .read<MowerConnectionBloc>()
                              .add(ConnectToControlWebsocketMower());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.control_camera),
                    title: const Text('Control'),
                    selected: currentIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      widget.navigationShell.goBranch(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('Paths'),
                    selected: currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      widget.navigationShell.goBranch(2);
                    },
                  ),
                ],
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(child: widget.navigationShell),
            Positioned(
              top: 0,
              right: 20,
              child: BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
                buildWhen: (p, n) => p.connectionStatus != n.connectionStatus,
                builder: (context, state) => _connectionStatus(state),
              ),
            ),
            if (orientation == Orientation.landscape)
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: IconButton(
                    tooltip: 'Menu',
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isPortrait)
                    BottomNavigationBar(
                      elevation: 3,
                      currentIndex: currentIndex,
                      onTap: _onNavTap,
                      showUnselectedLabels: false,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.wifi),
                          label: 'Connection',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.control_camera),
                          label: 'Control',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.map),
                          label: 'Paths',
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Text _connectionStatus(MowerConnectionState state) {
    final msgStyle = const TextStyle(fontSize: 12);
    return switch (state.connectionStatus) {
      ConnectionStatus.ctrlWsConnected => Text(
          'Connected to mower (control)',
          textScaler: const TextScaler.linear(1),
          style: msgStyle.copyWith(color: Colors.green),
        ),
      ConnectionStatus.videoWsConnected => Text(
          'Video stream connected',
          textScaler: const TextScaler.linear(1),
          style: msgStyle.copyWith(color: Colors.blue),
        ),
      ConnectionStatus.connecting => const Text(
          'Connecting...',
          style: TextStyle(color: Colors.orange),
        ),
      ConnectionStatus.disconnected => const Text(
          'Disconnected',
          style: TextStyle(color: Colors.red),
        ),
      ConnectionStatus.hostUnreachable => Text(
          (state.error?.isNotEmpty == true)
              ? 'Host unreachable: ${_short(state.error!)}'
              : 'Host unreachable',
          style: msgStyle.copyWith(color: Colors.red),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ConnectionStatus.error => Text(
          state.error?.isNotEmpty == true ? _short(state.error!) : 'Error',
          style: msgStyle.copyWith(color: Colors.red),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
    };
  }

  String _short(String s) => s.length > 48 ? '${s.substring(0, 45)}...' : s;
}

