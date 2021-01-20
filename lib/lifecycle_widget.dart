import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';

class LifecycleBuilder<T> extends SingleChildStatefulWidget {
  final T Function(BuildContext context) create;

  final Function(BuildContext context) initState;

  final Function(BuildContext context, T value) initFrame;

  final Function(BuildContext context, T value) deactivate;

  final Function(BuildContext context, T value) dispose;

  final Function(BuildContext context, T oldValue, LifecycleBuilder oldWidget)
      didUpdateWidget;

  final Function(BuildContext context, T oldValue) didChangeDependencies;

  final Function(BuildContext context, StateSetter setState) state;

  final Widget Function(
          BuildContext context, StateSetter setState, T value, Widget child)
      builder;

  LifecycleBuilder({
    Key key,
    this.create,
    this.initState,
    this.initFrame,
    this.deactivate,
    this.dispose,
    this.didUpdateWidget,
    this.didChangeDependencies,
    this.state,
    this.builder,
    Widget child,
  }) : super(key: key, child: child);

  @override
  _LifecycleWidgetState<T> createState() => _LifecycleWidgetState<T>();
}

class _LifecycleWidgetState<T> extends SingleChildState<LifecycleBuilder<T>> {
  T value;

  @override
  void initState() {
    super.initState();
    if (widget.initState != null) {
      widget.initState(
        context,
      );
    }
    if (widget.initFrame != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.initFrame(context, value);
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.deactivate?.call(context, value);
  }

  @override
  void dispose() {
    widget.dispose?.call(context, value);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LifecycleBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context, value, oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context, value);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    value = widget.create?.call(context);
    widget.state?.call(context, setState);
    return widget.builder?.call(context, setState, value, child) ?? child;
  }
}
