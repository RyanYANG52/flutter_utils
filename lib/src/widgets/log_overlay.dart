import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_utils/flutter_utils.dart';

class LogOverlay<T extends Object> extends StatelessWidget {
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final Stream<T> logStream;
  final Widget child;
  final int maxLineCount;
  final Color backgroundColor;
  final TextStyle textStyle;

  LogOverlay({
    Key key,
    @required this.logStream,
    @required this.child,
    this.padding,
    this.alignment = Alignment.topCenter,
    this.maxLineCount = 10,
    this.backgroundColor = const Color(0x8A000000),
    this.textStyle = const TextStyle(
      color: const Color(0xAAFFFFFF),
      fontSize: 13,
      decoration: TextDecoration.none,      
    ),
  })  : assert(child != null),
        assert(logStream != null),
        assert(maxLineCount > 0),
        super(key: key);

  String _getLogMessage(List<T> logs) {
    StringBuffer logMessage = StringBuffer();
    for (var i = 0; i < logs.length - 1; i++) {
      logMessage.writeln('${logs[i]}');
    }
    logMessage.write('${logs[logs.length - 1]}');
    return logMessage.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        IgnorePointer(
          child: TrailStreamBuilder(
            trailCount: maxLineCount,
            stream: logStream,
            builder: (BuildContext context, AsyncSnapshot<List<T>> snapshot) {
              // new log received
              if (snapshot.hasData && snapshot.data != null) {
                return SafeArea(
                  child: Align(
                    alignment: alignment,
                    child: Container(
                      margin: padding,
                      padding: const EdgeInsets.all(16.0),
                      color: backgroundColor,
                      child: Text(
                        _getLogMessage(snapshot.data),
                        style: textStyle,
                      ),
                    ),
                  ),
                );
              }
              return const LimitedBox();
            },
          ),
        ),
      ],
    );
  }
}