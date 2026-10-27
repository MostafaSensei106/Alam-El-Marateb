import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../main/navigation/admin_module.dart';
import '../sample/accounting_models.dart';
import '../shared/accounting_shared.dart';
import 'check_detail.dart';
import 'check_form.dart';
import 'checks_view.dart';

/// Checks tab (`GET|POST checks`, `POST checks/{id}/status`).
///
/// The tab itself only owns the selected/editing record; the list lives in its
/// own hook widget so the search and pagination hooks are never skipped.
final class ChecksTab extends HookWidget {
  const ChecksTab({required this.section, super.key});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final selected = useState<CheckRow?>(null);
    final editing = useState<CheckRow?>(null);
    final creating = useState(false);

    if (creating.value || editing.value != null) {
      return CheckForm(
        check: editing.value,
        onSave: () {
          accountingShowSampleAction(context);
          creating.value = false;
          editing.value = null;
        },
        onCancel: () {
          creating.value = false;
          editing.value = null;
        },
      );
    }

    final check = selected.value;
    if (check != null) {
      return CheckDetail(
        check: check,
        onBack: () => selected.value = null,
        onEdit: () => editing.value = check,
      );
    }

    return ChecksView(
      section: section,
      onCreate: () => creating.value = true,
      onOpen: (check) => selected.value = check,
    );
  }
}
