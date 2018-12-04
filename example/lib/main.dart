import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DoubleBackExit(
          backOnceCallback: () {
            Fluttertoast.showToast(msg: 'back again to exit app',);            
          },
          exitCallback: (){
            print('App EXIT!');
          },
          child: const Center(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
