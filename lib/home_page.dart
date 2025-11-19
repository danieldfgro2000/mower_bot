import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_event.dart';
import 'package:mower_bot/features/connection/presentation/bloc/connection_state.dart';
import 'package:mower_bot/features/paths/presentation/pages/paths_page.dart';

import 'features/connection/presentation/pages/connection_page.dart';
import 'features/control/presentation/pages/control_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    ConnectionPage(),
    ControlPage(),
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
      builder: (ctx, state) {
        final orientation = MediaQuery.of(context).orientation;
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: ListView(
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
                    selected: _currentIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                      _onNavTap(0);
                    },
                  ),
                  ListTile(
                    leading: state.connectionStatus == ConnectionStatus.ctrlWsConnected
                        ? const Icon(Icons.link)
                        : const Icon(Icons.link_off),
                    title: const Text('Connect'),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<MowerConnectionBloc>().add(ConnectToMower());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.control_camera),
                    title: const Text('Control'),
                    selected: _currentIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      _onNavTap(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('Paths'),
                    selected: _currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      _onNavTap(2);
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 20,
                  child:
                  BlocBuilder<MowerConnectionBloc, MowerConnectionState>(
                    buildWhen: (p, n) =>
                    p.connectionStatus != n.connectionStatus,
                    builder: (context, state) {
                      return _connectionStatus(state);
                    },
                  ),),
                PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: _currentIndex == 1
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  children: _pages,
                ),
                if (orientation == Orientation.landscape)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Material(
                        elevation: 2,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black45,
                        child: IconButton(
                          tooltip: 'Menu',
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
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
                          currentIndex: _currentIndex,
                          onTap: _onNavTap,
                          showUnselectedLabels: false,
                          items: [
                            BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'Connection'),
                            BottomNavigationBarItem(icon: Icon(Icons.control_camera), label: 'Control'),
                            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Paths'),
                          ]),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Text _connectionStatus(MowerConnectionState state) {
    final msgStyle = const TextStyle(fontSize: 12);
    return switch (state.connectionStatus) {
      ConnectionStatus.ctrlWsConnected => Text(
        'Connected to mower (control)',
        textScaler: TextScaler.linear(1),
        style: msgStyle.copyWith(color: Colors.green),
      ),
      ConnectionStatus.videoWsConnected => Text(
        'Video stream connected',
        textScaler: TextScaler.linear(1),
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

  String _short(String s) => s.length > 48 ? s.substring(0, 45) + '...' : s;
}
