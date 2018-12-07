import 'package:flutter/material.dart';
import 'package:flutter_utils/dart_utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';

int _counter = 0;
var log = Logger('log');
var logStream = log.onRecord.map((log) =>
    '${TimeFormatter.formatDateTime(log.time, true)} - ${log.message}');

void main() {
  Logger.root.level = Level.ALL;
  runApp(AppLifecycle(
      keepAliveDurationInBackground: const Duration(seconds: 30),
      onInit: () {
        log.info('App Init');
      },
      onClose: () => print('App Exit'),
      onBecameBackground: () => log.info('App went into background'),
      onBecameForeground: () => log.info('App is brought back to foreground'),
      app: ExampleApp()));
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogOverlay(
        padding: const EdgeInsets.only(bottom: 84.0),
        alignment: Alignment.bottomCenter,
        logStream: logStream,
        child: Scaffold(
          appBar: AppBar(
            leading: ShinyLogo(
              parentBackground: Theme.of(context).primaryColor,
              opacityOffset: 0.25,
              shineDurationPercent: 0.15,
              bandSizePercent: 0.5,
              repeatDuration: const Duration(milliseconds: 2000),
              child: Icon(
                Icons.new_releases,
              ),
            ),
            centerTitle: true,
            title: OrientationBuilder(
              builder: (context, orientation) {
                return FutureBuilder(
                  future: Display().metrics,
                  builder: (context, AsyncSnapshot<DisplayMetrics> snapshot) {
                    String title = '';
                    if (snapshot.hasData) {
                      double width = NumUtil.roundAsFixed(
                          snapshot.data.screenWidthInCm, 1);
                      double height = NumUtil.roundAsFixed(
                          snapshot.data.screenHeightInCm, 1);
                      title = '${width}cm * ${height}cm';
                    }
                    return Text(title);
                  },
                );
              },
            ),
          ),
          body: DoubleBackExit(
            backOnceCallback: () {
              Fluttertoast.showToast(
                msg: 'back again to exit app',
              );
            },
            exitCallback: () {
              print('App double back EXIT!');
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  ShinyLogo(
                    parentBackground: Theme.of(context).scaffoldBackgroundColor,
                    child: Image.asset(
                      'assets/wait_logo.png',
                      height: 32.0,
                    ),
                  ),
                  ShinyLogo(
                    parentBackground: Theme.of(context).scaffoldBackgroundColor,
                    child: Image.asset(
                      'assets/logo.png',
                      height: 32.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              log.info('${_counter++}');
            },
          ),
        ),
      ),
    );
  }
}
