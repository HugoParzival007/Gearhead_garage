import '../data/models/records.dart';

sealed class TimelineEntry {
  const TimelineEntry();
  DateTime get date;
  int? get km;
  DateTime get createdAt;
}

class ModificationEntry extends TimelineEntry {
  const ModificationEntry(this.value);
  final ModificationWithItems value;

  @override
  DateTime get date => value.modification.date;
  @override
  int? get km => value.modification.km;
  @override
  DateTime get createdAt => value.modification.createdAt;
}

class MaintenanceEntry extends TimelineEntry {
  const MaintenanceEntry(this.value);
  final MaintenanceWithItems value;

  @override
  DateTime get date => value.record.date;
  @override
  int? get km => value.record.km;
  @override
  DateTime get createdAt => value.record.createdAt;
}

/// Newest first: date desc, then km desc (null km last), then createdAt desc.
List<TimelineEntry> buildTimeline(
  List<ModificationWithItems> mods,
  List<MaintenanceWithItems> maintenance,
) {
  final entries = <TimelineEntry>[
    for (final m in mods) ModificationEntry(m),
    for (final m in maintenance) MaintenanceEntry(m),
  ];
  entries.sort((a, b) {
    final byDate = b.date.compareTo(a.date);
    if (byDate != 0) return byDate;
    final ak = a.km, bk = b.km;
    if (ak != bk) {
      if (ak == null) return 1;
      if (bk == null) return -1;
      return bk.compareTo(ak);
    }
    return b.createdAt.compareTo(a.createdAt);
  });
  return entries;
}
