import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('HomeView'),
      //   centerTitle: true,
      // ),
      drawer: Drawer(
        width: 125,
        child: Column(
          children: [
            ListTile(
              title: Text('Home'),
              onTap: () {
                Get.toNamed('/home');
              },
            ),
            ListTile(
              title: Text('Statistic'),
              onTap: () {
                Get.toNamed('/statistic');
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu)),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'HomeView is working',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
