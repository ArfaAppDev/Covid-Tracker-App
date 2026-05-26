// lib/widgets/shimmer_loader.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_theme.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.divider,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.divider,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerStatGrid extends StatelessWidget {
  const ShimmerStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: List.generate(
        4,
        (_) => const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 80, height: 12),
                SizedBox(height: 12),
                ShimmerBox(width: 110, height: 22),
                SizedBox(height: 6),
                ShimmerBox(width: 60, height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerCountryList extends StatelessWidget {
  const ShimmerCountryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              ShimmerBox(width: 36, height: 24, borderRadius: 4),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 120, height: 14),
                    SizedBox(height: 6),
                    ShimmerBox(width: 80, height: 11),
                  ],
                ),
              ),
              ShimmerBox(width: 70, height: 14),
            ],
          ),
        ),
      ),
    );
  }
}
