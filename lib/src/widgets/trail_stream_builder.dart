import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_utils/dart_utils.dart';

class TrailStreamBuilder<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initialData != null ? <T>[initialData] : null,
      stream: stream.transform(trail(trailCount)),
      builder: builder,
    );
  }
}