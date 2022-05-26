import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';

/// 监听生命周期
class LifecycleBuilder<T> extends SingleChildStatefulWidget {
  final T Function(BuildContext context)? create;

  /// [State.initState] callback
  final Function(BuildContext context)? initState;

  /// first [SingleChildState.buildWithChild] callback
  final Function(BuildContext context, T value)? initBuild;

  /// 首帧执行
  /// [SchedulerBinding.addPostFrameCallback]
  final Function(BuildContext context, T value)? initFrame;

  /// [State.deactivate] callback
  final Function(BuildContext context, T value)? deactivate;

  /// [State.dispose] callback
  final Function(BuildContext context, T value)? dispose;

  /// [State.didUpdateWidget] callback
  final Function(BuildContext context, T? oldValue, LifecycleBuilder oldWidget)?
      didUpdateWidget;

  /// [State.didChangeDependencies] callback
  final Function(BuildContext context, T? oldValue)? didChangeDependencies;

  /// getter [State.setState] functions
  final Function(BuildContext context, StateSetter setState)? state;

  final Widget Function(
          BuildContext context, StateSetter setState, T value, Widget? child)?
      builder;

  LifecycleBuilder({
    Key? key,
    this.create,
    this.initState,
    this.initBuild,
    this.initFrame,
    this.deactivate,
    this.dispose,
    this.didUpdateWidget,
    this.didChangeDependencies,
    this.state,
    this.builder,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  _LifecycleWidgetState<T> createState() => _LifecycleWidgetState<T>();
}

class _LifecycleWidgetState<T> extends SingleChildState<LifecycleBuilder<T>> {
  T? value;
  bool _firstBuilder = true;

  static T? _castNullable<T>(T? value) => value;

  @override
  void initState() {
    super.initState();
    widget.initState?.call(context);
    final initFrame = widget.initFrame;
    if (initFrame != null) {
      _castNullable(WidgetsBinding.instance)!.addPostFrameCallback((_) {
        initFrame(context, value as T);
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.deactivate?.call(context, value as T);
  }

  @override
  void dispose() {
    widget.dispose?.call(context, value as T);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LifecycleBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context, value, oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context, value);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    value = widget.create?.call(context);
    widget.state?.call(context, setState);
    if (_firstBuilder) {
      widget.initBuild?.call(context, value as T);
      _firstBuilder = false;
    }
    return widget.builder?.call(context, setState, value as T, child) ??
        child ??
        const SizedBox();
  }
}
