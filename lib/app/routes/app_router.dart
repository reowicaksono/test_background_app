import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_background_service/app/routes/app_routes_name.dart';
import 'package:test_background_service/core/injections/injection_container.dart';
import 'package:test_background_service/features/home/presentation/view/home_view.dart';
import 'package:test_background_service/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:test_background_service/features/transaction/presentation/view/transaction_view.dart';

part 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: AppRoutesName.home,
    routes: [...AppRoutes.getRoutes(GlobalKey<NavigatorState>())],
  );
}
