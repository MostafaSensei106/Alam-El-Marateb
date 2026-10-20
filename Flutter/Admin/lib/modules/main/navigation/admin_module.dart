import 'package:flutter/widgets.dart';

/// A top-level destination in the admin workspace.
///
/// The declaration order is the navigation order and must stay in sync with the
/// branch order in `MainPage`.
enum AdminModuleId {
  dashboard,
  identity,
  catalog,
  inventory,
  sales,
  purchasing,
  crm,
  delivery,
  hr,
  accounting,
  marketing,
  profile,
  settings,
}

/// The layout sketch used by a planned screen.
enum AdminWireframeKind {
  table,
  form,
  stats,
  calendar,
  map,
  board,
  list,
  detail,
}

/// A screen planned inside an [AdminModule].
final class AdminSubSection {
  const AdminSubSection({
    required this.title,
    required this.icon,
    required this.wireframe,
  });

  final String title;
  final IconData icon;
  final AdminWireframeKind wireframe;
}

/// Navigation metadata for one top-level admin module.
final class AdminModule {
  const AdminModule({
    required this.id,
    required this.label,
    required this.title,
    required this.description,
    required this.icon,
    required this.subSections,
  });

  /// Stable identity and branch position.
  final AdminModuleId id;

  /// Short label used by the navigation rail.
  final String label;

  /// Page heading.
  final String title;

  /// Supporting copy under the page heading.
  final String description;

  /// Rail and page icon.
  final IconData icon;

  /// Screens planned for this module.
  final List<AdminSubSection> subSections;
}
