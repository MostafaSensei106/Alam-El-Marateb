/// Backend readiness of an admin screen.
///
/// The admin UI is intentionally UI-only: it never fetches on its own. This
/// catalog is static metadata that mirrors what the backend already exposes so
/// operators can tell a screen backed by a live endpoint from one that is still
/// a design preview.
enum AdminSectionAvailability {
  /// The backend exposes the list/detail surface for this screen.
  live,

  /// The screen design is final but the endpoint is still planned.
  planned,

  /// A local-only screen (profile, settings) that needs no endpoint.
  local,
}

/// Static catalog mapping every section id to its backend readiness.
///
/// Keep this file free of routes, field names and transport code: it is UI
/// metadata only, consumed by the workspace header pill.
abstract final class AdminSectionCatalog {
  static const Set<String> _planned = {
    'identity.permissions',
    'inventory.transfers',
    'inventory.audits',
    'sales.orders',
    'sales.custom-orders',
    'sales.promotions',
    'purchasing.shipments',
    'purchasing.invoices',
    'crm.warranties',
    'crm.claims',
    'crm.reviews',
    'hr.payroll',
    'marketing.spin',
    'marketing.prizes',
  };

  static const Set<String> _local = {
    'profile.details',
    'profile.edit',
    'profile.password',
    'profile.permissions',
    'settings.appearance',
    'settings.notifications',
    'settings.general',
    'settings.app-info',
  };

  /// Resolves the readiness of [sectionId].
  ///
  /// Unknown ids default to [AdminSectionAvailability.live] because the
  /// dashboard and every operational module ship against live endpoints.
  static AdminSectionAvailability availabilityOf(String sectionId) {
    if (_planned.contains(sectionId)) return AdminSectionAvailability.planned;
    if (_local.contains(sectionId)) return AdminSectionAvailability.local;
    return AdminSectionAvailability.live;
  }
}
