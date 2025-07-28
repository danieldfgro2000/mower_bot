import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mower_bot/features/paths/presentation/pages/paths_page.dart';

import 'features/control/presentation/pages/control_page.dart';
import 'features/telemetry/presentation/widgets/telemetry_display.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [ControlPage(), TelemetryPage(), PathsPage()];

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
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: _currentIndex == 0
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.control_camera),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Telemetry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Paths',
          ),
        ],
      ),
    );
  }
}
