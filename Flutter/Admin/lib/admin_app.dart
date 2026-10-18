import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';

final class AdminApp extends StatelessWidget {
  final String startLocation;

  const AdminApp({super.key, required this.startLocation});

  @override
  Widget build(BuildContext context) {
    AppRouter.setInitialLocation(startLocation);

    return MultiBlocSignalProvider(
      providers: [],
      child: Builder(
        builder: (context) {
          return MaterialApp.router();
        },
      ),
    );
  }
}
