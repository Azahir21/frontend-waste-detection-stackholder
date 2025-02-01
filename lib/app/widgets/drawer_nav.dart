import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/views/home_view.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/statistic_view.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/user_management_view.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'app_drawer.dart';

class DrawerNavView extends StatefulWidget {
  const DrawerNavView({Key? key}) : super(key: key);

  @override
  _DrawerNavViewState createState() => _DrawerNavViewState();
}

class _DrawerNavViewState extends State<DrawerNavView> {
  int _selectedIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of screens to navigate between
  static final List<Widget> _screens = <Widget>[
    HomeView(),
    StatisticView(),
    const UserManagementView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      // No AppBar is provided since the design is appbar-less
      body: Stack(
        children: [
          // Main content displayed based on the selected index
          PageStorage(
            bucket: _bucket,
            child: _screens[_selectedIndex],
          ),
          // Positioned drawer button (hamburger icon)
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
