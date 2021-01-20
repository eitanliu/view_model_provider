import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:collection/collection.dart';

export 'package:provider/provider.dart';

typedef ViewModelBindingWidgetBuilder<T> = Widget Function(
    BuildContext context, T value, bool isBinding, Widget child);

class ViewModelBinding0<T> extends SingleChildStatefulWidget {
  ViewModelBinding0({
    Key key,
    @required this.builder,
    @required this.selector,
    ShouldRebuild<T> shouldRebuild,
    Widget child,
  })  : assert(builder != null),
        assert(selector != null),
        _shouldRebuild = shouldRebuild,
        super(key: key, child: child);

  final ViewModelBindingWidgetBuilder<T> builder;

  final T Function(BuildContext context) selector;

  final ShouldRebuild<T> _shouldRebuild;

  @override
  _ViewModelBinding0State<T> createState() => _ViewModelBinding0State<T>();
}

class _ViewModelBinding0State<T>
    extends SingleChildState<ViewModelBinding0<T>> {
  T value;
  Widget cache;
  Widget oldWidget;

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    final selected = widget.selector(context);

    final shouldRebuild = widget._shouldRebuild?.call(value, selected) ??
        !const DeepCollectionEquality().equals(value, selected);

    var shouldInvalidateCache = shouldRebuild || oldWidget != widget;

    if (shouldInvalidateCache) {
      value = selected;
      oldWidget = widget;
      cache = widget.builder(
        context,
        selected,
        shouldRebuild,
        child,
      );
    }

    return cache;
  }
}

class ViewModelBinding<A, S> extends ViewModelBinding0<S> {
  ViewModelBinding({
    Key key,
    @required ViewModelBindingWidgetBuilder<S> builder,
    @required S Function(BuildContext, A) selector,
    ShouldRebuild<S> shouldRebuild,
    Widget child,
  })  : assert(selector != null),
        super(
          key: key,
          shouldRebuild: shouldRebuild,
          builder: builder,
          selector: (context) => selector(context, Provider.of(context)),
          child: child,
        );
}
