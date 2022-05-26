import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

import 'lifecycle_widget.dart';
import 'pair_view_model_provider_mixin.dart';
import 'view_model_provider.dart';

export 'pair_view_model_provider_mixin.dart';

typedef PairViewModelWidgetCallback<PVM, VM> = void Function(
    BuildContext context, PVM parent, VM viewModel);

typedef PairViewModelWidgetChange<PVM, VM> = void Function(
    BuildContext context, PVM parent, VM viewModel, VM? oldViewModel);

typedef PairViewModelWidgetBuilder<PVM, VM> = Widget Function(
    BuildContext context, PVM parent, VM viewModel, Widget? child);

/// ViewModelProvider
class PairChildViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final VM Function(BuildContext context, PVM parent) create;

  final PairViewModelWidgetCallback<PVM, VM>? initViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? initFrame;

  final PairViewModelWidgetCallback<PVM, VM>? bindViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? disposeViewModel;

  final PairViewModelWidgetChange<PVM, VM>? changeViewModel;

  final PairViewModelWidgetBuilder<PVM, VM>? builder;

  PairChildViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ViewModelBinding<PVM, Tuple2<PVM, VM>>(
      selector: (context, pvm) => Tuple2(pvm, create(context, pvm)),
      shouldRebuild: (previous, next) {
        return !const DeepCollectionEquality()
            .equals(previous.item2, next.item2);
      },
      child: child,
      builder: (context, value, isBinding, child) {
        return ListenableProvider.value(
          value: value.item2,
          child: child,
          builder: (context, child) {
            final buildWidget = () {
              if (isBinding) {
                bindViewModel?.call(context, value.item1, value.item2);
              }
              return builder?.call(context, value.item1, value.item2, child) ??
                  child ??
                  const SizedBox();
            };
            if (initViewModel != null ||
                initFrame != null ||
                disposeViewModel != null ||
                changeViewModel != null) {
              return LifecycleBuilder<VM>(
                create: (context) => context.viewModel<VM>(),
                initState: (_) =>
                    initViewModel?.call(context, value.item1, value.item2),
                initFrame: (_, __) =>
                    initFrame?.call(context, value.item1, value.item2),
                dispose: (_, __) =>
                    disposeViewModel?.call(context, value.item1, value.item2),
                didChangeDependencies: (context, oldValue) {
                  if (!const DeepCollectionEquality()
                      .equals(oldValue, value.item2)) {
                    changeViewModel?.call(
                        context, value.item1, value.item2, oldValue);
                  }
                },
                child: child,
                builder: (context, setState, value, child) => buildWidget(),
              );
            }
            return buildWidget();
          },
        );
      },
    );
  }
}

/// ViewModelProvider
class PairValueViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final ValueListenable<VM> Function(BuildContext context, PVM parent) create;

  final PairViewModelWidgetCallback<PVM, VM>? initViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? initFrame;

  final PairViewModelWidgetCallback<PVM, VM>? bindViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? disposeViewModel;

  final PairViewModelWidgetChange<PVM, VM>? changeViewModel;

  final PairViewModelWidgetBuilder<PVM, VM>? builder;

  PairValueViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ViewModelBinding<PVM, Tuple2<PVM, ValueListenable<VM>>>(
      selector: (context, pvm) => Tuple2(pvm, create(context, pvm)),
      child: child,
      builder: (context, value, isBinding, child) {
        return ValueListenableBuilder<VM>(
          valueListenable: value.item2,
          child: child,
          builder: (context, model, child) {
            return ListenableProvider<VM>.value(
              value: model,
              child: child,
              builder: (context, child) {
                final buildWidget = () {
                  if (isBinding) {
                    bindViewModel?.call(context, value.item1, model);
                  }
                  return builder?.call(context, value.item1, model, child) ??
                      child ??
                      const SizedBox();
                };
                if (initViewModel != null ||
                    disposeViewModel != null ||
                    changeViewModel != null) {
                  return LifecycleBuilder<VM>(
                    create: (context) => context.viewModel<VM>(),
                    initState: (_) =>
                        initViewModel?.call(context, value.item1, model),
                    initFrame: (_, __) =>
                        initFrame?.call(context, value.item1, model),
                    dispose: (_, __) =>
                        disposeViewModel?.call(context, value.item1, model),
                    didChangeDependencies: (_, oldValue) {
                      if (!const DeepCollectionEquality()
                          .equals(oldValue, model)) {
                        changeViewModel?.call(
                            context, value.item1, model, oldValue);
                      }
                    },
                    child: child,
                    builder: (context, setState, model, child) => buildWidget(),
                  );
                }
                return buildWidget();
              },
            );
          },
        );
      },
    );
  }
}

/// 提供继承功能
abstract class PairChildViewModelProviderWidget<PVM extends ChangeNotifier,
        VM extends ChangeNotifier> extends SingleChildStatelessWidget
    with PairChildViewModelProviderMixin<PVM, VM> {
  PairChildViewModelProviderWidget({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}

/// 提供继承功能
abstract class PairValueViewModelProviderWidget<PVM extends ChangeNotifier,
        VM extends ChangeNotifier> extends SingleChildStatelessWidget
    with PairValueViewModelProviderMixin<PVM, VM>
    implements PairViewModelProviderBuilder<PVM, VM> {
  PairValueViewModelProviderWidget({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  Widget buildChild(
      BuildContext context, PVM parent, VM? viewModel, Widget? child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}
