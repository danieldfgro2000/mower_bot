import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';
import 'package:mower_bot/features/paths/presentation/pages/paths_page.dart';

import 'features/connection/presentation/pages/connection_page.dart';
import 'features/control/presentation/pages/control_page.dart';
import 'features/telemetry/presentation/widgets/telemetry_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ConnectionPage(),
    ControlPage(),
    TelemetryPage(),
    PathsPage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: _currentIndex == 1
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            children: _pages,
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
                      NavigationBar(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: _onNavTap,
                        destinations: const [
                          NavigationDestination(
                            icon: Icon(Icons.wifi),
                            label: 'Connection',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.control_camera),
                            label: 'Control',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.speed),
                            label: 'Telemetry',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.map),
                            label: 'Paths',
                          ),
                        ],
                      ),
                    BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
                      buildWhen: (p, n) => p.status != n.status,
                      builder: (context, state) {
                        return _connectionStatus(state);
                      }
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Text _connectionStatus(MowerConnectionState state) {
    return switch (state) {
      MowerConnectionState(status: ConnectionStatus.ctrlWsConnected) => Text(
        'Control websocket Connected',
        textScaler: TextScaler.linear(1),
        style: TextStyle(color: Colors.green),
      ),
      MowerConnectionState(status: ConnectionStatus.videoWsConnected) => Text(
        'Video websocket Connected',
        textScaler: TextScaler.linear(1),
        style: TextStyle(color: Colors.blue),
      ),
      MowerConnectionState(status: ConnectionStatus.connecting) => const Text(
        'Connecting...',
      ),
      MowerConnectionState(status: ConnectionStatus.disconnected) => const Text(
        'Disconnected',
        style: TextStyle(color: Colors.red),
      ),
      MowerConnectionState(status: ConnectionStatus.hostUnreachable) => const Text(
        'Host unreachable',
        style: TextStyle(color: Colors.red),
      ),
      MowerConnectionState(status: ConnectionStatus.error) => Text(
        style: (TextStyle(color: Colors.red)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        state.error ?? "Error",
      ),
    };
  }
}
