import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/foundation.dart';

/// Lightweight, production-safe BlocObserver.
///
/// Prints bloc lifecycle events with the same pretty format used by
/// PrettyDioLogger. Set [enabled] to `true` (e.g. in debug builds) to print
/// detailed bloc lifecycle state changes. Defaults to `kDebugMode`.
final class AppBlocObserver extends BlocSignalObserver {
  /// Default constructor
  const AppBlocObserver({
    this.enabled = kDebugMode,
    this.maxWidth = 90,
    this.logPrint = print,
  });

  /// Enable logPrint
  final bool enabled;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  final void Function(Object object) logPrint;

  bool get _shouldLog => kDebugMode && enabled;

  @override
  void onCreate(BlocSignalBase bloc) {
    super.onCreate(bloc);
    if (!_shouldLog) return;

    _printBoxed(header: '🚀 onCreate ║ ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocSignalBase bloc, Change change) {
    super.onChange(bloc, change);
    if (!_shouldLog) return;

    _printBoxed(
      header: '✨ onChange ║ ${bloc.runtimeType}',
      text: _formatChange(change),
    );
  }

  @override
  void onError(BlocSignalBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (!_shouldLog) return;

    _printBoxed(
      header: '🚨 onError ║ ${bloc.runtimeType}',
      text: error.toString(),
    );
  }

  @override
  void onClose(BlocSignalBase bloc) {
    super.onClose(bloc);
    if (!_shouldLog) return;

    _printBoxed(header: '👋 onClose ║ ${bloc.runtimeType}');
  }

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║ ${DateTime.now().toIso8601String()}');

    if (text != null && text.isNotEmpty) {
      for (final line in text.split('\n')) {
        for (final chunk in _splitLinesIfNeeded(line)) {
          logPrint('║ $chunk');
        }
      }
    }

    _printLine('╚');
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * maxWidth}$suf');

  String _formatChange(Change change) {
    final current = change.currentState.runtimeType;
    final next = change.nextState.runtimeType;
    return 'CurrentState: $current\nNextState:    $next\nDetails:$change';
  }

  List<String> _splitLinesIfNeeded(String text) {
    final lines = <String>[];
    var start = 0;
    while (start < text.length) {
      var end = start + maxWidth;
      if (end >= text.length) {
        end = text.length;
      } else {
        final lastSpace = text.lastIndexOf(', ', end);
        if (lastSpace > start) {
          end = lastSpace + 1;
        }
      }
      lines.add(text.substring(start, end).trim());
      start = end;
    }
    return lines;
  }
}
