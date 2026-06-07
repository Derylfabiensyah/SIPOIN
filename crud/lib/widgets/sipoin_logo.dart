import 'package:flutter/material.dart';
import 'package:crud/constants/assets.dart';

/// Widget untuk menampilkan logo SIPOIN
class SipoinLogo extends StatelessWidget {
  /// Width logo (default: 120)
  final double? width;
  
  /// Height logo (default: 120)
  final double? height;
  
  /// Fit mode untuk Image (default: BoxFit.contain)
  final BoxFit fit;

  const SipoinLogo({
    super.key,
    this.width = 120,
    this.height = 120,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoSipoin,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback jika logo tidak ditemukan
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(60),
          ),
          child: Icon(
            Icons.school,
            size: (width ?? 120) * 0.5,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }
}
