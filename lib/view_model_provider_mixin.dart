import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

import 'lifecycle_widget.dart';
import 'view_model_provider.dart';

abstract class ViewModelProviderMixin<VM extends ChangeNotifier>
    implements ViewModelProviderCreate<VM> {
  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, {
    ViewModelWidgetBuilder<VM>? builder,
  }) {
    /// 混入 [ViewModelProviderLifecycleMixin] 不再 Provider 注册生命周期
    final _lifecycle = this is! ViewModelProviderLifecycleMixin<VM>
        ? this as ViewModelProviderLifecycle<VM>?
        : null;

    final _builder = this as ViewModelProviderBuilder<VM>?;

    return ViewModelProvider<VM>(
      create: create,
      initViewModel: _lifecycle?.initViewModel,
      initFrame: _lifecycle?.initFrame,
      bindViewModel: _lifecycle?.bindViewModel,
      disposeViewModel: _lifecycle?.disposeViewModel,
      child: child,
      builder: builder ?? _builder?.buildChild,
    );
  }
}

abstract class ChildViewModelProviderMixin<PVM extends ChangeNotifier,
        VM extends ChangeNotifier>
    implements ChildViewModelProviderCreate<PVM, VM> {
  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, {
    ChildViewModelWidgetBuilder<PVM, VM>? builder,
  }) {
    /// 混入 [ChildViewModelProviderLifecycleMixin] 不再 Provider 注册生命周期
    final _lifecycle = this is! ChildViewModelProviderLifecycleMixin<PVM, VM>
        ? this as ChildViewModelProviderLifecycle<PVM, VM>?
        : null;

    final _builder = this as ChildViewModelProviderBuilder<PVM, VM>?;

    return ChildViewModelProvider(
      create: create,
      initViewModel: _lifecycle?.initViewModel,
      initFrame: _lifecycle?.initFrame,
      bindViewModel: _lifecycle?.bindViewModel,
      disposeViewModel: _lifecycle?.disposeViewModel,
      changeViewModel: _lifecycle?.changeViewModel,
      child: child,
      builder: builder ?? _builder?.buildChild,
    );
  }
}

abstract class ValueViewModelProviderMixin<PVM extends ChangeNotifier,
        VM extends ChangeNotifier>
    implements ValueViewModelProviderCreate<PVM, VM> {
  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, {
    ChildViewModelWidgetBuilder<PVM, VM>? builder,
  }) {
    /// 混入 [ChildViewModelProviderLifecycleMixin] 不再 Provider 注册生命周期
    final _lifecycle = this is! ChildViewModelProviderLifecycleMixin<PVM, VM>
        ? this as ChildViewModelProviderLifecycle<PVM, VM>?
        : null;

    final _builder = this as ChildViewModelProviderBuilder<PVM, VM>?;
    return ValueViewModelProvider(
      create: create,
      initViewModel: _lifecycle?.initViewModel,
      initFrame: _lifecycle?.initFrame,
      bindViewModel: _lifecycle?.bindViewModel,
      disposeViewModel: _lifecycle?.disposeViewModel,
      changeViewModel: _lifecycle?.changeViewModel,
      child: child,
      builder: builder ?? _builder?.buildChild,
    );
  }
}

abstract class ViewModelProviderLifecycleMixin<VM>
    implements ViewModelProviderLifecycle<VM> {
  @protected
  Widget buildLifecycle(
    BuildContext context,
    Widget? child, {
    ViewModelWidgetBuilder<VM>? builder,
  }) {
    final _builder =
        builder ?? (this as ViewModelProviderBuilder<VM>?)?.buildChild;

    return ViewModelBinding<VM, VM>(
      selector: (context, pvm) => pvm,
      builder: (context, value, isBinding, child) => LifecycleBuilder<VM>(
        create: (context) => context.viewModel<VM>(),
        initState: (_) => initViewModel(context, value),
        initBuild: (_, __) => bindViewModel(context, value),
        initFrame: (_, __) => initFrame(context, value),
        dispose: (_, __) => disposeViewModel(context, value),
        didChangeDependencies: (_, oldValue) {
          if (!const DeepCollectionEquality().equals(oldValue, value)) {
            changeViewModel(context, value, oldValue);
          }
        },
        child: child,
        builder: _builder != null
            ? (_, setStatus, __, child) {
                return _builder(context, value, child);
              }
            : null,
      ),
    );
  }
}

abstract class ChildViewModelProviderLifecycleMixin<PVM, VM>
    implements ChildViewModelProviderLifecycle<PVM, VM> {
  @protected
  Widget buildChildLifecycle(
    BuildContext context,
    Widget? child, {
    ChildViewModelWidgetBuilder<PVM, VM>? builder,
  }) {
    final _builder = builder ??
        (this as ChildViewModelProviderBuilder<PVM, VM>?)?.buildChild;

    return ViewModelBinding<PVM, Tuple2<PVM, VM>>(
      selector: (context, pvm) => Tuple2(pvm, context.viewModel<VM>()),
      shouldRebuild: (previous, next) {
        return !const DeepCollectionEquality()
            .equals(previous.item2, next.item2);
      },
      builder: (context, value, isBinding, child) => LifecycleBuilder<VM>(
        create: (context) => context.viewModel<VM>(),
        initState: (_) => initViewModel(context, value.item1, value.item2),
        initBuild: (_, __) => bindViewModel(context, value.item1, value.item2),
        initFrame: (_, __) => initFrame(context, value.item1, value.item2),
        dispose: (_, __) => disposeViewModel(context, value.item1, value.item2),
        didChangeDependencies: (_, oldValue) {
          if (!const DeepCollectionEquality().equals(oldValue, value.item2)) {
            changeViewModel(context, value.item1, value.item2, oldValue);
          }
        },
        child: child,
        builder: _builder != null
            ? (_, setStatus, __, child) {
                return _builder(context, value.item1, value.item2, child);
              }
            : null,
      ),
    );
  }
}

abstract class ViewModelProviderCreate<VM> {
  VM create(BuildContext context);
}

abstract class ViewModelProviderBuilder<VM> {
  Widget buildChild(BuildContext context, VM viewModel, Widget? child);
}

abstract class ViewModelProviderLifecycle<VM> {
  void initViewModel(BuildContext context, VM viewModel) {}

  void initFrame(BuildContext context, VM viewModel) {}

  void bindViewModel(BuildContext context, VM viewModel) {}

  void changeViewModel(BuildContext context, VM viewModel, VM? oldViewModel) {}

  void disposeViewModel(BuildContext context, VM viewModel) {}
}

abstract class ChildViewModelProviderCreate<PVM, VM> {
  VM create(BuildContext context, PVM parent);
}

abstract class ValueViewModelProviderCreate<PVM, VM> {
  ValueListenable<VM> create(BuildContext context, PVM parent);
}

abstract class ChildViewModelProviderBuilder<PVM, VM> {
  Widget buildChild(
      BuildContext context, PVM parent, VM viewModel, Widget? child);
}

abstract class ChildViewModelProviderLifecycle<PVM, VM> {
  void initViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void initFrame(BuildContext context, PVM parent, VM viewModel) {}

  void bindViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void changeViewModel(
      BuildContext context, PVM parent, VM viewModel, VM? oldViewModel) {}

  void disposeViewModel(BuildContext context, PVM parent, VM viewModel) {}
}
