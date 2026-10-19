import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'admin_app.dart';
import 'core/utils/sys_init/sys_init.dart';

void main() async {
  await SysInit.initializeCriticalServices();
  runApp(const AdminApp());
  SchedulerBinding.instance.addPostFrameCallback((_) {
    unawaited(SysInit.initializeDeferredServices());
  });
}
