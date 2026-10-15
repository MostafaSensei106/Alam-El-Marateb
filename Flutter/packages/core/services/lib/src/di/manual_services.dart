import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:alam_el_marateb_services/src/attachment_handler/attachment_handler_service.dart';
import 'package:alam_el_marateb_services/src/attachment_handler/base_attachment_handler_service.dart';

/// Manual services — the ones codegen can't own.
///
/// [AttachmentHandlerService] needs the app's configured [Dio] (with the
/// interceptor stack) plus the API origin. Called by each app AFTER
/// `buildAuthenticatedDio()`.
void registerAttachmentService(Dio dio, {String baseUrl = ApiRoutes.baseUrl}) {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<BaseAttachmentHandlerService>()) return;
  getIt.registerLazySingleton<BaseAttachmentHandlerService>(
    () => AttachmentHandlerService(dio, baseUrl: baseUrl),
  );
}
