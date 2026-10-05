import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper widget that provides all the application's module Cubits.
///
/// It uses `lazy: false` to eagerly fetch the initial data in the background
/// (Smart Parallel & Lazy Caching), adhering to the Clean Architecture principles.
/// By injecting this at the root of the authenticated shell (`MainPage`),
/// we guarantee that no unauthorized API requests are fired.
import 'package:nested/nested.dart';

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
  final List<SingleChildWidget> providers;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: providers, child: child);
  }
}
