import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({this.logPrint = print, this.maxWidth = 80});
  final int maxWidth;
  final void Function(Object object) logPrint;

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      _printBoxed(
        header: '✨ onChange ══ ${bloc.runtimeType} ✨',
        text: '$change',
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      _printBoxed(
        header: '🚨 onError ══ ${bloc.runtimeType} 🚨',
        text: '$error',
        color: Colors.red,
      );
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      _printBoxed(header: '👋 onClosed ══ ${bloc.runtimeType} 👋');
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      _printBoxed(header: '🚀 onCreated ══ ${bloc.runtimeType} 🚀');
    }
  }

  void _printBoxed({String? header, String? text, Color color = Colors.blue}) {
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    final ansiColor = '\x1B[38;2;$r;$g;${b}m';

    log('');
    log('$ansiColor╔╣ $header');
    log('$ansiColor║ ${DateTime.now().toIso8601String()}');

    if (text != null && text.isNotEmpty) {
      final lines = _splitLinesIfNeeded(text);
      for (var line in lines) {
        if (line.contains('currentState:')) {
          line = line.replaceFirst('Change { currentState:', 'currentState:');
          log('$ansiColor║ ═> $line');
        } else if (line.contains('nextState:')) {
          log('$ansiColor║      ══════════════════════════════');
          log('$ansiColor║ ═>$line');
        } else {
          log('$ansiColor║ $line');
        }
      }
    }
    log('╚═${'═' * maxWidth}═╝');
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
