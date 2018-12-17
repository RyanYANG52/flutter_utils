import 'dart:async';

/// Keep a trail of values from the source Stream by [trailCount].
/// 
/// [trailCount] is the maximum size of the trail emitted
/// 
///   Stream.fromIterable(<int>[1, 2, 3, 4, 5, 6])
///     .transform(trail(3))
///     .listen(print); 
///   //prints [1], [1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5] done!
/// 
StreamTransformer<T, List<T>> trail<T>(int trailCount) => _Trail(trailCount);

class _Trail<T> extends StreamTransformerBase<T, List<T>> {
  final int trailCount;

  _Trail(this.trailCount) : assert(trailCount > 0);

  @override
  Stream<List<T>> bind(Stream<T> values) {
    var controller = values.isBroadcast
        ? StreamController<List<T>>.broadcast(sync: true)
        : StreamController<List<T>>(sync: true);
    List<T> trailResults;
    StreamSubscription valueSub;
    var isValueDone = false;

    void emit() {
      controller.add(trailResults);
    }

    void onValue(T value) {
      (trailResults ??= <T>[]).add(value);
      if (trailResults.length > trailCount) {
        trailResults.removeAt(0);
      }
      emit();
    }

    void onValuesDone() {
      isValueDone = true;
      controller.close();
      trailResults?.clear();
      trailResults = null;
    }

    controller.onListen = () {
      if (valueSub != null) return;
      valueSub = values.listen(onValue,
          onError: controller.addError, onDone: onValuesDone);

      if (!values.isBroadcast) {
        controller.onPause = () {
          valueSub?.pause();
        };
        controller.onResume = () {
          valueSub?.resume();
        };
      }
      controller.onCancel = () {
        if (!isValueDone) {
          return valueSub?.cancel();
        } else {
          return null;
        }
      };
    };

    return controller.stream;
  }
}
