import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/services/shared_prefs/base_pref_storage_service.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';

/// Capability granted to a role on one module.
enum _PermissionAction { view, create, edit, delete }

/// Roles the matrix can be edited for.
///
/// These are design-time personas, not backend records: the matrix is a local
/// preview until the identity permissions endpoint ships.
enum _PermissionRole { admin, manager, cashier, warehouse }

const _storageKey = 'admin.permissions.matrix.v1';

const _modules = <AdminModuleId>[
  AdminModuleId.catalog,
  AdminModuleId.inventory,
  AdminModuleId.sales,
  AdminModuleId.purchasing,
  AdminModuleId.crm,
  AdminModuleId.delivery,
  AdminModuleId.hr,
  AdminModuleId.accounting,
  AdminModuleId.marketing,
];

/// Role/action permission grid for the identity module.
///
/// The grid is deliberately local: every toggle is persisted on the device and
/// nothing is sent to the backend. It previews the permissions screen that will
/// consume the identity permissions endpoint once it ships.
final class PermissionsMatrixPanel extends HookWidget {
  const PermissionsMatrixPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final role = useState(_PermissionRole.manager);
    final grants = useState<Map<_PermissionRole, Set<String>>>(
      _defaultGrants(),
    );
    useEffect(() {
      unawaited(() async {
        final stored = await _readGrants();
        if (stored == null || !context.mounted) return;
        grants.value = stored;
      }());
      return null;
    }, const <Object>[]);

    void persist(Map<_PermissionRole, Set<String>> value) {
      grants.value = value;
      unawaited(_writeGrants(value));
    }

    void toggle(AdminModuleId module, _PermissionAction action) {
      final next = <_PermissionRole, Set<String>>{
        for (final entry in grants.value.entries)
          entry.key: <String>{...entry.value},
      };
      final active = next[role.value]!;
      final key = _key(module, action);

      if (active.contains(key)) {
        active.remove(key);
        if (action == _PermissionAction.view) {
          for (final other in _PermissionAction.values) {
            active.remove(_key(module, other));
          }
        }
      } else {
        // Editing implies reading: keep the matrix internally consistent.
        active.add(_key(module, _PermissionAction.view));
        active.add(key);
      }

      persist(next);
    }

    void reset() {
      final next = <_PermissionRole, Set<String>>{
        for (final entry in grants.value.entries)
          entry.key: <String>{...entry.value},
        role.value: _grantsFor(role.value),
      };
      persist(next);
    }

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.permissionsTitle,
            subtitle: l10n.permissionsHint,
            icon: LucideIcons.shieldCheck,
            trailing: TextButton.icon(
              onPressed: reset,
              icon: const Icon(LucideIcons.rotateCcw, size: AppIconSizes.small),
              label: Text(l10n.permissionsReset),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _RoleSelector(
            selected: role.value,
            onSelected: (value) => role.value = value,
          ),
          const SizedBox(height: AppSpacing.medium),
          _PermissionMatrix(
            modules: _modules,
            grants: grants.value[role.value] ?? const <String>{},
            onToggle: toggle,
          ),
        ],
      ),
    );
  }
}

final class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.selected, required this.onSelected});

  final _PermissionRole selected;
  final ValueChanged<_PermissionRole> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final role in _PermissionRole.values)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 4),
                child: _RolePill(
                  label: switch (role) {
                    _PermissionRole.admin => l10n.permissionsRoleAdmin,
                    _PermissionRole.manager => l10n.permissionsRoleManager,
                    _PermissionRole.cashier => l10n.permissionsRoleCashier,
                    _PermissionRole.warehouse => l10n.permissionsRoleWarehouse,
                  },
                  selected: role == selected,
                  onTap: () => onSelected(role),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _RolePill extends StatelessWidget {
  const _RolePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: AnimatedContainer(
          duration: AppMotion.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(
              color: selected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

final class _PermissionMatrix extends StatelessWidget {
  const _PermissionMatrix({
    required this.modules,
    required this.grants,
    required this.onToggle,
  });

  final List<AdminModuleId> modules;
  final Set<String> grants;
  final void Function(AdminModuleId module, _PermissionAction action)
  onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 132,
                child: Text(
                  l10n.permissionsModuleColumn,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              for (final action in _PermissionAction.values)
                SizedBox(
                  width: 58,
                  child: Text(
                    _actionLabel(l10n, action),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          for (final module in modules)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 132,
                    child: Text(
                      AdminModules.byId(l10n, module).label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  for (final action in _PermissionAction.values)
                    SizedBox(
                      width: 58,
                      child: _PermissionCell(
                        key: ValueKey(_key(module, action)),
                        granted: grants.contains(_key(module, action)),
                        label:
                            '${AdminModules.byId(l10n, module).label} '
                            '${_actionLabel(l10n, action)}',
                        onTap: () => onToggle(module, action),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

final class _PermissionCell extends StatelessWidget {
  const _PermissionCell({
    required this.granted,
    required this.label,
    required this.onTap,
    super.key,
  });

  final bool granted;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      toggled: granted,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.small),
        child: SizedBox(
          height: 40,
          child: Center(
            child: AnimatedContainer(
              duration: AppMotion.fast,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: granted
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: granted
                  ? Icon(
                      LucideIcons.check,
                      size: AppIconSizes.small,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

String _key(AdminModuleId module, _PermissionAction action) =>
    '${module.name}.${action.name}';

String _actionLabel(AppLocalizations l10n, _PermissionAction action) =>
    switch (action) {
      _PermissionAction.view => l10n.permissionsActionView,
      _PermissionAction.create => l10n.permissionsActionCreate,
      _PermissionAction.edit => l10n.permissionsActionEdit,
      _PermissionAction.delete => l10n.permissionsActionDelete,
    };

Map<_PermissionRole, Set<String>> _defaultGrants() => {
  for (final role in _PermissionRole.values) role: _grantsFor(role),
};

Set<String> _grantsFor(_PermissionRole role) {
  final grants = <String>{};

  void grant(AdminModuleId module, Set<_PermissionAction> actions) {
    for (final action in actions) {
      grants.add(_key(module, action));
    }
  }

  const readWrite = {
    _PermissionAction.view,
    _PermissionAction.create,
    _PermissionAction.edit,
  };
  const readOnly = {_PermissionAction.view};
  const readWriteDelete = {
    _PermissionAction.view,
    _PermissionAction.create,
    _PermissionAction.edit,
    _PermissionAction.delete,
  };

  switch (role) {
    case _PermissionRole.admin:
      for (final module in _modules) {
        grant(module, readWriteDelete);
      }
    case _PermissionRole.manager:
      for (final module in _modules) {
        grant(
          module,
          module == AdminModuleId.hr || module == AdminModuleId.accounting
              ? readWrite
              : readWriteDelete,
        );
      }
    case _PermissionRole.cashier:
      grant(AdminModuleId.catalog, readOnly);
      grant(AdminModuleId.inventory, readOnly);
      grant(AdminModuleId.sales, const {
        _PermissionAction.view,
        _PermissionAction.create,
      });
      grant(AdminModuleId.crm, readOnly);
    case _PermissionRole.warehouse:
      grant(AdminModuleId.catalog, readWrite);
      grant(AdminModuleId.inventory, readWrite);
      grant(AdminModuleId.purchasing, readWrite);
      grant(AdminModuleId.delivery, readWrite);
      grant(AdminModuleId.sales, readOnly);
  }

  return grants;
}

Future<Map<_PermissionRole, Set<String>>?> _readGrants() async {
  if (!getIt.isRegistered<BasePrefStorageService>()) return null;

  final raw = await getIt<BasePrefStorageService>().getData<String>(
    key: _storageKey,
  );
  if (raw == null) return null;

  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;

    return {
      for (final role in _PermissionRole.values)
        role: {
          ...?_stringSet(decoded[role.name]),
        },
    };
  } catch (_) {
    return null;
  }
}

Future<void> _writeGrants(Map<_PermissionRole, Set<String>> grants) async {
  if (!getIt.isRegistered<BasePrefStorageService>()) return;

  final payload = <String, List<String>>{
    for (final entry in grants.entries) entry.key.name: entry.value.toList(),
  };

  try {
    await getIt<BasePrefStorageService>().setData<String>(
      key: _storageKey,
      value: jsonEncode(payload),
    );
  } catch (_) {
    // A preview screen must never break because local storage is unavailable.
  }
}

Set<String>? _stringSet(Object? value) {
  if (value is! List) return null;
  return value.whereType<String>().toSet();
}
