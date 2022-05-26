import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'extension/tuple_extension.dart';
import 'list_notifier.dart';

export 'package:tuple/tuple.dart';

/// [Tuple2] WidgetBuilder
typedef ValueTuple2WidgetBuilder<T, T2> = Widget Function(
    BuildContext context, Tuple2<T, T2> value, Widget? child);

/// [Tuple3] WidgetBuilder
typedef ValueTuple3WidgetBuilder<T, T2, T3> = Widget Function(
    BuildContext context, Tuple3<T, T2, T3> value, Widget? child);

/// [Tuple4] WidgetBuilder
typedef ValueTuple4WidgetBuilder<T, T2, T3, T4> = Widget Function(
    BuildContext context, Tuple4<T, T2, T3, T4> value, Widget? child);

/// [Tuple5] WidgetBuilder
typedef ValueTuple5WidgetBuilder<T, T2, T3, T4, T5> = Widget Function(
    BuildContext context, Tuple5<T, T2, T3, T4, T5> value, Widget? child);

/// [Tuple6] WidgetBuilder
typedef ValueTuple6WidgetBuilder<T, T2, T3, T4, T5, T6> = Widget Function(
    BuildContext context, Tuple6<T, T2, T3, T4, T5, T6> value, Widget? child);

/// [Tuple7] WidgetBuilder
typedef ValueTuple7WidgetBuilder<T, T2, T3, T4, T5, T6, T7> = Widget Function(
    BuildContext context,
    Tuple7<T, T2, T3, T4, T5, T6, T7> value,
    Widget? child);

/// [List] WidgetBuilder
typedef ValueListWidgetBuilder<T> = Widget Function(
    BuildContext context, List<T> value, Widget? child);

/// Tuple2<ValueListenable> 变化监听
class ValueListenableTuple2Builder<T, T2> extends ValueListenableListBuilder {
  ValueListenableTuple2Builder({
    Key? key,
    required Tuple2<ValueListenable<T>, ValueListenable<T2>> valueListenables,
    required ValueTuple2WidgetBuilder<T, T2> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenables:
              valueListenables.toTypeList<ValueListenable<dynamic>>(),
          builder: (context, value, child) =>
              builder(context, Tuple2.fromList(value), child),
          child: child,
        );
}

/// Tuple3<ValueListenable> 变化监听
class ValueListenableTuple3Builder<T, T2, T3>
    extends ValueListenableListBuilder {
  ValueListenableTuple3Builder({
    Key? key,
    required Tuple3<ValueListenable<T>, ValueListenable<T2>,
            ValueListenable<T3>>
        valueListenables,
    required ValueTuple3WidgetBuilder<T, T2, T3> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenables:
              valueListenables.toTypeList<ValueListenable<dynamic>>(),
          builder: (context, value, child) =>
              builder(context, Tuple3.fromList(value), child),
          child: child,
        );
}

/// Tuple4<ValueListenable> 变化监听
class ValueListenableTuple4Builder<T, T2, T3, T4>
    extends ValueListenableListBuilder {
  ValueListenableTuple4Builder({
    Key? key,
    required Tuple4<ValueListenable<T>, ValueListenable<T2>,
            ValueListenable<T3>, ValueListenable<T4>>
        valueListenables,
    required ValueTuple4WidgetBuilder<T, T2, T3, T4> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenables:
              valueListenables.toTypeList<ValueListenable<dynamic>>(),
          builder: (context, value, child) =>
              builder(context, Tuple4.fromList(value), child),
          child: child,
        );
}

/// Tuple5<ValueListenable> 变化监听
class ValueListenableTuple5Builder<T, T2, T3, T4, T5>
    extends ValueListenableListBuilder {
  ValueListenableTuple5Builder({
    Key? key,
    required Tuple5<ValueListenable<T>, ValueListenable<T2>,
            ValueListenable<T3>, ValueListenable<T4>, ValueListenable<T5>>
        valueListenables,
    required ValueTuple5WidgetBuilder<T, T2, T3, T4, T5> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenables:
              valueListenables.toTypeList<ValueListenable<dynamic>>(),
          builder: (context, value, child) =>
              builder(context, Tuple5.fromList(value), child),
          child: child,
        );
}

/// Tuple6<ValueListenable> 变化监听
class ValueListenableTuple6Builder<T, T2, T3, T4, T5, T6>
    extends ValueListenableListBuilder {
  ValueListenableTuple6Builder({
    Key? key,
    required Tuple6<
            ValueListenable<T>,
            ValueListenable<T2>,
            ValueListenable<T3>,
            ValueListenable<T4>,
            ValueListenable<T5>,
            ValueListenable<T6>>
        valueListenables,
    required ValueTuple6WidgetBuilder<T, T2, T3, T4, T5, T6> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenables:
              valueListenables.toTypeList<ValueListenable<dynamic>>(),
          builder: (context, value, child) =>
              builder(context, Tuple6.fromList(value), child),
          child: child,
        );
}

/// Tuple7<ValueListenable> 变化监听
class ValueListenableTuple7Builder<T, T2, T3, T4, T5, T6, T7>
    extends ValueListenableListBuilder {
  ValueListenableTuple7Builder({
    Key? key,
    required Tuple7<
            ValueListenable<T>,
            ValueListenable<T2>,
            ValueListenable<T3>,
            ValueListenable<T4>,
            ValueListenable<T5>,
            ValueListenable<T6>,
            ValueListenable<T7>>
        valueListenables,
    required ValueTuple7WidgetBuilder<T, T2, T3, T4, T5, T6, T7> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenables:
              valueListenables.toTypeList<ValueListenable<dynamic>>(),
          builder: (context, value, child) =>
              builder(context, Tuple7.fromList(value), child),
          child: child,
        );
}

/// 多个 [ValueListenable] 变化监听
class ValueListenableListBuilder<T> extends StatefulWidget {
  const ValueListenableListBuilder({
    Key? key,
    required this.valueListenables,
    required this.builder,
    this.child,
  }) : super(key: key);

  final List<ValueListenable<T>> valueListenables;

  final ValueListWidgetBuilder<T> builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ValueListenableListBuilderState<T>();
}

class _ValueListenableListBuilderState<T>
    extends State<ValueListenableListBuilder<T>> {
  late List<ValueListenable<T>> value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenables;
    widget.valueListenables.forEach((element) {
      element.addListener(_valueChanged);
    });
  }

  @override
  void didUpdateWidget(ValueListenableListBuilder<T> oldWidget) {
    if (!const DeepCollectionEquality()
        .equals(oldWidget.valueListenables, widget.valueListenables)) {
      oldWidget.valueListenables.forEach((element) {
        element.removeListener(_valueChanged);
      });
      value = widget.valueListenables;
      widget.valueListenables.forEach((element) {
        element.addListener(_valueChanged);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenables.forEach((element) {
      element.removeListener(_valueChanged);
    });
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = List.of(widget.valueListenables);
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = value.map((e) => e.value).toList();
    return widget.builder(context, result, widget.child);
  }
}

/// [ListListenable] 变化监听
/// [ListListenable] 是可监听[List]的包装类
class ListListenableBuilder<T>
    extends ListenableBuilder<ListListenable<T>, List<T>> {
  ListListenableBuilder({
    Key? key,
    required ListListenable<T> listenable,
    ShouldRebuild<List<T>>? shouldRebuild,
    required ValueWidgetBuilder<List<T>> builder,
    Widget? child,
  }) : super(
          key: key,
          listenable: listenable,
          selector: (ListListenable<T> listenable) => List.of(listenable.value),
          shouldRebuild: shouldRebuild,
          builder: builder,
          child: child,
        );
}

/// Listenable 变化监听
class ListenableBuilder<T extends Listenable, S> extends StatefulWidget {
  ListenableBuilder({
    Key? key,
    required this.listenable,
    required this.selector,
    required this.builder,
    ShouldRebuild<S>? shouldRebuild,
    this.child,
  })  : _shouldRebuild = shouldRebuild,
        super(key: key);

  final T listenable;

  final S Function(T listenable) selector;

  final ShouldRebuild<S>? _shouldRebuild;

  final ValueWidgetBuilder<S> builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ListenableBuilderState<T, S>();
}

class _ListenableBuilderState<T extends Listenable, S>
    extends State<ListenableBuilder<T, S>> {
  late S value;
  late S oldValue;
  late Widget cache;
  Widget? oldWidget;

  @override
  void initState() {
    super.initState();
    value = widget.selector(widget.listenable);
    widget.listenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(ListenableBuilder<T, S> oldWidget) {
    if (oldWidget.listenable != widget.listenable) {
      oldWidget.listenable.removeListener(_valueChanged);
      oldValue = value;
      value = widget.selector(widget.listenable);
      widget.listenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      oldValue = value;
      value = widget.selector(widget.listenable);
    });
  }

  @override
  Widget build(BuildContext context) {
    var shouldInvalidateCache = oldWidget != widget ||
        (widget._shouldRebuild?.call(oldValue, value) ??
            !const DeepCollectionEquality().equals(oldValue, value));
    if (shouldInvalidateCache) {
      oldWidget = widget;
      cache = widget.builder(context, value, widget.child);
    }
    return cache;
  }
}
