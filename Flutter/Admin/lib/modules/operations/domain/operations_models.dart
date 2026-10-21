/// Fixed reference day for the sample operations data.
///
/// The screens are UI-only, so relative labels (due today, overdue by two
/// days) are anchored here instead of to the wall clock.
final DateTime opsReferenceDate = DateTime(2026, 10, 21);

/// Drops the time part so due-date comparisons ignore the hour.
DateTime opsDateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Who owns an operations task.
enum OpsAssigneeKind { person, group, branch }

enum OpsPriority { low, normal, high, urgent }

enum OpsTaskStatus { open, inProgress, blocked, done }

enum OpsHoldStatus { waiting, arrived, ready, cancelled }

/// Goods held for a customer are either pulled from stock or made to a custom
/// mattress size.
enum OpsHoldType { stock, custom }

/// One line of a task's to-do list.
final class OpsChecklistItem {
  const OpsChecklistItem({required this.label, this.done = false});

  final String label;
  final bool done;

  OpsChecklistItem toggle() => OpsChecklistItem(label: label, done: !done);
}

/// An internal operations task.
///
/// A task can be assigned to a single person, to a group, or directly to one
/// or more branches. Person and group tasks carry exactly one owning branch;
/// branch tasks list every branch they affect in [branchIds].
final class OpsTask {
  const OpsTask({
    required this.id,
    required this.title,
    required this.context,
    required this.assigneeKind,
    required this.assigneeIds,
    required this.branchIds,
    required this.priority,
    required this.due,
    required this.status,
    required this.checklist,
  });

  final String id;
  final String title;
  final String context;
  final OpsAssigneeKind assigneeKind;
  final List<String> assigneeIds;
  final List<String> branchIds;
  final OpsPriority priority;
  final DateTime due;
  final OpsTaskStatus status;
  final List<OpsChecklistItem> checklist;

  int get doneSteps => checklist.where((item) => item.done).length;

  double get completion =>
      checklist.isEmpty ? 0 : doneSteps / checklist.length;

  bool get isDone => status == OpsTaskStatus.done;

  bool isOverdue(DateTime reference) =>
      !isDone && opsDateOnly(due).isBefore(opsDateOnly(reference));

  bool isDueToday(DateTime reference) =>
      !isDone && opsDateOnly(due) == opsDateOnly(reference);

  OpsTask copyWith({
    OpsTaskStatus? status,
    List<OpsChecklistItem>? checklist,
  }) => OpsTask(
    id: id,
    title: title,
    context: context,
    assigneeKind: assigneeKind,
    assigneeIds: assigneeIds,
    branchIds: branchIds,
    priority: priority,
    due: due,
    status: status ?? this.status,
    checklist: checklist ?? this.checklist,
  );

  OpsTask toggleStep(int index) {
    if (index < 0 || index >= checklist.length) return this;

    final next = [...checklist];
    next[index] = next[index].toggle();

    return copyWith(checklist: next);
  }
}

/// Goods or a custom mattress size reserved for a customer until it arrives.
final class OpsHold {
  const OpsHold({
    required this.id,
    required this.customer,
    required this.item,
    required this.type,
    required this.branchId,
    required this.deposit,
    required this.expected,
    required this.status,
    this.sizeWidth,
    this.sizeLength,
  });

  final String id;
  final String customer;
  final String item;
  final OpsHoldType type;
  final String branchId;
  final int deposit;
  final DateTime expected;
  final OpsHoldStatus status;
  final int? sizeWidth;
  final int? sizeLength;

  bool get isWaiting => status == OpsHoldStatus.waiting;
}

/// One branch with the people and workload needed by the branch-load board.
final class OpsBranch {
  const OpsBranch({
    required this.id,
    required this.name,
    required this.manager,
    required this.team,
  });

  final String id;
  final String name;
  final String manager;
  final int team;
}
