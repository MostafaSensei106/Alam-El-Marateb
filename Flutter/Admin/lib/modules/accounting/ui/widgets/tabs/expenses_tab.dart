import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../main/navigation/admin_module.dart';
import '../sample/accounting_models.dart';
import '../shared/accounting_shared.dart';
import 'expense_detail.dart';
import 'expense_form.dart';
import 'expenses_view.dart';

/// Expenses tab (`GET|POST expenses`).
///
/// The tab itself only owns the selected/editing record; the list lives in its
/// own hook widget so the search and pagination hooks are never skipped.
final class ExpensesTab extends HookWidget {
  const ExpensesTab({required this.section, super.key});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final selected = useState<ExpenseRow?>(null);
    final editing = useState<ExpenseRow?>(null);
    final creating = useState(false);

    if (creating.value || editing.value != null) {
      return ExpenseForm(
        expense: editing.value,
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

    final expense = selected.value;
    if (expense != null) {
      return ExpenseDetail(
        expense: expense,
        onBack: () => selected.value = null,
        onEdit: () => editing.value = expense,
      );
    }

    return ExpensesView(
      section: section,
      onCreate: () => creating.value = true,
      onOpen: (expense) => selected.value = expense,
    );
  }
}
