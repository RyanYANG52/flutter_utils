import 'package:flutter/widgets.dart';

class LogOverlay<T extends Object> extends StatelessWidget {
  final List<String> _logBuffer = <String>[];
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
        color: const Color(0x8AFFFFFF),
        fontSize: 13,
        decoration: TextDecoration.none),
  })  : assert(child != null),
        assert(logStream != null),
        assert(maxLineCount > 0),
        super(key: key);

  String _getLogMessage() {
    String logMessage = '';
    for (var i = 0; i < _logBuffer.length - 1; i++) {
      logMessage += '${_logBuffer[i]}\n';
    }
    logMessage += _logBuffer[_logBuffer.length - 1];
    return logMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        IgnorePointer(
          child: StreamBuilder(
            stream: logStream,
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
              // new log received
              if (snapshot.hasData && snapshot.data != null) {
                _logBuffer.add('${snapshot.data}');
              }

              if (_logBuffer.length > maxLineCount) {
                _logBuffer.removeAt(0);
              }

              if (_logBuffer.isEmpty) {
                // empty widget
                return const LimitedBox();
              } else {
                return SafeArea(
                  child: Align(
                    alignment: alignment,
                    child: Container(
                      margin: padding,
                      padding: const EdgeInsets.all(16.0),
                      color: backgroundColor,
                      child: Text(
                        _getLogMessage(),
                        style: textStyle,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
