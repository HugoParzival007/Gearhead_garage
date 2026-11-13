import 'package:uuid/uuid.dart';

abstract interface class IdGenerator {
  String newId();
}

/// UUID v4 gerado no aparelho.
class UuidIdGenerator implements IdGenerator {
  UuidIdGenerator() : _uuid = const Uuid();

  final Uuid _uuid;

  @override
  String newId() => _uuid.v4();
}
