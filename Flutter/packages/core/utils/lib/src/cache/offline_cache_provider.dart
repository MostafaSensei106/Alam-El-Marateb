import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

/// A generic wrapper widget that provides a list of BlocProviders to the tree.
///
/// This adheres to the Open-Closed Principle (OCP) and Dependency Inversion
/// Principle (DIP). It delegates the responsibility of knowing *which* cubits
/// to prefetch to an external configuration, keeping the UI layer completely
/// decoupled from specific state management implementations.
///
/// Each app builds its own provider list (eager providers for smart
/// parallel background prefetching) with [SingleChildBuilder]s and injects
/// it here — typically at the root of the authenticated shell so no
/// unauthorized API requests fire.
///
/// Example:
/// ```dart
/// OfflineCacheProvider(
///   providers: [
///     SingleChildBuilder(
///       builder: (context, child) => BlocSignalProvider.value(
///         value: getIt<ProfileCubit>(),
///         child: child!,
///       ),
///     ),
///   ],
///   child: const MainPage(),
/// )
/// ```
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
    return Nested(children: providers, child: child);
  }
}
