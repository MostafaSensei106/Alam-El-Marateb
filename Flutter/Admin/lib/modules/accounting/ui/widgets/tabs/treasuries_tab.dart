import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../main/navigation/admin_module.dart';
import '../sample/accounting_models.dart';
import '../shared/accounting_shared.dart';
import 'transfer_detail.dart';
import 'transfer_form.dart';
import 'transfers_view.dart';
import 'treasuries_view.dart';
import 'treasury_detail.dart';
import 'treasury_form.dart';

/// Treasuries tab (`GET|POST treasuries`, `POST treasuries/transfers`).
///
/// The treasuries list and the transfers list share the tab through a view
/// switch; the shell only owns the mode and the open record so each list keeps
/// its own hooks.
final class TreasuriesTab extends HookWidget {
  const TreasuriesTab({required this.section, super.key});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final mode = useState(TreasuryViewMode.treasuries);
    final selected = useState<TreasuryRow?>(null);
    final transfer = useState<TransferRow?>(null);
    final creating = useState(false);

    if (creating.value) {
      return mode.value == TreasuryViewMode.transfers
          ? TransferForm(
              onSave: () {
                accountingShowSampleAction(context);
                creating.value = false;
              },
              onCancel: () => creating.value = false,
            )
          : TreasuryForm(
              treasury: selected.value,
              onSave: () {
                accountingShowSampleAction(context);
                creating.value = false;
              },
              onCancel: () => creating.value = false,
            );
    }

    final openTransfer = transfer.value;
    if (openTransfer != null) {
      return TransferDetail(
        transfer: openTransfer,
        onBack: () => transfer.value = null,
      );
    }

    final treasury = selected.value;
    if (treasury != null) {
      return TreasuryDetail(
        treasury: treasury,
        onBack: () => selected.value = null,
        onEdit: () => creating.value = true,
        onOpenTransfer: (value) => transfer.value = value,
      );
    }

    void changeMode(TreasuryViewMode value) {
      mode.value = value;
      selected.value = null;
      transfer.value = null;
    }

    void create() {
      selected.value = null;
      creating.value = true;
    }

    return switch (mode.value) {
      TreasuryViewMode.treasuries => TreasuriesView(
        section: section,
        mode: mode.value,
        onModeChanged: changeMode,
        onCreate: create,
        onOpen: (value) => selected.value = value,
      ),
      TreasuryViewMode.transfers => TransfersView(
        section: section,
        mode: mode.value,
        onModeChanged: changeMode,
        onCreate: create,
        onOpen: (value) => transfer.value = value,
      ),
    };
  }
}
