import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'lifecycle_widget.dart';
import 'view_model_provider.dart';

/// 提供 [ViewModelProvider] 混入实现
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

/// 提供 [ChildViewModelProvider] 混入实现
abstract class ChildViewModelProviderMixin<VM extends ChangeNotifier>
    implements ViewModelProviderCreate<VM> {
  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, {
    ViewModelWidgetBuilder<VM>? builder,
  }) {
    /// 混入 [ChildViewModelProviderLifecycleMixin] 不再 Provider 注册生命周期
    final _lifecycle = this is! ViewModelProviderLifecycleMixin<VM>
        ? this as ViewModelProviderLifecycle<VM>?
        : null;

    final _builder = this as ViewModelProviderBuilder<VM>?;

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

/// 提供 [ValueViewModelProvider] 混入实现
abstract class ValueViewModelProviderMixin<VM extends ChangeNotifier>
    implements ValueViewModelProviderCreate<VM> {
  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, {
    ViewModelWidgetBuilder<VM>? builder,
  }) {
    /// 混入 [ChildViewModelProviderLifecycleMixin] 不再 Provider 注册生命周期
    final _lifecycle = this is! ViewModelProviderLifecycleMixin<VM>
        ? this as ViewModelProviderLifecycle<VM>?
        : null;

    final _builder = this as ViewModelProviderBuilder<VM>?;

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

/// 提供 [ViewModelProviderLifecycle] 混入实现
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
      selector: (context, vm) => vm,
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

/// 创建 ViewModel 接口
abstract class ViewModelProviderCreate<VM> {
  VM create(BuildContext context);
}

/// 创建 ValueListenable<ViewModel> 接口
abstract class ValueViewModelProviderCreate<VM> {
  ValueListenable<VM> create(BuildContext context);
}

abstract class ViewModelProviderBuilder<VM> {
  Widget buildChild(BuildContext context, VM viewModel, Widget? child);
}

/// ViewModelProvider 生命周期
abstract class ViewModelProviderLifecycle<VM> {
  void initViewModel(BuildContext context, VM viewModel) {}

  void initFrame(BuildContext context, VM viewModel) {}

  void bindViewModel(BuildContext context, VM viewModel) {}

  void changeViewModel(BuildContext context, VM viewModel, VM? oldViewModel) {}

  void disposeViewModel(BuildContext context, VM viewModel) {}
}
