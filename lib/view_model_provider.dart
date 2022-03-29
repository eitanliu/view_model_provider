import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tuple/tuple.dart';

import 'lifecycle_widget.dart';
import 'view_model_binding.dart';
import 'view_model_provider_mixin.dart';

export 'package:provider/single_child_widget.dart';

export 'view_model_binding.dart';
export 'view_model_provider_mixin.dart';

typedef ViewModelWidgetCallback<VM> = void Function(
    BuildContext context, VM viewModel);

typedef ViewModelWidgetBuilder<VM> = Widget Function(
    BuildContext context, VM viewModel, Widget? child);

typedef ChildViewModelWidgetCallback<PVM, VM> = void Function(
    BuildContext context, PVM parent, VM viewModel);

typedef ChildViewModelWidgetChange<PVM, VM> = void Function(
    BuildContext context, PVM parent, VM viewModel, VM? oldViewModel);

typedef ChildViewModelWidgetBuilder<PVM, VM> = Widget Function(
    BuildContext context, PVM parent, VM viewModel, Widget? child);

class ViewModelProvider<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget {
  final VM Function(BuildContext context) create;

  final ViewModelWidgetCallback<VM>? initViewModel;

  final ViewModelWidgetCallback<VM>? initFrame;

  final ViewModelWidgetCallback<VM>? bindViewModel;

  final ViewModelWidgetCallback<VM>? disposeViewModel;

  final ViewModelWidgetBuilder<VM>? builder;

  ViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ChangeNotifierProvider<VM>(
      create: (_) => create(context),
      child: child,
      builder: (context, child) {
        return ViewModelBinding<VM, VM>(
          selector: (context, vm) => vm,
          child: child,
          builder: (context, value, isBinding, child) {
            final buildWidget = () {
              if (isBinding) bindViewModel?.call(context, value);
              return builder?.call(context, value, child) ??
                  child ??
                  const SizedBox();
            };
            if (initViewModel != null || disposeViewModel != null) {
              return LifecycleBuilder<VM>(
                create: (context) => value,
                initState: (_) => initViewModel?.call(context, value),
                initFrame: (_, __) => initFrame?.call(context, value),
                dispose: (_, value) => disposeViewModel?.call(context, value),
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

class ChildViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final VM Function(BuildContext context, PVM parent) create;

  final ChildViewModelWidgetCallback<PVM, VM>? initViewModel;

  final ChildViewModelWidgetCallback<PVM, VM>? initFrame;

  final ChildViewModelWidgetCallback<PVM, VM>? bindViewModel;

  final ChildViewModelWidgetCallback<PVM, VM>? disposeViewModel;

  final ChildViewModelWidgetChange<PVM, VM>? changeViewModel;

  final ChildViewModelWidgetBuilder<PVM, VM>? builder;

  ChildViewModelProvider({
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

class ValueViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final ValueListenable<VM> Function(BuildContext context, PVM parent) create;

  final ChildViewModelWidgetCallback<PVM, VM>? initViewModel;

  final ChildViewModelWidgetCallback<PVM, VM>? initFrame;

  final ChildViewModelWidgetCallback<PVM, VM>? bindViewModel;

  final ChildViewModelWidgetCallback<PVM, VM>? disposeViewModel;

  final ChildViewModelWidgetChange<PVM, VM>? changeViewModel;

  final ChildViewModelWidgetBuilder<PVM, VM>? builder;

  ValueViewModelProvider({
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

abstract class ViewModelProviderWidget<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget
    with ViewModelProviderMixin<VM>
    implements ViewModelProviderBuilder<VM> {
  ViewModelProviderWidget({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}

abstract class ChildViewModelProviderWidget<PVM extends ChangeNotifier,
        VM extends ChangeNotifier> extends SingleChildStatelessWidget
    with ChildViewModelProviderMixin<PVM, VM> {
  ChildViewModelProviderWidget({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}

abstract class ValueViewModelProviderWidget<PVM extends ChangeNotifier,
        VM extends ChangeNotifier> extends SingleChildStatelessWidget
    with ValueViewModelProviderMixin<PVM, VM>
    implements ChildViewModelProviderBuilder<PVM, VM> {
  ValueViewModelProviderWidget({
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

extension ViewModelContext on BuildContext {
  T viewModel<T>() => this.select((T value) => value);
}
