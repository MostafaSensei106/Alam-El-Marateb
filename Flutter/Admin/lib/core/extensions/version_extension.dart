extension StringVersionExtension on String {
  /// Compares this version string with [requiredVersion].
  ///
  /// Correctly handles:
  /// - Stripping pre-release tags (e.g. `-beta`, `-rc1`) and build metadata (e.g. `+10`)
  /// - Unequal segment counts (e.g. `1.0` vs `1.0.1`)
  ///
  /// Returns `true` if this version is strictly lower than [requiredVersion].
  bool isLowerThan(String requiredVersion) {
    final cleanCurrent = split(RegExp(r'[-+]')).first.trim();
    final cleanRequired = requiredVersion.split(RegExp(r'[-+]')).first.trim();

    final currentParts = cleanCurrent
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    final requiredParts = cleanRequired
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    final maxLength = currentParts.length > requiredParts.length
        ? currentParts.length
        : requiredParts.length;

    for (var i = 0; i < maxLength; i++) {
      final current = i < currentParts.length ? currentParts[i] : 0;
      final required = i < requiredParts.length ? requiredParts[i] : 0;

      if (current < required) return true;
      if (current > required) return false;
    }

    return false;
  }
}
