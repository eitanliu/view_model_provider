import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/single_child_widget.dart';

import 'value_listenable_list_builder.dart';
import 'view_model_provider.dart';

export 'value_listenable_list_builder.dart';
export 'view_model_provider.dart';

typedef ViewModelValueTuple2<VM, T, T2>
    = Tuple2<ValueListenable<T>, ValueListenable<T2>> Function(VM viewModel);

typedef ViewModelValueTuple3<VM, T, T2, T3>
    = Tuple3<ValueListenable<T>, ValueListenable<T2>, ValueListenable<T3>>
        Function(VM viewModel);

typedef ViewModelValueTuple4<VM, T, T2, T3, T4> = Tuple4<ValueListenable<T>,
        ValueListenable<T2>, ValueListenable<T3>, ValueListenable<T4>>
    Function(VM viewModel);

typedef ViewModelValueTuple5<VM, T, T2, T3, T4, T5> = Tuple5<
        ValueListenable<T>,
        ValueListenable<T2>,
        ValueListenable<T3>,
        ValueListenable<T4>,
        ValueListenable<T5>>
    Function(VM viewModel);

typedef ViewModelValueTuple6<VM, T, T2, T3, T4, T5, T6> = Tuple6<
        ValueListenable<T>,
        ValueListenable<T2>,
        ValueListenable<T3>,
        ValueListenable<T4>,
        ValueListenable<T5>,
        ValueListenable<T6>>
    Function(VM viewModel);

typedef ViewModelValueTuple7<VM, T, T2, T3, T4, T5, T6, T7> = Tuple7<
        ValueListenable<T>,
        ValueListenable<T2>,
        ValueListenable<T3>,
        ValueListenable<T4>,
        ValueListenable<T5>,
        ValueListenable<T6>,
        ValueListenable<T7>>
    Function(VM viewModel);

typedef ViewModelValueList<VM, T> = List<ValueListenable<T>> Function(
    VM viewModel);

typedef ViewModelValueTuple2WidgetBuilder<VM, T, T2> = Widget Function(
    BuildContext context, VM viewModel, Tuple2<T, T2> value, Widget child);

typedef ViewModelValueTuple3WidgetBuilder<VM, T, T2, T3> = Widget Function(
    BuildContext context, VM viewModel, Tuple3<T, T2, T3> value, Widget child);

typedef ViewModelValueTuple4WidgetBuilder<VM, T, T2, T3, T4> = Widget Function(
    BuildContext context,
    VM viewModel,
    Tuple4<T, T2, T3, T4> value,
    Widget child);

typedef ViewModelValueTuple5WidgetBuilder<VM, T, T2, T3, T4, T5>
    = Widget Function(BuildContext context, VM viewModel,
        Tuple5<T, T2, T3, T4, T5> value, Widget child);

typedef ViewModelValueTuple6WidgetBuilder<VM, T, T2, T3, T4, T5, T6>
    = Widget Function(BuildContext context, VM viewModel,
        Tuple6<T, T2, T3, T4, T5, T6> value, Widget child);

typedef ViewModelValueTuple7WidgetBuilder<VM, T, T2, T3, T4, T5, T6, T7>
    = Widget Function(BuildContext context, VM viewModel,
        Tuple7<T, T2, T3, T4, T5, T6, T7> value, Widget child);

typedef ViewModelValueListWidgetBuilder<VM, T> = Widget Function(
    BuildContext context, VM viewModel, List<T> value, Widget child);

typedef ViewModelValueWidgetBuilder<VM, T> = Widget Function(
    BuildContext context, VM viewModel, T value, Widget child);

class ViewModelValueTuple2Builder<VM extends ChangeNotifier, T, T2>
    extends ViewModelValueListBuilder<VM, dynamic> {
  ViewModelValueTuple2Builder({
    Key key,
    @required ViewModelValueTuple2<VM, T, T2> valueListenables,
    @required ViewModelValueTuple2WidgetBuilder<VM, T, T2> builder,
    Widget child,
  }) : super(
          key: key,
          valueListenables: (viewModel) => List<ValueListenable<dynamic>>.from(
              valueListenables(viewModel).toList()),
          builder: (context, viewModel, value, child) =>
              builder(context, viewModel, Tuple2.fromList(value), child),
          child: child,
        );
}

class ViewModelValueTuple3Builder<VM extends ChangeNotifier, T, T2, T3>
    extends ViewModelValueListBuilder<VM, dynamic> {
  ViewModelValueTuple3Builder({
    Key key,
    @required ViewModelValueTuple3<VM, T, T2, T3> valueListenables,
    @required ViewModelValueTuple3WidgetBuilder<VM, T, T2, T3> builder,
    Widget child,
  }) : super(
          key: key,
          valueListenables: (viewModel) => List<ValueListenable<dynamic>>.from(
              valueListenables(viewModel).toList()),
          builder: (context, viewModel, value, child) =>
              builder(context, viewModel, Tuple3.fromList(value), child),
          child: child,
        );
}

class ViewModelValueTuple4Builder<VM extends ChangeNotifier, T, T2, T3, T4>
    extends ViewModelValueListBuilder<VM, dynamic> {
  ViewModelValueTuple4Builder({
    Key key,
    @required ViewModelValueTuple4<VM, T, T2, T3, T4> valueListenables,
    @required ViewModelValueTuple4WidgetBuilder<VM, T, T2, T3, T4> builder,
    Widget child,
  }) : super(
          key: key,
          valueListenables: (viewModel) => List<ValueListenable<dynamic>>.from(
              valueListenables(viewModel).toList()),
          builder: (context, viewModel, value, child) =>
              builder(context, viewModel, Tuple4.fromList(value), child),
          child: child,
        );
}

class ViewModelValueTuple5Builder<VM extends ChangeNotifier, T, T2, T3, T4, T5>
    extends ViewModelValueListBuilder<VM, dynamic> {
  ViewModelValueTuple5Builder({
    Key key,
    @required ViewModelValueTuple5<VM, T, T2, T3, T4, T5> valueListenables,
    @required ViewModelValueTuple5WidgetBuilder<VM, T, T2, T3, T4, T5> builder,
    Widget child,
  }) : super(
          key: key,
          valueListenables: (viewModel) => List<ValueListenable<dynamic>>.from(
              valueListenables(viewModel).toList()),
          builder: (context, viewModel, value, child) =>
              builder(context, viewModel, Tuple5.fromList(value), child),
          child: child,
        );
}

class ViewModelValueTuple6Builder<VM extends ChangeNotifier, T, T2, T3, T4, T5,
    T6> extends ViewModelValueListBuilder<VM, dynamic> {
  ViewModelValueTuple6Builder({
    Key key,
    @required ViewModelValueTuple6<VM, T, T2, T3, T4, T5, T6> valueListenables,
    @required
        ViewModelValueTuple6WidgetBuilder<VM, T, T2, T3, T4, T5, T6> builder,
    Widget child,
  }) : super(
          key: key,
          valueListenables: (viewModel) => List<ValueListenable<dynamic>>.from(
              valueListenables(viewModel).toList()),
          builder: (context, viewModel, value, child) =>
              builder(context, viewModel, Tuple6.fromList(value), child),
          child: child,
        );
}

class ViewModelValueTuple7Builder<VM extends ChangeNotifier, T, T2, T3, T4, T5,
    T6, T7> extends ViewModelValueListBuilder<VM, dynamic> {
  ViewModelValueTuple7Builder({
    Key key,
    @required
        ViewModelValueTuple7<VM, T, T2, T3, T4, T5, T6, T7> valueListenables,
    @required
        ViewModelValueTuple7WidgetBuilder<VM, T, T2, T3, T4, T5, T6, T7>
            builder,
    Widget child,
  }) : super(
          key: key,
          valueListenables: (viewModel) => List<ValueListenable<dynamic>>.from(
              valueListenables(viewModel).toList()),
          builder: (context, viewModel, value, child) =>
              builder(context, viewModel, Tuple7.fromList(value), child),
          child: child,
        );
}

class ViewModelValueListBuilder<VM extends ChangeNotifier, T>
    extends SingleChildStatelessWidget {
  final ViewModelValueList<VM, T> valueListenables;
  final ViewModelValueListWidgetBuilder<VM, T> builder;

  ViewModelValueListBuilder({
    Key key,
    @required this.valueListenables,
    @required this.builder,
    Widget child,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return ViewModelBuilder<VM>(builder: (context, viewModel, child) {
      return ValueListenableListBuilder<T>(
        valueListenables: valueListenables(viewModel),
        builder: (context, value, child) => builder(
          context,
          viewModel,
          value,
          child,
        ),
      );
    });
  }
}

class ViewModelValueBuilder<VM extends ChangeNotifier, T>
    extends SingleChildStatelessWidget {
  final ValueListenable<T> Function(VM viewModel) valueListenable;
  final ViewModelValueWidgetBuilder<VM, T> builder;

  ViewModelValueBuilder({
    Key key,
    @required this.valueListenable,
    @required this.builder,
    Widget child,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return ViewModelBuilder<VM>(builder: (context, viewModel, child) {
      return ValueListenableBuilder<T>(
        valueListenable: valueListenable(viewModel),
        builder: (context, value, child) => builder(
          context,
          viewModel,
          value,
          child,
        ),
      );
    });
  }
}

class ViewModelBuilder<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget {
  final ViewModelWidgetBuilder<VM> builder;

  ViewModelBuilder({Key key, @required this.builder, Widget child});

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return builder?.call(context, context.viewModel<VM>(), child) ?? child;
  }
}
