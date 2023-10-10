import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/providers/main_bottom_nav_page.dart';

class MainBottomNavPage extends StatelessWidget {
  const MainBottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Consumer(
        builder: (_, wiRef, __) {
          int indexView = wiRef.watch(bottomNavIndexProvider);
          return AppConstants.mainBottomNavPage[indexView]['view'] as Widget;
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
        child: Consumer(
          builder: (_, wiRef, __) {
            int navIndex = wiRef.watch(bottomNavIndexProvider);
            return Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              elevation: 8,
              child: BottomNavigationBar(
                currentIndex: navIndex,
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconSize: 30,
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  wiRef.read(bottomNavIndexProvider.notifier).state = value;
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey[400],
                items: AppConstants.mainBottomNavPage.map((item) {
                  return BottomNavigationBarItem(
                    icon: Icon(item['icon']),
                    label: item['label'],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
