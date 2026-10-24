import 'package:flutter/material.dart';

/// Gives first-page error/empty indicators near-viewport height so their
/// internal [Center] actually centers them on screen.
///
/// Background: paged lists use `shrinkWrapFirstPageIndicators: true`
/// because loading skeletons contain a LayoutBuilder (via `Bone.text`)
/// and crash inside `SliverFillRemaining`, which queries intrinsic
/// dimensions. That flag top-aligns EVERY first-page indicator, so error
/// and empty states  which are intrinsic-safe (plain Text/Icon)  are
/// wrapped here to recover the centered look. Loading skeletons
/// intentionally stay top-aligned.
final class CenteredFirstPageState extends StatelessWidget {
  const CenteredFirstPageState({
    required this.child,
    super.key,
    this.heightFraction = 0.65,
  });

  final Widget child;

  /// Fraction of the screen height granted to the child. 0.65 approximates
  /// the remaining viewport below a typical app bar, placing content
  /// visually centered in the leftover space.
  final double heightFraction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * heightFraction,
      width: double.infinity,
      child: child,
    );
  }
}
