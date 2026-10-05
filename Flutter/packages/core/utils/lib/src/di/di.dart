import 'package:get_it/get_it.dart';

/// Shared service locator accessor (mirrors the reference toolkit's di.dart).
/// Apps register everything in their own composition root; shared code
/// only resolves through this instance — never creates containers.
final GetIt getIt = GetIt.instance;
