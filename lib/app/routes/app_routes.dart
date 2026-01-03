part of 'app_router.dart';

class AppRoutes {
  AppRoutes._();

  static List<GoRoute> getRoutes(GlobalKey<NavigatorState> navigatorKey) {
    return [
      GoRoute(
        path: AppRoutesName.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutesName.transaction,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<TransactionBloc>(),
          child: const TransactionView(),
        ),
      ),
    ];
  }
}
