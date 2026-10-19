import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

import '../../core/router/app_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KaiselBranchedShell.specs(
      branches:         KaiselBranchSpec<HomeRoute>(
          initial: const HomeRoot(),
          builder: (context, route) => switch (route) {
            HomeRoot() => const HomeScreen(),
          },
        ),,
      chromeBuilder: chromeBuilder,
    );
  }
}
