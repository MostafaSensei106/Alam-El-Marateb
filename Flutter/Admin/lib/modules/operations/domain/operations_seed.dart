import '../../../../l10n/app_localizations.dart';
import 'operations_models.dart';

/// Stable branch identifiers used by tasks and holds.
const String opsBranchTanta = 'tanta';
const String opsBranchCairo = 'cairo';
const String opsBranchAlexandria = 'alexandria';
const String opsBranchMansoura = 'mansoura';

String opsBranchName(AppLocalizations l10n, String id) => switch (id) {
  opsBranchTanta => l10n.warehouseTanta,
  opsBranchCairo => l10n.warehouseCairo,
  opsBranchAlexandria => l10n.warehouseAlex,
  opsBranchMansoura => l10n.warehouseMansoura,
  _ => id,
};

String opsPersonName(AppLocalizations l10n, String id) => switch (id) {
  'p1' => l10n.opsPerson1,
  'p2' => l10n.opsPerson2,
  'p3' => l10n.opsPerson3,
  'p4' => l10n.opsPerson4,
  'p5' => l10n.opsPerson5,
  'p6' => l10n.opsPerson6,
  _ => id,
};

String opsGroupName(AppLocalizations l10n, String id) => switch (id) {
  'g1' => l10n.opsGroup1,
  'g2' => l10n.opsGroup2,
  'g3' => l10n.opsGroup3,
  'g4' => l10n.opsGroup4,
  _ => id,
};

/// Readable label for whoever owns a task.
String opsAssigneeLabel(AppLocalizations l10n, OpsTask task) {
  final names = switch (task.assigneeKind) {
    OpsAssigneeKind.person => [
      for (final id in task.assigneeIds) opsPersonName(l10n, id),
    ],
    OpsAssigneeKind.group => [
      for (final id in task.assigneeIds) opsGroupName(l10n, id),
    ],
    OpsAssigneeKind.branch => [
      for (final id in task.assigneeIds) opsBranchName(l10n, id),
    ],
  };

  return names.join('، ');
}

/// Sample people, groups, branches, tasks and holds for the operations module.
final class OperationsSeed {
  const OperationsSeed._();

  static const List<String> people = ['p1', 'p2', 'p3', 'p4', 'p5', 'p6'];
  static const List<String> groups = ['g1', 'g2', 'g3', 'g4'];
  static const List<String> branchIds = [
    opsBranchTanta,
    opsBranchCairo,
    opsBranchAlexandria,
    opsBranchMansoura,
  ];

  static List<OpsBranch> branches(AppLocalizations l10n) => [
    OpsBranch(
      id: opsBranchTanta,
      name: l10n.warehouseTanta,
      manager: l10n.opsPerson1,
      team: 6,
    ),
    OpsBranch(
      id: opsBranchCairo,
      name: l10n.warehouseCairo,
      manager: l10n.opsPerson2,
      team: 9,
    ),
    OpsBranch(
      id: opsBranchAlexandria,
      name: l10n.warehouseAlex,
      manager: l10n.opsPerson3,
      team: 5,
    ),
    OpsBranch(
      id: opsBranchMansoura,
      name: l10n.warehouseMansoura,
      manager: l10n.opsPerson4,
      team: 4,
    ),
  ];

  static List<OpsTask> tasks(AppLocalizations l10n) => [
    _task(
      id: 'OPS-1041',
      title: l10n.opsTask1Title,
      context: l10n.opsTask1Context,
      kind: OpsAssigneeKind.person,
      assignees: const ['p1'],
      branches: const [opsBranchTanta],
      priority: OpsPriority.normal,
      due: DateTime(2026, 10, 23),
      status: OpsTaskStatus.inProgress,
      steps: [
        (l10n.opsStep11, true),
        (l10n.opsStep1, true),
        (l10n.opsStep12, false),
        (l10n.opsStep18, false),
      ],
    ),
    _task(
      id: 'OPS-1042',
      title: l10n.opsTask2Title,
      context: l10n.opsTask2Context,
      kind: OpsAssigneeKind.group,
      assignees: const ['g1'],
      branches: const [opsBranchCairo],
      priority: OpsPriority.high,
      due: DateTime(2026, 10, 24),
      status: OpsTaskStatus.open,
      steps: [
        (l10n.opsStep3, false),
        (l10n.opsStep4, false),
        (l10n.opsStep13, false),
      ],
    ),
    _task(
      id: 'OPS-1043',
      title: l10n.opsTask3Title,
      context: l10n.opsTask3Context,
      kind: OpsAssigneeKind.person,
      assignees: const ['p3'],
      branches: const [opsBranchAlexandria],
      priority: OpsPriority.normal,
      due: DateTime(2026, 10, 22),
      status: OpsTaskStatus.inProgress,
      steps: [
        (l10n.opsStep5, true),
        (l10n.opsStep14, false),
        (l10n.opsStep18, false),
      ],
    ),
    _task(
      id: 'OPS-1044',
      title: l10n.opsTask4Title,
      context: l10n.opsTask4Context,
      kind: OpsAssigneeKind.branch,
      assignees: const [opsBranchMansoura, opsBranchTanta],
      branches: const [opsBranchMansoura, opsBranchTanta],
      priority: OpsPriority.low,
      due: DateTime(2026, 10, 18),
      status: OpsTaskStatus.done,
      steps: [(l10n.opsStep6, true), (l10n.opsStep7, true)],
    ),
    _task(
      id: 'OPS-1045',
      title: l10n.opsTask5Title,
      context: l10n.opsTask5Context,
      kind: OpsAssigneeKind.person,
      assignees: const ['p2'],
      branches: const [opsBranchTanta],
      priority: OpsPriority.normal,
      due: DateTime(2026, 10, 21),
      status: OpsTaskStatus.open,
      steps: [
        (l10n.opsStep8, false),
        (l10n.opsStep9, false),
        (l10n.opsStep10, false),
      ],
    ),
    _task(
      id: 'OPS-1046',
      title: l10n.opsTask6Title,
      context: l10n.opsTask6Context,
      kind: OpsAssigneeKind.person,
      assignees: const ['p5'],
      branches: const [opsBranchCairo],
      priority: OpsPriority.urgent,
      due: DateTime(2026, 10, 22),
      status: OpsTaskStatus.open,
      steps: [
        (l10n.opsStep15, true),
        (l10n.opsStep3, false),
        (l10n.opsStep18, false),
      ],
    ),
    _task(
      id: 'OPS-1047',
      title: l10n.opsTask7Title,
      context: l10n.opsTask7Context,
      kind: OpsAssigneeKind.group,
      assignees: const ['g4'],
      branches: const [opsBranchAlexandria],
      priority: OpsPriority.high,
      due: DateTime(2026, 10, 19),
      status: OpsTaskStatus.blocked,
      steps: [
        (l10n.opsStep3, true),
        (l10n.opsStep10, false),
        (l10n.opsStep17, false),
      ],
    ),
    _task(
      id: 'OPS-1048',
      title: l10n.opsTask8Title,
      context: l10n.opsTask8Context,
      kind: OpsAssigneeKind.person,
      assignees: const ['p6'],
      branches: const [opsBranchMansoura],
      priority: OpsPriority.low,
      due: DateTime(2026, 10, 17),
      status: OpsTaskStatus.done,
      steps: [(l10n.opsStep5, true), (l10n.opsStep18, true)],
    ),
    _task(
      id: 'OPS-1049',
      title: l10n.opsTask9Title,
      context: l10n.opsTask9Context,
      kind: OpsAssigneeKind.group,
      assignees: const ['g2'],
      branches: const [opsBranchTanta],
      priority: OpsPriority.high,
      due: DateTime(2026, 10, 21),
      status: OpsTaskStatus.open,
      steps: [
        (l10n.opsStep1, false),
        (l10n.opsStep16, false),
        (l10n.opsStep17, false),
      ],
    ),
    _task(
      id: 'OPS-1050',
      title: l10n.opsTask10Title,
      context: l10n.opsTask10Context,
      kind: OpsAssigneeKind.branch,
      assignees: const [opsBranchCairo],
      branches: const [opsBranchCairo],
      priority: OpsPriority.urgent,
      due: DateTime(2026, 10, 20),
      status: OpsTaskStatus.blocked,
      steps: [
        (l10n.opsStep2, true),
        (l10n.opsStep3, false),
        (l10n.opsStep17, false),
        (l10n.opsStep4, false),
      ],
    ),
  ];

  static List<OpsHold> holds(AppLocalizations l10n) => [
    OpsHold(
      id: 'HLD-3201',
      customer: l10n.customer1,
      item: l10n.product1,
      type: OpsHoldType.stock,
      branchId: opsBranchCairo,
      deposit: 4000,
      expected: DateTime(2026, 10, 22),
      status: OpsHoldStatus.waiting,
    ),
    OpsHold(
      id: 'HLD-3202',
      customer: l10n.customer2,
      item: l10n.product2,
      type: OpsHoldType.custom,
      branchId: opsBranchCairo,
      deposit: 3000,
      expected: DateTime(2026, 10, 24),
      status: OpsHoldStatus.waiting,
      sizeWidth: 180,
      sizeLength: 200,
    ),
    OpsHold(
      id: 'HLD-3203',
      customer: l10n.customer3,
      item: l10n.product3,
      type: OpsHoldType.stock,
      branchId: opsBranchCairo,
      deposit: 1500,
      expected: DateTime(2026, 10, 23),
      status: OpsHoldStatus.waiting,
    ),
    OpsHold(
      id: 'HLD-3204',
      customer: l10n.customer4,
      item: l10n.product4,
      type: OpsHoldType.custom,
      branchId: opsBranchTanta,
      deposit: 2500,
      expected: DateTime(2026, 10, 25),
      status: OpsHoldStatus.waiting,
      sizeWidth: 160,
      sizeLength: 195,
    ),
    OpsHold(
      id: 'HLD-3205',
      customer: l10n.customer5,
      item: l10n.product5,
      type: OpsHoldType.stock,
      branchId: opsBranchAlexandria,
      deposit: 2000,
      expected: DateTime(2026, 10, 22),
      status: OpsHoldStatus.waiting,
    ),
    OpsHold(
      id: 'HLD-3206',
      customer: l10n.customer6,
      item: l10n.product6,
      type: OpsHoldType.stock,
      branchId: opsBranchMansoura,
      deposit: 2000,
      expected: DateTime(2026, 10, 26),
      status: OpsHoldStatus.waiting,
    ),
    OpsHold(
      id: 'HLD-3207',
      customer: l10n.customer7,
      item: l10n.product7,
      type: OpsHoldType.stock,
      branchId: opsBranchCairo,
      deposit: 3500,
      expected: DateTime(2026, 10, 20),
      status: OpsHoldStatus.arrived,
    ),
    OpsHold(
      id: 'HLD-3208',
      customer: l10n.customer8,
      item: l10n.product8,
      type: OpsHoldType.custom,
      branchId: opsBranchAlexandria,
      deposit: 4500,
      expected: DateTime(2026, 10, 19),
      status: OpsHoldStatus.ready,
      sizeWidth: 170,
      sizeLength: 200,
    ),
    OpsHold(
      id: 'HLD-3209',
      customer: l10n.customer9,
      item: l10n.product9,
      type: OpsHoldType.stock,
      branchId: opsBranchTanta,
      deposit: 1800,
      expected: DateTime(2026, 10, 18),
      status: OpsHoldStatus.arrived,
    ),
    OpsHold(
      id: 'HLD-3210',
      customer: l10n.customer10,
      item: l10n.product10,
      type: OpsHoldType.stock,
      branchId: opsBranchCairo,
      deposit: 2200,
      expected: DateTime(2026, 10, 19),
      status: OpsHoldStatus.ready,
    ),
    OpsHold(
      id: 'HLD-3211',
      customer: l10n.customer2,
      item: l10n.product11,
      type: OpsHoldType.stock,
      branchId: opsBranchMansoura,
      deposit: 1000,
      expected: DateTime(2026, 10, 17),
      status: OpsHoldStatus.cancelled,
    ),
  ];

  static OpsTask _task({
    required String id,
    required String title,
    required String context,
    required OpsAssigneeKind kind,
    required List<String> assignees,
    required List<String> branches,
    required OpsPriority priority,
    required DateTime due,
    required OpsTaskStatus status,
    required List<(String, bool)> steps,
  }) => OpsTask(
    id: id,
    title: title,
    context: context,
    assigneeKind: kind,
    assigneeIds: assignees,
    branchIds: branches,
    priority: priority,
    due: due,
    status: status,
    checklist: [
      for (final (label, done) in steps)
        OpsChecklistItem(label: label, done: done),
    ],
  );
}
