import 'package:flutter/material.dart';

import '../../../main/navigation/admin_module.dart';
import 'tabs/accounts_tab.dart';
import 'tabs/checks_tab.dart';
import 'tabs/expenses_tab.dart';
import 'tabs/journal_tab.dart';
import 'tabs/reports_tab.dart';
import 'tabs/treasuries_tab.dart';

/// Routes an accounting tab to its own screen instead of the generic
/// section workspace.
///
/// Every branch receives the live [AdminSubSection] so the header title, icon
/// and `sectionId` stay driven by `AdminModules`.
Widget accountingSectionBuilder(
  BuildContext context,
  AdminSubSection section,
  int index,
) => switch (section.id) {
  'accounting.accounts' => AccountsTab(section: section),
  'accounting.journal' => JournalTab(section: section),
  'accounting.treasuries' => TreasuriesTab(section: section),
  'accounting.expenses' => ExpensesTab(section: section),
  'accounting.checks' => ChecksTab(section: section),
  _ => ReportsTab(section: section),
};
