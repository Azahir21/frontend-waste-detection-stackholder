import 'package:get/get.dart';

import '../data/services/auth_middleware.dart';
import '../data/services/network_middleware.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/statistic/bindings/statistic_binding.dart';
import '../modules/statistic/views/statistic_view.dart';
import '../modules/user_management/bindings/user_management_binding.dart';
import '../modules/user_management/views/user_management_view.dart';
import '../widgets/drawer_nav.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        transition: Transition.noTransition,
        middlewares: [
          ConnectivityMiddleware(),
          AuthMiddleware(),
        ]),
    GetPage(
      name: _Paths.STATISTIC,
      page: () => StatisticView(),
      binding: StatisticBinding(),
      transition: Transition.noTransition,
      middlewares: [
        ConnectivityMiddleware(),
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.noTransition,
      middlewares: [
        ConnectivityMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.APP,
      page: () => const DrawerNavView(),
      children: [
        GetPage(
          name: '/home',
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/statistic',
          page: () => StatisticView(),
          binding: StatisticBinding(),
        ),
        GetPage(
          name: '/user-management',
          page: () => UserManagementView(),
          binding: UserManagementBinding(),
        ),
      ],
      middlewares: [
        ConnectivityMiddleware(),
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.USER_MANAGEMENT,
      page: () => UserManagementView(),
      binding: UserManagementBinding(),
      middlewares: [
        ConnectivityMiddleware(),
        AuthMiddleware(),
      ],
    ),
  ];
}
