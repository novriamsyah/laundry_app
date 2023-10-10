import 'package:flutter/material.dart';
import 'package:laundry_app/pages/home_view/account_page.dart';
import 'package:laundry_app/pages/home_view/home_page.dart';
import 'package:laundry_app/pages/home_view/laundry_page.dart';

class AppConstants {
  static const appName = "Bob Laundry";

  static const _host = "http://192.168.43.67:8000";

  // static const _host = "http://192.168.120.122:8000";

  // static const _host = "http://172.16.1.9:8000";

  /// ``` baseUrl = 'http://192.168.43.67/api' ```
  static const baseUrl = '$_host/api';

  /// ``` baseUrl = 'http://192.168.43.67/storage' ```
  static const baseImageUrl = '$_host/storage';

  static const laundryStatusCategory = [
    'All',
    'Pickup',
    'Queue',
    'Process',
    'Washing',
    'Dried',
    'Ironed',
    'Done',
    'Delivery'
  ];

  static List<Map> mainBottomNavPage = [
    {
      'view': const HomePage(),
      'icon': Icons.home_filled,
      'label': 'Home',
    },
    {
      'view': const LaundryPage(),
      'icon': Icons.local_laundry_service,
      'label': 'My Laundry',
    },
    {
      'view': const AccountPage(),
      'icon': Icons.account_circle,
      'label': 'Account',
    },
  ];

  static const homeCategories = [
    'All',
    'Regular',
    'Express',
    'Economical',
    'Exlusive',
  ];
}
