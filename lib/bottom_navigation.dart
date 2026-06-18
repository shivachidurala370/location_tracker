import 'package:background_location_tracker/screens/history_screen.dart';
import 'package:background_location_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseBottomNavigationPage extends StatefulWidget {
  final int? index;
  const BaseBottomNavigationPage({super.key, this.index});

  @override
  State<BaseBottomNavigationPage> createState() =>
      _BaseBottomNavigationPageState();
}

class _BaseBottomNavigationPageState extends State<BaseBottomNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [HomeScreen(), HistoryScreen()];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),

      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: IndexedStack(index: _currentIndex, children: _tabs),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home_filled, label: 'Home', index: 0),
                _buildNavItem(
                  icon: Icons.history_rounded,
                  label: 'History',
                  index: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        // Defined width/padding parameters prevent layout raster shifts
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1D61FF)
              : Colors
                    .transparent, // Using the premium blue/purple shade from your image
          borderRadius: BorderRadius.circular(
            18,
          ), // Perfectly matches the capsule curvature in your screenshot
        ),
        // Stacking icon and label together inside the container
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
