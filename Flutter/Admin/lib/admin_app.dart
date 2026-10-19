import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart';

final class AdminApp extends StatelessWidget {
  const AdminApp({required this.startLocation, super.key});
  final String startLocation;

  @override
  Widget build(BuildContext context) {
    AppRouter.setInitialLocation(startLocation);

    return MultiBlocSignalProvider(
      providers: const [],
      child: Builder(
        builder: (context) {
          return MaterialApp.router();
        },
      ),
    );
  }
}
