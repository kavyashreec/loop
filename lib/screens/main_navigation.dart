import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'home_screen.dart';
import 'marketplace_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MarketplaceScreen(),
    Placeholder(), // Add Listing
    Placeholder(), // History
    Placeholder(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [

              /// HOME
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? AppColors.primary
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),

              /// MARKETPLACE
              IconButton(
                icon: Icon(
                  Icons.storefront,
                  color: _currentIndex == 1
                      ? AppColors.primary
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),

              const SizedBox(width: 40),

              /// HISTORY
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: _currentIndex == 3
                      ? AppColors.primary
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),

              /// PROFILE
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 4
                      ? AppColors.primary
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}