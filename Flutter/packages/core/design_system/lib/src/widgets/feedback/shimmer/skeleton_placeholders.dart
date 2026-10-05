import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constants/app_config.dart';

/// Bone-based loading placeholders.
///
/// Rules followed here (per skeletonizer docs):
/// - ONE [Skeletonizer.zone] per loading list/screen, never one per item.
///   Multiple nested [Skeletonizer]s create out-of-sync shimmers that look
///   like "2 skeletons / overlapping".
/// - Inside a zone ONLY `Bone.*` widgets shimmer. Real containers (Card,
///   surfaceContainer backgrounds) keep their color, so nothing collapses,
///   turns black, or gets ignored.
/// - No NetworkImage / Hero / Bloc inside skeletons (fake urls + duplicated
///   hero tags crash or flicker). Bones only.
/// - Fixed heights everywhere so lists don't jump when content arrives.

/// Wraps [child] in a single synced shimmer zone with pointers ignored.
final class SkeletonZone extends StatelessWidget {
  const SkeletonZone({required this.child, super.key, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) =>
      Skeletonizer.zone(enabled: enabled, child: child);
}

final class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceContainer,
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Bone(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConfig.outBorderRadius.r),
                topRight: Radius.circular(AppConfig.outBorderRadius.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Bone.text(words: 2),
                SizedBox(height: 6),
                Bone.text(words: 1),
                SizedBox(height: 8),
                Bone(width: 70, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class ProductsGridSkeleton extends StatelessWidget {
  const ProductsGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: AppConfig.padding.w,
          vertical: AppConfig.paddingHalf.h,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: itemCount,
        itemBuilder: (_, _) => const ProductCardSkeleton(),
      ),
    );
  }
}

final class ChipRowSkeleton extends StatelessWidget {
  const ChipRowSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: SizedBox(
        height: 42.h,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: AppConfig.padding.w),
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          separatorBuilder: (_, _) => SizedBox(width: 8.w),
          itemBuilder: (_, index) => Bone(
            width: index.isEven ? 110.w : 90.w,
            height: 36.h,
            uniRadius: 20.r,
          ),
        ),
      ),
    );
  }
}

final class InvoiceCardSkeleton extends StatelessWidget {
  const InvoiceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppConfig.padding.r),
      decoration: BoxDecoration(
        color: c.surfaceContainer,
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bone.text(words: 2),
              Bone(width: 70, height: 24, uniRadius: 12),
            ],
          ),
          SizedBox(height: 12.h),
          const Bone.multiText(),
          SizedBox(height: 12.h),
          const Divider(color: Colors.transparent, height: 1),
          SizedBox(height: 12.h),
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Bone.text(words: 2), Bone(width: 60, height: 14)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class InvoiceListSkeleton extends StatelessWidget {
  const InvoiceListSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++) ...[
            const InvoiceCardSkeleton(),
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }
}

/// Order-list skeleton: same card-bone rhythm as invoices, used by the
/// My Orders first-page loading indicator.
final class OrderListSkeleton extends StatelessWidget {
  const OrderListSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++) ...[
            const InvoiceCardSkeleton(),
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }
}

/// Generic details-page skeleton: header card + rows + list rows + footer.
final class DetailsPageSkeleton extends StatelessWidget {
  const DetailsPageSkeleton({
    super.key,
    this.rows = 4,
    this.listRows = 2,
    this.hasFooter = true,
  });

  final int rows;
  final int listRows;
  final bool hasFooter;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SkeletonZone(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppConfig.padding.w,
                vertical: AppConfig.paddingHalf.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppConfig.padding.r),
                    decoration: BoxDecoration(
                      color: c.surfaceContainer,
                      borderRadius: BorderRadius.circular(
                        AppConfig.outBorderRadius.r,
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Bone.text(words: 2),
                            Bone(width: 70, height: 24, uniRadius: 12),
                          ],
                        ),
                        SizedBox(height: 12),
                        Bone.multiText(),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  for (var i = 0; i < rows; i++)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Bone.circle(size: 36),
                          SizedBox(width: 12),
                          Expanded(child: Bone.multiText()),
                        ],
                      ),
                    ),
                  SizedBox(height: 12.h),
                  const Bone.text(words: 2),
                  SizedBox(height: 16.h),
                  for (var i = 0; i < listRows; i++)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Bone.multiText(),
                    ),
                ],
              ),
            ),
          ),
          if (hasFooter)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppConfig.padding.w,
                  AppConfig.paddingHalf.h,
                  AppConfig.padding.w,
                  AppConfig.paddingHalf.h,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: c.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bone.text(words: 2),
                      Bone(width: 80, height: 16),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key, this.itemCount = 1});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++)
            Container(
              height: 150.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: AppConfig.padding.w,
                vertical: 4.h,
              ),
              padding: EdgeInsets.all(AppConfig.padding.r),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(
                  AppConfig.outBorderRadius.r,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Bone.text(words: 3),
                  SizedBox(height: 10),
                  Bone.multiText(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

final class TileListSkeleton extends StatelessWidget {
  const TileListSkeleton({
    super.key,
    this.itemCount = 6,
    this.leading = TileLeading.circle,
  });

  final int itemCount;
  final TileLeading leading;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SkeletonZone(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppConfig.padding),
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(height: AppConfig.paddingHalf.h),
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: c.surfaceContainer,
            borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading == TileLeading.circle) ...[
                const Bone.circle(size: 40),
                SizedBox(width: 12.w),
              ] else ...[
                const Bone(width: 40, height: 40, uniRadius: 10),
                SizedBox(width: 12.w),
              ],
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 3),
                    SizedBox(height: 8),
                    Bone.multiText(),
                    SizedBox(height: 8),
                    Bone(width: 90, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum TileLeading { circle, square }

final class SectorsPricesListSkeleton extends StatelessWidget {
  const SectorsPricesListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SkeletonZone(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: AppConfig.padding.w,
          vertical: AppConfig.padding.h,
        ),
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(height: AppConfig.padding.h),
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surfaceContainer,
            borderRadius: BorderRadius.circular(AppConfig.outBorderRadius.r),
            border: Border.all(color: c.outlineVariant),
          ),
          child: Row(
            children: [
              const Bone.square(size: 80, uniRadius: 12),
              SizedBox(width: 8.w),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 2),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Bone(width: 80, height: 24, uniRadius: 8),
                        SizedBox(width: 8),
                        Bone(width: 90, height: 24, uniRadius: 8),
                      ],
                    ),
                  ],
                ),
              ),
              const Bone.icon(size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

final class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SkeletonZone(
      child: Column(
        children: [
          const Bone.circle(size: 90),
          SizedBox(height: 16.h),
          const Bone.text(words: 2),
          SizedBox(height: 8.h),
          const Bone(width: 180, height: 14),
          SizedBox(height: 24.h),
          for (var i = 0; i < 4; i++)
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Bone.circle(size: 40),
                  SizedBox(width: 12),
                  Expanded(child: Bone.multiText()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

final class FormSkeleton extends StatelessWidget {
  const FormSkeleton({super.key, this.fields = 5});

  final int fields;

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < fields; i++) ...[
              const Bone(width: 100, height: 14),
              const SizedBox(height: 8),
              const Bone(height: 52, uniRadius: 12),
              const SizedBox(height: 16),
            ],
            const Bone.button(width: double.infinity),
          ],
        ),
      ),
    );
  }
}

final class PriceTextSkeleton extends StatelessWidget {
  const PriceTextSkeleton({super.key, this.words = 1});

  final int words;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(child: Bone.text(words: words));
  }
}

final class SocialSkeleton extends StatelessWidget {
  const SocialSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Bone.text(words: 3),
                SizedBox(height: 10),
                Bone.multiText(),
                SizedBox(height: 14),
                Bone.button(width: 180),
              ],
            ),
          ),
          const Spacer(),
          const Bone.text(words: 2),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Bone.circle(size: 52),
                    SizedBox(height: 8),
                    Bone(width: 52, height: 12),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
