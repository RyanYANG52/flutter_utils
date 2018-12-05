import 'dart:async';

StreamTransformer<T, List<T>> trail<T>(int trailCount) => _Trail(trailCount);

class _Trail<T> extends StreamTransformerBase<T, List<T>> {
  final int _trailCount;

  _Trail(this._trailCount) : assert(_trailCount > 0);

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
      if (trailResults.length > _trailCount) {
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
