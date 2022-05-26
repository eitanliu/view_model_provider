import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

import 'lifecycle_widget.dart';
import 'pair_view_model_provider.dart';
import 'view_model_provider.dart';

/// 创建 ViewModel 接口
abstract class PairViewModelProviderCreate<PVM, VM> {
  VM create(BuildContext context, PVM parent);
}

/// 创建 ViewModel 接口
abstract class PairValueViewModelProviderCreate<PVM, VM> {
  ValueListenable<VM> create(BuildContext context, PVM parent);
}

/// WidgetBuilder
abstract class PairViewModelProviderBuilder<PVM, VM> {
  Widget buildChild(
      BuildContext context, PVM parent, VM viewModel, Widget? child);
}

/// 生命周期
abstract class PairViewModelProviderLifecycle<PVM, VM> {
  void initViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void initFrame(BuildContext context, PVM parent, VM viewModel) {}

  void bindViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void changeViewModel(
      BuildContext context, PVM parent, VM viewModel, VM? oldViewModel) {}

  void disposeViewModel(BuildContext context, PVM parent, VM viewModel) {}
}

/// 提供 [PairChildViewModelProvider] 混入实现
abstract class PairChildViewModelProviderMixin<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> implements PairViewModelProviderCreate<PVM, VM> {
  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, {
    PairViewModelWidgetBuilder<PVM, VM>? builder,
  }) {
    /// 混入 [ChildViewModelProviderLifecycleMixin] 不再 Provider 注册生命周期
    final _lifecycle = this is! PairViewModelProviderLifecycleMixin<PVM, VM>
        ? this as PairViewModelProviderLifecycle<PVM, VM>?
        : null;

    final _builder = this as PairViewModelProviderBuilder<PVM, VM>?;

    return PairChildViewModelProvider(
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

/// 提供 [PairValueViewModelProvider] 混入实现
abstract class PairValueViewModelProviderMixin<PVM extends ChangeNotifier,
        VM extends ChangeNotifier>
    implements PairValueViewModelProviderCreate<PVM, VM> {
  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, {
    PairViewModelWidgetBuilder<PVM, VM>? builder,
  }) {
    /// 混入 [ChildViewModelProviderLifecycleMixin] 不再 Provider 注册生命周期
    final _lifecycle = this is! PairViewModelProviderLifecycleMixin<PVM, VM>
        ? this as PairViewModelProviderLifecycle<PVM, VM>?
        : null;

    final _builder = this as PairViewModelProviderBuilder<PVM, VM>?;
    return PairValueViewModelProvider(
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

/// 提供 [PairViewModelProviderLifecycle] 混入实现
abstract class PairViewModelProviderLifecycleMixin<PVM, VM>
    implements PairViewModelProviderLifecycle<PVM, VM> {
  @protected
  Widget buildChildLifecycle(
    BuildContext context,
    Widget? child, {
    PairViewModelWidgetBuilder<PVM, VM>? builder,
  }) {
    final _builder =
        builder ?? (this as PairViewModelProviderBuilder<PVM, VM>?)?.buildChild;

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
