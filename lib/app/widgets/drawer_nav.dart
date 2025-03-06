import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/bindings/home_binding.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/home_view.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/bindings/statistic_binding.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/statistic_view.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/bindings/user_management_binding.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/user_management_view.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'app_drawer.dart';
import 'package:get_storage/get_storage.dart';

class DrawerNavView extends StatefulWidget {
  const DrawerNavView({Key? key}) : super(key: key);

  @override
  _DrawerNavViewState createState() => _DrawerNavViewState();
}

class _DrawerNavViewState extends State<DrawerNavView> {
  final PageStorageBucket _bucket = PageStorageBucket();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Widget> _screens = <Widget>[
    HomeView(),
    StatisticView(),
    UserManagementView(),
  ];

  static final List<String> _routes = [
    '/app/home',
    '/app/statistic',
    '/app/user-management',
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    HomeBinding().dependencies();
    StatisticBinding().dependencies();
    UserManagementBinding().dependencies();

    // Load last visited route from storage or arguments from login
    String? lastRoute =
        Get.arguments?['route'] ?? GetStorage().read('last_route');

    if (GetStorage().read('role') != 'admin' &&
        lastRoute == '/app/user-management') {
      lastRoute = '/app/home';
    }

    if (lastRoute != null && _routes.contains(lastRoute)) {
      int index = _routes.indexOf(lastRoute);
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _updateSelectedIndexFromRoute(String? route) {
    if (route != null && _routes.contains(route)) {
      int index = _routes.indexOf(route);
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Save last visited route in local storage
    GetStorage().write('last_route', _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Stack(
        children: [
          PageStorage(
            bucket: _bucket,
            child: _screens[_selectedIndex],
          ),
          Positioned(
            top: 32,
            left: 32,
            child: CustomIconButton.primary(
              iconName: AppIconName.drawer,
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}
