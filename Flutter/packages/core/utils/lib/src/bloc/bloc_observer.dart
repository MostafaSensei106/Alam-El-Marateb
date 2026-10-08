import 'dart:developer' as dev;

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/foundation.dart';

/// Lightweight, production-safe BlocObserver.
///
/// Set [enableLogging] to `true` (e.g. in debug builds) to print detailed
/// bloc lifecycle state changes. Defaults to `false`.
final class AppBlocObserver extends BlocSignalObserver {
  const AppBlocObserver({this.enableLogging = false, this.maxWidth = 80});

  final bool enableLogging;

  final int maxWidth;

  // Pure Dart ANSI Escape Codes
  static const _resetColor = '\x1B[0m';
  static const _blueColor = '\x1B[34m';
  static const _redColor = '\x1B[31m';
  static const _greenColor = '\x1B[32m';

  bool get _shouldLog => kDebugMode && enableLogging;

  @override
  void onCreate(BlocSignalBase bloc) {
    super.onCreate(bloc);
    if (!_shouldLog) return;

    _printBoxed(
      header: '🚀 onCreate ══ ${bloc.runtimeType}',
      colorAnsi: _greenColor,
    );
  }

  @override
  void onChange(BlocSignalBase bloc, Change change) {
    super.onChange(bloc, change);
    if (!_shouldLog) return;

    _printBoxed(
      header: '✨ onChange ══ ${bloc.runtimeType}',
      text: _formatChange(change),
      colorAnsi: _blueColor,
    );
  }

  @override
  void onError(BlocSignalBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (!_shouldLog) return;

    _printBoxed(
      header: '🚨 onError ══ ${bloc.runtimeType}',
      text: error.toString(),
      colorAnsi: _redColor,
    );
  }

  @override
  void onClose(BlocSignalBase bloc) {
    super.onClose(bloc);
    if (!_shouldLog) return;

    _printBoxed(
      header: '👋 onClose ══ ${bloc.runtimeType}',
      colorAnsi: _redColor,
    );
  }

  void _printBoxed({
    required String header,
    String? text,
    required String colorAnsi,
  }) {
    final buffer = StringBuffer()
      ..writeln()
      ..writeln('$colorAnsi╔╣ $header')
      ..writeln('║ ${DateTime.now().toIso8601String()}');

    if (text != null && text.isNotEmpty) {
      final lines = _splitLinesIfNeeded(text);
      for (final line in lines) {
        buffer.writeln('║ $line');
      }
    }

    buffer.write('╚═${'═' * maxWidth}═╝$_resetColor');

    dev.log(buffer.toString(), name: 'BLOC');
  }

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
