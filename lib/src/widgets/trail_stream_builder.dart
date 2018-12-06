import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_utils/dart_utils.dart';

class TrailStreamBuilder<T> extends StatefulWidget {
  const TrailStreamBuilder({
    Key key,
    this.initialData,
    @required this.stream,
    @required this.builder,
    this.trailCount = 10,
  }) : super(key: key);

  final T initialData;
  final AsyncWidgetBuilder<List<T>> builder;
  final Stream<T> stream;
  final int trailCount;

  @override
  _TrailStreamBuilderState<T> createState() => _TrailStreamBuilderState<T>();
}

class _TrailStreamBuilderState<T> extends State<TrailStreamBuilder<T>> {
  Stream<List<T>> _trailStream;

  @override
  void initState() {
    super.initState();
    _trailStream = widget.stream.transform(trail(widget.trailCount));
  }

  @override
  void didUpdateWidget(TrailStreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _trailStream = widget.stream.transform(trail(widget.trailCount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: widget.initialData != null ? <T>[widget.initialData] : null,
      stream: _trailStream,
      builder: widget.builder,
    );
  }
}