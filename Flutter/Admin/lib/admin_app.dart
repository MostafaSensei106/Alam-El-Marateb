import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart';

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
