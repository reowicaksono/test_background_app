import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_background_service/app/routes/app_routes_name.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => context.push(AppRoutesName.transaction),
          child: Text(
            "Go to Transaction",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
