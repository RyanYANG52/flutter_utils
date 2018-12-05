import 'package:flutter/material.dart';
import 'package:flutter_utils/dart_utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';

int _counter = 0;

void main() {
  Logger.root.level = Level.ALL;
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogOverlay(
        padding: const EdgeInsets.only(bottom: 16.0),
        alignment: Alignment.bottomCenter,
        logStream: Logger.root.onRecord.map((log) =>
            '${TimeFormatter.formatDateTime(log.time, true)} - ${log.message}'),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Example'),
          ),
          body: DoubleBackExit(
            backOnceCallback: () {
              Fluttertoast.showToast(
                msg: 'back again to exit app',
              );
            },
            exitCallback: () {
              print('App EXIT!');
            },
            child: const Center(
              child: Text('Hello World!'),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Logger.root.fine('${_counter++}');
            },
          ),
        ),
      ),
    );
  }
}
