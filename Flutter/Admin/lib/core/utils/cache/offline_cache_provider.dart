import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';

/// A generic wrapper widget that provides a list of BlocProviders to the tree.
///
/// This adheres to the Open-Closed Principle (OCP) and Dependency Inversion
/// Principle (DIP). It delegates the responsibility of knowing *which* cubits
/// to prefetch to an external configuration, keeping the UI layer completely
/// decoupled from specific state management implementations.
final class OfflineCacheProvider extends StatelessWidget {
  const OfflineCacheProvider({
    required this.child,
    required this.providers,
    super.key,
  });

  final Widget child;
  final List<BlocSignalProviderSingleChildWidget> providers;

  @override
  Widget build(BuildContext context) {
    return MultiBlocSignalProvider(providers: providers, child: child);
  }
}
