// GetX 4 uses Flutter's legacy Material types.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/login/login_controller.dart';
import 'features/login/login_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'The Vault 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDDB044),
          brightness: Brightness.dark,
          primary: const Color(0xFFFFD574),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage<void>(
          name: '/',
          page: () => const LoginView(),
          binding: BindingsBuilder(
            () => Get.lazyPut<LoginController>(LoginController.new),
          ),
        ),
      ],
    );
  }
}
