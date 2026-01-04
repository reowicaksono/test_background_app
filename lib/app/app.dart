import 'package:flutter/material.dart';
import 'package:test_background_service/app/routes/app_router.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: "Test Background Service", debugShowCheckedModeBanner: false,routerConfig: AppRouter.router);
  }
}