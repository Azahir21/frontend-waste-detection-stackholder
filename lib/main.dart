import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_waste_management_stackholder/core/theme/color_theme.dart';
import 'package:frontend_waste_management_stackholder/core/theme/dimension_theme.dart';
import 'package:frontend_waste_management_stackholder/core/theme/text_theme.dart';
import 'package:frontend_waste_management_stackholder/dependency_injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  final box = GetStorage();
  String? savedLanguageCode = box.read('language');
  Locale appLocale;
  switch (savedLanguageCode) {
    case 'id':
      appLocale = const Locale('id', 'ID');
      break;
    case 'ja':
      appLocale = const Locale('ja', 'JP');
      break;
    default:
      appLocale = const Locale('en', 'US'); // Default to English
      break;
  }
  runApp(MyApp(appLocale: appLocale));

  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final Locale appLocale;
  const MyApp({required this.appLocale, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Lara'an",
      theme: ThemeData().copyWith(
        extensions: [
          AppDimensionsTheme.main(View.of(context)),
          AppColorsTheme.light(),
          AppTextsTheme.main(),
        ],
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      locale: appLocale,
      fallbackLocale: const Locale('en', 'US'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('id', 'ID'), // Indonesian
        Locale('ja', 'JP'), // Japanese
      ],
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
