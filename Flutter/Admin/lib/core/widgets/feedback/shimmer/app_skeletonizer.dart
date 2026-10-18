import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Global Skeletonizer configuration (skeletonizer v3+).
///
/// - [SkeletonizerConfigData] no longer extends [ThemeExtension], so it must
///   be provided via [SkeletonizerConfig] (not `ThemeData.extensions`).
/// - The default config resolves the shimmer from the *platform* brightness.
///   Since the app forces its own [Theme] brightness, we pass
///   `Theme.of(context).brightness` explicitly, otherwise a light app on a
///   dark-mode device renders dark/black shimmers.
/// - `ignoreContainers: false` keeps Card/Container backgrounds painted with
///   their real color so skeletons don't collapse into transparent/overlapping
///   bones. Only text/icons/bones shimmer.
/// - `enableSwitchAnimation: true` smooths the skeleton -> content transition.
/// - `justifyMultiLineText: false` avoids stretched full-width text bones that
///   look like overlapping bars.
final class AppSkeletonizerConfig extends StatelessWidget {
  const AppSkeletonizerConfig({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        brightness: brightness,
        justifyMultiLineText: false,
        enableSwitchAnimation: true,
      ),
      child: child,
    );
  }
}

/// Convenience wrapper around [Skeletonizer] with the app-wide defaults.
///
/// Prefer [AppSkeletonizer.zone] + `Bone.*` widgets for loading states:
/// a single zone per list paints one synced shimmer instead of N nested
/// [Skeletonizer]s (which causes double/overlapping shimmers and jank).
final class AppSkeletonizer extends StatelessWidget {
  const AppSkeletonizer({
    required this.child,
    super.key,
    this.enabled = true,
    this.ignorePointers = true,
    this.enableSwitchAnimation = true,
  }) : _isZone = false;

  /// Zone mode: only `Bone.*` descendants shimmer. Containers (Card, etc.)
  /// keep their real color. Use this with the placeholders in
  /// `skeleton_placeholders.dart`.
  const AppSkeletonizer.zone({
    required this.child,
    super.key,
    this.enabled = true,
    this.ignorePointers = true,
    this.enableSwitchAnimation = false,
  }) : _isZone = true;

  final Widget child;
  final bool enabled;
  final bool ignorePointers;
  final bool enableSwitchAnimation;
  final bool _isZone;

  @override
  Widget build(BuildContext context) {
    if (_isZone) {
      return Skeletonizer.zone(
        enabled: enabled,
        ignorePointers: ignorePointers,
        child: child,
      );
    }
    return Skeletonizer(
      enabled: enabled,
      ignorePointers: ignorePointers,
      enableSwitchAnimation: enableSwitchAnimation,
      child: child,
    );
  }
}
