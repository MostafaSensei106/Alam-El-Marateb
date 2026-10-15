import 'package:alam_el_marateb_services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _FakeAudit implements BaseAuditLogger {
  final events = <SecurityEvent>[];

  @override
  void audit(SecurityEvent event) => events.add(event);

  @override
  void report(
    Object error,
    StackTrace stackTrace, {
    required String context,
    Map<String, Object?>? fields,
  }) {}
}

class _FakeClipboard implements ClipboardBackend {
  String? text;

  @override
  Future<void> setText(String value) async => text = value;

  @override
  Future<String?> getText() async => text;
}

void main() {
  group('UrlLauncherService validation', () {
    late _FakeAudit audit;
    late UrlLauncherService launcher;

    setUp(() {
      audit = _FakeAudit();
      launcher = UrlLauncherService(audit);
    });

    test('rejects non-http schemes and audits the block', () {
      expect(
        () => launcher.launchWebsite(url: 'ftp://example.com/x'),
        throwsArgumentError,
      );
      expect(
        audit.events.single,
        isA<ExternalUrlBlocked>().having(
          (e) => e.reason,
          'reason',
          'unsupported_scheme',
        ),
      );
    });

    test('rejects malformed urls', () {
      expect(() => launcher.launchWebsite(url: '   '), throwsArgumentError);
    });

    test('rejects invalid email without touching the OS', () {
      expect(
        () => launcher.launchEmail(to: 'not-an-email', subject: 's', body: 'b'),
        throwsArgumentError,
      );
      expect(audit.events, isEmpty);
    });

    test('rejects invalid phone without touching the OS', () {
      expect(() => launcher.callPhone('abc'), throwsArgumentError);
      expect(audit.events, isEmpty);
    });
  });

  group('AttachmentHandlerService', () {
    const baseUrl = 'https://api.alamelmarateb.com/api/v1';

    test('resolveFullUrl keeps absolute and joins relative', () {
      final handler = AttachmentHandlerService(Dio(), baseUrl: baseUrl);
      expect(
        handler.resolveFullUrl('https://cdn.x.com/f.pdf'),
        'https://cdn.x.com/f.pdf',
      );
      expect(
        handler.resolveFullUrl('/files/f.pdf'),
        'https://api.alamelmarateb.com/files/f.pdf',
      );
    });

    test('downloadFile rejects untrusted domains before network', () {
      final handler = AttachmentHandlerService(Dio(), baseUrl: baseUrl);
      expect(
        () => handler.downloadFile(
          url: 'https://evil.com/f.pdf',
          fileName: 'f.pdf',
        ),
        throwsArgumentError,
      );
    });

    test('downloadFile rejects disallowed extensions before network', () {
      final handler = AttachmentHandlerService(Dio(), baseUrl: baseUrl);
      expect(
        () => handler.downloadFile(
          url: 'https://api.alamelmarateb.com/f.exe',
          fileName: 'f.exe',
        ),
        throwsArgumentError,
      );
    });
  });

  group('AppInfoService', () {
    test('getAppDetails maps adapter fields', () {
      final info = PackageInfo(
        appName: 'TestApp',
        packageName: 'com.test.app',
        version: '1.2.3',
        buildNumber: '42',
      );
      final service = AppInfoService(PackageInfoPlusAdapter(info));
      final details = service.getAppDetails();
      expect(details.appName, 'TestApp');
      expect(details.version, '1.2.3');
      expect(details.buildNumber, '42');
      expect(details.operatingSystemName, isNotEmpty);
      expect(details.dartVersion, isNotEmpty);
    });
  });

  group('ClipboardGuardService', () {
    test('copySensitive then auto-clear wipes only own content', () async {
      final audit = _FakeAudit();
      final backend = _FakeClipboard();
      final guard = ClipboardGuardService.testing(
        audit,
        clipboard: backend,
      );

      await guard.copySensitive('secret');
      expect(backend.text, 'secret');

      await guard.clear(auto: true);
      expect(backend.text, '');
      expect(
        audit.events.whereType<ClipboardCleared>().single.auto,
        isTrue,
      );
    });

    test('auto-clear never wipes user content copied after us', () async {
      final audit = _FakeAudit();
      final backend = _FakeClipboard();
      final guard = ClipboardGuardService.testing(
        audit,
        clipboard: backend,
      );

      await guard.copySensitive('secret');
      backend.text = 'user typed this';
      await guard.clear(auto: true);
      expect(backend.text, 'user typed this');
    });
  });

  group('SessionMemoryGuard', () {
    test('wipes on background states only', () async {
      var calls = 0;
      final guard = SessionMemoryGuard(
        onBackgrounded: () async => calls++,
      );
      await guard.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(calls, 0);
      await guard.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(calls, 1);
      await guard.didChangeAppLifecycleState(AppLifecycleState.hidden);
      expect(calls, 2);
    });
  });
}
