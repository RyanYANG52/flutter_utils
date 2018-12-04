import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogOverlay(
        padding: const EdgeInsets.only(top: 16.0),
        logStream: Logger.root.onRecord,
        child: Scaffold(
          body: DoubleBackExit(
            backOnceCallback: () {
              Fluttertoast.showToast(
                msg: 'back again to exit app',
              );
            },
            exitCallback: () {
              print('App EXIT!');
            },
            child: Container(
              padding: const EdgeInsets.all(64.0),
              alignment: Alignment.topCenter,
              child: Text('Hello World'),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Logger.root.fine('${DateTime.now()}');
            },
          ),
        ),
      ),
    );
  }
}
